#' Create a temporary directory that is automatically cleaned up
#'
#' Creates a temporary directory and sets up an `on.exit()` handler to
#' remove it when the calling function exits.
#'
#' @param pattern Pattern for directory name.
#' @param tmpdir Parent temporary directory (defaults to `tempdir()`).
#' @param envir Environment in which to register the cleanup action (defaults to parent frame).
#'
#' @return Path to the created temporary directory.
local_tempdir <- function(
    pattern = "pkgdown-offline-test-",
    tmpdir = tempdir(),
    envir = parent.frame()) {
  path <- tempfile(pattern = pattern, tmpdir = tmpdir)
  dir.create(path, recursive = TRUE)

  # Register cleanup in the specified environment (typically the test function)
  do.call(
    "on.exit",
    list(substitute(unlink(path, recursive = TRUE)), add = TRUE),
    envir = envir
  )

  path
}
