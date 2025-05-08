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
