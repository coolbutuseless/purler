

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Run Length Encoding with Modifed \code{NA} handling
#'
#' Compute the lengths and values of runs of equal values in a vector.
#'
#' This is a drop-in replacement for \code{base::rle()} that treats all NAs as
#' identical. The returned object is a data.frame which is compatible with
#' \code{base::inverse.rle()}.
#'
#' This function is implemented in pure R - modelled after \code{base::rle()} and
#' should be compatible with every input the base function accepts.
#'
#' If the input is a simple raw, logical, integer, numeric or character vector
#' then \code{rlenc()} may be a faster alternative.
#'
#' @param x an atomic vector (not a list)
#'
#' @return   \code{rlenc_compat()} returns an object of class \code{"rle"} which
#' is a data.frame with components:
#' \item{start}{index of each first element in a run of a values}
#' \item{lengths}{an integer vector containing the length of each run.}
#' \item{values}{a vector of the same length as \code{lengths} with the
#'   corresponding values.}
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rlenc_compat <- function (x)  {
  stopifnot("'x' must be a vector of an atomic type" = is.atomic(x))

  n <- length(x)
  if (n == 0L) {
    return(
      structure(
        list(
          start   = integer(0),
          lengths = integer(0),
          values = x
        ),
        class     = "data.frame",
        row.names = integer(0))
    )
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Where does next value not equal current value?
  # i.e. y will be TRUE at the last index before a change
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  y <- (x[-1L] != x[-n])

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Since NAs are never equal to anything, NAs in 'x' will lead to NAs in 'y'.
  # These current NAs in 'y' tell use nothing - Set all NAs in y to FALSE
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  y[is.na(y)] <- FALSE

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # When a value in x is NA and its successor is not (or vice versa) then that
  # should also count as a value change and location in 'y' should be set to TRUE
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  y <- y | xor(is.na(x[-1L]), is.na(x[-n]))

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Any TRUE locations in 'y' are the end of a run, where the next value
  # changes to something different
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  i <- c(which(y), n)

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Return a data.frame rather than a list.
  # Still compatible with inverse.rle()
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  structure(
    list(
      lengths = diff(c(0L, i)),
      values  = x[i],
      start   = c(1L, i[-length(i)] + 1L)
    ),
    class = c("data.frame"),
    row.names = c(NA, length(i))
  )
}


