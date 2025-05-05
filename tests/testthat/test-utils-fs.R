test_that("dir_create creates a directory if it doesn't exist", {
  # Create a temporary directory that gets cleaned up automatically
  temp_dir <- local_tempdir()
  new_dir <- file.path(temp_dir, "new_directory")

  # Test creating a new directory
  expect_false(dir.exists(new_dir))
  expect_true(dir_create(new_dir))
  expect_true(dir.exists(new_dir))

  # Test with an existing directory
  expect_true(dir_create(new_dir))
})

test_that("dir_create can create nested directories", {
  temp_dir <- local_tempdir()
  nested_dir <- file.path(temp_dir, "parent", "child", "grandchild")

  expect_false(dir.exists(nested_dir))
  expect_true(dir_create(nested_dir))
  expect_true(dir.exists(nested_dir))
})

test_that("dir_delete removes a directory and its contents", {
  # Create a temporary directory structure
  temp_dir <- local_tempdir()
  test_dir <- file.path(temp_dir, "test_delete")
  dir.create(test_dir)
  file.create(file.path(test_dir, "file.txt"))

  # Test deleting the directory
  expect_true(dir.exists(test_dir))
  dir_delete(test_dir)
  expect_false(dir.exists(test_dir))
})

test_that("dir_delete handles NULL or non-existent directories", {
  # Test with NULL
  expect_null(dir_delete(NULL))

  # Test with non-existent directory
  temp_dir <- local_tempdir()
  non_existent <- file.path(temp_dir, "does_not_exist")
  expect_null(dir_delete(non_existent))
})

test_that("dir_copy copies a directory and its contents", {
  # Create source directory with contents
  temp_dir <- local_tempdir()
  source_dir <- file.path(temp_dir, "source")
  target_dir <- file.path(temp_dir, "target")

  dir.create(source_dir)
  file.create(file.path(source_dir, "file1.txt"))
  file.create(file.path(source_dir, "file2.txt"))

  # Test copying
  expect_false(dir.exists(target_dir))
  dir_copy(source_dir, target_dir)
  expect_true(dir.exists(target_dir))
  expect_true(file.exists(file.path(target_dir, "file1.txt")))
  expect_true(file.exists(file.path(target_dir, "file2.txt")))
})

test_that("dir_copy overwrites existing destination", {
  # Create source and destination directories
  temp_dir <- local_tempdir()
  source_dir <- file.path(temp_dir, "source")
  target_dir <- file.path(temp_dir, "target")

  dir.create(source_dir)
  dir.create(target_dir)
  file.create(file.path(source_dir, "source_file.txt"))
  file.create(file.path(target_dir, "target_file.txt"))

  # Verify initial state
  expect_true(file.exists(file.path(target_dir, "target_file.txt")))
  expect_false(file.exists(file.path(target_dir, "source_file.txt")))

  # Test that copy overwrites
  dir_copy(source_dir, target_dir)
  expect_true(file.exists(file.path(target_dir, "source_file.txt")))
  expect_false(file.exists(file.path(target_dir, "target_file.txt")))
})

test_that("dir_copy works with nested directories", {
  # Create source with nested structure
  temp_dir <- local_tempdir()
  source_dir <- file.path(temp_dir, "source")
  nested_dir <- file.path(source_dir, "nested")
  target_dir <- file.path(temp_dir, "target")

  dir.create(nested_dir, recursive = TRUE)
  file.create(file.path(nested_dir, "nested_file.txt"))

  # Test copying with nested structure
  dir_copy(source_dir, target_dir)
  expect_true(dir.exists(file.path(target_dir, "nested")))
  expect_true(file.exists(file.path(target_dir, "nested", "nested_file.txt")))
})
