#' Cache pkgdown dependencies
#'
#' Cache pkgdown dependencies for each pkgdown version
#' (>= 2.1.0) on CRAN. Running This requires internet connection.
#'
#' @param version pkgdown version.
#' @param destdir Where to put the cached dependencies.
#'
#' @note
#' To update the cache in pkgdown.offline,
#' run `update_cache("2.1.0", destdir = path_pkg_cache())` with the version(s)
#' you target.
#'
#' @noRd
update_cache <- function(version, destdir = tempdir()) {
  remotes::install_version("pkgdown", version = version, upgrade = FALSE)
  pkgdown.offline::clear_cache()

  if (version %in% c("2.1.0", "2.1.1")) {
    # Object stubbing for pkgdown::as_pkgdown()
    pkg <- list()
    pkg$meta$template$`math-rendering` <- "mathjax"
    pkgdown:::external_dependencies(pkg)

    pkg$meta$template$`math-rendering` <- "katex"
    pkgdown:::external_dependencies(pkg)
  }

  if (version %in% c("2.1.2")) {
    pkg <- list()
    pkgdown:::external_dependencies(pkg)
  }

  copy_from_cache(version, destdir)
}
