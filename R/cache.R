#' Clear pkgdown cache if any
#'
#' Removes all files from the pkgdown cache directory if it exists.
#' This is useful when troubleshooting or when you want to force a
#' fresh caching of pkgdown external dependencies.
#'
#' @return Invisible `NULL`, called for side effect of clearing the cache.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' pkgdown.offline::clear_cache()
#' }
clear_cache <- function() {
  path <- tools::R_user_dir("pkgdown", which = "cache")
  dir_delete(path)
}

#' Copy dependencies from pkgdown.offline into pkgdown cache
#'
#' @param version The pkgdown version to copy dependencies for.
#'
#' @return Invisible NULL, called for side effect of copying files.
#'
#' @noRd
copy_to_cache <- function(version) {
  target_cache_dir <- tools::R_user_dir("pkgdown", which = "cache")
  restore_cache(version, target_dir = target_cache_dir)
  invisible()
}

#' Restore original cache structure from minified cache
#'
#' Use the map to restore the original cache directory structure to
#' a temporary directory.
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
  minified_cache_dir <- path_cache_installed()
  map_file <- file.path(minified_cache_dir, "MD5")
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
    # Source file in minified cache
    source_file <- file.path(minified_cache_dir, version_files$hash[i])

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

#' Path to cache directory in pkgdown.offline (installed state)
#'
#' Returns the path to the cache directory when the package is installed.
#'
#' @return Character string with the path to the cache directory.
#'
#' @noRd
path_cache_installed <- function() {
  system.file("cache", package = "pkgdown.offline")
}
