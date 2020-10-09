

test_that("rlend works", {

  M <- 10
  N <- 1000

  # integer
  zz <- sample(seq_len(M), N, replace = TRUE)
  result <- rlenc(zz)
  expect_true(inherits(result, 'data.frame'))
  expect_identical(inverse.rle(result), zz)

  # numeric
  zz <- sample(as.numeric(seq_len(M)), N, replace = TRUE)
  result <- rlenc(zz)
  expect_true(inherits(result, 'data.frame'))
  expect_identical(inverse.rle(result), zz)

  # character
  zz <- sample(letters[seq_len(M)], N, replace = TRUE)
  result <- rlenc(zz)
  expect_true(inherits(result, 'data.frame'))
  expect_identical(inverse.rle(result), zz)

  # raw
  zz <- sample(as.raw(seq_len(M)), N, replace = TRUE)
  result <- rlenc(zz)
  expect_true(inherits(result, 'data.frame'))
  expect_identical(inverse.rle(result), zz)


  # logical
  zz <- sample(c(T, F), N, replace = TRUE)
  result <- rlenc(zz)
  expect_true(inherits(result, 'data.frame'))
  expect_identical(inverse.rle(result), zz)


  expect_error(rlenc(list(1, 2, 3)), 'unsupported')


})
