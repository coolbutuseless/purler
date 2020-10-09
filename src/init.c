
#include <R.h>
#include <Rinternals.h>

extern SEXP rlenc_();
extern SEXP rlenc_id_();

static const R_CallMethodDef CEntries[] = {
  {"rlenc_"      , (DL_FUNC) &rlenc_      , 1},
  {"rlenc_id_"   , (DL_FUNC) &rlenc_id_   , 1},
  {NULL , NULL, 0}
};


void R_init_purler(DllInfo *info) {
  R_registerRoutines(
    info,      // DllInfo
    NULL,      // .C
    CEntries,  // .Call
    NULL,      // Fortran
    NULL       // External
  );
  R_useDynamicSymbols(info, FALSE);
}

