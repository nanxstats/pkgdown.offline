#' Cache pkgdown dependencies
#'
#' Cache pkgdown dependencies for each pkgdown version
#' (>= 2.1.0) on CRAN. Running This requires internet connection.
#'
#' @param version pkgdown version.
#' @param destdir Where to put the cached dependencies.
#'
#' @return Invisible `NULL`, called for side effect of updating cache.
#'
#' @noRd
update_cache <- function(version, destdir = tempdir()) {
  install_pkgdown(version)
  pkgdown.offline::clear_cache()

  cache_deps <- utils::getFromNamespace("external_dependencies", "pkgdown")

  if (version %in% c("2.1.0", "2.1.1")) {
    # Object stubbing for pkgdown::as_pkgdown()
    pkg <- list()
    pkg$meta$template$`math-rendering` <- "mathjax"
    cache_deps(pkg)

    pkg$meta$template$`math-rendering` <- "katex"
    cache_deps(pkg)
  }

  if (version %in% c("2.1.2", "2.1.3")) {
    pkg <- list()
    cache_deps(pkg)
  }

  copy_from_cache(version, destdir)
}

#' Copy dependencies from pkgdown cache to a target directory
#'
#' @param version The pkgdown version to copy dependencies for.
#' @param destdir Destination directory to copy the dependencies to.
#'
#' @return Invisible `NULL`, called for side effect of copying files.
#'
#' @noRd
copy_from_cache <- function(version, destdir) {
  source_cache_dir <- tools::R_user_dir("pkgdown", which = "cache")
  target_cache_dir <- file.path(destdir, version)
  pkgdown.offline:::dir_copy(source_cache_dir, target_cache_dir)
  invisible()
}

#' Minify cache by deduplicating files and creating a map
#'
#' Scans all files in the cache directory, identifies duplicates by MD5
#' checksum, and creates a minimal set of unique files along with a map.
#'
#' @param raw_cache_dir Directory containing the version-specific
#'   raw pkgdown cache directories.
#'
#' @return Invisibly returns the path to the created map file.
#'
#' @importFrom utils write.table
#'
#' @noRd
minify_cache <- function(raw_cache_dir) {
  minimal_dir <- path_cache_dev()
  pkgdown.offline:::dir_create(minimal_dir)

  # Calculate checksum for all cached files
  all_files <- list.files(raw_cache_dir, recursive = TRUE, full.names = TRUE)
  md5_hashes <- tools::md5sum(all_files)

  # Create a data frame with file info
  file_info <- data.frame(
    original_path = all_files,
    relative_path = gsub(paste0("^", gsub("([.|()\\^{}+$*?])", "\\\\\\1", raw_cache_dir), "/"), "", all_files),
    hash = md5_hashes,
    stringsAsFactors = FALSE
  )

  # Identify unique files by hash
  unique_hashes <- unique(file_info$hash)
  unique_files <- data.frame(
    hash = unique_hashes,
    minimal_path = file.path(minimal_dir, unique_hashes),
    stringsAsFactors = FALSE
  )

  # Create mapping between original files and minimal files
  map <- merge(file_info, unique_files, by = "hash")

  # Copy unique files to minimal directory
  for (i in seq_len(nrow(unique_files))) {
    source_file <- file_info$original_path[file_info$hash == unique_files$hash[i]][1]
    target_file <- unique_files$minimal_path[i]
    file.copy(source_file, target_file, overwrite = TRUE)
  }

  # Save map to minimal directory
  map_file <- file.path(minimal_dir, "MD5")
  map_data <- data.frame(
    hash = map$hash,
    relative_path = map$relative_path,
    stringsAsFactors = FALSE
  )
  # Sort by hash then by file name for consistent output
  map_data <- map_data[order(map_data$hash, map_data$relative_path), ]
  write.table(map_data, file = map_file, quote = FALSE, row.names = FALSE, col.names = FALSE, sep = " ")

  message("Cache minified: ", length(all_files), " files reduced to ", length(unique_hashes), " unique files.\n")

  invisible(map_file)
}

#' Path to cache directory in pkgdown.offline (source state)
#'
#' Returns the path to the cache directory when the package is in
#' development mode (not installed).
#'
#' @return Character string with the path to the cache directory.
#'
#' @noRd
path_cache_dev <- function() {
  file.path("inst", "cache")
}

#' Install a specific version of pkgdown
#'
#' @param version The version of pkgdown to install.
#'
#' @return Invisible `NULL`, called for side effect of installing pkgdown.
#'
#' @importFrom utils available.packages install.packages
#'
#' @noRd
install_pkgdown <- function(version) {
  current_version <- available.packages(repos = "https://cloud.r-project.org/")["pkgdown", "Version"]
  url <- if (version == current_version) {
    paste0("https://cloud.r-project.org/src/contrib/pkgdown_", version, ".tar.gz")
  } else {
    paste0("https://cloud.r-project.org/src/contrib/Archive/pkgdown/pkgdown_", version, ".tar.gz")
  }
  install.packages(url, repos = NULL)
}
