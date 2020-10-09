

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Run Length Encoding with Modifed \code{NA} handling
#'
#' Compute the lengths and values of runs of equal values in a vector.
#'
#' This is a drop-in replacement for \code{base::rle()} that treats all NAs as
#' identical. The returned object is the same as that produced by \code{base::rle()}
#' and is compatible with \code{base::inverse.rle()}.
#'
#' This function is implemented in pure R - modelled after \code{base::rle()} and
#' should be compatible with whatever input the base function accepts.
#'
#' If the input is a raw, logical, integer, numeric or character vector
#' then \code{rlenc()} may be a faster alternative.
#'
#' @param x an atomic vector (not a list)
#'
#' @return   \code{rle2()} returns an object of class \code{"rle"} which is a list
#' with components:
#'   \item{lengths}{an integer vector containing the length of each run.}
#' \item{values}{a vector of the same length as \code{lengths} with the
#'   corresponding values.}
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rle2 <- function (x)  {
  stopifnot("'x' must be a vector of an atomic type" = is.atomic(x))

  n <- length(x)
  if (n == 0L) {
    return(structure(list(
      lengths = integer(), values = x),
      class = 'rle'))
  }

  # Where does next value not equal current value?
  # i.e. y will be TRUE at the last index before a change
  y <- (x[-1L] != x[-n])

  # Since NAs are never equal to anything, NAs in 'x' will lead to NAs in 'y'.
  # These current NAs in 'y' tell use nothing - Set all NAs in y to FALSE
  y[is.na(y)] <- FALSE

  # When a value in x is NA and its successor is not (or vice versa) then that
  # should also count as a value change and location in 'y' should be set to TRUE
  y <- y | xor(is.na(x[-1L]), is.na(x[-n]))

  # Any TRUE locations in 'y' are the end of a run, where the next value
  # changes to something different
  i <- c(which(y), n)

  structure(list(
    lengths = diff(c(0L, i)),
    values  = x[i]
  ), class = 'rle')
}


