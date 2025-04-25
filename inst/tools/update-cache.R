#' Cache pkgdown dependencies into pkgdown.offline
#'
#' Cache pkgdown dependencies into pkgdown.offline for each pkgdown version
#' (>= 2.1.0) on CRAN. Running This requires internet connection.
#'
#' @param version pkgdown version
#'
#' @examples
#' update_cache("2.1.0")
#' update_cache("2.1.1")
#' update_cache("2.1.2")
update_cache <- function(version) {
  if (version %in% c("2.1.0", "2.1.1")) {
    remotes::install_version("pkgdown", version)
    pkgdown.offline::clear_cache()

    # Object stubbing for pkgdown::as_pkgdown()
    pkg <- list()
    pkg$meta$template$`math-rendering` <- "mathjax"
    pkgdown:::external_dependencies(pkg)

    pkg$meta$template$`math-rendering` <- "katex"
    pkgdown:::external_dependencies(pkg)

    copy_from_cache(version)
  }

  if (version %in% c("2.1.2")) {
    remotes::install_github("r-lib/pkgdown@f362d53", upgrade = FALSE)

    pkgdown.offline::clear_cache()
    pkg <- list()
    pkgdown:::external_dependencies(pkg)

    copy_from_cache(version)
  }
}

#' Copy deps from cache into pkgdown.offline
copy_from_cache <- function(version) {
  source_cache_dir <- tools::R_user_dir("pkgdown", which = "cache")
  target_cache_dir <- file.path("inst/cache/", version)
  fs::dir_copy(source_cache_dir, target_cache_dir, overwrite = TRUE)
  invisible(NULL)
}
