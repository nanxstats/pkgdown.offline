#' @export
clear_cache <- function() {
  fs::dir_delete(tools::R_user_dir("pkgdown", which = "cache"))
}

#' Path to cache directory in pkgdown.offline
path_pkg_cache <- function() {
  file.path("inst", "cache")
}

#' Copy deps from cache to somewhere (for example, pkgdown.offline in dev mode)
copy_from_cache <- function(version, destdir) {
  source_cache_dir <- tools::R_user_dir("pkgdown", which = "cache")
  target_cache_dir <- file.path(destdir, version)
  fs::dir_copy(source_cache_dir, target_cache_dir, overwrite = TRUE)
  invisible(NULL)
}

#' Copy deps from pkgdown.offline into cache
copy_to_cache <- function(version) {
  source_cache_dir <- system.file(file.path("cache", version), package = "pkgdown.offline")
  target_cache_dir <- tools::R_user_dir("pkgdown", which = "cache")
  fs::dir_copy(source_cache_dir, target_cache_dir, overwrite = TRUE)
  invisible(NULL)
}
