


test_that("rleid works", {

  zz <- c(0, 0, 1, 1, 1, 2, 2, 1, 1, NA, NA)
  truth <- as.integer(c(1, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5))

  result <- rlenc_id(zz)
  expect_identical(result, truth)

  yy <- as.integer(zz)
  result <- rlenc_id(yy)
  expect_identical(result, truth)


  # Note: NAs aren't expressible in Raw vectors
  yy <- suppressWarnings(as.raw(zz))
  result <- rlenc_id(yy)
  expect_identical(result, truth)

  yy <- c('apple', 'bob', 'cat')[zz + 1]
  result <- rlenc_id(yy)
  expect_identical(result, truth)


  expect_error(rlenc_id(list(1, 2, 3)), 'unsupported')

})
