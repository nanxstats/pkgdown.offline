#' Build a complete pkgdown website offline
#'
#' @param ... TBA
#'
#' @importFrom utils packageVersion
#'
#' @export
build_site <- function(...) {
  # TODO: support versions forward and backward
  version <- packageVersion("pkgdown")

  if (version %in% c("2.1.0", "2.1.1")) {
    options(pkgdown.internet = FALSE)
    pkgdown::build_site(...)
  }
  if (version %in% c("2.1.2")) {
    # Monkey patch internet-dependent functions
    # <https://github.com/r-lib/pkgdown/pull/2869>
    return_null("cran_link")
    return_null("pkg_timeline")

    # Always initialize in case `build_site()` is called directly
    pkgdown.offline::init_site()
    pkgdown::build_site(..., new_process = FALSE)
  }
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
