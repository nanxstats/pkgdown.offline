#' Clear pkgdown cache if any
#'
#' @export
clear_cache <- function() {
  path <- tools::R_user_dir("pkgdown", which = "cache")
  if (fs::dir_exists(path)) fs::dir_delete(path)
}

#' Path to cache directory in pkgdown.offline
#'
#' @export
path_pkg_cache <- function() {
  file.path("inst", "cache")
}

#' Copy deps from cache to somewhere (for example, pkgdown.offline in dev mode)
#'
#' @noRd
copy_from_cache <- function(version, destdir) {
  source_cache_dir <- tools::R_user_dir("pkgdown", which = "cache")
  target_cache_dir <- file.path(destdir, version)
  fs::dir_copy(source_cache_dir, target_cache_dir, overwrite = TRUE)
  invisible(NULL)
}

#' Copy deps from pkgdown.offline into cache
#'
#' @noRd
copy_to_cache <- function(version) {
  source_cache_dir <- system.file(file.path("cache", version), package = "pkgdown.offline")
  target_cache_dir <- tools::R_user_dir("pkgdown", which = "cache")
  fs::dir_copy(source_cache_dir, target_cache_dir, overwrite = TRUE)
  invisible(NULL)
}
