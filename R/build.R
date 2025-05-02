#' Build a complete pkgdown website offline
#'
#' @param ... Arguments passed to [pkgdown::build_site()].
#'
#' @importFrom utils packageVersion
#'
#' @export
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
#' @param version The pkgdown version.
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
#' @param ... Arguments passed to [pkgdown::build_site()].
#'
#' @noRd
build_site_offline_0 <- function(...) {
  options(pkgdown.internet = FALSE)
  pkgdown::build_site(...)
}

#' Build with monkey patching
#'
#' @param ... Arguments passed to [pkgdown::build_site()].
#'
#' @noRd
build_site_offline_1 <- function(...) {
  # Monkey patch internet-dependent functions
  # <https://github.com/r-lib/pkgdown/pull/2869>
  return_null("cran_link")
  return_null("pkg_timeline")

  # Always initialize in case `build_site()` is called directly
  pkgdown.offline::init_site()
  pkgdown::build_site(..., new_process = FALSE)
}

#' @importFrom utils getFromNamespace
#'
#' @noRd
return_null <- function(f) {
  func <- getFromNamespace(f, ns = "pkgdown")
  code <- deparse(body(func))
  code <- "{ NULL }"
  body(func) <- parse(text = code)
  safe_assign(f, func, ns = "pkgdown")
}

#' @importFrom utils getFromNamespace
#'
#' @noRd
safe_assign <- function(name, value, ns) {
  f <- getFromNamespace("assignInNamespace", ns = "utils")
  f(name, value, ns)
}
