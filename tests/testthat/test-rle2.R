


test_that("rle2 works", {


  z1 <- rle (numeric(0))
  z2 <- rle2(numeric(0))
  expect_identical(z1, z2)


  M <- 10
  N <- 1000

  # integer
  zz <- sample(seq_len(M), N, replace = TRUE)
  result <- rle2(zz)
  expect_true(inherits(result, 'rle'))
  expect_identical(inverse.rle(result), zz)

  # numeric
  zz <- sample(as.numeric(seq_len(M)), N, replace = TRUE)
  result <- rle2(zz)
  expect_true(inherits(result, 'rle'))
  expect_identical(inverse.rle(result), zz)

  # character
  zz <- sample(letters[seq_len(M)], N, replace = TRUE)
  result <- rle2(zz)
  expect_true(inherits(result, 'rle'))
  expect_identical(inverse.rle(result), zz)

  # raw
  zz <- sample(as.raw(seq_len(M)), N, replace = TRUE)
  result <- rle2(zz)
  expect_true(inherits(result, 'rle'))
  expect_identical(inverse.rle(result), zz)


  # logical
  zz <- sample(c(T, F), N, replace = TRUE)
  result <- rle2(zz)
  expect_true(inherits(result, 'rle'))
  expect_identical(inverse.rle(result), zz)



})
