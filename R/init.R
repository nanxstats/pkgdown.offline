#' @export
init_site <- function(...) {
  # Parse installed pkgdown version
  # pkgdown_version <- packageVersion("pkgdown")
  pkgdown_version <- "2.1.2"
  source_cache_dir <- system.file(
    file.path("cache", pkgdown_version),
    package = "pkgdown.offline"
  )
  target_cache_dir <- tools::R_user_dir("pkgdown", which = "cache")
  fs::dir_copy(source_cache_dir, target_cache_dir, overwrite = TRUE)

  pkgdown::init_site(...)
}
