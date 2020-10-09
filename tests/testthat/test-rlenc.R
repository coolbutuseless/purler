

test_that("rlenc works", {


  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Empty vector rle
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  z1 <- rle (numeric(0))
  z2 <- rlenc_compat(numeric(0))
  z3 <- rlenc(numeric(0))
  expect_identical(z2, z3)

  expect_identical(z1$lengths, z2$lengths)
  expect_identical(z1$values, z2$values)
  expect_identical(inverse.rle(z1), inverse.rle(z2))





  M <- 10
  N <- 1000

  # integer
  zz <- sample(seq_len(M), N, replace = TRUE)
  result <- rlenc(zz)
  res2   <- rlenc_compat(zz)
  expect_identical(result, res2)
  expect_true(inherits(result, 'data.frame'))
  expect_identical(inverse.rle(result), zz)

  # numeric
  zz <- sample(as.numeric(seq_len(M)), N, replace = TRUE)
  result <- rlenc(zz)
  res2   <- rlenc_compat(zz)
  expect_identical(result, res2)
  expect_true(inherits(result, 'data.frame'))
  expect_identical(inverse.rle(result), zz)

  # character
  zz <- sample(letters[seq_len(M)], N, replace = TRUE)
  result <- rlenc(zz)
  res2   <- rlenc_compat(zz)
  expect_identical(result, res2)
  expect_true(inherits(result, 'data.frame'))
  expect_identical(inverse.rle(result), zz)

  # raw
  zz <- sample(as.raw(seq_len(M)), N, replace = TRUE)
  result <- rlenc(zz)
  res2   <- rlenc_compat(zz)
  expect_identical(result, res2)
  expect_true(inherits(result, 'data.frame'))
  expect_identical(inverse.rle(result), zz)


  # logical
  zz <- sample(c(T, F), N, replace = TRUE)
  result <- rlenc(zz)
  res2   <- rlenc_compat(zz)
  expect_identical(result, res2)
  expect_true(inherits(result, 'data.frame'))
  expect_identical(inverse.rle(result), zz)


  expect_error(rlenc(list(1, 2, 3)), 'unsupported')


})
