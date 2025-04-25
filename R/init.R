#' @export
init_site <- function(...) {
  version <- packageVersion("pkgdown")
  copy_to_cache(version)

  options(pkgdown.internet = FALSE)
  pkgdown::init_site(...)
}

# TODO: pkgdown 2.1.2 fails building site as
# pkgdown::cran_link() might need monkey patching
build_site <- function (...) {
  NULL
}
