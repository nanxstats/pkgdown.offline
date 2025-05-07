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
  copy_to_cache(packageVersion("pkgdown"))
  stub_with_null("pkgdown", "build_favicons")
  pkgdown::init_site(...)
}
