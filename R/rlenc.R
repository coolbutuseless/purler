


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Fast run-length encoding.
#'
#' @param x atomic vector of raw, logical, integer, numeric or character data
#'
#' @return a data.frame with lengths, values and start location of each run
#'         within the given vector
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rlenc <- function(x) {

  if (length(x) == 0L) {
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


  .Call(rlenc_, x)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Fast run-length encoding of group id
#'
#' @inheritParams rlenc
#'
#' @return integer vector with group IDs associated with each run of identical
#'         values
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rlenc_id <- function(x) {
  .Call(rlenc_id_, x)
}

