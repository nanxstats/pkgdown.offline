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
