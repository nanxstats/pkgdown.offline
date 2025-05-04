#' Clear pkgdown cache if any
#'
#' @export
clear_cache <- function() {
  path <- tools::R_user_dir("pkgdown", which = "cache")
  dir_delete(path)
}

#' Path to cache directory in pkgdown.offline (source state)
#'
#' @export
path_cache_dev <- function() {
  file.path("inst", "cache")
}

#' Path to cache directory in pkgdown.offline (installed state)
#'
#' @export
path_cache_installed <- function() {
  system.file("cache", package = "pkgdown.offline")
}

#' Copy deps from cache to somewhere (for example, pkgdown.offline in dev mode)
#'
#' @noRd
copy_from_cache <- function(version, destdir) {
  source_cache_dir <- tools::R_user_dir("pkgdown", which = "cache")
  target_cache_dir <- file.path(destdir, version)
  dir_copy(source_cache_dir, target_cache_dir)
  invisible(NULL)
}

#' Copy deps from pkgdown.offline into pkgdown cache
#'
#' @noRd
copy_to_cache <- function(version) {
  target_cache_dir <- tools::R_user_dir("pkgdown", which = "cache")
  restore_cache(version, target_dir = target_cache_dir)
  invisible(NULL)
}

#' @importFrom utils available.packages install.packages
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
#' @param version The version to check.
#' @param target The target version to compare against.
#' @param operator The comparison operator ("==", "<", "<=", ">", ">=").
#'
#' @return Logical result of the comparison
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

#' Safely get a function from a namespace
#'
#' @param ns Namespace.
#' @param name Name of the function to get.
#' @param silent Logical. If `TRUE`, suppress error messages.
#'
#' @return
#' The function if successful. `NULL` if the package is not installed or
#' the function does not exist.
#'
#' @noRd
safe_get <- function(ns, name, silent = FALSE) {
  tryCatch(
    {
      if (!requireNamespace(ns, quietly = TRUE)) {
        if (!silent) warning("Package '", ns, "' is not installed.")
        return(NULL)
      }
      if (!exists(name, envir = asNamespace(ns), inherits = FALSE)) {
        if (!silent) warning("Function '", name, "' does not exist in package '", ns, "'.")
        return(NULL)
      }
      utils::getFromNamespace(name, ns = ns)
    },
    error = function(e) {
      if (!silent) warning("Error getting function: ", e$message)
      NULL
    }
  )
}

#' Safely assign a value to a name in a namespace
#'
#' @param ns Namespace.
#' @param name Name of the object to assign to.
#' @param value Value to assign.
#' @param silent Logical. If `TRUE`, suppress error messages.
#'
#' @return Logical indicating whether assignment was successful.
#'
#' @noRd
safe_assign <- function(ns, name, value, silent = FALSE) {
  tryCatch(
    {
      if (!requireNamespace(ns, quietly = TRUE)) {
        if (!silent) warning("Package '", ns, "' is not installed.")
        return(FALSE)
      }

      assing_ns <- safe_get("assignInNamespace", ns = "utils")
      assing_ns(name, value = value, ns = ns)
      TRUE
    },
    error = function(e) {
      if (!silent) warning("Error assigning in namespace: ", e$message)
      FALSE
    }
  )
}

#' Stub a function in a namespace to return NULL in the current session
#'
#' @param ns Namespace.
#' @param x Name of the function to stub.
#' @param silent Logical. If `TRUE`, suppress error messages.
#'
#' @return Logical indicating whether stubbing was successful.
#'
#' @noRd
stub_with_null <- function(ns, x, silent = FALSE) {
  func <- safe_get(ns, x, silent = silent)
  if (is.null(func)) {
    return(FALSE)
  }
  tryCatch(
    {
      body(func) <- parse(text = "{ NULL }")
      safe_assign(ns, name = x, value = func, silent = silent)
    },
    error = function(e) {
      if (!silent) warning("Error stubbing function: ", e$message)
      FALSE
    }
  )
}
