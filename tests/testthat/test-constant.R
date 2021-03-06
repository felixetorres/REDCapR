library(testthat)

test_that("scalar w/ simplify", {
  expect_equal(object= constant("form_incomplete"    ), expected=0L)
  expect_equal(object= constant("form_unverified"    ), expected=1L)
  expect_equal(object= constant("form_complete"      ), expected=2L)
})

test_that("scalar w/o simplify", {
  expect_equal(object= constant("form_incomplete"    , simplify=T), expected=0L)
  expect_equal(object= constant("form_unverified"    , simplify=T), expected=1L)
  expect_equal(object= constant("form_complete"      , simplify=T), expected=2L)
})

test_that("vector w/ simplify", {
  expected <- c(2L, 2L, 0L)
  observed <- constant(c("form_complete", "form_complete", "form_incomplete"), simplify=T)
  expect_equal(observed, expected)
})

test_that("vector w/o simplify", {
  expected <- list(2L, 2L, 0L)
  observed <- constant(c("form_complete", "form_complete", "form_incomplete"), simplify=F)
  expect_equal(observed, expected)
})

test_that("bad-name", {
  # expected_error_message <- "Assertion on 'name' failed: Must be a subset of {'form_complete','form_incomplete','form_unverified'}, but is {'bad-name'}."
  expected_error_message <- "^Assertion on 'name' failed.+"

  expect_error(
    constant("bad-name"),
    expected_error_message
  )
  expect_error(
    constant(c("bad-name", "form_complete")),
    expected_error_message
  )
})

test_that("missing name", {
  # expected_error_message <- ""Assertion on 'name' failed: Must be a subset of {'form_complete','form_incomplete','form_unverified'}, but is {'bad-name'}.""Assertion on 'name' failed: Contains missing values (element 1)."
  expected_error_message <- "^Assertion on 'name' failed.+"

  expect_error(
    constant(NA_character_),
    expected_error_message
  )
  expect_error(
    constant(c(NA_character_, "form_complete")),
    expected_error_message
  )
})

test_that("bad simplify", {
  # expected_error_message <- "Assertion on 'simplify' failed: Must be of type 'logical', not 'character'."
  expect_error(
    constant("form_complete", simplify="aa"),
    "^Assertion on 'simplify' failed: Must be of type 'logical', not 'character'\\.$"
  )
})
test_that("missing simplify", {
  # expected_error_message <- "Assertion on 'simplify' failed: Must be of type 'logical', not 'NULL'. "
  expect_error(
    constant("form_complete", simplify=NULL),
    "^Assertion on 'simplify' failed: Must be of type 'logical', not 'NULL'\\.$"
  )
})
test_that("NA simplify", {
  # newer version of checkmate: "Assertion on 'simplify' failed: Contains missing values (element 1)."
  # older version of checkmate: "Assertion on 'simplify' failed: Contains missing values."
  expect_error(
    constant("form_complete", simplify=NA_character_),
    "^Assertion on 'simplify' failed: Contains missing values.*$"
  )
})


# ---- constant-to-* -----------------------------------------------------------
test_that("constant_to_form_completion", {
  expected <- structure(c(1L, 3L, 2L, 3L, 4L), .Label = c("incomplete", "unverified", "complete", "unknown"), class = "factor")
  observed <- constant_to_form_completion(c(0, 2, 1, 2, NA))
  expect_equal(observed, expected)
})

test_that("constant_to_form_rights", {
  expected <- structure(c(1L, 4L, 3L, 2L, 5L), .Label = c("no_access", "readonly", "edit_form", "edit_survey", "unknown"), class = "factor")
  observed <- constant_to_form_rights(c(0, 3, 1, 2, NA))
  expect_equal(observed, expected)
})

test_that("constant_to_export_rights", {
  expected <- structure(c(1L, 3L, 2L, 3L, 4L), .Label = c("no_access", "deidentified", "rights_full", "unknown"), class = "factor")
  observed <- constant_to_export_rights(c(0, 2, 1, 2, NA))
  expect_equal(observed, expected)
})

test_that("constant_to_access", {
  expected <- structure(c(1L, 2L, 2L, 1L, 3L), .Label = c("no", "yes", "unknown"), class = "factor")
  observed <- constant_to_access(c(0, 1, 1, 0, NA))
  expect_equal(observed, expected)
})


# ---- constant-to-* errors -----------------------------------------------------------
test_that("constant_to_form_completion-error", {
  expect_error(
    constant_to_form_completion(NULL),
    "^The value to recode must be a character, integer, or floating point.  It was `NULL`\\.$",
  )
})

test_that("constant_to_form_rights-error", {
  expect_error(
    constant_to_form_rights(NULL),
    "^The value to recode must be a character, integer, or floating point.  It was `NULL`\\.$",
  )
})

test_that("constant_to_export_rights-error", {
  expect_error(
    constant_to_export_rights(NULL),
    "^The value to recode must be a character, integer, or floating point.  It was `NULL`\\.$",
  )
})

test_that("constant_to_access-error", {
  expect_error(
    constant_to_access(NULL),
    "^The value to recode must be a character, integer, or floating point.  It was `NULL`\\.$",
  )
})
