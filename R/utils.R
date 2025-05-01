#' Clear pkgdown cache if any
#'
#' @export
clear_cache <- function() {
  path <- tools::R_user_dir("pkgdown", which = "cache")
  if (fs::dir_exists(path)) fs::dir_delete(path)
}

#' Path to cache directory in pkgdown.offline (source state)
#'
#' @export
path_cache_dev <- function() {
  file.path("inst", "cache")
}

#' Path to cache directory in pkgdown.offline (installed state)
#'
#' @export
path_cache_installed <- function() {
  system.file("cache", package = "pkgdown.offline")
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

#' Copy deps from pkgdown.offline into pkgdown cache
#'
#' @noRd
copy_to_cache <- function(version) {
  target_cache_dir <- tools::R_user_dir("pkgdown", which = "cache")
  restore_cache(version, target_dir = target_cache_dir)
  invisible(NULL)
}

#' @importFrom utils available.packages install.packages
install_pkgdown <- function(version) {
  current_version <- available.packages(repos = "https://cran.r-project.org/")["pkgdown", "Version"]
  url <- if (version == current_version) {
    paste0("https://cran.r-project.org/src/contrib/pkgdown_", version, ".tar.gz")
  } else {
    paste0("https://cran.r-project.org/src/contrib/Archive/pkgdown/pkgdown_", version, ".tar.gz")
  }
  install.packages(url, repos = NULL)
}
