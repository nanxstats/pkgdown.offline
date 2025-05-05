#' Clear pkgdown cache if any
#'
#' Removes all files from the pkgdown cache directory if it exists.
#' This is useful when troubleshooting or when you want to force a
#' fresh caching of pkgdown external dependencies.
#'
#' @return Invisible `NULL`, called for side effect of clearing the cache.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' pkgdown.offline::clear_cache()
#' }
clear_cache <- function() {
  path <- tools::R_user_dir("pkgdown", which = "cache")
  dir_delete(path)
}

#' Path to cache directory in pkgdown.offline (source state)
#'
#' Returns the path to the cache directory when the package is in
#' development mode (not installed).
#'
#' @return Character string with the path to the cache directory.
#'
#' @export
#'
#' @examples
#' # Get the path to the cache in development mode
#' pkgdown.offline::path_cache_dev()
path_cache_dev <- function() {
  file.path("inst", "cache")
}

#' Path to cache directory in pkgdown.offline (installed state)
#'
#' Returns the path to the cache directory when the package is installed.
#'
#' @return Character string with the path to the cache directory.
#'
#' @export
#'
#' @examples
#' # Get the path to the cache in the installed package
#' pkgdown.offline::path_cache_installed()
path_cache_installed <- function() {
  system.file("cache", package = "pkgdown.offline")
}

#' Copy dependencies from pkgdown cache to a target directory
#'
#' @param version The pkgdown version to copy dependencies for.
#' @param destdir Destination directory to copy the dependencies to.
#'
#' @return Invisible `NULL`, called for side effect of copying files.
#'
#' @noRd
copy_from_cache <- function(version, destdir) {
  source_cache_dir <- tools::R_user_dir("pkgdown", which = "cache")
  target_cache_dir <- file.path(destdir, version)
  dir_copy(source_cache_dir, target_cache_dir)
  invisible(NULL)
}

#' Copy dependencies from pkgdown.offline into pkgdown cache
#'
#' @param version The pkgdown version to copy dependencies for.
#'
#' @return Invisible NULL, called for side effect of copying files.
#'
#' @noRd
copy_to_cache <- function(version) {
  target_cache_dir <- tools::R_user_dir("pkgdown", which = "cache")
  restore_cache(version, target_dir = target_cache_dir)
  invisible(NULL)
}

#' Install a specific version of pkgdown
#'
#' @param version The version of pkgdown to install.
#'
#' @return Invisible `NULL`, called for side effect of installing pkgdown.
#'
#' @importFrom utils available.packages install.packages
#'
#' @noRd
install_pkgdown <- function(version) {
  current_version <- available.packages(repos = "https://cloud.r-project.org/")["pkgdown", "Version"]
  url <- if (version == current_version) {
    paste0("https://cloud.r-project.org/src/contrib/pkgdown_", version, ".tar.gz")
  } else {
    paste0("https://cloud.r-project.org/src/contrib/Archive/pkgdown/pkgdown_", version, ".tar.gz")
  }
  install.packages(url, repos = NULL)
}

#' Compare package versions
#'
#' Compares two package versions using a specified operator.
#'
#' @param version The version to check.
#' @param operator The comparison operator ("==", "<", "<=", ">", ">=").
#' @param target The target version to compare against.
#'
#' @return Logical result of the comparison.
#'
#' @noRd
compare_version <- function(
    version,
    operator = c("==", "<", "<=", ">", ">="),
    target) {
  operator <- match.arg(operator)
  result <- utils::compareVersion(as.character(version), target)

  switch(operator,
    "==" = result == 0,
    "<"  = result < 0,
    "<=" = result <= 0,
    ">"  = result > 0,
    ">=" = result >= 0,
    stop("Invalid operator: ", operator)
  )
}
