#' Create directory
#'
#' @param path TBA
#'
#' @noRd
dir_create <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE) else TRUE
}

#' Delete directories
#'
#' @param path TBA
#'
#' @noRd
dir_delete <- function(path) {
  if (is.null(path) || !dir.exists(path)) {
    return()
  }
  unlink(path, recursive = TRUE)
}

#' Copy directories
#'
#' @param from TBA
#' @param to TBA
#'
#' @noRd
dir_copy <- function(from, to) {
  dir_delete(to)
  dir_create(to)
  invisible(file.copy(list.files(from, full.names = TRUE), to, recursive = TRUE, overwrite = TRUE))
}
