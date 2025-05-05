test_that("compare_version() handles equality operator correctly", {
  expect_true(compare_version("1.0.0", "==", "1.0.0"))
  expect_false(compare_version("1.0.0", "==", "1.0.1"))
  expect_false(compare_version("1.0.0", "==", "1.1.0"))
  expect_false(compare_version("1.0", "==", "1.0.0"))
})

test_that("compare_version() handles less than operator correctly", {
  expect_true(compare_version("1.0.0", "<", "1.0.1"))
  expect_true(compare_version("1.0.0", "<", "1.1.0"))
  expect_true(compare_version("0.9.9", "<", "1.0.0"))
  expect_false(compare_version("1.0.0", "<", "1.0.0"))
  expect_false(compare_version("1.0.1", "<", "1.0.0"))
})

test_that("compare_version() handles less than or equal operator correctly", {
  expect_true(compare_version("1.0.0", "<=", "1.0.0"))
  expect_true(compare_version("0.9.9", "<=", "1.0.0"))
  expect_true(compare_version("1.0.0", "<=", "1.0.1"))
  expect_false(compare_version("1.0.1", "<=", "1.0.0"))
  expect_false(compare_version("1.1.0", "<=", "1.0.0"))
})

test_that("compare_version() handles greater than operator correctly", {
  expect_true(compare_version("1.0.1", ">", "1.0.0"))
  expect_true(compare_version("1.1.0", ">", "1.0.0"))
  expect_true(compare_version("2.0.0", ">", "1.9.9"))
  expect_false(compare_version("1.0.0", ">", "1.0.0"))
  expect_false(compare_version("0.9.9", ">", "1.0.0"))
})

test_that("compare_version() handles greater than or equal operator correctly", {
  expect_true(compare_version("1.0.0", ">=", "1.0.0"))
  expect_true(compare_version("1.0.1", ">=", "1.0.0"))
  expect_true(compare_version("1.1.0", ">=", "1.0.0"))
  expect_false(compare_version("0.9.9", ">=", "1.0.0"))
  expect_false(compare_version("0.9.0", ">=", "1.0.0"))
})

test_that("compare_version() validates operator argument", {
  expect_error(compare_version("1.0.0", "!=", "1.0.0"), "should be one of")
  expect_error(compare_version("1.0.0", "invalid", "1.0.0"), "should be one of")
})

test_that("compare_version() handles multi-part version strings", {
  expect_true(compare_version("1.0.0.9000", ">", "1.0.0"))
  expect_true(compare_version("1.2.3.4", "==", "1.2.3.4"))
})
