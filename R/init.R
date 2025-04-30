#' Initialize site infrastructure offline
#'
#' @param ... TBA
#'
#' @importFrom utils packageVersion
#'
#' @export
init_site <- function(...) {
  version <- packageVersion("pkgdown")
  copy_to_cache(version)

  pkgdown::init_site(...)
}
