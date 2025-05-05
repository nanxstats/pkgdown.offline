#' Build a complete pkgdown website offline
#'
#' Builds a pkgdown website without requiring internet connection by using
#' cached dependencies. Detects the installed pkgdown version and applies
#' the appropriate offline build strategy.
#'
#' @param ... Arguments passed to [pkgdown::build_site()].
#'
#' @return Invisible `NULL`, called for side effect of building the website.
#'
#' @importFrom utils packageVersion
#'
#' @export
#'
#' @examples
#' \dontrun{
#' pkgdown.offline::build_site()
#'
#' pkgdown.offline::build_site(override = list(destination = tempdir()))
#' }
build_site <- function(...) {
  version <- packageVersion("pkgdown")

  # Determine version category for dispatch
  version_category <- get_version_category(version)

  # Switch based on version category
  switch(version_category,
    "old" = {
      build_site_offline_0(...)
    },
    "v2.1.0" = {
      build_site_offline_1(...)
    },
    "v2.1.1" = {
      build_site_offline_1(...)
    },
    "v2.1.2" = {
      build_site_offline_1(...)
    },
    "future" = {
      message(
        "pkgdown.offline support for this new pkgdown version is unknown.\n",
        "Attempting to use the latest logic to build...\n"
      )
      build_site_offline_1(...)
    }
  )
}

#' Determine pkgdown version category for dispatch
#'
#' Maps the installed pkgdown version to a category used for selecting
#' the appropriate offline build strategy.
#'
#' @param version The pkgdown version.
#'
#' @return A string category used for dispatch.
#'
#' @noRd
get_version_category <- function(version) {
  if (compare_version(version, "<", "2.1.0")) {
    return("old")
  } else if (compare_version(version, "==", "2.1.0")) {
    return("v2.1.0")
  } else if (compare_version(version, "==", "2.1.1")) {
    return("v2.1.1")
  } else if (compare_version(version, "==", "2.1.2")) {
    return("v2.1.2")
  } else {
    return("future")
  }
}

#' Simple offline build
#'
#' Implements the offline build strategy for older pkgdown versions
#' by setting the `pkgdown.internet` option to `FALSE`.
#'
#' @param ... Arguments passed to [pkgdown::build_site()].
#'
#' @return Invisible `NULL`, called for side effect of building the website.
#'
#' @noRd
build_site_offline_0 <- function(...) {
  options(pkgdown.internet = FALSE)
  pkgdown::build_site(...)
}

#' Offline build with monkey patching
#'
#' Implements the offline build strategy for pkgdown v2.1.0 and later
#' by stubbing functions that require internet access and using cached assets.
#'
#' @param ... Arguments passed to [pkgdown::build_site()].
#'
#' @return Invisible `NULL`, called for side effect of building the website.
#'
#' @noRd
build_site_offline_1 <- function(...) {
  # Stub functions requiring internet
  # <https://github.com/r-lib/pkgdown/pull/2869>
  stub_with_null("pkgdown", "cran_link")
  stub_with_null("pkgdown", "pkg_timeline")

  # Always initialize in case `build_site()` is called directly
  pkgdown.offline::init_site()
  pkgdown::build_site(..., new_process = FALSE)
}
