#' Initialize site infrastructure offline
#'
#' Sets up the necessary infrastructure for building a pkgdown site offline
#' by copying locally cached dependencies to the pkgdown cache directory.
#'
#' @param ... Arguments passed to [pkgdown::init_site()].
#'
#' @return Invisible `NULL`, called for side effect of initializing site resources.
#'
#' @importFrom utils packageVersion
#'
#' @export
#'
#' @examples
#' \dontrun{
#' pkgdown.offline::init_site()
#' }
init_site <- function(...) {
  version <- packageVersion("pkgdown")
  copy_to_cache(version)
  pkgdown::init_site(...)
}
