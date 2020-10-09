
#include <R.h>
#include <Rinternals.h>
#include <Rdefines.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Run-length encoding group id
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SEXP rlenc_id_(SEXP x) {

  int len = length(x);

  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Create an integer vector of the correct length and copy into it
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  SEXP id_ = PROTECT(allocVector(INTSXP, len));

  switch( TYPEOF( x ) ) {
  case INTSXP: case LGLSXP: {
    int *id = INTEGER(id_);
    id[0] = 1;
    int group = 1;
    int *xptr = INTEGER( x );
    for(int i = 1; i < len; ++i ) {
      group += xptr[i] != xptr[i-1];
      id[i] = group;
    }
  } break;
  case RAWSXP: {
    int *id = INTEGER(id_);
    id[0] = 1;
    int group = 1;
    unsigned char *xptr = RAW( x );
    for(int i = 1; i < len; ++i ) {
      group += xptr[i] != xptr[i-1];
      id[i] = group;
    }
  } break;
  case REALSXP: {
    int *id = INTEGER(id_);
    id[0] = 1;
    int group = 1;
    // NA_REAL is never equal to NA_REAL in floating point calcs
    // So use a 'long long' interpretation to treat as integer
    long long *llxptr = (long long *)REAL(x);
    for(int i = 1; i < len; ++i ) {
      group += llxptr[i] != llxptr[i-1];
      id[i] = group;
    }
  } break;
  case STRSXP: {
    int *id = INTEGER(id_);
    id[0] = 1;
    int group = 1;
    const SEXP *jd = STRING_PTR( x );
    for (int i = 1; i < len; ++i ) {
      group += jd[i] != jd[i-1];
      id[i] = group;
      //id[i] = jd[i] != jd[i-1] ? ++group : group;
    }
  } break;
  default: {
    error("rlenc_id(): unsupported vector type");
  }
  }


  UNPROTECT(1);
  return id_;

}


