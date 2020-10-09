

#include <R.h>
#include <Rinternals.h>
#include <Rdefines.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Run-length encoding. Returning a data.frame
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SEXP rlenc_(SEXP x) {

  int len = length(x);
  int counter = 0;

  int *start = (int *)calloc(len, sizeof(int));
  SEXP value_;

  start[0] = 1;
  counter++;

  switch( TYPEOF( x ) ) {
  case INTSXP: case LGLSXP: {
    int *xptr = INTEGER( x );
    for(int i = 1; i < len; ++i ) {
      if( xptr[i] != xptr[i-1] ) {
        start[ counter ] = i + 1;
        counter++;
      }
    }
    if (TYPEOF(x) == INTSXP) {
      value_ = PROTECT(allocVector(INTSXP, counter));
    } else {
      value_ = PROTECT(allocVector(LGLSXP, counter));
    }
    int *valuep = INTEGER(value_);
    for (int i = 0; i < counter; ++i) {
      valuep[i] = xptr[start[i] - 1];
    }
  } break;
  case RAWSXP: {
    unsigned char *xptr = RAW( x );
    for(int i = 1; i < len; ++i ) {
      if( xptr[i] != xptr[i-1] ) {
        start[ counter ] = i + 1;
        counter++;
      }
    }
    value_ = PROTECT(allocVector(RAWSXP, counter));
    unsigned char *valuep = RAW(value_);
    for (int i = 0; i < counter; ++i) {
      valuep[i] = xptr[start[i] - 1];
    }
  } break;
  case REALSXP: {
    // NA_REAL is never equal to NA_REAL in floating point calcs
    // So use a 'long long' interpretation to treat as integer
    double *xptr = (double *)REAL(x);
    long long *llxptr = (long long *)REAL(x);
    for(int i = 1; i < len; ++i ) {
      if( llxptr[i] != llxptr[i-1] ) {
        start[ counter ] = i + 1;
        counter++;
      }
    }
    value_ = PROTECT(allocVector(REALSXP, counter));
    double *valuep = REAL(value_);
    for (int i = 0; i < counter; ++i) {
      valuep[i] = xptr[start[i] - 1];
    }
  } break;
  case STRSXP: {
    //error("STRXP not done yet mike");
    const SEXP *jd = STRING_PTR( x );
    for (int i = 1; i < len; ++i ) {
      if( jd[i] != jd[i-1] ) {
        start[ counter ] = i + 1;
        counter++;
      }
    }

    // Copy values into destination
    value_ = PROTECT(allocVector(STRSXP, counter));
    for (int i = 0; i < counter; ++i) {
      SET_STRING_ELT(value_, i, STRING_ELT(x, start[i] - 1));
    }

  } break;
  default: {
    error("rlenc(): unsupported vector type");
  }
  }

  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Create an integer vector of the correct length and copy into it
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  SEXP start_ = PROTECT(allocVector(INTSXP, counter));
  memcpy(INTEGER(start_), start, 4 * counter);


  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Calculate lengths from the vector of start locations
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  SEXP len_ = PROTECT(allocVector(INTSXP, counter));
  int *lenp = INTEGER(len_);

  for (int i = 0; i < counter-1; ++i) {
    lenp[i] = start[i + 1] - start[i];
  }
  lenp[counter - 1] = len - start[counter - 1] + 1;


  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Return list/data.frame
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  SEXP df_ = PROTECT(allocVector(VECSXP, 3));
  SET_VECTOR_ELT(df_, 0, start_);
  SET_VECTOR_ELT(df_, 1, value_);
  SET_VECTOR_ELT(df_, 2, len_  );


  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Set the names on the list.
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  SEXP names = PROTECT(allocVector(STRSXP, 3));
  SET_STRING_ELT(names, 0, mkChar("start" ));
  SET_STRING_ELT(names, 1, mkChar("values" ));
  SET_STRING_ELT(names, 2, mkChar("lengths"));
  setAttrib(df_, R_NamesSymbol, names);


  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Promote the current list to a full data.frame
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  SET_CLASS(df_, mkString("data.frame"));


  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Set the row.names on the list.
  // Use the shortcut as used in .set_row_names() in R
  // i.e. set rownames to c(NA_integer, -len) and it will
  // take care of the rest
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  SEXP rownames = PROTECT(allocVector(INTSXP, 2));
  SET_INTEGER_ELT(rownames, 0, NA_INTEGER);
  SET_INTEGER_ELT(rownames, 1, -counter);
  setAttrib(df_, R_RowNamesSymbol, rownames);


  free(start);
  UNPROTECT(6);
  return df_;

}


