#' Cache pkgdown dependencies
#'
#' Cache pkgdown dependencies for each pkgdown version
#' (>= 2.1.0) on CRAN. Running This requires internet connection.
#'
#' @param version pkgdown version.
#' @param destdir Where to put the cached dependencies.
#'
#' @importFrom utils getFromNamespace
#'
#' @noRd
update_cache <- function(version, destdir = tempdir()) {
  install_pkgdown(version)
  clear_cache()

  cache_deps <- getFromNamespace("external_dependencies", "pkgdown")

  if (version %in% c("2.1.0", "2.1.1")) {
    # Object stubbing for pkgdown::as_pkgdown()
    pkg <- list()
    pkg$meta$template$`math-rendering` <- "mathjax"
    cache_deps(pkg)

    pkg$meta$template$`math-rendering` <- "katex"
    cache_deps(pkg)
  }

  if (version %in% c("2.1.2")) {
    pkg <- list()
    cache_deps(pkg)
  }

  copy_from_cache(version, destdir)
}

#' Minify cache by deduplicating files and creating a map
#'
#' Scans all files in the cache directory, identifies duplicates by MD5
#' checksum, and creates a minimal set of unique files along with a map.
#'
#' @param raw_cache_dir Directory containing the version-specific raw pkgdown cache directories.
#'
#' @return Invisibly returns the path to the created map file.
#'
#' @importFrom utils write.table
#'
#' @noRd
minify_cache <- function(raw_cache_dir) {
  minimal_dir <- path_cache_dev()
  dir_create(minimal_dir)

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

#' Restore original cache structure from minimal cache
#'
#' Use the map created by `minify_cache()` to restore the
#' original cache directory structure to a temporary directory.
#'
#' @param version pkgdown version cache to restore.
#' @param target_dir Directory to restore the cache to.
#'
#' @return Invisibly returns the path to the restored cache directory.
#'
#' @importFrom utils read.table
#'
#' @noRd
restore_cache <- function(version, target_dir) {
  # Load the map from plain text file
  minimal_dir <- path_cache_installed()
  map_file <- file.path(minimal_dir, "MD5")
  if (!file.exists(map_file)) stop("MD5 map file not found in cache directory.")
  map <- read.table(map_file, header = FALSE, col.names = c("hash", "relative_path"), stringsAsFactors = FALSE)

  # Filter for files from the requested version
  version_prefix <- paste0("^", version, "/")
  version_files <- map[grepl(version_prefix, map$relative_path), ]

  # Create target directory
  dir_delete(target_dir)
  dir_create(target_dir)

  # Copy files to their original locations
  for (i in seq_len(nrow(version_files))) {
    # Source file in minimal cache
    source_file <- file.path(minimal_dir, version_files$hash[i])

    # Target file in temporary structure (without version prefix)
    rel_path <- sub(version_prefix, "", version_files$relative_path[i])
    target_file <- file.path(target_dir, rel_path)

    # Create directory if needed
    target_dir_path <- dirname(target_file)
    dir_create(target_dir_path)

    # Copy file
    file.copy(source_file, target_file, overwrite = TRUE)
  }

  message("Restored ", nrow(version_files), " files for pkgdown version ", version, ".\n")

  invisible(target_dir)
}
