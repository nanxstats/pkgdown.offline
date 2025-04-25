#' @export
build_site <- function(...) {
  version <- packageVersion("pkgdown")

  if (version %in% c("2.1.0", "2.1.1")) options(pkgdown.internet = FALSE)
  if (version %in% c("2.1.2")) disable_cran_link()

  pkgdown::build_site(...)
}

disable_cran_link <- function() {
  func <- getFromNamespace("cran_link", ns = "pkgdown")
  code <- deparse(body(func))
  code <- "{ NULL }"
  body(func) <- parse(text = code)
  assignInNamespace("cran_link", func, ns = "pkgdown")
}
