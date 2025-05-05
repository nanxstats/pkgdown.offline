#' Create directory
#'
#' Creates a directory if it does not already exist.
#'
#' @param path Path to the directory to create.
#'
#' @return `TRUE` if the directory exists or was successfully created.
#'
#' @noRd
dir_create <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE) else TRUE
}

#' Delete directories
#'
#' Recursively removes a directory and all its contents.
#'
#' @param path Path to the directory to delete.
#'
#' @return
#' Invisible `NULL` if directory does not exist.
#' Otherwise, invisible 0 for success, 1 for failure.
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
#' Recursively copies a directory and all its contents to a new location.
#' The destination directory will be deleted first if it exists.
#'
#' @param from Path to the source directory.
#' @param to Path to the destination directory.
#'
#' @return
#' Invisible logical vector indicating whether each file was successfully copied.
#'
#' @noRd
dir_copy <- function(from, to) {
  dir_delete(to)
  dir_create(to)
  invisible(file.copy(list.files(from, full.names = TRUE), to, recursive = TRUE, overwrite = TRUE))
}
