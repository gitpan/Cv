#define PERL_constant_NOTFOUND	1
#define PERL_constant_NOTDEF	2
#define PERL_constant_ISIV	3
#define PERL_constant_ISNO	4
#define PERL_constant_ISNV	5
#define PERL_constant_ISPV	6
#define PERL_constant_ISPVN	7
#define PERL_constant_ISSV	8
#define PERL_constant_ISUNDEF	9
#define PERL_constant_ISUV	10
#define PERL_constant_ISYES	11

#ifndef NVTYPE
typedef double NV; /* 5.6 and later define NVTYPE, and typedef NV to it.  */
#endif
#ifndef aTHX_
#define aTHX_ /* 5.6 or later define this for threading support.  */
#endif
#ifndef pTHX_
#define pTHX_ /* 5.6 or later define this for threading support.  */
#endif

static int
constant_5 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_1F CV_8S CV_8U CV_AA CV_L1 CV_L2 CV_LU CV_OK CV_PI */
  /* Offset 4 gives the best switch position.  */
  switch (name[4]) {
  case '1':
    if (memEQ(name, "CV_L", 4)) {
    /*                   1     */
#ifdef CV_L1
      *iv_return = CV_L1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '2':
    if (memEQ(name, "CV_L", 4)) {
    /*                   2     */
#ifdef CV_L2
      *iv_return = CV_L2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'A':
    if (memEQ(name, "CV_A", 4)) {
    /*                   A     */
#ifdef CV_AA
      *iv_return = CV_AA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'F':
    if (memEQ(name, "CV_1", 4)) {
    /*                   F     */
#ifdef CV_1F
      *iv_return = CV_1F;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "CV_P", 4)) {
    /*                   I     */
#ifdef CV_PI
      *iv_return = CV_PI;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'K':
    if (memEQ(name, "CV_O", 4)) {
    /*                   K     */
#ifdef CV_OK
      *iv_return = CV_OK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_8", 4)) {
    /*                   S     */
#ifdef CV_8S
      *iv_return = CV_8S;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'U':
    if (memEQ(name, "CV_8", 4)) {
    /*                   U     */
#ifdef CV_8U
      *iv_return = CV_8U;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_L", 4)) {
    /*                   U     */
#ifdef CV_LU
      *iv_return = CV_LU;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_6 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_16S CV_16U CV_32F CV_32S CV_64F CV_ICC CV_LSQ CV_SVD */
  /* Offset 5 gives the best switch position.  */
  switch (name[5]) {
  case 'C':
    if (memEQ(name, "CV_IC", 5)) {
    /*                    C     */
#ifdef CV_ICC
      *iv_return = CV_ICC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'D':
    if (memEQ(name, "CV_SV", 5)) {
    /*                    D     */
#ifdef CV_SVD
      *iv_return = CV_SVD;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'F':
    if (memEQ(name, "CV_32", 5)) {
    /*                    F     */
#ifdef CV_32F
      *iv_return = CV_32F;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_64", 5)) {
    /*                    F     */
#ifdef CV_64F
      *iv_return = CV_64F;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Q':
    if (memEQ(name, "CV_LS", 5)) {
    /*                    Q     */
#ifdef CV_LSQ
      *iv_return = CV_LSQ;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_16", 5)) {
    /*                    S     */
#ifdef CV_16S
      *iv_return = CV_16S;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_32", 5)) {
    /*                    S     */
#ifdef CV_32S
      *iv_return = CV_32S;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'U':
    if (memEQ(name, "CV_16", 5)) {
    /*                    U     */
#ifdef CV_16U
      *iv_return = CV_16U;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_7 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_8SC1 CV_8SC2 CV_8SC3 CV_8SC4 CV_8UC1 CV_8UC2 CV_8UC3 CV_8UC4 CV_BACK
     CV_BLUR CV_DIFF CV_LOG2 CV_SSE2 */
  /* Offset 6 gives the best switch position.  */
  switch (name[6]) {
  case '1':
    if (memEQ(name, "CV_8SC", 6)) {
    /*                     1     */
#ifdef CV_8SC1
      *iv_return = CV_8SC1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_8UC", 6)) {
    /*                     1     */
#ifdef CV_8UC1
      *iv_return = CV_8UC1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '2':
    if (memEQ(name, "CV_8SC", 6)) {
    /*                     2     */
#ifdef CV_8SC2
      *iv_return = CV_8SC2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_8UC", 6)) {
    /*                     2     */
#ifdef CV_8UC2
      *iv_return = CV_8UC2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_LOG", 6)) {
    /*                     2     */
#ifdef CV_LOG2
      *iv_return = CV_LOG2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SSE", 6)) {
    /*                     2     */
#ifdef CV_SSE2
      *iv_return = CV_SSE2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '3':
    if (memEQ(name, "CV_8SC", 6)) {
    /*                     3     */
#ifdef CV_8SC3
      *iv_return = CV_8SC3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_8UC", 6)) {
    /*                     3     */
#ifdef CV_8UC3
      *iv_return = CV_8UC3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '4':
    if (memEQ(name, "CV_8SC", 6)) {
    /*                     4     */
#ifdef CV_8SC4
      *iv_return = CV_8SC4;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_8UC", 6)) {
    /*                     4     */
#ifdef CV_8UC4
      *iv_return = CV_8UC4;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'F':
    if (memEQ(name, "CV_DIF", 6)) {
    /*                     F     */
#ifdef CV_DIFF
      *iv_return = CV_DIFF;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'K':
    if (memEQ(name, "CV_BAC", 6)) {
    /*                     K     */
#ifdef CV_BACK
      *iv_return = CV_BACK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_BLU", 6)) {
    /*                     R     */
#ifdef CV_BLUR
      *iv_return = CV_BLUR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_8 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_16SC1 CV_16SC2 CV_16SC3 CV_16SC4 CV_16UC1 CV_16UC2 CV_16UC3 CV_16UC4
     CV_32FC1 CV_32FC2 CV_32FC3 CV_32FC4 CV_32SC1 CV_32SC2 CV_32SC3 CV_32SC4
     CV_64FC1 CV_64FC2 CV_64FC3 CV_64FC4 CV_ARRAY CV_FRONT CV_GRAPH CV_LMEDS
     CV_StsOk CV_VALUE */
  /* Offset 7 gives the best switch position.  */
  switch (name[7]) {
  case '1':
    if (memEQ(name, "CV_16SC", 7)) {
    /*                      1     */
#ifdef CV_16SC1
      *iv_return = CV_16SC1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_16UC", 7)) {
    /*                      1     */
#ifdef CV_16UC1
      *iv_return = CV_16UC1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_32FC", 7)) {
    /*                      1     */
#ifdef CV_32FC1
      *iv_return = CV_32FC1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_32SC", 7)) {
    /*                      1     */
#ifdef CV_32SC1
      *iv_return = CV_32SC1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_64FC", 7)) {
    /*                      1     */
#ifdef CV_64FC1
      *iv_return = CV_64FC1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '2':
    if (memEQ(name, "CV_16SC", 7)) {
    /*                      2     */
#ifdef CV_16SC2
      *iv_return = CV_16SC2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_16UC", 7)) {
    /*                      2     */
#ifdef CV_16UC2
      *iv_return = CV_16UC2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_32FC", 7)) {
    /*                      2     */
#ifdef CV_32FC2
      *iv_return = CV_32FC2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_32SC", 7)) {
    /*                      2     */
#ifdef CV_32SC2
      *iv_return = CV_32SC2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_64FC", 7)) {
    /*                      2     */
#ifdef CV_64FC2
      *iv_return = CV_64FC2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '3':
    if (memEQ(name, "CV_16SC", 7)) {
    /*                      3     */
#ifdef CV_16SC3
      *iv_return = CV_16SC3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_16UC", 7)) {
    /*                      3     */
#ifdef CV_16UC3
      *iv_return = CV_16UC3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_32FC", 7)) {
    /*                      3     */
#ifdef CV_32FC3
      *iv_return = CV_32FC3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_32SC", 7)) {
    /*                      3     */
#ifdef CV_32SC3
      *iv_return = CV_32SC3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_64FC", 7)) {
    /*                      3     */
#ifdef CV_64FC3
      *iv_return = CV_64FC3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '4':
    if (memEQ(name, "CV_16SC", 7)) {
    /*                      4     */
#ifdef CV_16SC4
      *iv_return = CV_16SC4;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_16UC", 7)) {
    /*                      4     */
#ifdef CV_16UC4
      *iv_return = CV_16UC4;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_32FC", 7)) {
    /*                      4     */
#ifdef CV_32FC4
      *iv_return = CV_32FC4;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_32SC", 7)) {
    /*                      4     */
#ifdef CV_32SC4
      *iv_return = CV_32SC4;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_64FC", 7)) {
    /*                      4     */
#ifdef CV_64FC4
      *iv_return = CV_64FC4;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_VALU", 7)) {
    /*                      E     */
#ifdef CV_VALUE
      *iv_return = CV_VALUE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'H':
    if (memEQ(name, "CV_GRAP", 7)) {
    /*                      H     */
#ifdef CV_GRAPH
      *iv_return = CV_GRAPH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_LMED", 7)) {
    /*                      S     */
#ifdef CV_LMEDS
      *iv_return = CV_LMEDS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "CV_FRON", 7)) {
    /*                      T     */
#ifdef CV_FRONT
      *iv_return = CV_FRONT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Y':
    if (memEQ(name, "CV_ARRA", 7)) {
    /*                      Y     */
#ifdef CV_ARRAY
      *iv_return = CV_ARRAY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'k':
    if (memEQ(name, "CV_StsO", 7)) {
    /*                      k     */
#ifdef CV_StsOk
      *iv_return = CV_StsOk;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_9 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_BadCOI CV_CAP_QT CV_CMP_EQ CV_CMP_GE CV_CMP_GT CV_CMP_LE CV_CMP_LT
     CV_CMP_NE CV_CN_MAX CV_DIFF_C CV_DIST_C CV_FILLED CV_LOG2PI CV_MAT32F
     CV_MAT64D CV_MEDIAN CV_MINMAX CV_NO_ERR CV_RANSAC CV_SCHARR CV_TYZX_Z */
  /* Offset 7 gives the best switch position.  */
  switch (name[7]) {
  case '2':
    if (memEQ(name, "CV_MAT32F", 9)) {
    /*                      ^       */
#ifdef CV_MAT32F
      *iv_return = CV_MAT32F;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '4':
    if (memEQ(name, "CV_MAT64D", 9)) {
    /*                      ^       */
#ifdef CV_MAT64D
      *iv_return = CV_MAT64D;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'A':
    if (memEQ(name, "CV_CN_MAX", 9)) {
    /*                      ^       */
#ifdef CV_CN_MAX
      *iv_return = CV_CN_MAX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MEDIAN", 9)) {
    /*                      ^       */
#ifdef CV_MEDIAN
      *iv_return = CV_MEDIAN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MINMAX", 9)) {
    /*                      ^       */
#ifdef CV_MINMAX
      *iv_return = CV_MINMAX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RANSAC", 9)) {
    /*                      ^       */
#ifdef CV_RANSAC
      *iv_return = CV_RANSAC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_CMP_EQ", 9)) {
    /*                      ^       */
#ifdef CV_CMP_EQ
      *iv_return = CV_CMP_EQ;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_FILLED", 9)) {
    /*                      ^       */
#ifdef CV_FILLED
      *iv_return = CV_FILLED;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'G':
    if (memEQ(name, "CV_CMP_GE", 9)) {
    /*                      ^       */
#ifdef CV_CMP_GE
      *iv_return = CV_CMP_GE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CMP_GT", 9)) {
    /*                      ^       */
#ifdef CV_CMP_GT
      *iv_return = CV_CMP_GT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "CV_CMP_LE", 9)) {
    /*                      ^       */
#ifdef CV_CMP_LE
      *iv_return = CV_CMP_LE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CMP_LT", 9)) {
    /*                      ^       */
#ifdef CV_CMP_LT
      *iv_return = CV_CMP_LT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "CV_CMP_NE", 9)) {
    /*                      ^       */
#ifdef CV_CMP_NE
      *iv_return = CV_CMP_NE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "CV_BadCOI", 9)) {
    /*                      ^       */
#ifdef CV_BadCOI
      *iv_return = CV_BadCOI;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "CV_LOG2PI", 9)) {
    /*                      ^       */
#ifdef CV_LOG2PI
      *iv_return = CV_LOG2PI;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Q':
    if (memEQ(name, "CV_CAP_QT", 9)) {
    /*                      ^       */
#ifdef CV_CAP_QT
      *iv_return = CV_CAP_QT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_NO_ERR", 9)) {
    /*                      ^       */
#ifdef CV_NO_ERR
      *iv_return = CV_NO_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SCHARR", 9)) {
    /*                      ^       */
#ifdef CV_SCHARR
      *iv_return = CV_SCHARR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '_':
    if (memEQ(name, "CV_DIFF_C", 9)) {
    /*                      ^       */
#ifdef CV_DIFF_C
      *iv_return = CV_DIFF_C;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_DIST_C", 9)) {
    /*                      ^       */
#ifdef CV_DIST_C
      *iv_return = CV_DIST_C;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_TYZX_Z", 9)) {
    /*                      ^       */
#ifdef CV_TYZX_Z
      *iv_return = CV_TYZX_Z;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_10 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_BGR2HLS CV_BGR2HSV CV_BGR2Lab CV_BGR2Luv CV_BGR2RGB CV_BGR2XYZ
     CV_BadStep CV_CAP_ANY CV_CAP_MIL CV_CAP_V4L CV_CAP_VFW CV_DIFF_L1
     CV_DIFF_L2 CV_DIST_L1 CV_DIST_L2 CV_HLS2BGR CV_HLS2RGB CV_HSV2BGR
     CV_HSV2RGB CV_LEE_INT CV_LEE_NON CV_Lab2BGR CV_Lab2RGB CV_Luv2BGR
     CV_Luv2RGB CV_MAX_ARR CV_MAX_DIM CV_NEG_INF CV_POS_INF CV_RGB2BGR
     CV_RGB2HLS CV_RGB2HSV CV_RGB2Lab CV_RGB2Luv CV_RGB2XYZ CV_SVD_SYM
     CV_SVD_U_T CV_SVD_V_T CV_XYZ2BGR CV_XYZ2RGB */
  /* Offset 9 gives the best switch position.  */
  switch (name[9]) {
  case '1':
    if (memEQ(name, "CV_DIFF_L", 9)) {
    /*                        1     */
#ifdef CV_DIFF_L1
      *iv_return = CV_DIFF_L1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_DIST_L", 9)) {
    /*                        1     */
#ifdef CV_DIST_L1
      *iv_return = CV_DIST_L1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '2':
    if (memEQ(name, "CV_DIFF_L", 9)) {
    /*                        2     */
#ifdef CV_DIFF_L2
      *iv_return = CV_DIFF_L2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_DIST_L", 9)) {
    /*                        2     */
#ifdef CV_DIST_L2
      *iv_return = CV_DIST_L2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'B':
    if (memEQ(name, "CV_BGR2RG", 9)) {
    /*                        B     */
#ifdef CV_BGR2RGB
      *iv_return = CV_BGR2RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_HLS2RG", 9)) {
    /*                        B     */
#ifdef CV_HLS2RGB
      *iv_return = CV_HLS2RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_HSV2RG", 9)) {
    /*                        B     */
#ifdef CV_HSV2RGB
      *iv_return = CV_HSV2RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_Lab2RG", 9)) {
    /*                        B     */
#ifdef CV_Lab2RGB
      *iv_return = CV_Lab2RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_Luv2RG", 9)) {
    /*                        B     */
#ifdef CV_Luv2RGB
      *iv_return = CV_Luv2RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_XYZ2RG", 9)) {
    /*                        B     */
#ifdef CV_XYZ2RGB
      *iv_return = CV_XYZ2RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'F':
    if (memEQ(name, "CV_NEG_IN", 9)) {
    /*                        F     */
#ifdef CV_NEG_INF
      *iv_return = CV_NEG_INF;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_POS_IN", 9)) {
    /*                        F     */
#ifdef CV_POS_INF
      *iv_return = CV_POS_INF;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "CV_CAP_MI", 9)) {
    /*                        L     */
#ifdef CV_CAP_MIL
      *iv_return = CV_CAP_MIL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CAP_V4", 9)) {
    /*                        L     */
#ifdef CV_CAP_V4L
      *iv_return = CV_CAP_V4L;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "CV_MAX_DI", 9)) {
    /*                        M     */
#ifdef CV_MAX_DIM
      *iv_return = CV_MAX_DIM;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SVD_SY", 9)) {
    /*                        M     */
#ifdef CV_SVD_SYM
      *iv_return = CV_SVD_SYM;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "CV_LEE_NO", 9)) {
    /*                        N     */
#ifdef CV_LEE_NON
      *iv_return = CV_LEE_NON;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_HLS2BG", 9)) {
    /*                        R     */
#ifdef CV_HLS2BGR
      *iv_return = CV_HLS2BGR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_HSV2BG", 9)) {
    /*                        R     */
#ifdef CV_HSV2BGR
      *iv_return = CV_HSV2BGR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_Lab2BG", 9)) {
    /*                        R     */
#ifdef CV_Lab2BGR
      *iv_return = CV_Lab2BGR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_Luv2BG", 9)) {
    /*                        R     */
#ifdef CV_Luv2BGR
      *iv_return = CV_Luv2BGR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MAX_AR", 9)) {
    /*                        R     */
#ifdef CV_MAX_ARR
      *iv_return = CV_MAX_ARR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGB2BG", 9)) {
    /*                        R     */
#ifdef CV_RGB2BGR
      *iv_return = CV_RGB2BGR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_XYZ2BG", 9)) {
    /*                        R     */
#ifdef CV_XYZ2BGR
      *iv_return = CV_XYZ2BGR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_BGR2HL", 9)) {
    /*                        S     */
#ifdef CV_BGR2HLS
      *iv_return = CV_BGR2HLS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGB2HL", 9)) {
    /*                        S     */
#ifdef CV_RGB2HLS
      *iv_return = CV_RGB2HLS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "CV_LEE_IN", 9)) {
    /*                        T     */
#ifdef CV_LEE_INT
      *iv_return = CV_LEE_INT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SVD_U_", 9)) {
    /*                        T     */
#ifdef CV_SVD_U_T
      *iv_return = CV_SVD_U_T;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SVD_V_", 9)) {
    /*                        T     */
#ifdef CV_SVD_V_T
      *iv_return = CV_SVD_V_T;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'V':
    if (memEQ(name, "CV_BGR2HS", 9)) {
    /*                        V     */
#ifdef CV_BGR2HSV
      *iv_return = CV_BGR2HSV;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGB2HS", 9)) {
    /*                        V     */
#ifdef CV_RGB2HSV
      *iv_return = CV_RGB2HSV;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'W':
    if (memEQ(name, "CV_CAP_VF", 9)) {
    /*                        W     */
#ifdef CV_CAP_VFW
      *iv_return = CV_CAP_VFW;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Y':
    if (memEQ(name, "CV_CAP_AN", 9)) {
    /*                        Y     */
#ifdef CV_CAP_ANY
      *iv_return = CV_CAP_ANY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Z':
    if (memEQ(name, "CV_BGR2XY", 9)) {
    /*                        Z     */
#ifdef CV_BGR2XYZ
      *iv_return = CV_BGR2XYZ;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGB2XY", 9)) {
    /*                        Z     */
#ifdef CV_RGB2XYZ
      *iv_return = CV_RGB2XYZ;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'b':
    if (memEQ(name, "CV_BGR2La", 9)) {
    /*                        b     */
#ifdef CV_BGR2Lab
      *iv_return = CV_BGR2Lab;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGB2La", 9)) {
    /*                        b     */
#ifdef CV_RGB2Lab
      *iv_return = CV_RGB2Lab;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'p':
    if (memEQ(name, "CV_BadSte", 9)) {
    /*                        p     */
#ifdef CV_BadStep
      *iv_return = CV_BadStep;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'v':
    if (memEQ(name, "CV_BGR2Lu", 9)) {
    /*                        v     */
#ifdef CV_BGR2Luv
      *iv_return = CV_BGR2Luv;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGB2Lu", 9)) {
    /*                        v     */
#ifdef CV_RGB2Luv
      *iv_return = CV_RGB2Luv;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_11 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_AUTOSTEP CV_BGR2BGRA CV_BGR2GRAY CV_BGR2RGBA CV_BGRA2BGR CV_BGRA2RGB
     CV_BadAlign CV_BadDepth CV_BadOrder CV_CAP_TYZX CV_CAP_V4L2 CV_CN_SHIFT
     CV_DIST_L12 CV_DXT_ROWS CV_FM_LMEDS CV_GAUSSIAN CV_GEMM_A_T CV_GEMM_B_T
     CV_GEMM_C_T CV_GLCM_ALL CV_GRAY2BGR CV_GRAY2RGB CV_INTER_NN CV_LEE_AUTO
     CV_LEE_ZOOM CV_MOP_OPEN CV_NODE_INT CV_NODE_MAP CV_NODE_REF CV_NODE_SEQ
     CV_NODE_STR CV_RAND_UNI CV_RELATIVE CV_RGB2BGRA CV_RGB2GRAY CV_RGB2RGBA
     CV_RGBA2BGR CV_RGBA2RGB CV_SHIFT_LD CV_SHIFT_LU CV_SHIFT_RD CV_SHIFT_RU
     CV_SHIFT_UP CV_StsError CV_StsNoMem CV_TM_CCORR CV_USRTYPE1 */
  /* Offset 10 gives the best switch position.  */
  switch (name[10]) {
  case '1':
    if (memEQ(name, "CV_USRTYPE", 10)) {
    /*                         1      */
#ifdef CV_USRTYPE1
      *iv_return = CV_USRTYPE1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '2':
    if (memEQ(name, "CV_CAP_V4L", 10)) {
    /*                         2      */
#ifdef CV_CAP_V4L2
      *iv_return = CV_CAP_V4L2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_DIST_L1", 10)) {
    /*                         2      */
#ifdef CV_DIST_L12
      *iv_return = CV_DIST_L12;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'A':
    if (memEQ(name, "CV_BGR2BGR", 10)) {
    /*                         A      */
#ifdef CV_BGR2BGRA
      *iv_return = CV_BGR2BGRA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BGR2RGB", 10)) {
    /*                         A      */
#ifdef CV_BGR2RGBA
      *iv_return = CV_BGR2RGBA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGB2BGR", 10)) {
    /*                         A      */
#ifdef CV_RGB2BGRA
      *iv_return = CV_RGB2BGRA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGB2RGB", 10)) {
    /*                         A      */
#ifdef CV_RGB2RGBA
      *iv_return = CV_RGB2RGBA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'B':
    if (memEQ(name, "CV_BGRA2RG", 10)) {
    /*                         B      */
#ifdef CV_BGRA2RGB
      *iv_return = CV_BGRA2RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GRAY2RG", 10)) {
    /*                         B      */
#ifdef CV_GRAY2RGB
      *iv_return = CV_GRAY2RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGBA2RG", 10)) {
    /*                         B      */
#ifdef CV_RGBA2RGB
      *iv_return = CV_RGBA2RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'D':
    if (memEQ(name, "CV_SHIFT_L", 10)) {
    /*                         D      */
#ifdef CV_SHIFT_LD
      *iv_return = CV_SHIFT_LD;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SHIFT_R", 10)) {
    /*                         D      */
#ifdef CV_SHIFT_RD
      *iv_return = CV_SHIFT_RD;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_RELATIV", 10)) {
    /*                         E      */
#ifdef CV_RELATIVE
      *iv_return = CV_RELATIVE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'F':
    if (memEQ(name, "CV_NODE_RE", 10)) {
    /*                         F      */
#ifdef CV_NODE_REF
      *iv_return = CV_NODE_REF;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "CV_RAND_UN", 10)) {
    /*                         I      */
#ifdef CV_RAND_UNI
      *iv_return = CV_RAND_UNI;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "CV_GLCM_AL", 10)) {
    /*                         L      */
#ifdef CV_GLCM_ALL
      *iv_return = CV_GLCM_ALL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "CV_LEE_ZOO", 10)) {
    /*                         M      */
#ifdef CV_LEE_ZOOM
      *iv_return = CV_LEE_ZOOM;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "CV_GAUSSIA", 10)) {
    /*                         N      */
#ifdef CV_GAUSSIAN
      *iv_return = CV_GAUSSIAN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_INTER_N", 10)) {
    /*                         N      */
#ifdef CV_INTER_NN
      *iv_return = CV_INTER_NN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MOP_OPE", 10)) {
    /*                         N      */
#ifdef CV_MOP_OPEN
      *iv_return = CV_MOP_OPEN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "CV_LEE_AUT", 10)) {
    /*                         O      */
#ifdef CV_LEE_AUTO
      *iv_return = CV_LEE_AUTO;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "CV_AUTOSTE", 10)) {
    /*                         P      */
#ifdef CV_AUTOSTEP
      *iv_return = CV_AUTOSTEP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NODE_MA", 10)) {
    /*                         P      */
#ifdef CV_NODE_MAP
      *iv_return = CV_NODE_MAP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SHIFT_U", 10)) {
    /*                         P      */
#ifdef CV_SHIFT_UP
      *iv_return = CV_SHIFT_UP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Q':
    if (memEQ(name, "CV_NODE_SE", 10)) {
    /*                         Q      */
#ifdef CV_NODE_SEQ
      *iv_return = CV_NODE_SEQ;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_BGRA2BG", 10)) {
    /*                         R      */
#ifdef CV_BGRA2BGR
      *iv_return = CV_BGRA2BGR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GRAY2BG", 10)) {
    /*                         R      */
#ifdef CV_GRAY2BGR
      *iv_return = CV_GRAY2BGR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NODE_ST", 10)) {
    /*                         R      */
#ifdef CV_NODE_STR
      *iv_return = CV_NODE_STR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGBA2BG", 10)) {
    /*                         R      */
#ifdef CV_RGBA2BGR
      *iv_return = CV_RGBA2BGR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_TM_CCOR", 10)) {
    /*                         R      */
#ifdef CV_TM_CCORR
      *iv_return = CV_TM_CCORR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_DXT_ROW", 10)) {
    /*                         S      */
#ifdef CV_DXT_ROWS
      *iv_return = CV_DXT_ROWS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_FM_LMED", 10)) {
    /*                         S      */
#ifdef CV_FM_LMEDS
      *iv_return = CV_FM_LMEDS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "CV_CN_SHIF", 10)) {
    /*                         T      */
#ifdef CV_CN_SHIFT
      *iv_return = CV_CN_SHIFT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GEMM_A_", 10)) {
    /*                         T      */
#ifdef CV_GEMM_A_T
      *iv_return = CV_GEMM_A_T;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GEMM_B_", 10)) {
    /*                         T      */
#ifdef CV_GEMM_B_T
      *iv_return = CV_GEMM_B_T;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GEMM_C_", 10)) {
    /*                         T      */
#ifdef CV_GEMM_C_T
      *iv_return = CV_GEMM_C_T;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NODE_IN", 10)) {
    /*                         T      */
#ifdef CV_NODE_INT
      *iv_return = CV_NODE_INT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'U':
    if (memEQ(name, "CV_SHIFT_L", 10)) {
    /*                         U      */
#ifdef CV_SHIFT_LU
      *iv_return = CV_SHIFT_LU;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SHIFT_R", 10)) {
    /*                         U      */
#ifdef CV_SHIFT_RU
      *iv_return = CV_SHIFT_RU;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'X':
    if (memEQ(name, "CV_CAP_TYZ", 10)) {
    /*                         X      */
#ifdef CV_CAP_TYZX
      *iv_return = CV_CAP_TYZX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Y':
    if (memEQ(name, "CV_BGR2GRA", 10)) {
    /*                         Y      */
#ifdef CV_BGR2GRAY
      *iv_return = CV_BGR2GRAY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGB2GRA", 10)) {
    /*                         Y      */
#ifdef CV_RGB2GRAY
      *iv_return = CV_RGB2GRAY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'h':
    if (memEQ(name, "CV_BadDept", 10)) {
    /*                         h      */
#ifdef CV_BadDepth
      *iv_return = CV_BadDepth;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'm':
    if (memEQ(name, "CV_StsNoMe", 10)) {
    /*                         m      */
#ifdef CV_StsNoMem
      *iv_return = CV_StsNoMem;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'n':
    if (memEQ(name, "CV_BadAlig", 10)) {
    /*                         n      */
#ifdef CV_BadAlign
      *iv_return = CV_BadAlign;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'r':
    if (memEQ(name, "CV_BadOrde", 10)) {
    /*                         r      */
#ifdef CV_BadOrder
      *iv_return = CV_BadOrder;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_StsErro", 10)) {
    /*                         r      */
#ifdef CV_StsError
      *iv_return = CV_StsError;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_12 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_AUTO_STEP CV_BGR2YCrCb CV_BGRA2GRAY CV_BGRA2RGBA CV_BILATERAL
     CV_BadOffset CV_BadOrigin CV_CAP_DSHOW CV_CLOCKWISE CV_DEPTH_MAX
     CV_DIST_FAIR CV_DIST_USER CV_DXT_SCALE CV_FM_7POINT CV_FM_8POINT
     CV_FM_RANSAC CV_GLCM_DESC CV_GLCM_GLCM CV_GRAY2BGRA CV_GRAY2RGBA
     CV_HIST_TREE CV_LEE_ERODE CV_LEE_FLOAT CV_LINK_RUNS CV_MOP_CLOSE
     CV_NODE_FLOW CV_NODE_NONE CV_NODE_REAL CV_NODE_USER CV_NORM_MASK
     CV_ORIGIN_BL CV_ORIGIN_TL CV_RETR_LIST CV_RETR_TREE CV_RGB2YCrCb
     CV_RGBA2BGRA CV_RGBA2GRAY CV_SEQ_CHAIN CV_SEQ_INDEX CV_STUB_STEP
     CV_StsBadArg CV_StsNoConv CV_TM_CCOEFF CV_TM_SQDIFF CV_TYZX_LEFT
     CV_YCrCb2BGR CV_YCrCb2RGB IPL_DEPTH_1U IPL_DEPTH_8S IPL_DEPTH_8U */
  /* Offset 8 gives the best switch position.  */
  switch (name[8]) {
  case '2':
    if (memEQ(name, "CV_YCrCb2BGR", 12)) {
    /*                       ^          */
#ifdef CV_YCrCb2BGR
      *iv_return = CV_YCrCb2BGR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_YCrCb2RGB", 12)) {
    /*                       ^          */
#ifdef CV_YCrCb2RGB
      *iv_return = CV_YCrCb2RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'B':
    if (memEQ(name, "CV_GRAY2BGRA", 12)) {
    /*                       ^          */
#ifdef CV_GRAY2BGRA
      *iv_return = CV_GRAY2BGRA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGBA2BGRA", 12)) {
    /*                       ^          */
#ifdef CV_RGBA2BGRA
      *iv_return = CV_RGBA2BGRA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'C':
    if (memEQ(name, "CV_BGR2YCrCb", 12)) {
    /*                       ^          */
#ifdef CV_BGR2YCrCb
      *iv_return = CV_BGR2YCrCb;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_DXT_SCALE", 12)) {
    /*                       ^          */
#ifdef CV_DXT_SCALE
      *iv_return = CV_DXT_SCALE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGB2YCrCb", 12)) {
    /*                       ^          */
#ifdef CV_RGB2YCrCb
      *iv_return = CV_RGB2YCrCb;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_StsNoConv", 12)) {
    /*                       ^          */
#ifdef CV_StsNoConv
      *iv_return = CV_StsNoConv;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'D':
    if (memEQ(name, "CV_GLCM_DESC", 12)) {
    /*                       ^          */
#ifdef CV_GLCM_DESC
      *iv_return = CV_GLCM_DESC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_TM_SQDIFF", 12)) {
    /*                       ^          */
#ifdef CV_TM_SQDIFF
      *iv_return = CV_TM_SQDIFF;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_BILATERAL", 12)) {
    /*                       ^          */
#ifdef CV_BILATERAL
      *iv_return = CV_BILATERAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'F':
    if (memEQ(name, "CV_DIST_FAIR", 12)) {
    /*                       ^          */
#ifdef CV_DIST_FAIR
      *iv_return = CV_DIST_FAIR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NODE_FLOW", 12)) {
    /*                       ^          */
#ifdef CV_NODE_FLOW
      *iv_return = CV_NODE_FLOW;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'G':
    if (memEQ(name, "CV_BGRA2GRAY", 12)) {
    /*                       ^          */
#ifdef CV_BGRA2GRAY
      *iv_return = CV_BGRA2GRAY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GLCM_GLCM", 12)) {
    /*                       ^          */
#ifdef CV_GLCM_GLCM
      *iv_return = CV_GLCM_GLCM;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGBA2GRAY", 12)) {
    /*                       ^          */
#ifdef CV_RGBA2GRAY
      *iv_return = CV_RGBA2GRAY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'H':
    if (memEQ(name, "CV_SEQ_CHAIN", 12)) {
    /*                       ^          */
#ifdef CV_SEQ_CHAIN
      *iv_return = CV_SEQ_CHAIN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_DEPTH_1U", 12)) {
    /*                       ^          */
#ifdef IPL_DEPTH_1U
      *iv_return = IPL_DEPTH_1U;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_DEPTH_8S", 12)) {
    /*                       ^          */
#ifdef IPL_DEPTH_8S
      *iv_return = IPL_DEPTH_8S;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_DEPTH_8U", 12)) {
    /*                       ^          */
#ifdef IPL_DEPTH_8U
      *iv_return = IPL_DEPTH_8U;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "CV_LEE_FLOAT", 12)) {
    /*                       ^          */
#ifdef CV_LEE_FLOAT
      *iv_return = CV_LEE_FLOAT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MOP_CLOSE", 12)) {
    /*                       ^          */
#ifdef CV_MOP_CLOSE
      *iv_return = CV_MOP_CLOSE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RETR_LIST", 12)) {
    /*                       ^          */
#ifdef CV_RETR_LIST
      *iv_return = CV_RETR_LIST;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_TYZX_LEFT", 12)) {
    /*                       ^          */
#ifdef CV_TYZX_LEFT
      *iv_return = CV_TYZX_LEFT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "CV_NORM_MASK", 12)) {
    /*                       ^          */
#ifdef CV_NORM_MASK
      *iv_return = CV_NORM_MASK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "CV_FM_RANSAC", 12)) {
    /*                       ^          */
#ifdef CV_FM_RANSAC
      *iv_return = CV_FM_RANSAC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NODE_NONE", 12)) {
    /*                       ^          */
#ifdef CV_NODE_NONE
      *iv_return = CV_NODE_NONE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_ORIGIN_BL", 12)) {
    /*                       ^          */
#ifdef CV_ORIGIN_BL
      *iv_return = CV_ORIGIN_BL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_ORIGIN_TL", 12)) {
    /*                       ^          */
#ifdef CV_ORIGIN_TL
      *iv_return = CV_ORIGIN_TL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_INDEX", 12)) {
    /*                       ^          */
#ifdef CV_SEQ_INDEX
      *iv_return = CV_SEQ_INDEX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "CV_FM_7POINT", 12)) {
    /*                       ^          */
#ifdef CV_FM_7POINT
      *iv_return = CV_FM_7POINT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_FM_8POINT", 12)) {
    /*                       ^          */
#ifdef CV_FM_8POINT
      *iv_return = CV_FM_8POINT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_TM_CCOEFF", 12)) {
    /*                       ^          */
#ifdef CV_TM_CCOEFF
      *iv_return = CV_TM_CCOEFF;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_BGRA2RGBA", 12)) {
    /*                       ^          */
#ifdef CV_BGRA2RGBA
      *iv_return = CV_BGRA2RGBA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GRAY2RGBA", 12)) {
    /*                       ^          */
#ifdef CV_GRAY2RGBA
      *iv_return = CV_GRAY2RGBA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_LEE_ERODE", 12)) {
    /*                       ^          */
#ifdef CV_LEE_ERODE
      *iv_return = CV_LEE_ERODE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_LINK_RUNS", 12)) {
    /*                       ^          */
#ifdef CV_LINK_RUNS
      *iv_return = CV_LINK_RUNS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NODE_REAL", 12)) {
    /*                       ^          */
#ifdef CV_NODE_REAL
      *iv_return = CV_NODE_REAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_AUTO_STEP", 12)) {
    /*                       ^          */
#ifdef CV_AUTO_STEP
      *iv_return = CV_AUTO_STEP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CAP_DSHOW", 12)) {
    /*                       ^          */
#ifdef CV_CAP_DSHOW
      *iv_return = CV_CAP_DSHOW;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_STUB_STEP", 12)) {
    /*                       ^          */
#ifdef CV_STUB_STEP
      *iv_return = CV_STUB_STEP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "CV_HIST_TREE", 12)) {
    /*                       ^          */
#ifdef CV_HIST_TREE
      *iv_return = CV_HIST_TREE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RETR_TREE", 12)) {
    /*                       ^          */
#ifdef CV_RETR_TREE
      *iv_return = CV_RETR_TREE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'U':
    if (memEQ(name, "CV_DIST_USER", 12)) {
    /*                       ^          */
#ifdef CV_DIST_USER
      *iv_return = CV_DIST_USER;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NODE_USER", 12)) {
    /*                       ^          */
#ifdef CV_NODE_USER
      *iv_return = CV_NODE_USER;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'W':
    if (memEQ(name, "CV_CLOCKWISE", 12)) {
    /*                       ^          */
#ifdef CV_CLOCKWISE
      *iv_return = CV_CLOCKWISE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '_':
    if (memEQ(name, "CV_DEPTH_MAX", 12)) {
    /*                       ^          */
#ifdef CV_DEPTH_MAX
      *iv_return = CV_DEPTH_MAX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'd':
    if (memEQ(name, "CV_StsBadArg", 12)) {
    /*                       ^          */
#ifdef CV_StsBadArg
      *iv_return = CV_StsBadArg;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'f':
    if (memEQ(name, "CV_BadOffset", 12)) {
    /*                       ^          */
#ifdef CV_BadOffset
      *iv_return = CV_BadOffset;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'i':
    if (memEQ(name, "CV_BadOrigin", 12)) {
    /*                       ^          */
#ifdef CV_BadOrigin
      *iv_return = CV_BadOrigin;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_13 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_BADARG_ERR CV_BADROI_ERR CV_BGFG_FGD_T CV_BGR2BGR555 CV_BGR2BGR565
     CV_BGR5552BGR CV_BGR5552RGB CV_BGR5652BGR CV_BGR5652RGB CV_BadDataPtr
     CV_BadROISize CV_CAP_DC1394 CV_CAP_STEREO CV_CAP_UNICAP CV_CHAIN_CODE
     CV_COL_SAMPLE CV_COVAR_COLS CV_COVAR_ROWS CV_DIST_HUBER CV_FACE_MOUTH
     CV_GRAPH_OVER CV_HIST_ARRAY CV_INPAINT_NS CV_INTER_AREA CV_LEE_DOUBLE
     CV_MAGIC_MASK CV_MAT3x1_32F CV_MAT3x1_64D CV_MAT3x3_32F CV_MAT3x3_64D
     CV_MAT4x1_32F CV_MAT4x1_64D CV_MAT4x4_32F CV_MAT4x4_64D CV_MAX_STRLEN
     CV_MOP_TOPHAT CV_NODE_EMPTY CV_NODE_FLOAT CV_NODE_NAMED CV_PLUGIN_MAX
     CV_PLUGIN_MKL CV_REDUCE_AVG CV_REDUCE_MAX CV_REDUCE_MIN CV_REDUCE_SUM
     CV_RELATIVE_C CV_RETR_CCOMP CV_RGB2BGR555 CV_RGB2BGR565 CV_ROW_SAMPLE
     CV_SHAPE_RECT CV_SHIFT_DOWN CV_SHIFT_LEFT CV_SHIFT_NONE CV_StsBadFlag
     CV_StsBadFunc CV_StsBadMask CV_StsBadSize CV_StsNullPtr CV_TYZX_COLOR
     CV_TYZX_RIGHT ICV_CNN_LAYER IPL_DEPTH_16S IPL_DEPTH_16U IPL_DEPTH_32F
     IPL_DEPTH_32S IPL_DEPTH_64F IPL_IMAGE_ROI IPL_ORIGIN_BL IPL_ORIGIN_TL */
  /* Offset 11 gives the best switch position.  */
  switch (name[11]) {
  case '2':
    if (memEQ(name, "CV_MAT3x1_32F", 13)) {
    /*                          ^        */
#ifdef CV_MAT3x1_32F
      *iv_return = CV_MAT3x1_32F;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MAT3x3_32F", 13)) {
    /*                          ^        */
#ifdef CV_MAT3x3_32F
      *iv_return = CV_MAT3x3_32F;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MAT4x1_32F", 13)) {
    /*                          ^        */
#ifdef CV_MAT4x1_32F
      *iv_return = CV_MAT4x1_32F;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MAT4x4_32F", 13)) {
    /*                          ^        */
#ifdef CV_MAT4x4_32F
      *iv_return = CV_MAT4x4_32F;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_DEPTH_32F", 13)) {
    /*                          ^        */
#ifdef IPL_DEPTH_32F
      *iv_return = IPL_DEPTH_32F;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_DEPTH_32S", 13)) {
    /*                          ^        */
#ifdef IPL_DEPTH_32S
      *iv_return = IPL_DEPTH_32S;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '4':
    if (memEQ(name, "CV_MAT3x1_64D", 13)) {
    /*                          ^        */
#ifdef CV_MAT3x1_64D
      *iv_return = CV_MAT3x1_64D;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MAT3x3_64D", 13)) {
    /*                          ^        */
#ifdef CV_MAT3x3_64D
      *iv_return = CV_MAT3x3_64D;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MAT4x1_64D", 13)) {
    /*                          ^        */
#ifdef CV_MAT4x1_64D
      *iv_return = CV_MAT4x1_64D;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MAT4x4_64D", 13)) {
    /*                          ^        */
#ifdef CV_MAT4x4_64D
      *iv_return = CV_MAT4x4_64D;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_DEPTH_64F", 13)) {
    /*                          ^        */
#ifdef IPL_DEPTH_64F
      *iv_return = IPL_DEPTH_64F;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '5':
    if (memEQ(name, "CV_BGR2BGR555", 13)) {
    /*                          ^        */
#ifdef CV_BGR2BGR555
      *iv_return = CV_BGR2BGR555;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGB2BGR555", 13)) {
    /*                          ^        */
#ifdef CV_RGB2BGR555
      *iv_return = CV_RGB2BGR555;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '6':
    if (memEQ(name, "CV_BGR2BGR565", 13)) {
    /*                          ^        */
#ifdef CV_BGR2BGR565
      *iv_return = CV_BGR2BGR565;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGB2BGR565", 13)) {
    /*                          ^        */
#ifdef CV_RGB2BGR565
      *iv_return = CV_RGB2BGR565;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_DEPTH_16S", 13)) {
    /*                          ^        */
#ifdef IPL_DEPTH_16S
      *iv_return = IPL_DEPTH_16S;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_DEPTH_16U", 13)) {
    /*                          ^        */
#ifdef IPL_DEPTH_16U
      *iv_return = IPL_DEPTH_16U;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '9':
    if (memEQ(name, "CV_CAP_DC1394", 13)) {
    /*                          ^        */
#ifdef CV_CAP_DC1394
      *iv_return = CV_CAP_DC1394;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'A':
    if (memEQ(name, "CV_CAP_UNICAP", 13)) {
    /*                          ^        */
#ifdef CV_CAP_UNICAP
      *iv_return = CV_CAP_UNICAP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_HIST_ARRAY", 13)) {
    /*                          ^        */
#ifdef CV_HIST_ARRAY
      *iv_return = CV_HIST_ARRAY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MOP_TOPHAT", 13)) {
    /*                          ^        */
#ifdef CV_MOP_TOPHAT
      *iv_return = CV_MOP_TOPHAT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NODE_FLOAT", 13)) {
    /*                          ^        */
#ifdef CV_NODE_FLOAT
      *iv_return = CV_NODE_FLOAT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PLUGIN_MAX", 13)) {
    /*                          ^        */
#ifdef CV_PLUGIN_MAX
      *iv_return = CV_PLUGIN_MAX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_REDUCE_MAX", 13)) {
    /*                          ^        */
#ifdef CV_REDUCE_MAX
      *iv_return = CV_REDUCE_MAX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'B':
    if (memEQ(name, "IPL_ORIGIN_BL", 13)) {
    /*                          ^        */
#ifdef IPL_ORIGIN_BL
      *iv_return = IPL_ORIGIN_BL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'C':
    if (memEQ(name, "CV_SHAPE_RECT", 13)) {
    /*                          ^        */
#ifdef CV_SHAPE_RECT
      *iv_return = CV_SHAPE_RECT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'D':
    if (memEQ(name, "CV_CHAIN_CODE", 13)) {
    /*                          ^        */
#ifdef CV_CHAIN_CODE
      *iv_return = CV_CHAIN_CODE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_CAP_STEREO", 13)) {
    /*                          ^        */
#ifdef CV_CAP_STEREO
      *iv_return = CV_CAP_STEREO;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_DIST_HUBER", 13)) {
    /*                          ^        */
#ifdef CV_DIST_HUBER
      *iv_return = CV_DIST_HUBER;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GRAPH_OVER", 13)) {
    /*                          ^        */
#ifdef CV_GRAPH_OVER
      *iv_return = CV_GRAPH_OVER;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_INTER_AREA", 13)) {
    /*                          ^        */
#ifdef CV_INTER_AREA
      *iv_return = CV_INTER_AREA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MAX_STRLEN", 13)) {
    /*                          ^        */
#ifdef CV_MAX_STRLEN
      *iv_return = CV_MAX_STRLEN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NODE_NAMED", 13)) {
    /*                          ^        */
#ifdef CV_NODE_NAMED
      *iv_return = CV_NODE_NAMED;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "ICV_CNN_LAYER", 13)) {
    /*                          ^        */
#ifdef ICV_CNN_LAYER
      *iv_return = ICV_CNN_LAYER;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'F':
    if (memEQ(name, "CV_SHIFT_LEFT", 13)) {
    /*                          ^        */
#ifdef CV_SHIFT_LEFT
      *iv_return = CV_SHIFT_LEFT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'G':
    if (memEQ(name, "CV_BGR5552BGR", 13)) {
    /*                          ^        */
#ifdef CV_BGR5552BGR
      *iv_return = CV_BGR5552BGR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BGR5552RGB", 13)) {
    /*                          ^        */
#ifdef CV_BGR5552RGB
      *iv_return = CV_BGR5552RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BGR5652BGR", 13)) {
    /*                          ^        */
#ifdef CV_BGR5652BGR
      *iv_return = CV_BGR5652BGR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BGR5652RGB", 13)) {
    /*                          ^        */
#ifdef CV_BGR5652RGB
      *iv_return = CV_BGR5652RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'H':
    if (memEQ(name, "CV_TYZX_RIGHT", 13)) {
    /*                          ^        */
#ifdef CV_TYZX_RIGHT
      *iv_return = CV_TYZX_RIGHT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "CV_REDUCE_MIN", 13)) {
    /*                          ^        */
#ifdef CV_REDUCE_MIN
      *iv_return = CV_REDUCE_MIN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'K':
    if (memEQ(name, "CV_PLUGIN_MKL", 13)) {
    /*                          ^        */
#ifdef CV_PLUGIN_MKL
      *iv_return = CV_PLUGIN_MKL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "CV_COL_SAMPLE", 13)) {
    /*                          ^        */
#ifdef CV_COL_SAMPLE
      *iv_return = CV_COL_SAMPLE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_COVAR_COLS", 13)) {
    /*                          ^        */
#ifdef CV_COVAR_COLS
      *iv_return = CV_COVAR_COLS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_LEE_DOUBLE", 13)) {
    /*                          ^        */
#ifdef CV_LEE_DOUBLE
      *iv_return = CV_LEE_DOUBLE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_ROW_SAMPLE", 13)) {
    /*                          ^        */
#ifdef CV_ROW_SAMPLE
      *iv_return = CV_ROW_SAMPLE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "CV_RETR_CCOMP", 13)) {
    /*                          ^        */
#ifdef CV_RETR_CCOMP
      *iv_return = CV_RETR_CCOMP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "CV_INPAINT_NS", 13)) {
    /*                          ^        */
#ifdef CV_INPAINT_NS
      *iv_return = CV_INPAINT_NS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SHIFT_NONE", 13)) {
    /*                          ^        */
#ifdef CV_SHIFT_NONE
      *iv_return = CV_SHIFT_NONE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "CV_TYZX_COLOR", 13)) {
    /*                          ^        */
#ifdef CV_TYZX_COLOR
      *iv_return = CV_TYZX_COLOR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_IMAGE_ROI", 13)) {
    /*                          ^        */
#ifdef IPL_IMAGE_ROI
      *iv_return = IPL_IMAGE_ROI;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_BADARG_ERR", 13)) {
    /*                          ^        */
#ifdef CV_BADARG_ERR
      *iv_return = CV_BADARG_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BADROI_ERR", 13)) {
    /*                          ^        */
#ifdef CV_BADROI_ERR
      *iv_return = CV_BADROI_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_MAGIC_MASK", 13)) {
    /*                          ^        */
#ifdef CV_MAGIC_MASK
      *iv_return = CV_MAGIC_MASK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "CV_FACE_MOUTH", 13)) {
    /*                          ^        */
#ifdef CV_FACE_MOUTH
      *iv_return = CV_FACE_MOUTH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NODE_EMPTY", 13)) {
    /*                          ^        */
#ifdef CV_NODE_EMPTY
      *iv_return = CV_NODE_EMPTY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_ORIGIN_TL", 13)) {
    /*                          ^        */
#ifdef IPL_ORIGIN_TL
      *iv_return = IPL_ORIGIN_TL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'U':
    if (memEQ(name, "CV_REDUCE_SUM", 13)) {
    /*                          ^        */
#ifdef CV_REDUCE_SUM
      *iv_return = CV_REDUCE_SUM;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'V':
    if (memEQ(name, "CV_REDUCE_AVG", 13)) {
    /*                          ^        */
#ifdef CV_REDUCE_AVG
      *iv_return = CV_REDUCE_AVG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'W':
    if (memEQ(name, "CV_COVAR_ROWS", 13)) {
    /*                          ^        */
#ifdef CV_COVAR_ROWS
      *iv_return = CV_COVAR_ROWS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SHIFT_DOWN", 13)) {
    /*                          ^        */
#ifdef CV_SHIFT_DOWN
      *iv_return = CV_SHIFT_DOWN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '_':
    if (memEQ(name, "CV_BGFG_FGD_T", 13)) {
    /*                          ^        */
#ifdef CV_BGFG_FGD_T
      *iv_return = CV_BGFG_FGD_T;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RELATIVE_C", 13)) {
    /*                          ^        */
#ifdef CV_RELATIVE_C
      *iv_return = CV_RELATIVE_C;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'a':
    if (memEQ(name, "CV_StsBadFlag", 13)) {
    /*                          ^        */
#ifdef CV_StsBadFlag
      *iv_return = CV_StsBadFlag;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'n':
    if (memEQ(name, "CV_StsBadFunc", 13)) {
    /*                          ^        */
#ifdef CV_StsBadFunc
      *iv_return = CV_StsBadFunc;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 's':
    if (memEQ(name, "CV_StsBadMask", 13)) {
    /*                          ^        */
#ifdef CV_StsBadMask
      *iv_return = CV_StsBadMask;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 't':
    if (memEQ(name, "CV_BadDataPtr", 13)) {
    /*                          ^        */
#ifdef CV_BadDataPtr
      *iv_return = CV_BadDataPtr;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_StsNullPtr", 13)) {
    /*                          ^        */
#ifdef CV_StsNullPtr
      *iv_return = CV_StsNullPtr;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'z':
    if (memEQ(name, "CV_BadROISize", 13)) {
    /*                          ^        */
#ifdef CV_BadROISize
      *iv_return = CV_BadROISize;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_StsBadSize", 13)) {
    /*                          ^        */
#ifdef CV_StsBadSize
      *iv_return = CV_StsBadSize;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_14 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_BADSIZE_ERR CV_BGFG_FGD_LC CV_BGR5552BGRA CV_BGR5552GRAY CV_BGR5552RGBA
     CV_BGR5652BGRA CV_BGR5652GRAY CV_BGR5652RGBA CV_BGRA2BGR555 CV_BGRA2BGR565
     CV_BadCallBack CV_BadTileSize CV_BayerBG2BGR CV_BayerBG2RGB CV_BayerGB2BGR
     CV_BayerGB2RGB CV_BayerGR2BGR CV_BayerGR2RGB CV_BayerRG2BGR CV_BayerRG2RGB
     CV_CAP_CMU1394 CV_CHECK_QUIET CV_CHECK_RANGE CV_COMP_CHISQR CV_COMP_CORREL
     CV_COVAR_SCALE CV_CVTIMG_FLIP CV_DEFINE_MASK CV_DIST_MASK_3 CV_DIST_MASK_5
     CV_DIST_WELSCH CV_DXT_FORWARD CV_DXT_INVERSE CV_ErrModeLeaf CV_FONT_ITALIC
     CV_GRAY2BGR555 CV_GRAY2BGR565 CV_HIST_SPARSE CV_INTER_CUBIC CV_MAT_CN_MASK
     CV_MAX_THREADS CV_MaskIsTiled CV_NODE_STRING CV_NO_CN_CHECK CV_NULLPTR_ERR
     CV_PCA_USE_AVG CV_PLUGIN_IPPI CV_PLUGIN_IPPS CV_PLUGIN_NONE CV_PTLOC_ERROR
     CV_RAND_NORMAL CV_RELATIVE_L1 CV_RELATIVE_L2 CV_RGBA2BGR555 CV_RGBA2BGR565
     CV_SEQ_CONTOUR CV_SEQ_POLYGON CV_SHAPE_CROSS CV_SHIFT_RIGHT CV_StsBadPoint
     CV_StsInternal CV_THRESH_MASK CV_THRESH_OTSU CV_VAR_ORDERED IPL_DEPTH_SIGN
     IPL_IMAGE_DATA */
  /* Offset 13 gives the best switch position.  */
  switch (name[13]) {
  case '1':
    if (memEQ(name, "CV_RELATIVE_L", 13)) {
    /*                            1      */
#ifdef CV_RELATIVE_L1
      *iv_return = CV_RELATIVE_L1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '2':
    if (memEQ(name, "CV_RELATIVE_L", 13)) {
    /*                            2      */
#ifdef CV_RELATIVE_L2
      *iv_return = CV_RELATIVE_L2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '3':
    if (memEQ(name, "CV_DIST_MASK_", 13)) {
    /*                            3      */
#ifdef CV_DIST_MASK_3
      *iv_return = CV_DIST_MASK_3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '4':
    if (memEQ(name, "CV_CAP_CMU139", 13)) {
    /*                            4      */
#ifdef CV_CAP_CMU1394
      *iv_return = CV_CAP_CMU1394;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '5':
    if (memEQ(name, "CV_BGRA2BGR55", 13)) {
    /*                            5      */
#ifdef CV_BGRA2BGR555
      *iv_return = CV_BGRA2BGR555;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BGRA2BGR56", 13)) {
    /*                            5      */
#ifdef CV_BGRA2BGR565
      *iv_return = CV_BGRA2BGR565;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_DIST_MASK_", 13)) {
    /*                            5      */
#ifdef CV_DIST_MASK_5
      *iv_return = CV_DIST_MASK_5;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GRAY2BGR55", 13)) {
    /*                            5      */
#ifdef CV_GRAY2BGR555
      *iv_return = CV_GRAY2BGR555;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GRAY2BGR56", 13)) {
    /*                            5      */
#ifdef CV_GRAY2BGR565
      *iv_return = CV_GRAY2BGR565;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGBA2BGR55", 13)) {
    /*                            5      */
#ifdef CV_RGBA2BGR555
      *iv_return = CV_RGBA2BGR555;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RGBA2BGR56", 13)) {
    /*                            5      */
#ifdef CV_RGBA2BGR565
      *iv_return = CV_RGBA2BGR565;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'A':
    if (memEQ(name, "CV_BGR5552BGR", 13)) {
    /*                            A      */
#ifdef CV_BGR5552BGRA
      *iv_return = CV_BGR5552BGRA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BGR5552RGB", 13)) {
    /*                            A      */
#ifdef CV_BGR5552RGBA
      *iv_return = CV_BGR5552RGBA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BGR5652BGR", 13)) {
    /*                            A      */
#ifdef CV_BGR5652BGRA
      *iv_return = CV_BGR5652BGRA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BGR5652RGB", 13)) {
    /*                            A      */
#ifdef CV_BGR5652RGBA
      *iv_return = CV_BGR5652RGBA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_IMAGE_DAT", 13)) {
    /*                            A      */
#ifdef IPL_IMAGE_DATA
      *iv_return = IPL_IMAGE_DATA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'B':
    if (memEQ(name, "CV_BayerBG2RG", 13)) {
    /*                            B      */
#ifdef CV_BayerBG2RGB
      *iv_return = CV_BayerBG2RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BayerGB2RG", 13)) {
    /*                            B      */
#ifdef CV_BayerGB2RGB
      *iv_return = CV_BayerGB2RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BayerGR2RG", 13)) {
    /*                            B      */
#ifdef CV_BayerGR2RGB
      *iv_return = CV_BayerGR2RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BayerRG2RG", 13)) {
    /*                            B      */
#ifdef CV_BayerRG2RGB
      *iv_return = CV_BayerRG2RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'C':
    if (memEQ(name, "CV_BGFG_FGD_L", 13)) {
    /*                            C      */
#ifdef CV_BGFG_FGD_LC
      *iv_return = CV_BGFG_FGD_LC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_FONT_ITALI", 13)) {
    /*                            C      */
#ifdef CV_FONT_ITALIC
      *iv_return = CV_FONT_ITALIC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_INTER_CUBI", 13)) {
    /*                            C      */
#ifdef CV_INTER_CUBIC
      *iv_return = CV_INTER_CUBIC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'D':
    if (memEQ(name, "CV_DXT_FORWAR", 13)) {
    /*                            D      */
#ifdef CV_DXT_FORWARD
      *iv_return = CV_DXT_FORWARD;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_VAR_ORDERE", 13)) {
    /*                            D      */
#ifdef CV_VAR_ORDERED
      *iv_return = CV_VAR_ORDERED;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_CHECK_RANG", 13)) {
    /*                            E      */
#ifdef CV_CHECK_RANGE
      *iv_return = CV_CHECK_RANGE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_COVAR_SCAL", 13)) {
    /*                            E      */
#ifdef CV_COVAR_SCALE
      *iv_return = CV_COVAR_SCALE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_DXT_INVERS", 13)) {
    /*                            E      */
#ifdef CV_DXT_INVERSE
      *iv_return = CV_DXT_INVERSE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_HIST_SPARS", 13)) {
    /*                            E      */
#ifdef CV_HIST_SPARSE
      *iv_return = CV_HIST_SPARSE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PLUGIN_NON", 13)) {
    /*                            E      */
#ifdef CV_PLUGIN_NONE
      *iv_return = CV_PLUGIN_NONE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'G':
    if (memEQ(name, "CV_NODE_STRIN", 13)) {
    /*                            G      */
#ifdef CV_NODE_STRING
      *iv_return = CV_NODE_STRING;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PCA_USE_AV", 13)) {
    /*                            G      */
#ifdef CV_PCA_USE_AVG
      *iv_return = CV_PCA_USE_AVG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'H':
    if (memEQ(name, "CV_DIST_WELSC", 13)) {
    /*                            H      */
#ifdef CV_DIST_WELSCH
      *iv_return = CV_DIST_WELSCH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "CV_PLUGIN_IPP", 13)) {
    /*                            I      */
#ifdef CV_PLUGIN_IPPI
      *iv_return = CV_PLUGIN_IPPI;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'K':
    if (memEQ(name, "CV_DEFINE_MAS", 13)) {
    /*                            K      */
#ifdef CV_DEFINE_MASK
      *iv_return = CV_DEFINE_MASK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MAT_CN_MAS", 13)) {
    /*                            K      */
#ifdef CV_MAT_CN_MASK
      *iv_return = CV_MAT_CN_MASK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NO_CN_CHEC", 13)) {
    /*                            K      */
#ifdef CV_NO_CN_CHECK
      *iv_return = CV_NO_CN_CHECK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_THRESH_MAS", 13)) {
    /*                            K      */
#ifdef CV_THRESH_MASK
      *iv_return = CV_THRESH_MASK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "CV_COMP_CORRE", 13)) {
    /*                            L      */
#ifdef CV_COMP_CORREL
      *iv_return = CV_COMP_CORREL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RAND_NORMA", 13)) {
    /*                            L      */
#ifdef CV_RAND_NORMAL
      *iv_return = CV_RAND_NORMAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "CV_SEQ_POLYGO", 13)) {
    /*                            N      */
#ifdef CV_SEQ_POLYGON
      *iv_return = CV_SEQ_POLYGON;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_DEPTH_SIG", 13)) {
    /*                            N      */
#ifdef IPL_DEPTH_SIGN
      *iv_return = IPL_DEPTH_SIGN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "CV_CVTIMG_FLI", 13)) {
    /*                            P      */
#ifdef CV_CVTIMG_FLIP
      *iv_return = CV_CVTIMG_FLIP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_BADSIZE_ER", 13)) {
    /*                            R      */
#ifdef CV_BADSIZE_ERR
      *iv_return = CV_BADSIZE_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BayerBG2BG", 13)) {
    /*                            R      */
#ifdef CV_BayerBG2BGR
      *iv_return = CV_BayerBG2BGR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BayerGB2BG", 13)) {
    /*                            R      */
#ifdef CV_BayerGB2BGR
      *iv_return = CV_BayerGB2BGR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BayerGR2BG", 13)) {
    /*                            R      */
#ifdef CV_BayerGR2BGR
      *iv_return = CV_BayerGR2BGR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BayerRG2BG", 13)) {
    /*                            R      */
#ifdef CV_BayerRG2BGR
      *iv_return = CV_BayerRG2BGR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_COMP_CHISQ", 13)) {
    /*                            R      */
#ifdef CV_COMP_CHISQR
      *iv_return = CV_COMP_CHISQR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NULLPTR_ER", 13)) {
    /*                            R      */
#ifdef CV_NULLPTR_ERR
      *iv_return = CV_NULLPTR_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PTLOC_ERRO", 13)) {
    /*                            R      */
#ifdef CV_PTLOC_ERROR
      *iv_return = CV_PTLOC_ERROR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_CONTOU", 13)) {
    /*                            R      */
#ifdef CV_SEQ_CONTOUR
      *iv_return = CV_SEQ_CONTOUR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_MAX_THREAD", 13)) {
    /*                            S      */
#ifdef CV_MAX_THREADS
      *iv_return = CV_MAX_THREADS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PLUGIN_IPP", 13)) {
    /*                            S      */
#ifdef CV_PLUGIN_IPPS
      *iv_return = CV_PLUGIN_IPPS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SHAPE_CROS", 13)) {
    /*                            S      */
#ifdef CV_SHAPE_CROSS
      *iv_return = CV_SHAPE_CROSS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "CV_CHECK_QUIE", 13)) {
    /*                            T      */
#ifdef CV_CHECK_QUIET
      *iv_return = CV_CHECK_QUIET;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SHIFT_RIGH", 13)) {
    /*                            T      */
#ifdef CV_SHIFT_RIGHT
      *iv_return = CV_SHIFT_RIGHT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'U':
    if (memEQ(name, "CV_THRESH_OTS", 13)) {
    /*                            U      */
#ifdef CV_THRESH_OTSU
      *iv_return = CV_THRESH_OTSU;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Y':
    if (memEQ(name, "CV_BGR5552GRA", 13)) {
    /*                            Y      */
#ifdef CV_BGR5552GRAY
      *iv_return = CV_BGR5552GRAY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BGR5652GRA", 13)) {
    /*                            Y      */
#ifdef CV_BGR5652GRAY
      *iv_return = CV_BGR5652GRAY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'd':
    if (memEQ(name, "CV_MaskIsTile", 13)) {
    /*                            d      */
#ifdef CV_MaskIsTiled
      *iv_return = CV_MaskIsTiled;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'e':
    if (memEQ(name, "CV_BadTileSiz", 13)) {
    /*                            e      */
#ifdef CV_BadTileSize
      *iv_return = CV_BadTileSize;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'f':
    if (memEQ(name, "CV_ErrModeLea", 13)) {
    /*                            f      */
#ifdef CV_ErrModeLeaf
      *iv_return = CV_ErrModeLeaf;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'k':
    if (memEQ(name, "CV_BadCallBac", 13)) {
    /*                            k      */
#ifdef CV_BadCallBack
      *iv_return = CV_BadCallBack;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'l':
    if (memEQ(name, "CV_StsInterna", 13)) {
    /*                            l      */
#ifdef CV_StsInternal
      *iv_return = CV_StsInternal;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 't':
    if (memEQ(name, "CV_StsBadPoin", 13)) {
    /*                            t      */
#ifdef CV_StsBadPoint
      *iv_return = CV_StsBadPoint;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_15 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_BADDEPTH_ERR CV_BADPOINT_ERR CV_BADSCALE_ERR CV_BGFG_FGD_LCC
     CV_BGFG_FGD_N1C CV_BGFG_FGD_N2C CV_BG_MODEL_FGD CV_BG_MODEL_MOG
     CV_BadImageSize CV_CALIB_FIX_K1 CV_CALIB_FIX_K2 CV_CALIB_FIX_K3
     CV_CAP_FIREWARE CV_CAP_FIREWIRE CV_CAP_IEEE1394 CV_CAP_PROP_FPS
     CV_CAP_PROP_HUE CV_COLORCVT_MAX CV_COVAR_NORMAL CV_DXT_MUL_CONJ
     CV_FONT_VECTOR0 CV_GAUSSIAN_5x5 CV_GRAPH_VERTEX CV_HIST_UNIFORM
     CV_HeaderIsNull CV_INTER_LINEAR CV_MALLOC_ALIGN CV_MAX_DIM_HEAP
     CV_MOP_BLACKHAT CV_MOP_GRADIENT CV_NODE_INTEGER CV_NOTFOUND_ERR
     CV_NOT_WEIGHTED CV_OUTOFMEM_ERR CV_PLUGIN_IPPCC CV_PLUGIN_IPPCV
     CV_PLUGIN_IPPVM CV_PLUGIN_OPTCV CV_PTLOC_INSIDE CV_PTLOC_VERTEX
     CV_SEQ_POLYLINE CV_SHAPE_CUSTOM CV_SIZEOF_FLOAT CV_SIZEOF_SHORT
     CV_STORAGE_READ CV_STRUCT_ALIGN CV_SVD_MODIFY_A CV_StsAutoTrace
     CV_StsBackTrace CV_StsDivByZero CV_TERMCRIT_EPS CV_THRESH_TRUNC
     CV_WEIGHTED_ALL CV_WEIGHTED_VTX IPL_ALIGN_DWORD IPL_ALIGN_QWORD
     IPL_BORDER_WRAP */
  /* Offset 14 gives the best switch position.  */
  switch (name[14]) {
  case '0':
    if (memEQ(name, "CV_FONT_VECTOR", 14)) {
    /*                             0      */
#ifdef CV_FONT_VECTOR0
      *iv_return = CV_FONT_VECTOR0;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '1':
    if (memEQ(name, "CV_CALIB_FIX_K", 14)) {
    /*                             1      */
#ifdef CV_CALIB_FIX_K1
      *iv_return = CV_CALIB_FIX_K1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '2':
    if (memEQ(name, "CV_CALIB_FIX_K", 14)) {
    /*                             2      */
#ifdef CV_CALIB_FIX_K2
      *iv_return = CV_CALIB_FIX_K2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '3':
    if (memEQ(name, "CV_CALIB_FIX_K", 14)) {
    /*                             3      */
#ifdef CV_CALIB_FIX_K3
      *iv_return = CV_CALIB_FIX_K3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '4':
    if (memEQ(name, "CV_CAP_IEEE139", 14)) {
    /*                             4      */
#ifdef CV_CAP_IEEE1394
      *iv_return = CV_CAP_IEEE1394;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '5':
    if (memEQ(name, "CV_GAUSSIAN_5x", 14)) {
    /*                             5      */
#ifdef CV_GAUSSIAN_5x5
      *iv_return = CV_GAUSSIAN_5x5;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'A':
    if (memEQ(name, "CV_SVD_MODIFY_", 14)) {
    /*                             A      */
#ifdef CV_SVD_MODIFY_A
      *iv_return = CV_SVD_MODIFY_A;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'C':
    if (memEQ(name, "CV_BGFG_FGD_LC", 14)) {
    /*                             C      */
#ifdef CV_BGFG_FGD_LCC
      *iv_return = CV_BGFG_FGD_LCC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BGFG_FGD_N1", 14)) {
    /*                             C      */
#ifdef CV_BGFG_FGD_N1C
      *iv_return = CV_BGFG_FGD_N1C;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BGFG_FGD_N2", 14)) {
    /*                             C      */
#ifdef CV_BGFG_FGD_N2C
      *iv_return = CV_BGFG_FGD_N2C;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PLUGIN_IPPC", 14)) {
    /*                             C      */
#ifdef CV_PLUGIN_IPPCC
      *iv_return = CV_PLUGIN_IPPCC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_THRESH_TRUN", 14)) {
    /*                             C      */
#ifdef CV_THRESH_TRUNC
      *iv_return = CV_THRESH_TRUNC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'D':
    if (memEQ(name, "CV_BG_MODEL_FG", 14)) {
    /*                             D      */
#ifdef CV_BG_MODEL_FGD
      *iv_return = CV_BG_MODEL_FGD;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NOT_WEIGHTE", 14)) {
    /*                             D      */
#ifdef CV_NOT_WEIGHTED
      *iv_return = CV_NOT_WEIGHTED;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_STORAGE_REA", 14)) {
    /*                             D      */
#ifdef CV_STORAGE_READ
      *iv_return = CV_STORAGE_READ;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_ALIGN_DWOR", 14)) {
    /*                             D      */
#ifdef IPL_ALIGN_DWORD
      *iv_return = IPL_ALIGN_DWORD;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_ALIGN_QWOR", 14)) {
    /*                             D      */
#ifdef IPL_ALIGN_QWORD
      *iv_return = IPL_ALIGN_QWORD;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_CAP_FIREWAR", 14)) {
    /*                             E      */
#ifdef CV_CAP_FIREWARE
      *iv_return = CV_CAP_FIREWARE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CAP_FIREWIR", 14)) {
    /*                             E      */
#ifdef CV_CAP_FIREWIRE
      *iv_return = CV_CAP_FIREWIRE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CAP_PROP_HU", 14)) {
    /*                             E      */
#ifdef CV_CAP_PROP_HUE
      *iv_return = CV_CAP_PROP_HUE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PTLOC_INSID", 14)) {
    /*                             E      */
#ifdef CV_PTLOC_INSIDE
      *iv_return = CV_PTLOC_INSIDE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_POLYLIN", 14)) {
    /*                             E      */
#ifdef CV_SEQ_POLYLINE
      *iv_return = CV_SEQ_POLYLINE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'G':
    if (memEQ(name, "CV_BG_MODEL_MO", 14)) {
    /*                             G      */
#ifdef CV_BG_MODEL_MOG
      *iv_return = CV_BG_MODEL_MOG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'J':
    if (memEQ(name, "CV_DXT_MUL_CON", 14)) {
    /*                             J      */
#ifdef CV_DXT_MUL_CONJ
      *iv_return = CV_DXT_MUL_CONJ;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "CV_COVAR_NORMA", 14)) {
    /*                             L      */
#ifdef CV_COVAR_NORMAL
      *iv_return = CV_COVAR_NORMAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_WEIGHTED_AL", 14)) {
    /*                             L      */
#ifdef CV_WEIGHTED_ALL
      *iv_return = CV_WEIGHTED_ALL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "CV_HIST_UNIFOR", 14)) {
    /*                             M      */
#ifdef CV_HIST_UNIFORM
      *iv_return = CV_HIST_UNIFORM;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PLUGIN_IPPV", 14)) {
    /*                             M      */
#ifdef CV_PLUGIN_IPPVM
      *iv_return = CV_PLUGIN_IPPVM;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SHAPE_CUSTO", 14)) {
    /*                             M      */
#ifdef CV_SHAPE_CUSTOM
      *iv_return = CV_SHAPE_CUSTOM;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "CV_MALLOC_ALIG", 14)) {
    /*                             N      */
#ifdef CV_MALLOC_ALIGN
      *iv_return = CV_MALLOC_ALIGN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_STRUCT_ALIG", 14)) {
    /*                             N      */
#ifdef CV_STRUCT_ALIGN
      *iv_return = CV_STRUCT_ALIGN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "CV_MAX_DIM_HEA", 14)) {
    /*                             P      */
#ifdef CV_MAX_DIM_HEAP
      *iv_return = CV_MAX_DIM_HEAP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_BORDER_WRA", 14)) {
    /*                             P      */
#ifdef IPL_BORDER_WRAP
      *iv_return = IPL_BORDER_WRAP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_BADDEPTH_ER", 14)) {
    /*                             R      */
#ifdef CV_BADDEPTH_ERR
      *iv_return = CV_BADDEPTH_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BADPOINT_ER", 14)) {
    /*                             R      */
#ifdef CV_BADPOINT_ERR
      *iv_return = CV_BADPOINT_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BADSCALE_ER", 14)) {
    /*                             R      */
#ifdef CV_BADSCALE_ERR
      *iv_return = CV_BADSCALE_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_INTER_LINEA", 14)) {
    /*                             R      */
#ifdef CV_INTER_LINEAR
      *iv_return = CV_INTER_LINEAR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NODE_INTEGE", 14)) {
    /*                             R      */
#ifdef CV_NODE_INTEGER
      *iv_return = CV_NODE_INTEGER;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NOTFOUND_ER", 14)) {
    /*                             R      */
#ifdef CV_NOTFOUND_ERR
      *iv_return = CV_NOTFOUND_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_OUTOFMEM_ER", 14)) {
    /*                             R      */
#ifdef CV_OUTOFMEM_ERR
      *iv_return = CV_OUTOFMEM_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_CAP_PROP_FP", 14)) {
    /*                             S      */
#ifdef CV_CAP_PROP_FPS
      *iv_return = CV_CAP_PROP_FPS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_TERMCRIT_EP", 14)) {
    /*                             S      */
#ifdef CV_TERMCRIT_EPS
      *iv_return = CV_TERMCRIT_EPS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "CV_MOP_BLACKHA", 14)) {
    /*                             T      */
#ifdef CV_MOP_BLACKHAT
      *iv_return = CV_MOP_BLACKHAT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MOP_GRADIEN", 14)) {
    /*                             T      */
#ifdef CV_MOP_GRADIENT
      *iv_return = CV_MOP_GRADIENT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SIZEOF_FLOA", 14)) {
    /*                             T      */
#ifdef CV_SIZEOF_FLOAT
      *iv_return = CV_SIZEOF_FLOAT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SIZEOF_SHOR", 14)) {
    /*                             T      */
#ifdef CV_SIZEOF_SHORT
      *iv_return = CV_SIZEOF_SHORT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'V':
    if (memEQ(name, "CV_PLUGIN_IPPC", 14)) {
    /*                             V      */
#ifdef CV_PLUGIN_IPPCV
      *iv_return = CV_PLUGIN_IPPCV;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PLUGIN_OPTC", 14)) {
    /*                             V      */
#ifdef CV_PLUGIN_OPTCV
      *iv_return = CV_PLUGIN_OPTCV;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'X':
    if (memEQ(name, "CV_COLORCVT_MA", 14)) {
    /*                             X      */
#ifdef CV_COLORCVT_MAX
      *iv_return = CV_COLORCVT_MAX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GRAPH_VERTE", 14)) {
    /*                             X      */
#ifdef CV_GRAPH_VERTEX
      *iv_return = CV_GRAPH_VERTEX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PTLOC_VERTE", 14)) {
    /*                             X      */
#ifdef CV_PTLOC_VERTEX
      *iv_return = CV_PTLOC_VERTEX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_WEIGHTED_VT", 14)) {
    /*                             X      */
#ifdef CV_WEIGHTED_VTX
      *iv_return = CV_WEIGHTED_VTX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'e':
    if (memEQ(name, "CV_BadImageSiz", 14)) {
    /*                             e      */
#ifdef CV_BadImageSize
      *iv_return = CV_BadImageSize;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_StsAutoTrac", 14)) {
    /*                             e      */
#ifdef CV_StsAutoTrace
      *iv_return = CV_StsAutoTrace;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_StsBackTrac", 14)) {
    /*                             e      */
#ifdef CV_StsBackTrace
      *iv_return = CV_StsBackTrace;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'l':
    if (memEQ(name, "CV_HeaderIsNul", 14)) {
    /*                             l      */
#ifdef CV_HeaderIsNull
      *iv_return = CV_HeaderIsNull;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'o':
    if (memEQ(name, "CV_StsDivByZer", 14)) {
    /*                             o      */
#ifdef CV_StsDivByZero
      *iv_return = CV_StsDivByZero;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_16 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_BADFACTOR_ERR CV_BADHEADER_ERR CV_BGFG_FGD_N1CC CV_BGFG_FGD_N2CC
     CV_BLUR_NO_SCALE CV_CAP_PROP_GAIN CV_CAP_PROP_MODE CV_COVAR_USE_AVG
     CV_DOMINANT_IPAN CV_DXT_INV_SCALE CV_ErrModeParent CV_ErrModeSilent
     CV_FACE_LEFT_EYE CV_FM_LMEDS_ONLY CV_FOURCC_PROMPT CV_INPAINT_TELEA
     CV_MAJOR_VERSION CV_MAT_CONT_FLAG CV_MAT_MAGIC_VAL CV_MAT_TEMP_FLAG
     CV_MAT_TYPE_MASK CV_MINOR_VERSION CV_NO_SIZE_CHECK CV_PTLOC_ON_EDGE
     CV_RANDOM_INVERT CV_RETR_EXTERNAL CV_RODRIGUES_M2V CV_RODRIGUES_V2M
     CV_SEQ_FLAG_HOLE CV_SEQ_KIND_BITS CV_SEQ_KIND_MASK CV_SEQ_MAGIC_VAL
     CV_SEQ_POINT_SET CV_SET_MAGIC_VAL CV_SHAPE_ELLIPSE CV_STORAGE_WRITE
     CV_StsOutOfRange CV_StsParseError CV_TERMCRIT_ITER CV_THRESH_BINARY
     CV_THRESH_TOZERO CV_VAR_NUMERICAL CV_WEIGHTED_EDGE IPL_ALIGN_4BYTES
     IPL_ALIGN_8BYTES IPL_GAUSSIAN_5x5 IPL_IMAGE_HEADER */
  /* Offset 8 gives the best switch position.  */
  switch (name[8]) {
  case 'A':
    if (memEQ(name, "CV_BADHEADER_ERR", 16)) {
    /*                       ^              */
#ifdef CV_BADHEADER_ERR
      *iv_return = CV_BADHEADER_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_DOMINANT_IPAN", 16)) {
    /*                       ^              */
#ifdef CV_DOMINANT_IPAN
      *iv_return = CV_DOMINANT_IPAN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MAT_MAGIC_VAL", 16)) {
    /*                       ^              */
#ifdef CV_MAT_MAGIC_VAL
      *iv_return = CV_MAT_MAGIC_VAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_MAGIC_VAL", 16)) {
    /*                       ^              */
#ifdef CV_SEQ_MAGIC_VAL
      *iv_return = CV_SEQ_MAGIC_VAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SET_MAGIC_VAL", 16)) {
    /*                       ^              */
#ifdef CV_SET_MAGIC_VAL
      *iv_return = CV_SET_MAGIC_VAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'C':
    if (memEQ(name, "CV_BADFACTOR_ERR", 16)) {
    /*                       ^              */
#ifdef CV_BADFACTOR_ERR
      *iv_return = CV_BADFACTOR_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_FOURCC_PROMPT", 16)) {
    /*                       ^              */
#ifdef CV_FOURCC_PROMPT
      *iv_return = CV_FOURCC_PROMPT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_FM_LMEDS_ONLY", 16)) {
    /*                       ^              */
#ifdef CV_FM_LMEDS_ONLY
      *iv_return = CV_FM_LMEDS_ONLY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MAT_TEMP_FLAG", 16)) {
    /*                       ^              */
#ifdef CV_MAT_TEMP_FLAG
      *iv_return = CV_MAT_TEMP_FLAG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RETR_EXTERNAL", 16)) {
    /*                       ^              */
#ifdef CV_RETR_EXTERNAL
      *iv_return = CV_RETR_EXTERNAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_IMAGE_HEADER", 16)) {
    /*                       ^              */
#ifdef IPL_IMAGE_HEADER
      *iv_return = IPL_IMAGE_HEADER;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'F':
    if (memEQ(name, "CV_BGFG_FGD_N1CC", 16)) {
    /*                       ^              */
#ifdef CV_BGFG_FGD_N1CC
      *iv_return = CV_BGFG_FGD_N1CC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BGFG_FGD_N2CC", 16)) {
    /*                       ^              */
#ifdef CV_BGFG_FGD_N2CC
      *iv_return = CV_BGFG_FGD_N2CC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'G':
    if (memEQ(name, "CV_RODRIGUES_M2V", 16)) {
    /*                       ^              */
#ifdef CV_RODRIGUES_M2V
      *iv_return = CV_RODRIGUES_M2V;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_RODRIGUES_V2M", 16)) {
    /*                       ^              */
#ifdef CV_RODRIGUES_V2M
      *iv_return = CV_RODRIGUES_V2M;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_STORAGE_WRITE", 16)) {
    /*                       ^              */
#ifdef CV_STORAGE_WRITE
      *iv_return = CV_STORAGE_WRITE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'H':
    if (memEQ(name, "CV_THRESH_BINARY", 16)) {
    /*                       ^              */
#ifdef CV_THRESH_BINARY
      *iv_return = CV_THRESH_BINARY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_THRESH_TOZERO", 16)) {
    /*                       ^              */
#ifdef CV_THRESH_TOZERO
      *iv_return = CV_THRESH_TOZERO;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "CV_SEQ_KIND_BITS", 16)) {
    /*                       ^              */
#ifdef CV_SEQ_KIND_BITS
      *iv_return = CV_SEQ_KIND_BITS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_KIND_MASK", 16)) {
    /*                       ^              */
#ifdef CV_SEQ_KIND_MASK
      *iv_return = CV_SEQ_KIND_MASK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "CV_FACE_LEFT_EYE", 16)) {
    /*                       ^              */
#ifdef CV_FACE_LEFT_EYE
      *iv_return = CV_FACE_LEFT_EYE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_FLAG_HOLE", 16)) {
    /*                       ^              */
#ifdef CV_SEQ_FLAG_HOLE
      *iv_return = CV_SEQ_FLAG_HOLE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "CV_RANDOM_INVERT", 16)) {
    /*                       ^              */
#ifdef CV_RANDOM_INVERT
      *iv_return = CV_RANDOM_INVERT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "CV_BLUR_NO_SCALE", 16)) {
    /*                       ^              */
#ifdef CV_BLUR_NO_SCALE
      *iv_return = CV_BLUR_NO_SCALE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_DXT_INV_SCALE", 16)) {
    /*                       ^              */
#ifdef CV_DXT_INV_SCALE
      *iv_return = CV_DXT_INV_SCALE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_INPAINT_TELEA", 16)) {
    /*                       ^              */
#ifdef CV_INPAINT_TELEA
      *iv_return = CV_INPAINT_TELEA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_ALIGN_4BYTES", 16)) {
    /*                       ^              */
#ifdef IPL_ALIGN_4BYTES
      *iv_return = IPL_ALIGN_4BYTES;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_ALIGN_8BYTES", 16)) {
    /*                       ^              */
#ifdef IPL_ALIGN_8BYTES
      *iv_return = IPL_ALIGN_8BYTES;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "CV_MAT_CONT_FLAG", 16)) {
    /*                       ^              */
#ifdef CV_MAT_CONT_FLAG
      *iv_return = CV_MAT_CONT_FLAG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_POINT_SET", 16)) {
    /*                       ^              */
#ifdef CV_SEQ_POINT_SET
      *iv_return = CV_SEQ_POINT_SET;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_CAP_PROP_GAIN", 16)) {
    /*                       ^              */
#ifdef CV_CAP_PROP_GAIN
      *iv_return = CV_CAP_PROP_GAIN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CAP_PROP_MODE", 16)) {
    /*                       ^              */
#ifdef CV_CAP_PROP_MODE
      *iv_return = CV_CAP_PROP_MODE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_TERMCRIT_ITER", 16)) {
    /*                       ^              */
#ifdef CV_TERMCRIT_ITER
      *iv_return = CV_TERMCRIT_ITER;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "IPL_GAUSSIAN_5x5", 16)) {
    /*                       ^              */
#ifdef IPL_GAUSSIAN_5x5
      *iv_return = IPL_GAUSSIAN_5x5;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "CV_WEIGHTED_EDGE", 16)) {
    /*                       ^              */
#ifdef CV_WEIGHTED_EDGE
      *iv_return = CV_WEIGHTED_EDGE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'U':
    if (memEQ(name, "CV_VAR_NUMERICAL", 16)) {
    /*                       ^              */
#ifdef CV_VAR_NUMERICAL
      *iv_return = CV_VAR_NUMERICAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Y':
    if (memEQ(name, "CV_MAT_TYPE_MASK", 16)) {
    /*                       ^              */
#ifdef CV_MAT_TYPE_MASK
      *iv_return = CV_MAT_TYPE_MASK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Z':
    if (memEQ(name, "CV_NO_SIZE_CHECK", 16)) {
    /*                       ^              */
#ifdef CV_NO_SIZE_CHECK
      *iv_return = CV_NO_SIZE_CHECK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '_':
    if (memEQ(name, "CV_COVAR_USE_AVG", 16)) {
    /*                       ^              */
#ifdef CV_COVAR_USE_AVG
      *iv_return = CV_COVAR_USE_AVG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MAJOR_VERSION", 16)) {
    /*                       ^              */
#ifdef CV_MAJOR_VERSION
      *iv_return = CV_MAJOR_VERSION;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MINOR_VERSION", 16)) {
    /*                       ^              */
#ifdef CV_MINOR_VERSION
      *iv_return = CV_MINOR_VERSION;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PTLOC_ON_EDGE", 16)) {
    /*                       ^              */
#ifdef CV_PTLOC_ON_EDGE
      *iv_return = CV_PTLOC_ON_EDGE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SHAPE_ELLIPSE", 16)) {
    /*                       ^              */
#ifdef CV_SHAPE_ELLIPSE
      *iv_return = CV_SHAPE_ELLIPSE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'd':
    if (memEQ(name, "CV_ErrModeParent", 16)) {
    /*                       ^              */
#ifdef CV_ErrModeParent
      *iv_return = CV_ErrModeParent;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_ErrModeSilent", 16)) {
    /*                       ^              */
#ifdef CV_ErrModeSilent
      *iv_return = CV_ErrModeSilent;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'r':
    if (memEQ(name, "CV_StsParseError", 16)) {
    /*                       ^              */
#ifdef CV_StsParseError
      *iv_return = CV_StsParseError;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 't':
    if (memEQ(name, "CV_StsOutOfRange", 16)) {
    /*                       ^              */
#ifdef CV_StsOutOfRange
      *iv_return = CV_StsOutOfRange;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_17 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_BGFG_FGD_DELTA CV_BadNumChannels CV_CAMERA_TO_WARP CV_COMP_INTERSECT
     CV_CVTIMG_SWAP_RB CV_FACE_RIGHT_EYE CV_FAST_DIV_SHIFT CV_FM_RANSAC_ONLY
     CV_FOURCC_DEFAULT CV_GRAPH_ANY_EDGE CV_GRAPH_NEW_TREE CV_HAAR_MAGIC_VAL
     CV_HIST_MAGIC_VAL CV_HOUGH_GRADIENT CV_HOUGH_STANDARD CV_MAT_DEPTH_MASK
     CV_MAX_ALLOC_SIZE CV_MAX_LOCAL_SIZE CV_NODE_TYPE_MASK CV_NO_DEPTH_CHECK
     CV_ORIENTED_GRAPH CV_POLY_APPROX_DP CV_SEQ_ELTYPE_PTR CV_SEQ_FLAG_SHIFT
     CV_SEQ_KIND_CURVE CV_SEQ_KIND_GRAPH CV_SORT_ASCENDING CV_SORT_EVERY_ROW
     CV_STORAGE_APPEND CV_StsBadMemBlock CV_UNDEF_SC_PARAM CV_WARP_TO_CAMERA
     IPL_ALIGN_16BYTES IPL_ALIGN_32BYTES */
  /* Offset 15 gives the best switch position.  */
  switch (name[15]) {
  case 'A':
    if (memEQ(name, "CV_HAAR_MAGIC_VAL", 17)) {
    /*                              ^        */
#ifdef CV_HAAR_MAGIC_VAL
      *iv_return = CV_HAAR_MAGIC_VAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_HIST_MAGIC_VAL", 17)) {
    /*                              ^        */
#ifdef CV_HIST_MAGIC_VAL
      *iv_return = CV_HIST_MAGIC_VAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_UNDEF_SC_PARAM", 17)) {
    /*                              ^        */
#ifdef CV_UNDEF_SC_PARAM
      *iv_return = CV_UNDEF_SC_PARAM;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'C':
    if (memEQ(name, "CV_COMP_INTERSECT", 17)) {
    /*                              ^        */
#ifdef CV_COMP_INTERSECT
      *iv_return = CV_COMP_INTERSECT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NO_DEPTH_CHECK", 17)) {
    /*                              ^        */
#ifdef CV_NO_DEPTH_CHECK
      *iv_return = CV_NO_DEPTH_CHECK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'D':
    if (memEQ(name, "CV_POLY_APPROX_DP", 17)) {
    /*                              ^        */
#ifdef CV_POLY_APPROX_DP
      *iv_return = CV_POLY_APPROX_DP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_GRAPH_NEW_TREE", 17)) {
    /*                              ^        */
#ifdef CV_GRAPH_NEW_TREE
      *iv_return = CV_GRAPH_NEW_TREE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_ALIGN_16BYTES", 17)) {
    /*                              ^        */
#ifdef IPL_ALIGN_16BYTES
      *iv_return = IPL_ALIGN_16BYTES;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_ALIGN_32BYTES", 17)) {
    /*                              ^        */
#ifdef IPL_ALIGN_32BYTES
      *iv_return = IPL_ALIGN_32BYTES;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'F':
    if (memEQ(name, "CV_FAST_DIV_SHIFT", 17)) {
    /*                              ^        */
#ifdef CV_FAST_DIV_SHIFT
      *iv_return = CV_FAST_DIV_SHIFT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_FLAG_SHIFT", 17)) {
    /*                              ^        */
#ifdef CV_SEQ_FLAG_SHIFT
      *iv_return = CV_SEQ_FLAG_SHIFT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'G':
    if (memEQ(name, "CV_GRAPH_ANY_EDGE", 17)) {
    /*                              ^        */
#ifdef CV_GRAPH_ANY_EDGE
      *iv_return = CV_GRAPH_ANY_EDGE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "CV_FM_RANSAC_ONLY", 17)) {
    /*                              ^        */
#ifdef CV_FM_RANSAC_ONLY
      *iv_return = CV_FM_RANSAC_ONLY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_FOURCC_DEFAULT", 17)) {
    /*                              ^        */
#ifdef CV_FOURCC_DEFAULT
      *iv_return = CV_FOURCC_DEFAULT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "CV_HOUGH_GRADIENT", 17)) {
    /*                              ^        */
#ifdef CV_HOUGH_GRADIENT
      *iv_return = CV_HOUGH_GRADIENT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SORT_ASCENDING", 17)) {
    /*                              ^        */
#ifdef CV_SORT_ASCENDING
      *iv_return = CV_SORT_ASCENDING;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_STORAGE_APPEND", 17)) {
    /*                              ^        */
#ifdef CV_STORAGE_APPEND
      *iv_return = CV_STORAGE_APPEND;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "CV_SORT_EVERY_ROW", 17)) {
    /*                              ^        */
#ifdef CV_SORT_EVERY_ROW
      *iv_return = CV_SORT_EVERY_ROW;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "CV_ORIENTED_GRAPH", 17)) {
    /*                              ^        */
#ifdef CV_ORIENTED_GRAPH
      *iv_return = CV_ORIENTED_GRAPH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_KIND_GRAPH", 17)) {
    /*                              ^        */
#ifdef CV_SEQ_KIND_GRAPH
      *iv_return = CV_SEQ_KIND_GRAPH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_CAMERA_TO_WARP", 17)) {
    /*                              ^        */
#ifdef CV_CAMERA_TO_WARP
      *iv_return = CV_CAMERA_TO_WARP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CVTIMG_SWAP_RB", 17)) {
    /*                              ^        */
#ifdef CV_CVTIMG_SWAP_RB
      *iv_return = CV_CVTIMG_SWAP_RB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_HOUGH_STANDARD", 17)) {
    /*                              ^        */
#ifdef CV_HOUGH_STANDARD
      *iv_return = CV_HOUGH_STANDARD;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_WARP_TO_CAMERA", 17)) {
    /*                              ^        */
#ifdef CV_WARP_TO_CAMERA
      *iv_return = CV_WARP_TO_CAMERA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_MAT_DEPTH_MASK", 17)) {
    /*                              ^        */
#ifdef CV_MAT_DEPTH_MASK
      *iv_return = CV_MAT_DEPTH_MASK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NODE_TYPE_MASK", 17)) {
    /*                              ^        */
#ifdef CV_NODE_TYPE_MASK
      *iv_return = CV_NODE_TYPE_MASK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "CV_BGFG_FGD_DELTA", 17)) {
    /*                              ^        */
#ifdef CV_BGFG_FGD_DELTA
      *iv_return = CV_BGFG_FGD_DELTA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_ELTYPE_PTR", 17)) {
    /*                              ^        */
#ifdef CV_SEQ_ELTYPE_PTR
      *iv_return = CV_SEQ_ELTYPE_PTR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'V':
    if (memEQ(name, "CV_SEQ_KIND_CURVE", 17)) {
    /*                              ^        */
#ifdef CV_SEQ_KIND_CURVE
      *iv_return = CV_SEQ_KIND_CURVE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Y':
    if (memEQ(name, "CV_FACE_RIGHT_EYE", 17)) {
    /*                              ^        */
#ifdef CV_FACE_RIGHT_EYE
      *iv_return = CV_FACE_RIGHT_EYE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Z':
    if (memEQ(name, "CV_MAX_ALLOC_SIZE", 17)) {
    /*                              ^        */
#ifdef CV_MAX_ALLOC_SIZE
      *iv_return = CV_MAX_ALLOC_SIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MAX_LOCAL_SIZE", 17)) {
    /*                              ^        */
#ifdef CV_MAX_LOCAL_SIZE
      *iv_return = CV_MAX_LOCAL_SIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'c':
    if (memEQ(name, "CV_StsBadMemBlock", 17)) {
    /*                              ^        */
#ifdef CV_StsBadMemBlock
      *iv_return = CV_StsBadMemBlock;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'l':
    if (memEQ(name, "CV_BadNumChannels", 17)) {
    /*                              ^        */
#ifdef CV_BadNumChannels
      *iv_return = CV_BadNumChannels;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_18 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_BADMEMBLOCK_ERR CV_BadAlphaChannel CV_BadModelOrChSeq
     CV_BadNumChannel1U CV_CAP_PROP_FORMAT CV_CAP_PROP_FOURCC
     CV_COVAR_SCRAMBLED CV_DIV_BY_ZERO_ERR CV_EVENT_LBUTTONUP
     CV_EVENT_MBUTTONUP CV_EVENT_MOUSEMOVE CV_EVENT_RBUTTONUP
     CV_GLCMDESC_ENERGY CV_GRAPH_ALL_ITEMS CV_GRAPH_BACK_EDGE
     CV_GRAPH_TREE_EDGE CV_MATND_MAGIC_VAL CV_MAX_SOBEL_KSIZE
     CV_NEXT_AROUND_DST CV_NEXT_AROUND_ORG CV_NODE_SEQ_SIMPLE
     CV_PCA_DATA_AS_COL CV_PCA_DATA_AS_ROW CV_PREV_AROUND_DST
     CV_PREV_AROUND_ORG CV_SEQ_ELTYPE_BITS CV_SEQ_ELTYPE_CODE
     CV_SEQ_ELTYPE_MASK CV_SEQ_FLAG_CLOSED CV_SEQ_FLAG_CONVEX
     CV_SEQ_FLAG_SIMPLE CV_SEQ_POINT3D_SET CV_SORT_DESCENDING
     CV_STEREO_BM_BASIC CV_StsVecLengthErr CV_TERMCRIT_NUMBER
     CV_TM_CCORR_NORMED CV_VAR_CATEGORICAL CV_WINDOW_AUTOSIZE
     IPL_BORDER_REFLECT */
  /* Offset 10 gives the best switch position.  */
  switch (name[10]) {
  case 'A':
    if (memEQ(name, "CV_GRAPH_BACK_EDGE", 18)) {
    /*                         ^              */
#ifdef CV_GRAPH_BACK_EDGE
      *iv_return = CV_GRAPH_BACK_EDGE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MATND_MAGIC_VAL", 18)) {
    /*                         ^              */
#ifdef CV_MATND_MAGIC_VAL
      *iv_return = CV_MATND_MAGIC_VAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PCA_DATA_AS_COL", 18)) {
    /*                         ^              */
#ifdef CV_PCA_DATA_AS_COL
      *iv_return = CV_PCA_DATA_AS_COL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PCA_DATA_AS_ROW", 18)) {
    /*                         ^              */
#ifdef CV_PCA_DATA_AS_ROW
      *iv_return = CV_PCA_DATA_AS_ROW;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_WINDOW_AUTOSIZE", 18)) {
    /*                         ^              */
#ifdef CV_WINDOW_AUTOSIZE
      *iv_return = CV_WINDOW_AUTOSIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'B':
    if (memEQ(name, "CV_EVENT_LBUTTONUP", 18)) {
    /*                         ^              */
#ifdef CV_EVENT_LBUTTONUP
      *iv_return = CV_EVENT_LBUTTONUP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_EVENT_MBUTTONUP", 18)) {
    /*                         ^              */
#ifdef CV_EVENT_MBUTTONUP
      *iv_return = CV_EVENT_MBUTTONUP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_EVENT_RBUTTONUP", 18)) {
    /*                         ^              */
#ifdef CV_EVENT_RBUTTONUP
      *iv_return = CV_EVENT_RBUTTONUP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_STEREO_BM_BASIC", 18)) {
    /*                         ^              */
#ifdef CV_STEREO_BM_BASIC
      *iv_return = CV_STEREO_BM_BASIC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'C':
    if (memEQ(name, "CV_COVAR_SCRAMBLED", 18)) {
    /*                         ^              */
#ifdef CV_COVAR_SCRAMBLED
      *iv_return = CV_COVAR_SCRAMBLED;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GLCMDESC_ENERGY", 18)) {
    /*                         ^              */
#ifdef CV_GLCMDESC_ENERGY
      *iv_return = CV_GLCMDESC_ENERGY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_MAX_SOBEL_KSIZE", 18)) {
    /*                         ^              */
#ifdef CV_MAX_SOBEL_KSIZE
      *iv_return = CV_MAX_SOBEL_KSIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_VAR_CATEGORICAL", 18)) {
    /*                         ^              */
#ifdef CV_VAR_CATEGORICAL
      *iv_return = CV_VAR_CATEGORICAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'G':
    if (memEQ(name, "CV_SEQ_FLAG_CLOSED", 18)) {
    /*                         ^              */
#ifdef CV_SEQ_FLAG_CLOSED
      *iv_return = CV_SEQ_FLAG_CLOSED;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_FLAG_CONVEX", 18)) {
    /*                         ^              */
#ifdef CV_SEQ_FLAG_CONVEX
      *iv_return = CV_SEQ_FLAG_CONVEX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_FLAG_SIMPLE", 18)) {
    /*                         ^              */
#ifdef CV_SEQ_FLAG_SIMPLE
      *iv_return = CV_SEQ_FLAG_SIMPLE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "CV_BADMEMBLOCK_ERR", 18)) {
    /*                         ^              */
#ifdef CV_BADMEMBLOCK_ERR
      *iv_return = CV_BADMEMBLOCK_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GRAPH_ALL_ITEMS", 18)) {
    /*                         ^              */
#ifdef CV_GRAPH_ALL_ITEMS
      *iv_return = CV_GRAPH_ALL_ITEMS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "CV_SEQ_POINT3D_SET", 18)) {
    /*                         ^              */
#ifdef CV_SEQ_POINT3D_SET
      *iv_return = CV_SEQ_POINT3D_SET;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "CV_EVENT_MOUSEMOVE", 18)) {
    /*                         ^              */
#ifdef CV_EVENT_MOUSEMOVE
      *iv_return = CV_EVENT_MOUSEMOVE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NEXT_AROUND_DST", 18)) {
    /*                         ^              */
#ifdef CV_NEXT_AROUND_DST
      *iv_return = CV_NEXT_AROUND_DST;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NEXT_AROUND_ORG", 18)) {
    /*                         ^              */
#ifdef CV_NEXT_AROUND_ORG
      *iv_return = CV_NEXT_AROUND_ORG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PREV_AROUND_DST", 18)) {
    /*                         ^              */
#ifdef CV_PREV_AROUND_DST
      *iv_return = CV_PREV_AROUND_DST;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PREV_AROUND_ORG", 18)) {
    /*                         ^              */
#ifdef CV_PREV_AROUND_ORG
      *iv_return = CV_PREV_AROUND_ORG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "CV_CAP_PROP_FORMAT", 18)) {
    /*                         ^              */
#ifdef CV_CAP_PROP_FORMAT
      *iv_return = CV_CAP_PROP_FORMAT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CAP_PROP_FOURCC", 18)) {
    /*                         ^              */
#ifdef CV_CAP_PROP_FOURCC
      *iv_return = CV_CAP_PROP_FOURCC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Q':
    if (memEQ(name, "CV_NODE_SEQ_SIMPLE", 18)) {
    /*                         ^              */
#ifdef CV_NODE_SEQ_SIMPLE
      *iv_return = CV_NODE_SEQ_SIMPLE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_GRAPH_TREE_EDGE", 18)) {
    /*                         ^              */
#ifdef CV_GRAPH_TREE_EDGE
      *iv_return = CV_GRAPH_TREE_EDGE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_TM_CCORR_NORMED", 18)) {
    /*                         ^              */
#ifdef CV_TM_CCORR_NORMED
      *iv_return = CV_TM_CCORR_NORMED;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_SORT_DESCENDING", 18)) {
    /*                         ^              */
#ifdef CV_SORT_DESCENDING
      *iv_return = CV_SORT_DESCENDING;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "CV_TERMCRIT_NUMBER", 18)) {
    /*                         ^              */
#ifdef CV_TERMCRIT_NUMBER
      *iv_return = CV_TERMCRIT_NUMBER;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Y':
    if (memEQ(name, "CV_SEQ_ELTYPE_BITS", 18)) {
    /*                         ^              */
#ifdef CV_SEQ_ELTYPE_BITS
      *iv_return = CV_SEQ_ELTYPE_BITS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_ELTYPE_CODE", 18)) {
    /*                         ^              */
#ifdef CV_SEQ_ELTYPE_CODE
      *iv_return = CV_SEQ_ELTYPE_CODE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_ELTYPE_MASK", 18)) {
    /*                         ^              */
#ifdef CV_SEQ_ELTYPE_MASK
      *iv_return = CV_SEQ_ELTYPE_MASK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Z':
    if (memEQ(name, "CV_DIV_BY_ZERO_ERR", 18)) {
    /*                         ^              */
#ifdef CV_DIV_BY_ZERO_ERR
      *iv_return = CV_DIV_BY_ZERO_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '_':
    if (memEQ(name, "IPL_BORDER_REFLECT", 18)) {
    /*                         ^              */
#ifdef IPL_BORDER_REFLECT
      *iv_return = IPL_BORDER_REFLECT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'a':
    if (memEQ(name, "CV_BadAlphaChannel", 18)) {
    /*                         ^              */
#ifdef CV_BadAlphaChannel
      *iv_return = CV_BadAlphaChannel;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'e':
    if (memEQ(name, "CV_StsVecLengthErr", 18)) {
    /*                         ^              */
#ifdef CV_StsVecLengthErr
      *iv_return = CV_StsVecLengthErr;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'h':
    if (memEQ(name, "CV_BadNumChannel1U", 18)) {
    /*                         ^              */
#ifdef CV_BadNumChannel1U
      *iv_return = CV_BadNumChannel1U;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'l':
    if (memEQ(name, "CV_BadModelOrChSeq", 18)) {
    /*                         ^              */
#ifdef CV_BadModelOrChSeq
      *iv_return = CV_BadModelOrChSeq;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_19 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_BGFG_FGD_ALPHA_1 CV_BGFG_FGD_ALPHA_2 CV_BGFG_FGD_ALPHA_3
     CV_BGFG_FGD_MINAREA CV_BGFG_MOG_MINAREA CV_BGFG_MOG_NCOLORS
     CV_GLCMDESC_ENTROPY CV_GRAPH_CROSS_EDGE CV_HAAR_FEATURE_MAX
     CV_HAAR_SCALE_IMAGE CV_HIST_RANGES_FLAG CV_LOAD_IMAGE_COLOR
     CV_NEXT_AROUND_LEFT CV_PREV_AROUND_LEFT CV_SEQ_ELTYPE_INDEX
     CV_SEQ_ELTYPE_POINT CV_SEQ_KIND_GENERIC CV_SEQ_POLYGON_TREE
     CV_SPARSE_MAT_BLOCK CV_STEREO_BM_NARROW CV_SUBMINOR_VERSION
     CV_TM_CCOEFF_NORMED CV_TM_SQDIFF_NORMED CV_WARP_INVERSE_MAP
     IPL_BORDER_CONSTANT IPL_IMAGE_MAGIC_VAL */
  /* Offset 18 gives the best switch position.  */
  switch (name[18]) {
  case '1':
    if (memEQ(name, "CV_BGFG_FGD_ALPHA_", 18)) {
    /*                                 1      */
#ifdef CV_BGFG_FGD_ALPHA_1
      *iv_return = CV_BGFG_FGD_ALPHA_1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '2':
    if (memEQ(name, "CV_BGFG_FGD_ALPHA_", 18)) {
    /*                                 2      */
#ifdef CV_BGFG_FGD_ALPHA_2
      *iv_return = CV_BGFG_FGD_ALPHA_2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '3':
    if (memEQ(name, "CV_BGFG_FGD_ALPHA_", 18)) {
    /*                                 3      */
#ifdef CV_BGFG_FGD_ALPHA_3
      *iv_return = CV_BGFG_FGD_ALPHA_3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'A':
    if (memEQ(name, "CV_BGFG_FGD_MINARE", 18)) {
    /*                                 A      */
#ifdef CV_BGFG_FGD_MINAREA
      *iv_return = CV_BGFG_FGD_MINAREA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BGFG_MOG_MINARE", 18)) {
    /*                                 A      */
#ifdef CV_BGFG_MOG_MINAREA
      *iv_return = CV_BGFG_MOG_MINAREA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'C':
    if (memEQ(name, "CV_SEQ_KIND_GENERI", 18)) {
    /*                                 C      */
#ifdef CV_SEQ_KIND_GENERIC
      *iv_return = CV_SEQ_KIND_GENERIC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'D':
    if (memEQ(name, "CV_TM_CCOEFF_NORME", 18)) {
    /*                                 D      */
#ifdef CV_TM_CCOEFF_NORMED
      *iv_return = CV_TM_CCOEFF_NORMED;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_TM_SQDIFF_NORME", 18)) {
    /*                                 D      */
#ifdef CV_TM_SQDIFF_NORMED
      *iv_return = CV_TM_SQDIFF_NORMED;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_GRAPH_CROSS_EDG", 18)) {
    /*                                 E      */
#ifdef CV_GRAPH_CROSS_EDGE
      *iv_return = CV_GRAPH_CROSS_EDGE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_HAAR_SCALE_IMAG", 18)) {
    /*                                 E      */
#ifdef CV_HAAR_SCALE_IMAGE
      *iv_return = CV_HAAR_SCALE_IMAGE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_POLYGON_TRE", 18)) {
    /*                                 E      */
#ifdef CV_SEQ_POLYGON_TREE
      *iv_return = CV_SEQ_POLYGON_TREE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'G':
    if (memEQ(name, "CV_HIST_RANGES_FLA", 18)) {
    /*                                 G      */
#ifdef CV_HIST_RANGES_FLAG
      *iv_return = CV_HIST_RANGES_FLAG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'K':
    if (memEQ(name, "CV_SPARSE_MAT_BLOC", 18)) {
    /*                                 K      */
#ifdef CV_SPARSE_MAT_BLOCK
      *iv_return = CV_SPARSE_MAT_BLOCK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "IPL_IMAGE_MAGIC_VA", 18)) {
    /*                                 L      */
#ifdef IPL_IMAGE_MAGIC_VAL
      *iv_return = IPL_IMAGE_MAGIC_VAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "CV_SUBMINOR_VERSIO", 18)) {
    /*                                 N      */
#ifdef CV_SUBMINOR_VERSION
      *iv_return = CV_SUBMINOR_VERSION;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "CV_WARP_INVERSE_MA", 18)) {
    /*                                 P      */
#ifdef CV_WARP_INVERSE_MAP
      *iv_return = CV_WARP_INVERSE_MAP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_LOAD_IMAGE_COLO", 18)) {
    /*                                 R      */
#ifdef CV_LOAD_IMAGE_COLOR
      *iv_return = CV_LOAD_IMAGE_COLOR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_BGFG_MOG_NCOLOR", 18)) {
    /*                                 S      */
#ifdef CV_BGFG_MOG_NCOLORS
      *iv_return = CV_BGFG_MOG_NCOLORS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "CV_NEXT_AROUND_LEF", 18)) {
    /*                                 T      */
#ifdef CV_NEXT_AROUND_LEFT
      *iv_return = CV_NEXT_AROUND_LEFT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PREV_AROUND_LEF", 18)) {
    /*                                 T      */
#ifdef CV_PREV_AROUND_LEFT
      *iv_return = CV_PREV_AROUND_LEFT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_ELTYPE_POIN", 18)) {
    /*                                 T      */
#ifdef CV_SEQ_ELTYPE_POINT
      *iv_return = CV_SEQ_ELTYPE_POINT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_BORDER_CONSTAN", 18)) {
    /*                                 T      */
#ifdef IPL_BORDER_CONSTANT
      *iv_return = IPL_BORDER_CONSTANT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'W':
    if (memEQ(name, "CV_STEREO_BM_NARRO", 18)) {
    /*                                 W      */
#ifdef CV_STEREO_BM_NARROW
      *iv_return = CV_STEREO_BM_NARROW;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'X':
    if (memEQ(name, "CV_HAAR_FEATURE_MA", 18)) {
    /*                                 X      */
#ifdef CV_HAAR_FEATURE_MAX
      *iv_return = CV_HAAR_FEATURE_MAX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_ELTYPE_INDE", 18)) {
    /*                                 X      */
#ifdef CV_SEQ_ELTYPE_INDEX
      *iv_return = CV_SEQ_ELTYPE_INDEX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Y':
    if (memEQ(name, "CV_GLCMDESC_ENTROP", 18)) {
    /*                                 Y      */
#ifdef CV_GLCMDESC_ENTROPY
      *iv_return = CV_GLCMDESC_ENTROPY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_20 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_CALIB_ETALON_USER CV_CANNY_L2_GRADIENT CV_CAP_PROP_CONTRAST
     CV_CAP_PROP_POS_MSEC CV_CHAIN_APPROX_NONE CV_CONTOURS_MATCH_I1
     CV_CONTOURS_MATCH_I2 CV_CONTOURS_MATCH_I3 CV_COUNTER_CLOCKWISE
     CV_DIST_MASK_PRECISE CV_DXT_INVERSE_SCALE CV_EVENT_FLAG_ALTKEY
     CV_EVENT_LBUTTONDOWN CV_EVENT_MBUTTONDOWN CV_EVENT_RBUTTONDOWN
     CV_GLCMDESC_CONTRAST CV_HIST_UNIFORM_FLAG CV_HOUGH_MULTI_SCALE
     CV_NEXT_AROUND_RIGHT CV_NUM_FACE_ELEMENTS CV_PREV_AROUND_RIGHT
     CV_SEQ_CHAIN_CONTOUR CV_SEQ_ELTYPE_PPOINT CV_SEQ_KIND_BIN_TREE
     CV_SEQ_KIND_SUBDIV2D CV_SET_ELEM_IDX_MASK CV_SORT_EVERY_COLUMN
     CV_SPARSE_HASH_RATIO CV_SPARSE_HASH_SIZE0 CV_STORAGE_MAGIC_VAL
     CV_StsNotImplemented CV_StsObjectNotFound CV_StsUnmatchedSizes
     CV_THRESH_BINARY_INV CV_THRESH_TOZERO_INV CV_UNMATCHED_ROI_ERR
     IPL_BORDER_REPLICATE IPL_DATA_ORDER_PIXEL IPL_DATA_ORDER_PLANE */
  /* Offset 10 gives the best switch position.  */
  switch (name[10]) {
  case '2':
    if (memEQ(name, "CV_CANNY_L2_GRADIENT", 20)) {
    /*                         ^                */
#ifdef CV_CANNY_L2_GRADIENT
      *iv_return = CV_CANNY_L2_GRADIENT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'B':
    if (memEQ(name, "CV_EVENT_LBUTTONDOWN", 20)) {
    /*                         ^                */
#ifdef CV_EVENT_LBUTTONDOWN
      *iv_return = CV_EVENT_LBUTTONDOWN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_EVENT_MBUTTONDOWN", 20)) {
    /*                         ^                */
#ifdef CV_EVENT_MBUTTONDOWN
      *iv_return = CV_EVENT_MBUTTONDOWN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_EVENT_RBUTTONDOWN", 20)) {
    /*                         ^                */
#ifdef CV_EVENT_RBUTTONDOWN
      *iv_return = CV_EVENT_RBUTTONDOWN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_THRESH_BINARY_INV", 20)) {
    /*                         ^                */
#ifdef CV_THRESH_BINARY_INV
      *iv_return = CV_THRESH_BINARY_INV;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'C':
    if (memEQ(name, "CV_GLCMDESC_CONTRAST", 20)) {
    /*                         ^                */
#ifdef CV_GLCMDESC_CONTRAST
      *iv_return = CV_GLCMDESC_CONTRAST;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'D':
    if (memEQ(name, "CV_SEQ_KIND_BIN_TREE", 20)) {
    /*                         ^                */
#ifdef CV_SEQ_KIND_BIN_TREE
      *iv_return = CV_SEQ_KIND_BIN_TREE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_KIND_SUBDIV2D", 20)) {
    /*                         ^                */
#ifdef CV_SEQ_KIND_SUBDIV2D
      *iv_return = CV_SEQ_KIND_SUBDIV2D;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_DXT_INVERSE_SCALE", 20)) {
    /*                         ^                */
#ifdef CV_DXT_INVERSE_SCALE
      *iv_return = CV_DXT_INVERSE_SCALE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_NUM_FACE_ELEMENTS", 20)) {
    /*                         ^                */
#ifdef CV_NUM_FACE_ELEMENTS
      *iv_return = CV_NUM_FACE_ELEMENTS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SORT_EVERY_COLUMN", 20)) {
    /*                         ^                */
#ifdef CV_SORT_EVERY_COLUMN
      *iv_return = CV_SORT_EVERY_COLUMN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_UNMATCHED_ROI_ERR", 20)) {
    /*                         ^                */
#ifdef CV_UNMATCHED_ROI_ERR
      *iv_return = CV_UNMATCHED_ROI_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'H':
    if (memEQ(name, "CV_SPARSE_HASH_RATIO", 20)) {
    /*                         ^                */
#ifdef CV_SPARSE_HASH_RATIO
      *iv_return = CV_SPARSE_HASH_RATIO;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SPARSE_HASH_SIZE0", 20)) {
    /*                         ^                */
#ifdef CV_SPARSE_HASH_SIZE0
      *iv_return = CV_SPARSE_HASH_SIZE0;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "CV_HIST_UNIFORM_FLAG", 20)) {
    /*                         ^                */
#ifdef CV_HIST_UNIFORM_FLAG
      *iv_return = CV_HIST_UNIFORM_FLAG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_CHAIN_CONTOUR", 20)) {
    /*                         ^                */
#ifdef CV_SEQ_CHAIN_CONTOUR
      *iv_return = CV_SEQ_CHAIN_CONTOUR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "CV_EVENT_FLAG_ALTKEY", 20)) {
    /*                         ^                */
#ifdef CV_EVENT_FLAG_ALTKEY
      *iv_return = CV_EVENT_FLAG_ALTKEY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "CV_SET_ELEM_IDX_MASK", 20)) {
    /*                         ^                */
#ifdef CV_SET_ELEM_IDX_MASK
      *iv_return = CV_SET_ELEM_IDX_MASK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "CV_NEXT_AROUND_RIGHT", 20)) {
    /*                         ^                */
#ifdef CV_NEXT_AROUND_RIGHT
      *iv_return = CV_NEXT_AROUND_RIGHT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_PREV_AROUND_RIGHT", 20)) {
    /*                         ^                */
#ifdef CV_PREV_AROUND_RIGHT
      *iv_return = CV_PREV_AROUND_RIGHT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "CV_CAP_PROP_CONTRAST", 20)) {
    /*                         ^                */
#ifdef CV_CAP_PROP_CONTRAST
      *iv_return = CV_CAP_PROP_CONTRAST;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CAP_PROP_POS_MSEC", 20)) {
    /*                         ^                */
#ifdef CV_CAP_PROP_POS_MSEC
      *iv_return = CV_CAP_PROP_POS_MSEC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CHAIN_APPROX_NONE", 20)) {
    /*                         ^                */
#ifdef CV_CHAIN_APPROX_NONE
      *iv_return = CV_CHAIN_APPROX_NONE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "IPL_DATA_ORDER_PIXEL", 20)) {
    /*                         ^                */
#ifdef IPL_DATA_ORDER_PIXEL
      *iv_return = IPL_DATA_ORDER_PIXEL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_DATA_ORDER_PLANE", 20)) {
    /*                         ^                */
#ifdef IPL_DATA_ORDER_PLANE
      *iv_return = IPL_DATA_ORDER_PLANE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_CONTOURS_MATCH_I1", 20)) {
    /*                         ^                */
#ifdef CV_CONTOURS_MATCH_I1
      *iv_return = CV_CONTOURS_MATCH_I1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CONTOURS_MATCH_I2", 20)) {
    /*                         ^                */
#ifdef CV_CONTOURS_MATCH_I2
      *iv_return = CV_CONTOURS_MATCH_I2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CONTOURS_MATCH_I3", 20)) {
    /*                         ^                */
#ifdef CV_CONTOURS_MATCH_I3
      *iv_return = CV_CONTOURS_MATCH_I3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_DIST_MASK_PRECISE", 20)) {
    /*                         ^                */
#ifdef CV_DIST_MASK_PRECISE
      *iv_return = CV_DIST_MASK_PRECISE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "CV_CALIB_ETALON_USER", 20)) {
    /*                         ^                */
#ifdef CV_CALIB_ETALON_USER
      *iv_return = CV_CALIB_ETALON_USER;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_THRESH_TOZERO_INV", 20)) {
    /*                         ^                */
#ifdef CV_THRESH_TOZERO_INV
      *iv_return = CV_THRESH_TOZERO_INV;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'U':
    if (memEQ(name, "CV_HOUGH_MULTI_SCALE", 20)) {
    /*                         ^                */
#ifdef CV_HOUGH_MULTI_SCALE
      *iv_return = CV_HOUGH_MULTI_SCALE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Y':
    if (memEQ(name, "CV_SEQ_ELTYPE_PPOINT", 20)) {
    /*                         ^                */
#ifdef CV_SEQ_ELTYPE_PPOINT
      *iv_return = CV_SEQ_ELTYPE_PPOINT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '_':
    if (memEQ(name, "CV_COUNTER_CLOCKWISE", 20)) {
    /*                         ^                */
#ifdef CV_COUNTER_CLOCKWISE
      *iv_return = CV_COUNTER_CLOCKWISE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_STORAGE_MAGIC_VAL", 20)) {
    /*                         ^                */
#ifdef CV_STORAGE_MAGIC_VAL
      *iv_return = CV_STORAGE_MAGIC_VAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "IPL_BORDER_REPLICATE", 20)) {
    /*                         ^                */
#ifdef IPL_BORDER_REPLICATE
      *iv_return = IPL_BORDER_REPLICATE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'c':
    if (memEQ(name, "CV_StsObjectNotFound", 20)) {
    /*                         ^                */
#ifdef CV_StsObjectNotFound
      *iv_return = CV_StsObjectNotFound;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'm':
    if (memEQ(name, "CV_StsNotImplemented", 20)) {
    /*                         ^                */
#ifdef CV_StsNotImplemented
      *iv_return = CV_StsNotImplemented;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 't':
    if (memEQ(name, "CV_StsUnmatchedSizes", 20)) {
    /*                         ^                */
#ifdef CV_StsUnmatchedSizes
      *iv_return = CV_StsUnmatchedSizes;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_21 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_BADCONVERGENCE_ERR CV_COMP_BHATTACHARYYA CV_EIGOBJ_NO_CALLBACK
     CV_EVENT_FLAG_CTRLKEY CV_EVENT_FLAG_LBUTTON CV_EVENT_FLAG_MBUTTON
     CV_EVENT_FLAG_RBUTTON CV_FONT_HERSHEY_PLAIN CV_GRAPH_BACKTRACKING
     CV_GRAPH_FORWARD_EDGE CV_LKFLOW_PYR_A_READY CV_LKFLOW_PYR_B_READY
     CV_MAX_LOCAL_MAT_SIZE CV_PTLOC_OUTSIDE_RECT CV_SEQ_CONNECTED_COMP
     CV_SEQ_ELTYPE_GENERIC CV_SEQ_ELTYPE_POINT3D CV_SEQ_SIMPLE_POLYGON
     CV_SET_ELEM_FREE_FLAG CV_STEREO_BM_FISH_EYE CV_STEREO_GC_OCCLUDED
     CV_STORAGE_BLOCK_SIZE CV_STORAGE_WRITE_TEXT CV_StsFilterOffsetErr
     CV_WARP_FILL_OUTLIERS */
  /* Offset 14 gives the best switch position.  */
  switch (name[14]) {
  case 'A':
    if (memEQ(name, "CV_EIGOBJ_NO_CALLBACK", 21)) {
    /*                             ^             */
#ifdef CV_EIGOBJ_NO_CALLBACK
      *iv_return = CV_EIGOBJ_NO_CALLBACK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_LKFLOW_PYR_A_READY", 21)) {
    /*                             ^             */
#ifdef CV_LKFLOW_PYR_A_READY
      *iv_return = CV_LKFLOW_PYR_A_READY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MAX_LOCAL_MAT_SIZE", 21)) {
    /*                             ^             */
#ifdef CV_MAX_LOCAL_MAT_SIZE
      *iv_return = CV_MAX_LOCAL_MAT_SIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'B':
    if (memEQ(name, "CV_LKFLOW_PYR_B_READY", 21)) {
    /*                             ^             */
#ifdef CV_LKFLOW_PYR_B_READY
      *iv_return = CV_LKFLOW_PYR_B_READY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'C':
    if (memEQ(name, "CV_COMP_BHATTACHARYYA", 21)) {
    /*                             ^             */
#ifdef CV_COMP_BHATTACHARYYA
      *iv_return = CV_COMP_BHATTACHARYYA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_EVENT_FLAG_CTRLKEY", 21)) {
    /*                             ^             */
#ifdef CV_EVENT_FLAG_CTRLKEY
      *iv_return = CV_EVENT_FLAG_CTRLKEY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_STEREO_GC_OCCLUDED", 21)) {
    /*                             ^             */
#ifdef CV_STEREO_GC_OCCLUDED
      *iv_return = CV_STEREO_GC_OCCLUDED;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_STORAGE_BLOCK_SIZE", 21)) {
    /*                             ^             */
#ifdef CV_STORAGE_BLOCK_SIZE
      *iv_return = CV_STORAGE_BLOCK_SIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'D':
    if (memEQ(name, "CV_PTLOC_OUTSIDE_RECT", 21)) {
    /*                             ^             */
#ifdef CV_PTLOC_OUTSIDE_RECT
      *iv_return = CV_PTLOC_OUTSIDE_RECT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_SEQ_CONNECTED_COMP", 21)) {
    /*                             ^             */
#ifdef CV_SEQ_CONNECTED_COMP
      *iv_return = CV_SEQ_CONNECTED_COMP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SET_ELEM_FREE_FLAG", 21)) {
    /*                             ^             */
#ifdef CV_SET_ELEM_FREE_FLAG
      *iv_return = CV_SET_ELEM_FREE_FLAG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'G':
    if (memEQ(name, "CV_SEQ_ELTYPE_GENERIC", 21)) {
    /*                             ^             */
#ifdef CV_SEQ_ELTYPE_GENERIC
      *iv_return = CV_SEQ_ELTYPE_GENERIC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "CV_STEREO_BM_FISH_EYE", 21)) {
    /*                             ^             */
#ifdef CV_STEREO_BM_FISH_EYE
      *iv_return = CV_STEREO_BM_FISH_EYE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "CV_EVENT_FLAG_LBUTTON", 21)) {
    /*                             ^             */
#ifdef CV_EVENT_FLAG_LBUTTON
      *iv_return = CV_EVENT_FLAG_LBUTTON;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "CV_EVENT_FLAG_MBUTTON", 21)) {
    /*                             ^             */
#ifdef CV_EVENT_FLAG_MBUTTON
      *iv_return = CV_EVENT_FLAG_MBUTTON;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "CV_BADCONVERGENCE_ERR", 21)) {
    /*                             ^             */
#ifdef CV_BADCONVERGENCE_ERR
      *iv_return = CV_BADCONVERGENCE_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "CV_SEQ_ELTYPE_POINT3D", 21)) {
    /*                             ^             */
#ifdef CV_SEQ_ELTYPE_POINT3D
      *iv_return = CV_SEQ_ELTYPE_POINT3D;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_SIMPLE_POLYGON", 21)) {
    /*                             ^             */
#ifdef CV_SEQ_SIMPLE_POLYGON
      *iv_return = CV_SEQ_SIMPLE_POLYGON;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_EVENT_FLAG_RBUTTON", 21)) {
    /*                             ^             */
#ifdef CV_EVENT_FLAG_RBUTTON
      *iv_return = CV_EVENT_FLAG_RBUTTON;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GRAPH_BACKTRACKING", 21)) {
    /*                             ^             */
#ifdef CV_GRAPH_BACKTRACKING
      *iv_return = CV_GRAPH_BACKTRACKING;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GRAPH_FORWARD_EDGE", 21)) {
    /*                             ^             */
#ifdef CV_GRAPH_FORWARD_EDGE
      *iv_return = CV_GRAPH_FORWARD_EDGE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "CV_STORAGE_WRITE_TEXT", 21)) {
    /*                             ^             */
#ifdef CV_STORAGE_WRITE_TEXT
      *iv_return = CV_STORAGE_WRITE_TEXT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'U':
    if (memEQ(name, "CV_WARP_FILL_OUTLIERS", 21)) {
    /*                             ^             */
#ifdef CV_WARP_FILL_OUTLIERS
      *iv_return = CV_WARP_FILL_OUTLIERS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Y':
    if (memEQ(name, "CV_FONT_HERSHEY_PLAIN", 21)) {
    /*                             ^             */
#ifdef CV_FONT_HERSHEY_PLAIN
      *iv_return = CV_FONT_HERSHEY_PLAIN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'f':
    if (memEQ(name, "CV_StsFilterOffsetErr", 21)) {
    /*                             ^             */
#ifdef CV_StsFilterOffsetErr
      *iv_return = CV_StsFilterOffsetErr;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_22 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_BGFG_MOG_NGAUSSIANS CV_BGFG_MOG_SIGMA_INIT CV_BG_MODEL_FGD_SIMPLE
     CV_CALIB_FIX_INTRINSIC CV_CAP_PROP_BRIGHTNESS CV_CAP_PROP_POS_FRAMES
     CV_CAP_PROP_SATURATION CV_CHAIN_APPROX_SIMPLE CV_EVENT_FLAG_SHIFTKEY
     CV_EVENT_LBUTTONDBLCLK CV_EVENT_MBUTTONDBLCLK CV_EVENT_RBUTTONDBLCLK
     CV_FLOODFILL_MASK_ONLY CV_FONT_HERSHEY_DUPLEX CV_GLCMDESC_HOMOGENITY
     CV_GRAPH_FLAG_ORIENTED CV_HOUGH_PROBABILISTIC CV_LOAD_IMAGE_ANYCOLOR
     CV_LOAD_IMAGE_ANYDEPTH CV_MAT_CONT_FLAG_SHIFT CV_MAT_TEMP_FLAG_SHIFT
     CV_StsUnmatchedFormats CV_UNSUPPORTED_COI_ERR CV_WHOLE_SEQ_END_INDEX
     IPL_BORDER_REFLECT_101 */
  /* Offset 16 gives the best switch position.  */
  switch (name[16]) {
  case 'A':
    if (memEQ(name, "CV_BGFG_MOG_SIGMA_INIT", 22)) {
    /*                               ^            */
#ifdef CV_BGFG_MOG_SIGMA_INIT
      *iv_return = CV_BGFG_MOG_SIGMA_INIT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'C':
    if (memEQ(name, "IPL_BORDER_REFLECT_101", 22)) {
    /*                               ^            */
#ifdef IPL_BORDER_REFLECT_101
      *iv_return = IPL_BORDER_REFLECT_101;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'D':
    if (memEQ(name, "CV_EVENT_LBUTTONDBLCLK", 22)) {
    /*                               ^            */
#ifdef CV_EVENT_LBUTTONDBLCLK
      *iv_return = CV_EVENT_LBUTTONDBLCLK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_EVENT_MBUTTONDBLCLK", 22)) {
    /*                               ^            */
#ifdef CV_EVENT_MBUTTONDBLCLK
      *iv_return = CV_EVENT_MBUTTONDBLCLK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_EVENT_RBUTTONDBLCLK", 22)) {
    /*                               ^            */
#ifdef CV_EVENT_RBUTTONDBLCLK
      *iv_return = CV_EVENT_RBUTTONDBLCLK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_FONT_HERSHEY_DUPLEX", 22)) {
    /*                               ^            */
#ifdef CV_FONT_HERSHEY_DUPLEX
      *iv_return = CV_FONT_HERSHEY_DUPLEX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'F':
    if (memEQ(name, "CV_CAP_PROP_POS_FRAMES", 22)) {
    /*                               ^            */
#ifdef CV_CAP_PROP_POS_FRAMES
      *iv_return = CV_CAP_PROP_POS_FRAMES;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'G':
    if (memEQ(name, "CV_GLCMDESC_HOMOGENITY", 22)) {
    /*                               ^            */
#ifdef CV_GLCMDESC_HOMOGENITY
      *iv_return = CV_GLCMDESC_HOMOGENITY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'H':
    if (memEQ(name, "CV_CAP_PROP_BRIGHTNESS", 22)) {
    /*                               ^            */
#ifdef CV_CAP_PROP_BRIGHTNESS
      *iv_return = CV_CAP_PROP_BRIGHTNESS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "CV_EVENT_FLAG_SHIFTKEY", 22)) {
    /*                               ^            */
#ifdef CV_EVENT_FLAG_SHIFTKEY
      *iv_return = CV_EVENT_FLAG_SHIFTKEY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GRAPH_FLAG_ORIENTED", 22)) {
    /*                               ^            */
#ifdef CV_GRAPH_FLAG_ORIENTED
      *iv_return = CV_GRAPH_FLAG_ORIENTED;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'K':
    if (memEQ(name, "CV_FLOODFILL_MASK_ONLY", 22)) {
    /*                               ^            */
#ifdef CV_FLOODFILL_MASK_ONLY
      *iv_return = CV_FLOODFILL_MASK_ONLY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "CV_HOUGH_PROBABILISTIC", 22)) {
    /*                               ^            */
#ifdef CV_HOUGH_PROBABILISTIC
      *iv_return = CV_HOUGH_PROBABILISTIC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "CV_UNSUPPORTED_COI_ERR", 22)) {
    /*                               ^            */
#ifdef CV_UNSUPPORTED_COI_ERR
      *iv_return = CV_UNSUPPORTED_COI_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_CALIB_FIX_INTRINSIC", 22)) {
    /*                               ^            */
#ifdef CV_CALIB_FIX_INTRINSIC
      *iv_return = CV_CALIB_FIX_INTRINSIC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CAP_PROP_SATURATION", 22)) {
    /*                               ^            */
#ifdef CV_CAP_PROP_SATURATION
      *iv_return = CV_CAP_PROP_SATURATION;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_BGFG_MOG_NGAUSSIANS", 22)) {
    /*                               ^            */
#ifdef CV_BGFG_MOG_NGAUSSIANS
      *iv_return = CV_BGFG_MOG_NGAUSSIANS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_BG_MODEL_FGD_SIMPLE", 22)) {
    /*                               ^            */
#ifdef CV_BG_MODEL_FGD_SIMPLE
      *iv_return = CV_BG_MODEL_FGD_SIMPLE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CHAIN_APPROX_SIMPLE", 22)) {
    /*                               ^            */
#ifdef CV_CHAIN_APPROX_SIMPLE
      *iv_return = CV_CHAIN_APPROX_SIMPLE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Y':
    if (memEQ(name, "CV_LOAD_IMAGE_ANYCOLOR", 22)) {
    /*                               ^            */
#ifdef CV_LOAD_IMAGE_ANYCOLOR
      *iv_return = CV_LOAD_IMAGE_ANYCOLOR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_LOAD_IMAGE_ANYDEPTH", 22)) {
    /*                               ^            */
#ifdef CV_LOAD_IMAGE_ANYDEPTH
      *iv_return = CV_LOAD_IMAGE_ANYDEPTH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '_':
    if (memEQ(name, "CV_MAT_CONT_FLAG_SHIFT", 22)) {
    /*                               ^            */
#ifdef CV_MAT_CONT_FLAG_SHIFT
      *iv_return = CV_MAT_CONT_FLAG_SHIFT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_MAT_TEMP_FLAG_SHIFT", 22)) {
    /*                               ^            */
#ifdef CV_MAT_TEMP_FLAG_SHIFT
      *iv_return = CV_MAT_TEMP_FLAG_SHIFT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_WHOLE_SEQ_END_INDEX", 22)) {
    /*                               ^            */
#ifdef CV_WHOLE_SEQ_END_INDEX
      *iv_return = CV_WHOLE_SEQ_END_INDEX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'o':
    if (memEQ(name, "CV_StsUnmatchedFormats", 22)) {
    /*                               ^            */
#ifdef CV_StsUnmatchedFormats
      *iv_return = CV_StsUnmatchedFormats;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_23 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_BGFG_MOG_WEIGHT_INIT CV_BGFG_MOG_WINDOW_SIZE CV_CALIB_ZERO_DISPARITY
     CV_CAP_PROP_CONVERT_RGB CV_CAP_PROP_FRAME_COUNT CV_CAP_PROP_FRAME_WIDTH
     CV_CHAIN_APPROX_TC89_L1 CV_DEF_INIT_FUNC_TAB_1D CV_DISPARITY_BIRCHFIELD
     CV_EIGOBJ_BOTH_CALLBACK CV_FONT_HERSHEY_COMPLEX CV_FONT_HERSHEY_SIMPLEX
     CV_FONT_HERSHEY_TRIPLEX CV_GLCMDESC_CORRELATION CV_HAAR_DO_ROUGH_SEARCH
     CV_LOAD_IMAGE_GRAYSCALE CV_LOAD_IMAGE_UNCHANGED CV_SEQ_ELTYPE_TRIAN_ATR
     CV_SPARSE_MAT_MAGIC_VAL CV_STORAGE_WRITE_BINARY CV_StsUnsupportedFormat */
  /* Offset 17 gives the best switch position.  */
  switch (name[17]) {
  case 'A':
    if (memEQ(name, "CV_SEQ_ELTYPE_TRIAN_ATR", 23)) {
    /*                                ^            */
#ifdef CV_SEQ_ELTYPE_TRIAN_ATR
      *iv_return = CV_SEQ_ELTYPE_TRIAN_ATR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'B':
    if (memEQ(name, "CV_STORAGE_WRITE_BINARY", 23)) {
    /*                                ^            */
#ifdef CV_STORAGE_WRITE_BINARY
      *iv_return = CV_STORAGE_WRITE_BINARY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'C':
    if (memEQ(name, "CV_CHAIN_APPROX_TC89_L1", 23)) {
    /*                                ^            */
#ifdef CV_CHAIN_APPROX_TC89_L1
      *iv_return = CV_CHAIN_APPROX_TC89_L1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'F':
    if (memEQ(name, "CV_StsUnsupportedFormat", 23)) {
    /*                                ^            */
#ifdef CV_StsUnsupportedFormat
      *iv_return = CV_StsUnsupportedFormat;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'H':
    if (memEQ(name, "CV_DISPARITY_BIRCHFIELD", 23)) {
    /*                                ^            */
#ifdef CV_DISPARITY_BIRCHFIELD
      *iv_return = CV_DISPARITY_BIRCHFIELD;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_LOAD_IMAGE_UNCHANGED", 23)) {
    /*                                ^            */
#ifdef CV_LOAD_IMAGE_UNCHANGED
      *iv_return = CV_LOAD_IMAGE_UNCHANGED;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "CV_FONT_HERSHEY_SIMPLEX", 23)) {
    /*                                ^            */
#ifdef CV_FONT_HERSHEY_SIMPLEX
      *iv_return = CV_FONT_HERSHEY_SIMPLEX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SPARSE_MAT_MAGIC_VAL", 23)) {
    /*                                ^            */
#ifdef CV_SPARSE_MAT_MAGIC_VAL
      *iv_return = CV_SPARSE_MAT_MAGIC_VAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "CV_EIGOBJ_BOTH_CALLBACK", 23)) {
    /*                                ^            */
#ifdef CV_EIGOBJ_BOTH_CALLBACK
      *iv_return = CV_EIGOBJ_BOTH_CALLBACK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GLCMDESC_CORRELATION", 23)) {
    /*                                ^            */
#ifdef CV_GLCMDESC_CORRELATION
      *iv_return = CV_GLCMDESC_CORRELATION;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "CV_FONT_HERSHEY_COMPLEX", 23)) {
    /*                                ^            */
#ifdef CV_FONT_HERSHEY_COMPLEX
      *iv_return = CV_FONT_HERSHEY_COMPLEX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "CV_CALIB_ZERO_DISPARITY", 23)) {
    /*                                ^            */
#ifdef CV_CALIB_ZERO_DISPARITY
      *iv_return = CV_CALIB_ZERO_DISPARITY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_CAP_PROP_CONVERT_RGB", 23)) {
    /*                                ^            */
#ifdef CV_CAP_PROP_CONVERT_RGB
      *iv_return = CV_CAP_PROP_CONVERT_RGB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_FONT_HERSHEY_TRIPLEX", 23)) {
    /*                                ^            */
#ifdef CV_FONT_HERSHEY_TRIPLEX
      *iv_return = CV_FONT_HERSHEY_TRIPLEX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_HAAR_DO_ROUGH_SEARCH", 23)) {
    /*                                ^            */
#ifdef CV_HAAR_DO_ROUGH_SEARCH
      *iv_return = CV_HAAR_DO_ROUGH_SEARCH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "CV_BGFG_MOG_WEIGHT_INIT", 23)) {
    /*                                ^            */
#ifdef CV_BGFG_MOG_WEIGHT_INIT
      *iv_return = CV_BGFG_MOG_WEIGHT_INIT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_DEF_INIT_FUNC_TAB_1D", 23)) {
    /*                                ^            */
#ifdef CV_DEF_INIT_FUNC_TAB_1D
      *iv_return = CV_DEF_INIT_FUNC_TAB_1D;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'W':
    if (memEQ(name, "CV_BGFG_MOG_WINDOW_SIZE", 23)) {
    /*                                ^            */
#ifdef CV_BGFG_MOG_WINDOW_SIZE
      *iv_return = CV_BGFG_MOG_WINDOW_SIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Y':
    if (memEQ(name, "CV_LOAD_IMAGE_GRAYSCALE", 23)) {
    /*                                ^            */
#ifdef CV_LOAD_IMAGE_GRAYSCALE
      *iv_return = CV_LOAD_IMAGE_GRAYSCALE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '_':
    if (memEQ(name, "CV_CAP_PROP_FRAME_COUNT", 23)) {
    /*                                ^            */
#ifdef CV_CAP_PROP_FRAME_COUNT
      *iv_return = CV_CAP_PROP_FRAME_COUNT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CAP_PROP_FRAME_WIDTH", 23)) {
    /*                                ^            */
#ifdef CV_CAP_PROP_FRAME_WIDTH
      *iv_return = CV_CAP_PROP_FRAME_WIDTH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_24 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_CALIB_CB_FILTER_QUADS CV_CAP_PROP_FRAME_HEIGHT CV_CNN_GRAD_ESTIM_RANDOM
     CV_DEFAULT_MAT_ROW_ALIGN CV_EIGOBJ_INPUT_CALLBACK CV_FLOODFILL_FIXED_RANGE
     CV_GLCMDESC_CLUSTERSHADE CV_GLCM_OPTIMIZATION_LUT CV_HAAR_DO_CANNY_PRUNING
     CV_IDP_BIRCHFIELD_PARAM1 CV_IDP_BIRCHFIELD_PARAM2 CV_IDP_BIRCHFIELD_PARAM3
     CV_IDP_BIRCHFIELD_PARAM4 CV_IDP_BIRCHFIELD_PARAM5 CV_SEQ_ELTYPE_GRAPH_EDGE
     CV_TS_CONCENTRIC_SPHERES CV_UNMATCHED_FORMATS_ERR CV_UNSUPPORTED_DEPTH_ERR
     */
  /* Offset 23 gives the best switch position.  */
  switch (name[23]) {
  case '1':
    if (memEQ(name, "CV_IDP_BIRCHFIELD_PARAM", 23)) {
    /*                                      1      */
#ifdef CV_IDP_BIRCHFIELD_PARAM1
      *iv_return = CV_IDP_BIRCHFIELD_PARAM1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '2':
    if (memEQ(name, "CV_IDP_BIRCHFIELD_PARAM", 23)) {
    /*                                      2      */
#ifdef CV_IDP_BIRCHFIELD_PARAM2
      *iv_return = CV_IDP_BIRCHFIELD_PARAM2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '3':
    if (memEQ(name, "CV_IDP_BIRCHFIELD_PARAM", 23)) {
    /*                                      3      */
#ifdef CV_IDP_BIRCHFIELD_PARAM3
      *iv_return = CV_IDP_BIRCHFIELD_PARAM3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '4':
    if (memEQ(name, "CV_IDP_BIRCHFIELD_PARAM", 23)) {
    /*                                      4      */
#ifdef CV_IDP_BIRCHFIELD_PARAM4
      *iv_return = CV_IDP_BIRCHFIELD_PARAM4;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '5':
    if (memEQ(name, "CV_IDP_BIRCHFIELD_PARAM", 23)) {
    /*                                      5      */
#ifdef CV_IDP_BIRCHFIELD_PARAM5
      *iv_return = CV_IDP_BIRCHFIELD_PARAM5;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_FLOODFILL_FIXED_RANG", 23)) {
    /*                                      E      */
#ifdef CV_FLOODFILL_FIXED_RANGE
      *iv_return = CV_FLOODFILL_FIXED_RANGE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GLCMDESC_CLUSTERSHAD", 23)) {
    /*                                      E      */
#ifdef CV_GLCMDESC_CLUSTERSHADE
      *iv_return = CV_GLCMDESC_CLUSTERSHADE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_SEQ_ELTYPE_GRAPH_EDG", 23)) {
    /*                                      E      */
#ifdef CV_SEQ_ELTYPE_GRAPH_EDGE
      *iv_return = CV_SEQ_ELTYPE_GRAPH_EDGE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'G':
    if (memEQ(name, "CV_HAAR_DO_CANNY_PRUNIN", 23)) {
    /*                                      G      */
#ifdef CV_HAAR_DO_CANNY_PRUNING
      *iv_return = CV_HAAR_DO_CANNY_PRUNING;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'K':
    if (memEQ(name, "CV_EIGOBJ_INPUT_CALLBAC", 23)) {
    /*                                      K      */
#ifdef CV_EIGOBJ_INPUT_CALLBACK
      *iv_return = CV_EIGOBJ_INPUT_CALLBACK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "CV_CNN_GRAD_ESTIM_RANDO", 23)) {
    /*                                      M      */
#ifdef CV_CNN_GRAD_ESTIM_RANDOM
      *iv_return = CV_CNN_GRAD_ESTIM_RANDOM;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "CV_DEFAULT_MAT_ROW_ALIG", 23)) {
    /*                                      N      */
#ifdef CV_DEFAULT_MAT_ROW_ALIGN
      *iv_return = CV_DEFAULT_MAT_ROW_ALIGN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_UNMATCHED_FORMATS_ER", 23)) {
    /*                                      R      */
#ifdef CV_UNMATCHED_FORMATS_ERR
      *iv_return = CV_UNMATCHED_FORMATS_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_UNSUPPORTED_DEPTH_ER", 23)) {
    /*                                      R      */
#ifdef CV_UNSUPPORTED_DEPTH_ERR
      *iv_return = CV_UNSUPPORTED_DEPTH_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_CALIB_CB_FILTER_QUAD", 23)) {
    /*                                      S      */
#ifdef CV_CALIB_CB_FILTER_QUADS
      *iv_return = CV_CALIB_CB_FILTER_QUADS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_TS_CONCENTRIC_SPHERE", 23)) {
    /*                                      S      */
#ifdef CV_TS_CONCENTRIC_SPHERES
      *iv_return = CV_TS_CONCENTRIC_SPHERES;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "CV_CAP_PROP_FRAME_HEIGH", 23)) {
    /*                                      T      */
#ifdef CV_CAP_PROP_FRAME_HEIGHT
      *iv_return = CV_CAP_PROP_FRAME_HEIGHT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GLCM_OPTIMIZATION_LU", 23)) {
    /*                                      T      */
#ifdef CV_GLCM_OPTIMIZATION_LUT
      *iv_return = CV_GLCM_OPTIMIZATION_LUT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_25 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_ADAPTIVE_THRESH_MEAN_C CV_BGFG_MOG_STD_THRESHOLD
     CV_CALIB_FIX_ASPECT_RATIO CV_CALIB_FIX_FOCAL_LENGTH
     CV_CAP_PROP_POS_AVI_RATIO CV_CHAIN_APPROX_TC89_KCOS
     CV_CONTOUR_TREES_MATCH_I1 CV_EIGOBJ_OUTPUT_CALLBACK
     CV_GLCM_OPTIMIZATION_NONE CV_LKFLOW_INITIAL_GUESSES
     CV_MAX_INLINE_MAT_OP_SIZE CV_StsInplaceNotSupported
     CV_UNSUPPORTED_FORMAT_ERR ICV_CNN_CONVOLUTION_LAYER
     ICV_CNN_FULLCONNECT_LAYER ICV_CNN_SUBSAMPLING_LAYER */
  /* Offset 14 gives the best switch position.  */
  switch (name[14]) {
  case 'D':
    if (memEQ(name, "CV_BGFG_MOG_STD_THRESHOLD", 25)) {
    /*                             ^                 */
#ifdef CV_BGFG_MOG_STD_THRESHOLD
      *iv_return = CV_BGFG_MOG_STD_THRESHOLD;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_CONTOUR_TREES_MATCH_I1", 25)) {
    /*                             ^                 */
#ifdef CV_CONTOUR_TREES_MATCH_I1
      *iv_return = CV_CONTOUR_TREES_MATCH_I1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "CV_LKFLOW_INITIAL_GUESSES", 25)) {
    /*                             ^                 */
#ifdef CV_LKFLOW_INITIAL_GUESSES
      *iv_return = CV_LKFLOW_INITIAL_GUESSES;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "CV_MAX_INLINE_MAT_OP_SIZE", 25)) {
    /*                             ^                 */
#ifdef CV_MAX_INLINE_MAT_OP_SIZE
      *iv_return = CV_MAX_INLINE_MAT_OP_SIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "ICV_CNN_FULLCONNECT_LAYER", 25)) {
    /*                             ^                 */
#ifdef ICV_CNN_FULLCONNECT_LAYER
      *iv_return = ICV_CNN_FULLCONNECT_LAYER;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "CV_CALIB_FIX_FOCAL_LENGTH", 25)) {
    /*                             ^                 */
#ifdef CV_CALIB_FIX_FOCAL_LENGTH
      *iv_return = CV_CALIB_FIX_FOCAL_LENGTH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "ICV_CNN_SUBSAMPLING_LAYER", 25)) {
    /*                             ^                 */
#ifdef ICV_CNN_SUBSAMPLING_LAYER
      *iv_return = ICV_CNN_SUBSAMPLING_LAYER;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_ADAPTIVE_THRESH_MEAN_C", 25)) {
    /*                             ^                 */
#ifdef CV_ADAPTIVE_THRESH_MEAN_C
      *iv_return = CV_ADAPTIVE_THRESH_MEAN_C;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_CALIB_FIX_ASPECT_RATIO", 25)) {
    /*                             ^                 */
#ifdef CV_CALIB_FIX_ASPECT_RATIO
      *iv_return = CV_CALIB_FIX_ASPECT_RATIO;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_CAP_PROP_POS_AVI_RATIO", 25)) {
    /*                             ^                 */
#ifdef CV_CAP_PROP_POS_AVI_RATIO
      *iv_return = CV_CAP_PROP_POS_AVI_RATIO;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'U':
    if (memEQ(name, "CV_EIGOBJ_OUTPUT_CALLBACK", 25)) {
    /*                             ^                 */
#ifdef CV_EIGOBJ_OUTPUT_CALLBACK
      *iv_return = CV_EIGOBJ_OUTPUT_CALLBACK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "ICV_CNN_CONVOLUTION_LAYER", 25)) {
    /*                             ^                 */
#ifdef ICV_CNN_CONVOLUTION_LAYER
      *iv_return = ICV_CNN_CONVOLUTION_LAYER;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'X':
    if (memEQ(name, "CV_CHAIN_APPROX_TC89_KCOS", 25)) {
    /*                             ^                 */
#ifdef CV_CHAIN_APPROX_TC89_KCOS
      *iv_return = CV_CHAIN_APPROX_TC89_KCOS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'Z':
    if (memEQ(name, "CV_GLCM_OPTIMIZATION_NONE", 25)) {
    /*                             ^                 */
#ifdef CV_GLCM_OPTIMIZATION_NONE
      *iv_return = CV_GLCM_OPTIMIZATION_NONE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '_':
    if (memEQ(name, "CV_UNSUPPORTED_FORMAT_ERR", 25)) {
    /*                             ^                 */
#ifdef CV_UNSUPPORTED_FORMAT_ERR
      *iv_return = CV_UNSUPPORTED_FORMAT_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'o':
    if (memEQ(name, "CV_StsInplaceNotSupported", 25)) {
    /*                             ^                 */
#ifdef CV_StsInplaceNotSupported
      *iv_return = CV_StsInplaceNotSupported;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_26 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_BGFG_MOG_MAX_NGAUSSIANS CV_CALIB_ETALON_CHESSBOARD
     CV_CALIB_SAME_FOCAL_LENGTH CV_CALIB_ZERO_TANGENT_DIST
     CV_DEFAULT_IMAGE_ROW_ALIGN CV_GRAPH_FORWARD_EDGE_FLAG
     CV_GRAPH_ITEM_VISITED_FLAG CV_SEQ_ELTYPE_GRAPH_VERTEX */
  /* Offset 22 gives the best switch position.  */
  switch (name[22]) {
  case 'D':
    if (memEQ(name, "CV_CALIB_ZERO_TANGENT_DIST", 26)) {
    /*                                     ^          */
#ifdef CV_CALIB_ZERO_TANGENT_DIST
      *iv_return = CV_CALIB_ZERO_TANGENT_DIST;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'F':
    if (memEQ(name, "CV_GRAPH_FORWARD_EDGE_FLAG", 26)) {
    /*                                     ^          */
#ifdef CV_GRAPH_FORWARD_EDGE_FLAG
      *iv_return = CV_GRAPH_FORWARD_EDGE_FLAG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GRAPH_ITEM_VISITED_FLAG", 26)) {
    /*                                     ^          */
#ifdef CV_GRAPH_ITEM_VISITED_FLAG
      *iv_return = CV_GRAPH_ITEM_VISITED_FLAG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "CV_BGFG_MOG_MAX_NGAUSSIANS", 26)) {
    /*                                     ^          */
#ifdef CV_BGFG_MOG_MAX_NGAUSSIANS
      *iv_return = CV_BGFG_MOG_MAX_NGAUSSIANS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "CV_DEFAULT_IMAGE_ROW_ALIGN", 26)) {
    /*                                     ^          */
#ifdef CV_DEFAULT_IMAGE_ROW_ALIGN
      *iv_return = CV_DEFAULT_IMAGE_ROW_ALIGN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "CV_CALIB_SAME_FOCAL_LENGTH", 26)) {
    /*                                     ^          */
#ifdef CV_CALIB_SAME_FOCAL_LENGTH
      *iv_return = CV_CALIB_SAME_FOCAL_LENGTH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "CV_CALIB_ETALON_CHESSBOARD", 26)) {
    /*                                     ^          */
#ifdef CV_CALIB_ETALON_CHESSBOARD
      *iv_return = CV_CALIB_ETALON_CHESSBOARD;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_SEQ_ELTYPE_GRAPH_VERTEX", 26)) {
    /*                                     ^          */
#ifdef CV_SEQ_ELTYPE_GRAPH_VERTEX
      *iv_return = CV_SEQ_ELTYPE_GRAPH_VERTEX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_27 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_BGFG_FGD_BG_UPDATE_TRESH CV_CALIB_CB_ADAPTIVE_THRESH
     CV_CALIB_CB_NORMALIZE_IMAGE CV_GLCMDESC_CLUSTERTENDENCY
     CV_HAAR_FIND_BIGGEST_OBJECT CV_LKFLOW_GET_MIN_EIGENVALS
     CV_UNSUPPORTED_CHANNELS_ERR */
  /* Offset 15 gives the best switch position.  */
  switch (name[15]) {
  case 'C':
    if (memEQ(name, "CV_UNSUPPORTED_CHANNELS_ERR", 27)) {
    /*                              ^                  */
#ifdef CV_UNSUPPORTED_CHANNELS_ERR
      *iv_return = CV_UNSUPPORTED_CHANNELS_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'G':
    if (memEQ(name, "CV_HAAR_FIND_BIGGEST_OBJECT", 27)) {
    /*                              ^                  */
#ifdef CV_HAAR_FIND_BIGGEST_OBJECT
      *iv_return = CV_HAAR_FIND_BIGGEST_OBJECT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "CV_LKFLOW_GET_MIN_EIGENVALS", 27)) {
    /*                              ^                  */
#ifdef CV_LKFLOW_GET_MIN_EIGENVALS
      *iv_return = CV_LKFLOW_GET_MIN_EIGENVALS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "CV_CALIB_CB_NORMALIZE_IMAGE", 27)) {
    /*                              ^                  */
#ifdef CV_CALIB_CB_NORMALIZE_IMAGE
      *iv_return = CV_CALIB_CB_NORMALIZE_IMAGE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "CV_CALIB_CB_ADAPTIVE_THRESH", 27)) {
    /*                              ^                  */
#ifdef CV_CALIB_CB_ADAPTIVE_THRESH
      *iv_return = CV_CALIB_CB_ADAPTIVE_THRESH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "CV_GLCMDESC_CLUSTERTENDENCY", 27)) {
    /*                              ^                  */
#ifdef CV_GLCMDESC_CLUSTERTENDENCY
      *iv_return = CV_GLCMDESC_CLUSTERTENDENCY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'U':
    if (memEQ(name, "CV_BGFG_FGD_BG_UPDATE_TRESH", 27)) {
    /*                              ^                  */
#ifdef CV_BGFG_FGD_BG_UPDATE_TRESH
      *iv_return = CV_BGFG_FGD_BG_UPDATE_TRESH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_28 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_CALIB_ETALON_CHECKERBOARD CV_CALIB_FIX_PRINCIPAL_POINT
     CV_CALIB_USE_INTRINSIC_GUESS CV_GLCMDESC_CORRELATIONINFO1
     CV_GLCMDESC_CORRELATIONINFO2 CV_INPLACE_NOT_SUPPORTED_ERR
     CV_SEQ_ELTYPE_CONNECTED_COMP CV_StsFilterStructContentErr
     CV_StsKernelStructContentErr */
  /* Offset 11 gives the best switch position.  */
  switch (name[11]) {
  case 'A':
    if (memEQ(name, "CV_CALIB_ETALON_CHECKERBOARD", 28)) {
    /*                          ^                       */
#ifdef CV_CALIB_ETALON_CHECKERBOARD
      *iv_return = CV_CALIB_ETALON_CHECKERBOARD;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_CALIB_USE_INTRINSIC_GUESS", 28)) {
    /*                          ^                       */
#ifdef CV_CALIB_USE_INTRINSIC_GUESS
      *iv_return = CV_CALIB_USE_INTRINSIC_GUESS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "CV_INPLACE_NOT_SUPPORTED_ERR", 28)) {
    /*                          ^                       */
#ifdef CV_INPLACE_NOT_SUPPORTED_ERR
      *iv_return = CV_INPLACE_NOT_SUPPORTED_ERR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "CV_SEQ_ELTYPE_CONNECTED_COMP", 28)) {
    /*                          ^                       */
#ifdef CV_SEQ_ELTYPE_CONNECTED_COMP
      *iv_return = CV_SEQ_ELTYPE_CONNECTED_COMP;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'X':
    if (memEQ(name, "CV_CALIB_FIX_PRINCIPAL_POINT", 28)) {
    /*                          ^                       */
#ifdef CV_CALIB_FIX_PRINCIPAL_POINT
      *iv_return = CV_CALIB_FIX_PRINCIPAL_POINT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '_':
    if (memEQ(name, "CV_GLCMDESC_CORRELATIONINFO1", 28)) {
    /*                          ^                       */
#ifdef CV_GLCMDESC_CORRELATIONINFO1
      *iv_return = CV_GLCMDESC_CORRELATIONINFO1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_GLCMDESC_CORRELATIONINFO2", 28)) {
    /*                          ^                       */
#ifdef CV_GLCMDESC_CORRELATIONINFO2
      *iv_return = CV_GLCMDESC_CORRELATIONINFO2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'l':
    if (memEQ(name, "CV_StsKernelStructContentErr", 28)) {
    /*                          ^                       */
#ifdef CV_StsKernelStructContentErr
      *iv_return = CV_StsKernelStructContentErr;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'r':
    if (memEQ(name, "CV_StsFilterStructContentErr", 28)) {
    /*                          ^                       */
#ifdef CV_StsFilterStructContentErr
      *iv_return = CV_StsFilterStructContentErr;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_30 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CV_CNN_GRAD_ESTIM_BY_WORST_IMG CV_FONT_HERSHEY_SCRIPT_COMPLEX
     CV_FONT_HERSHEY_SCRIPT_SIMPLEX CV_GLCMDESC_MAXIMUMPROBABILITY
     CV_GLCM_OPTIMIZATION_HISTOGRAM CV_GRAPH_SEARCH_TREE_NODE_FLAG
     CV_SUBDIV2D_VIRTUAL_POINT_FLAG */
  /* Offset 18 gives the best switch position.  */
  switch (name[18]) {
  case 'B':
    if (memEQ(name, "CV_CNN_GRAD_ESTIM_BY_WORST_IMG", 30)) {
    /*                                 ^                  */
#ifdef CV_CNN_GRAD_ESTIM_BY_WORST_IMG
      *iv_return = CV_CNN_GRAD_ESTIM_BY_WORST_IMG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CV_GRAPH_SEARCH_TREE_NODE_FLAG", 30)) {
    /*                                 ^                  */
#ifdef CV_GRAPH_SEARCH_TREE_NODE_FLAG
      *iv_return = CV_GRAPH_SEARCH_TREE_NODE_FLAG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "CV_SUBDIV2D_VIRTUAL_POINT_FLAG", 30)) {
    /*                                 ^                  */
#ifdef CV_SUBDIV2D_VIRTUAL_POINT_FLAG
      *iv_return = CV_SUBDIV2D_VIRTUAL_POINT_FLAG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "CV_GLCMDESC_MAXIMUMPROBABILITY", 30)) {
    /*                                 ^                  */
#ifdef CV_GLCMDESC_MAXIMUMPROBABILITY
      *iv_return = CV_GLCMDESC_MAXIMUMPROBABILITY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "CV_GLCM_OPTIMIZATION_HISTOGRAM", 30)) {
    /*                                 ^                  */
#ifdef CV_GLCM_OPTIMIZATION_HISTOGRAM
      *iv_return = CV_GLCM_OPTIMIZATION_HISTOGRAM;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "CV_FONT_HERSHEY_SCRIPT_COMPLEX", 30)) {
    /*                                 ^                  */
#ifdef CV_FONT_HERSHEY_SCRIPT_COMPLEX
      *iv_return = CV_FONT_HERSHEY_SCRIPT_COMPLEX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "CV_FONT_HERSHEY_SCRIPT_SIMPLEX", 30)) {
    /*                                 ^                  */
#ifdef CV_FONT_HERSHEY_SCRIPT_SIMPLEX
      *iv_return = CV_FONT_HERSHEY_SCRIPT_SIMPLEX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant (pTHX_ const char *name, STRLEN len, IV *iv_return) {
  /* Initially switch on the length of the name.  */
  /* When generated this function returned values for the list of names given
     in this section of perl code.  Rather than manually editing these functions
     to add or remove constants, which would result in this comment and section
     of code becoming inaccurate, we recommend that you edit this section of
     code, and use it to regenerate a new set of constant functions which you
     then use to replace the originals.

     Regenerate these constant functions by feeding this entire source file to
     perl -x

#!perl -w
use ExtUtils::Constant qw (constant_types C_constant XS_constant);

my $types = {map {($_, 1)} qw(IV)};
my @names = (qw(CV_16S CV_16SC1 CV_16SC2 CV_16SC3 CV_16SC4 CV_16U CV_16UC1
	       CV_16UC2 CV_16UC3 CV_16UC4 CV_1F CV_32F CV_32FC1 CV_32FC2
	       CV_32FC3 CV_32FC4 CV_32S CV_32SC1 CV_32SC2 CV_32SC3 CV_32SC4
	       CV_64F CV_64FC1 CV_64FC2 CV_64FC3 CV_64FC4 CV_8S CV_8SC1 CV_8SC2
	       CV_8SC3 CV_8SC4 CV_8U CV_8UC1 CV_8UC2 CV_8UC3 CV_8UC4 CV_AA
	       CV_ADAPTIVE_THRESH_GAUSSIAN_C CV_ADAPTIVE_THRESH_MEAN_C CV_ARRAY
	       CV_AUTOSTEP CV_AUTO_STEP CV_BACK CV_BADARG_ERR
	       CV_BADCONVERGENCE_ERR CV_BADDEPTH_ERR CV_BADFACTOR_ERR
	       CV_BADHEADER_ERR CV_BADMEMBLOCK_ERR CV_BADPOINT_ERR
	       CV_BADROI_ERR CV_BADSCALE_ERR CV_BADSIZE_ERR CV_BGFG_FGD_ALPHA_1
	       CV_BGFG_FGD_ALPHA_2 CV_BGFG_FGD_ALPHA_3
	       CV_BGFG_FGD_BG_UPDATE_TRESH CV_BGFG_FGD_DELTA CV_BGFG_FGD_LC
	       CV_BGFG_FGD_LCC CV_BGFG_FGD_MINAREA CV_BGFG_FGD_N1C
	       CV_BGFG_FGD_N1CC CV_BGFG_FGD_N2C CV_BGFG_FGD_N2CC CV_BGFG_FGD_T
	       CV_BGFG_MOG_BACKGROUND_THRESHOLD CV_BGFG_MOG_MAX_NGAUSSIANS
	       CV_BGFG_MOG_MINAREA CV_BGFG_MOG_NCOLORS CV_BGFG_MOG_NGAUSSIANS
	       CV_BGFG_MOG_SIGMA_INIT CV_BGFG_MOG_STD_THRESHOLD
	       CV_BGFG_MOG_WEIGHT_INIT CV_BGFG_MOG_WINDOW_SIZE CV_BGR2BGR555
	       CV_BGR2BGR565 CV_BGR2BGRA CV_BGR2GRAY CV_BGR2HLS CV_BGR2HSV
	       CV_BGR2Lab CV_BGR2Luv CV_BGR2RGB CV_BGR2RGBA CV_BGR2XYZ
	       CV_BGR2YCrCb CV_BGR5552BGR CV_BGR5552BGRA CV_BGR5552GRAY
	       CV_BGR5552RGB CV_BGR5552RGBA CV_BGR5652BGR CV_BGR5652BGRA
	       CV_BGR5652GRAY CV_BGR5652RGB CV_BGR5652RGBA CV_BGRA2BGR
	       CV_BGRA2BGR555 CV_BGRA2BGR565 CV_BGRA2GRAY CV_BGRA2RGB
	       CV_BGRA2RGBA CV_BG_MODEL_FGD CV_BG_MODEL_FGD_SIMPLE
	       CV_BG_MODEL_MOG CV_BILATERAL CV_BLUR CV_BLUR_NO_SCALE
	       CV_BadAlign CV_BadAlphaChannel CV_BadCOI CV_BadCallBack
	       CV_BadDataPtr CV_BadDepth CV_BadImageSize CV_BadModelOrChSeq
	       CV_BadNumChannel1U CV_BadNumChannels CV_BadOffset CV_BadOrder
	       CV_BadOrigin CV_BadROISize CV_BadStep CV_BadTileSize
	       CV_BayerBG2BGR CV_BayerBG2RGB CV_BayerGB2BGR CV_BayerGB2RGB
	       CV_BayerGR2BGR CV_BayerGR2RGB CV_BayerRG2BGR CV_BayerRG2RGB CV_C
	       CV_CALIB_CB_ADAPTIVE_THRESH CV_CALIB_CB_FILTER_QUADS
	       CV_CALIB_CB_NORMALIZE_IMAGE CV_CALIB_ETALON_CHECKERBOARD
	       CV_CALIB_ETALON_CHESSBOARD CV_CALIB_ETALON_USER
	       CV_CALIB_FIX_ASPECT_RATIO CV_CALIB_FIX_FOCAL_LENGTH
	       CV_CALIB_FIX_INTRINSIC CV_CALIB_FIX_K1 CV_CALIB_FIX_K2
	       CV_CALIB_FIX_K3 CV_CALIB_FIX_PRINCIPAL_POINT
	       CV_CALIB_SAME_FOCAL_LENGTH CV_CALIB_USE_INTRINSIC_GUESS
	       CV_CALIB_ZERO_DISPARITY CV_CALIB_ZERO_TANGENT_DIST
	       CV_CAMERA_TO_WARP CV_CANNY_L2_GRADIENT CV_CAP_ANY CV_CAP_CMU1394
	       CV_CAP_DC1394 CV_CAP_DSHOW CV_CAP_FIREWARE CV_CAP_FIREWIRE
	       CV_CAP_IEEE1394 CV_CAP_MIL CV_CAP_PROP_BRIGHTNESS
	       CV_CAP_PROP_CONTRAST CV_CAP_PROP_CONVERT_RGB CV_CAP_PROP_FORMAT
	       CV_CAP_PROP_FOURCC CV_CAP_PROP_FPS CV_CAP_PROP_FRAME_COUNT
	       CV_CAP_PROP_FRAME_HEIGHT CV_CAP_PROP_FRAME_WIDTH
	       CV_CAP_PROP_GAIN CV_CAP_PROP_HUE CV_CAP_PROP_MODE
	       CV_CAP_PROP_POS_AVI_RATIO CV_CAP_PROP_POS_FRAMES
	       CV_CAP_PROP_POS_MSEC CV_CAP_PROP_SATURATION CV_CAP_QT
	       CV_CAP_STEREO CV_CAP_TYZX CV_CAP_UNICAP CV_CAP_V4L CV_CAP_V4L2
	       CV_CAP_VFW CV_CHAIN_APPROX_NONE CV_CHAIN_APPROX_SIMPLE
	       CV_CHAIN_APPROX_TC89_KCOS CV_CHAIN_APPROX_TC89_L1 CV_CHAIN_CODE
	       CV_CHECK_QUIET CV_CHECK_RANGE CV_CLOCKWISE CV_CMP_EQ CV_CMP_GE
	       CV_CMP_GT CV_CMP_LE CV_CMP_LT CV_CMP_NE
	       CV_CNN_GRAD_ESTIM_BY_WORST_IMG CV_CNN_GRAD_ESTIM_RANDOM
	       CV_CNN_LEARN_RATE_DECREASE_HYPERBOLICALLY
	       CV_CNN_LEARN_RATE_DECREASE_LOG_INV
	       CV_CNN_LEARN_RATE_DECREASE_SQRT_INV CV_CN_MAX CV_CN_SHIFT
	       CV_COLORCVT_MAX CV_COL_SAMPLE CV_COMP_BHATTACHARYYA
	       CV_COMP_CHISQR CV_COMP_CORREL CV_COMP_INTERSECT
	       CV_CONTOURS_MATCH_I1 CV_CONTOURS_MATCH_I2 CV_CONTOURS_MATCH_I3
	       CV_CONTOUR_TREES_MATCH_I1 CV_COUNTER_CLOCKWISE CV_COVAR_COLS
	       CV_COVAR_NORMAL CV_COVAR_ROWS CV_COVAR_SCALE CV_COVAR_SCRAMBLED
	       CV_COVAR_USE_AVG CV_CVTIMG_FLIP CV_CVTIMG_SWAP_RB
	       CV_DEFAULT_IMAGE_ROW_ALIGN CV_DEFAULT_MAT_ROW_ALIGN
	       CV_DEFINE_MASK CV_DEF_INIT_FUNC_TAB_1D CV_DEPTH_MAX CV_DIFF
	       CV_DIFF_C CV_DIFF_L1 CV_DIFF_L2 CV_DISPARITY_BIRCHFIELD
	       CV_DIST_C CV_DIST_FAIR CV_DIST_HUBER CV_DIST_L1 CV_DIST_L12
	       CV_DIST_L2 CV_DIST_MASK_3 CV_DIST_MASK_5 CV_DIST_MASK_PRECISE
	       CV_DIST_USER CV_DIST_WELSCH CV_DIV_BY_ZERO_ERR CV_DOMINANT_IPAN
	       CV_DXT_FORWARD CV_DXT_INVERSE CV_DXT_INVERSE_SCALE
	       CV_DXT_INV_SCALE CV_DXT_MUL_CONJ CV_DXT_ROWS CV_DXT_SCALE
	       CV_EIGOBJ_BOTH_CALLBACK CV_EIGOBJ_INPUT_CALLBACK
	       CV_EIGOBJ_NO_CALLBACK CV_EIGOBJ_OUTPUT_CALLBACK
	       CV_EVENT_FLAG_ALTKEY CV_EVENT_FLAG_CTRLKEY CV_EVENT_FLAG_LBUTTON
	       CV_EVENT_FLAG_MBUTTON CV_EVENT_FLAG_RBUTTON
	       CV_EVENT_FLAG_SHIFTKEY CV_EVENT_LBUTTONDBLCLK
	       CV_EVENT_LBUTTONDOWN CV_EVENT_LBUTTONUP CV_EVENT_MBUTTONDBLCLK
	       CV_EVENT_MBUTTONDOWN CV_EVENT_MBUTTONUP CV_EVENT_MOUSEMOVE
	       CV_EVENT_RBUTTONDBLCLK CV_EVENT_RBUTTONDOWN CV_EVENT_RBUTTONUP
	       CV_ErrModeLeaf CV_ErrModeParent CV_ErrModeSilent
	       CV_FACE_LEFT_EYE CV_FACE_MOUTH CV_FACE_RIGHT_EYE
	       CV_FAST_DIV_SHIFT CV_FILLED CV_FLOODFILL_FIXED_RANGE
	       CV_FLOODFILL_MASK_ONLY CV_FM_7POINT CV_FM_8POINT CV_FM_LMEDS
	       CV_FM_LMEDS_ONLY CV_FM_RANSAC CV_FM_RANSAC_ONLY
	       CV_FONT_HERSHEY_COMPLEX CV_FONT_HERSHEY_COMPLEX_SMALL
	       CV_FONT_HERSHEY_DUPLEX CV_FONT_HERSHEY_PLAIN
	       CV_FONT_HERSHEY_SCRIPT_COMPLEX CV_FONT_HERSHEY_SCRIPT_SIMPLEX
	       CV_FONT_HERSHEY_SIMPLEX CV_FONT_HERSHEY_TRIPLEX CV_FONT_ITALIC
	       CV_FONT_VECTOR0 CV_FOURCC_DEFAULT CV_FOURCC_PROMPT CV_FRONT
	       CV_GAUSSIAN CV_GAUSSIAN_5x5 CV_GEMM_A_T CV_GEMM_B_T CV_GEMM_C_T
	       CV_GLCMDESC_CLUSTERSHADE CV_GLCMDESC_CLUSTERTENDENCY
	       CV_GLCMDESC_CONTRAST CV_GLCMDESC_CORRELATION
	       CV_GLCMDESC_CORRELATIONINFO1 CV_GLCMDESC_CORRELATIONINFO2
	       CV_GLCMDESC_ENERGY CV_GLCMDESC_ENTROPY CV_GLCMDESC_HOMOGENITY
	       CV_GLCMDESC_MAXIMUMPROBABILITY
	       CV_GLCMDESC_OPTIMIZATION_ALLOWDOUBLENEST
	       CV_GLCMDESC_OPTIMIZATION_ALLOWTRIPLENEST
	       CV_GLCMDESC_OPTIMIZATION_HISTOGRAM CV_GLCM_ALL CV_GLCM_DESC
	       CV_GLCM_GLCM CV_GLCM_OPTIMIZATION_HISTOGRAM
	       CV_GLCM_OPTIMIZATION_LUT CV_GLCM_OPTIMIZATION_NONE CV_GRAPH
	       CV_GRAPH_ALL_ITEMS CV_GRAPH_ANY_EDGE CV_GRAPH_BACKTRACKING
	       CV_GRAPH_BACK_EDGE CV_GRAPH_CROSS_EDGE CV_GRAPH_FLAG_ORIENTED
	       CV_GRAPH_FORWARD_EDGE CV_GRAPH_FORWARD_EDGE_FLAG
	       CV_GRAPH_ITEM_VISITED_FLAG CV_GRAPH_NEW_TREE CV_GRAPH_OVER
	       CV_GRAPH_SEARCH_TREE_NODE_FLAG CV_GRAPH_TREE_EDGE
	       CV_GRAPH_VERTEX CV_GRAY2BGR CV_GRAY2BGR555 CV_GRAY2BGR565
	       CV_GRAY2BGRA CV_GRAY2RGB CV_GRAY2RGBA CV_HAAR_DO_CANNY_PRUNING
	       CV_HAAR_DO_ROUGH_SEARCH CV_HAAR_FEATURE_MAX
	       CV_HAAR_FIND_BIGGEST_OBJECT CV_HAAR_MAGIC_VAL
	       CV_HAAR_SCALE_IMAGE CV_HIST_ARRAY CV_HIST_MAGIC_VAL
	       CV_HIST_RANGES_FLAG CV_HIST_SPARSE CV_HIST_TREE CV_HIST_UNIFORM
	       CV_HIST_UNIFORM_FLAG CV_HLS2BGR CV_HLS2RGB CV_HOUGH_GRADIENT
	       CV_HOUGH_MULTI_SCALE CV_HOUGH_PROBABILISTIC CV_HOUGH_STANDARD
	       CV_HSV2BGR CV_HSV2RGB CV_HeaderIsNull CV_ICC
	       CV_IDP_BIRCHFIELD_PARAM1 CV_IDP_BIRCHFIELD_PARAM2
	       CV_IDP_BIRCHFIELD_PARAM3 CV_IDP_BIRCHFIELD_PARAM4
	       CV_IDP_BIRCHFIELD_PARAM5 CV_INPAINT_NS CV_INPAINT_TELEA
	       CV_INPLACE_NOT_SUPPORTED_ERR CV_INTER_AREA CV_INTER_CUBIC
	       CV_INTER_LINEAR CV_INTER_NN CV_L1 CV_L2 CV_LEE_AUTO
	       CV_LEE_DOUBLE CV_LEE_ERODE CV_LEE_FLOAT CV_LEE_INT CV_LEE_NON
	       CV_LEE_ZOOM CV_LINK_RUNS CV_LKFLOW_GET_MIN_EIGENVALS
	       CV_LKFLOW_INITIAL_GUESSES CV_LKFLOW_PYR_A_READY
	       CV_LKFLOW_PYR_B_READY CV_LMEDS CV_LOAD_IMAGE_ANYCOLOR
	       CV_LOAD_IMAGE_ANYDEPTH CV_LOAD_IMAGE_COLOR
	       CV_LOAD_IMAGE_GRAYSCALE CV_LOAD_IMAGE_UNCHANGED CV_LOG2
	       CV_LOG2PI CV_LSQ CV_LU CV_Lab2BGR CV_Lab2RGB CV_Luv2BGR
	       CV_Luv2RGB CV_MAGIC_MASK CV_MAJOR_VERSION CV_MALLOC_ALIGN
	       CV_MAT32F CV_MAT3x1_32F CV_MAT3x1_64D CV_MAT3x3_32F
	       CV_MAT3x3_64D CV_MAT4x1_32F CV_MAT4x1_64D CV_MAT4x4_32F
	       CV_MAT4x4_64D CV_MAT64D CV_MATND_MAGIC_VAL CV_MAT_CN_MASK
	       CV_MAT_CONT_FLAG CV_MAT_CONT_FLAG_SHIFT CV_MAT_DEPTH_MASK
	       CV_MAT_MAGIC_VAL CV_MAT_TEMP_FLAG CV_MAT_TEMP_FLAG_SHIFT
	       CV_MAT_TYPE_MASK CV_MAX_ALLOC_SIZE CV_MAX_ARR CV_MAX_DIM
	       CV_MAX_DIM_HEAP CV_MAX_INLINE_MAT_OP_SIZE CV_MAX_LOCAL_MAT_SIZE
	       CV_MAX_LOCAL_SIZE CV_MAX_SOBEL_KSIZE CV_MAX_STRLEN
	       CV_MAX_THREADS CV_MEDIAN CV_MINMAX CV_MINOR_VERSION
	       CV_MOP_BLACKHAT CV_MOP_CLOSE CV_MOP_GRADIENT CV_MOP_OPEN
	       CV_MOP_TOPHAT CV_MaskIsTiled CV_NEG_INF CV_NEXT_AROUND_DST
	       CV_NEXT_AROUND_LEFT CV_NEXT_AROUND_ORG CV_NEXT_AROUND_RIGHT
	       CV_NODE_EMPTY CV_NODE_FLOAT CV_NODE_FLOW CV_NODE_INT
	       CV_NODE_INTEGER CV_NODE_MAP CV_NODE_NAMED CV_NODE_NONE
	       CV_NODE_REAL CV_NODE_REF CV_NODE_SEQ CV_NODE_SEQ_SIMPLE
	       CV_NODE_STR CV_NODE_STRING CV_NODE_TYPE_MASK CV_NODE_USER
	       CV_NORM_MASK CV_NOTFOUND_ERR CV_NOT_WEIGHTED CV_NO_CN_CHECK
	       CV_NO_DEPTH_CHECK CV_NO_ERR CV_NO_SIZE_CHECK CV_NULLPTR_ERR
	       CV_NUM_FACE_ELEMENTS CV_OK CV_ORIENTED_GRAPH CV_ORIGIN_BL
	       CV_ORIGIN_TL CV_OUTOFMEM_ERR CV_PCA_DATA_AS_COL
	       CV_PCA_DATA_AS_ROW CV_PCA_USE_AVG CV_PI CV_PLUGIN_IPPCC
	       CV_PLUGIN_IPPCV CV_PLUGIN_IPPI CV_PLUGIN_IPPS CV_PLUGIN_IPPVM
	       CV_PLUGIN_MAX CV_PLUGIN_MKL CV_PLUGIN_NONE CV_PLUGIN_OPTCV
	       CV_POLY_APPROX_DP CV_POS_INF CV_PREV_AROUND_DST
	       CV_PREV_AROUND_LEFT CV_PREV_AROUND_ORG CV_PREV_AROUND_RIGHT
	       CV_PTLOC_ERROR CV_PTLOC_INSIDE CV_PTLOC_ON_EDGE
	       CV_PTLOC_OUTSIDE_RECT CV_PTLOC_VERTEX CV_RANDOM_INVERT
	       CV_RAND_NORMAL CV_RAND_UNI CV_RANSAC CV_REDUCE_AVG CV_REDUCE_MAX
	       CV_REDUCE_MIN CV_REDUCE_SUM CV_RELATIVE CV_RELATIVE_C
	       CV_RELATIVE_L1 CV_RELATIVE_L2 CV_RETR_CCOMP CV_RETR_EXTERNAL
	       CV_RETR_LIST CV_RETR_TREE CV_RGB2BGR CV_RGB2BGR555 CV_RGB2BGR565
	       CV_RGB2BGRA CV_RGB2GRAY CV_RGB2HLS CV_RGB2HSV CV_RGB2Lab
	       CV_RGB2Luv CV_RGB2RGBA CV_RGB2XYZ CV_RGB2YCrCb CV_RGBA2BGR
	       CV_RGBA2BGR555 CV_RGBA2BGR565 CV_RGBA2BGRA CV_RGBA2GRAY
	       CV_RGBA2RGB CV_RODRIGUES_M2V CV_RODRIGUES_V2M CV_ROW_SAMPLE
	       CV_SCHARR CV_SEQ_CHAIN CV_SEQ_CHAIN_CONTOUR
	       CV_SEQ_CONNECTED_COMP CV_SEQ_CONTOUR CV_SEQ_ELTYPE_BITS
	       CV_SEQ_ELTYPE_CODE CV_SEQ_ELTYPE_CONNECTED_COMP
	       CV_SEQ_ELTYPE_GENERIC CV_SEQ_ELTYPE_GRAPH_EDGE
	       CV_SEQ_ELTYPE_GRAPH_VERTEX CV_SEQ_ELTYPE_INDEX
	       CV_SEQ_ELTYPE_MASK CV_SEQ_ELTYPE_POINT CV_SEQ_ELTYPE_POINT3D
	       CV_SEQ_ELTYPE_PPOINT CV_SEQ_ELTYPE_PTR CV_SEQ_ELTYPE_TRIAN_ATR
	       CV_SEQ_FLAG_CLOSED CV_SEQ_FLAG_CONVEX CV_SEQ_FLAG_HOLE
	       CV_SEQ_FLAG_SHIFT CV_SEQ_FLAG_SIMPLE CV_SEQ_INDEX
	       CV_SEQ_KIND_BIN_TREE CV_SEQ_KIND_BITS CV_SEQ_KIND_CURVE
	       CV_SEQ_KIND_GENERIC CV_SEQ_KIND_GRAPH CV_SEQ_KIND_MASK
	       CV_SEQ_KIND_SUBDIV2D CV_SEQ_MAGIC_VAL CV_SEQ_POINT3D_SET
	       CV_SEQ_POINT_SET CV_SEQ_POLYGON CV_SEQ_POLYGON_TREE
	       CV_SEQ_POLYLINE CV_SEQ_SIMPLE_POLYGON CV_SET_ELEM_FREE_FLAG
	       CV_SET_ELEM_IDX_MASK CV_SET_MAGIC_VAL CV_SHAPE_CROSS
	       CV_SHAPE_CUSTOM CV_SHAPE_ELLIPSE CV_SHAPE_RECT CV_SHIFT_DOWN
	       CV_SHIFT_LD CV_SHIFT_LEFT CV_SHIFT_LU CV_SHIFT_NONE CV_SHIFT_RD
	       CV_SHIFT_RIGHT CV_SHIFT_RU CV_SHIFT_UP CV_SIZEOF_FLOAT
	       CV_SIZEOF_SHORT CV_SORT_ASCENDING CV_SORT_DESCENDING
	       CV_SORT_EVERY_COLUMN CV_SORT_EVERY_ROW CV_SPARSE_HASH_RATIO
	       CV_SPARSE_HASH_SIZE0 CV_SPARSE_MAT_BLOCK CV_SPARSE_MAT_MAGIC_VAL
	       CV_SSE2 CV_STEREO_BM_BASIC CV_STEREO_BM_FISH_EYE
	       CV_STEREO_BM_NARROW CV_STEREO_BM_NORMALIZED_RESPONSE
	       CV_STEREO_GC_OCCLUDED CV_STORAGE_APPEND CV_STORAGE_BLOCK_SIZE
	       CV_STORAGE_MAGIC_VAL CV_STORAGE_READ CV_STORAGE_WRITE
	       CV_STORAGE_WRITE_BINARY CV_STORAGE_WRITE_TEXT CV_STRUCT_ALIGN
	       CV_STUB_STEP CV_SUBDIV2D_VIRTUAL_POINT_FLAG CV_SUBMINOR_VERSION
	       CV_SVD CV_SVD_MODIFY_A CV_SVD_SYM CV_SVD_U_T CV_SVD_V_T
	       CV_StsAutoTrace CV_StsBackTrace CV_StsBadArg CV_StsBadFlag
	       CV_StsBadFunc CV_StsBadMask CV_StsBadMemBlock CV_StsBadPoint
	       CV_StsBadSize CV_StsDivByZero CV_StsError CV_StsFilterOffsetErr
	       CV_StsFilterStructContentErr CV_StsInplaceNotSupported
	       CV_StsInternal CV_StsKernelStructContentErr CV_StsNoConv
	       CV_StsNoMem CV_StsNotImplemented CV_StsNullPtr
	       CV_StsObjectNotFound CV_StsOk CV_StsOutOfRange CV_StsParseError
	       CV_StsUnmatchedFormats CV_StsUnmatchedSizes
	       CV_StsUnsupportedFormat CV_StsVecLengthErr CV_TERMCRIT_EPS
	       CV_TERMCRIT_ITER CV_TERMCRIT_NUMBER CV_THRESH_BINARY
	       CV_THRESH_BINARY_INV CV_THRESH_MASK CV_THRESH_OTSU
	       CV_THRESH_TOZERO CV_THRESH_TOZERO_INV CV_THRESH_TRUNC
	       CV_TM_CCOEFF CV_TM_CCOEFF_NORMED CV_TM_CCORR CV_TM_CCORR_NORMED
	       CV_TM_SQDIFF CV_TM_SQDIFF_NORMED CV_TS_CONCENTRIC_SPHERES
	       CV_TYZX_COLOR CV_TYZX_LEFT CV_TYZX_RIGHT CV_TYZX_Z
	       CV_UNDEF_SC_PARAM CV_UNMATCHED_FORMATS_ERR CV_UNMATCHED_ROI_ERR
	       CV_UNSUPPORTED_CHANNELS_ERR CV_UNSUPPORTED_COI_ERR
	       CV_UNSUPPORTED_DEPTH_ERR CV_UNSUPPORTED_FORMAT_ERR CV_USRTYPE1
	       CV_VALUE CV_VAR_CATEGORICAL CV_VAR_NUMERICAL CV_VAR_ORDERED
	       CV_WARP_FILL_OUTLIERS CV_WARP_INVERSE_MAP CV_WARP_TO_CAMERA
	       CV_WEIGHTED_ALL CV_WEIGHTED_EDGE CV_WEIGHTED_VTX
	       CV_WHOLE_SEQ_END_INDEX CV_WINDOW_AUTOSIZE CV_XYZ2BGR CV_XYZ2RGB
	       CV_YCrCb2BGR CV_YCrCb2RGB ICV_CNN_CONVOLUTION_LAYER
	       ICV_CNN_FULLCONNECT_LAYER ICV_CNN_LAYER
	       ICV_CNN_SUBSAMPLING_LAYER IPL_ALIGN_16BYTES IPL_ALIGN_32BYTES
	       IPL_ALIGN_4BYTES IPL_ALIGN_8BYTES IPL_ALIGN_DWORD
	       IPL_ALIGN_QWORD IPL_BORDER_CONSTANT IPL_BORDER_REFLECT
	       IPL_BORDER_REFLECT_101 IPL_BORDER_REPLICATE IPL_BORDER_WRAP
	       IPL_DATA_ORDER_PIXEL IPL_DATA_ORDER_PLANE IPL_DEPTH_16S
	       IPL_DEPTH_16U IPL_DEPTH_1U IPL_DEPTH_32F IPL_DEPTH_32S
	       IPL_DEPTH_64F IPL_DEPTH_8S IPL_DEPTH_8U IPL_DEPTH_SIGN
	       IPL_GAUSSIAN_5x5 IPL_IMAGE_DATA IPL_IMAGE_HEADER
	       IPL_IMAGE_MAGIC_VAL IPL_IMAGE_ROI IPL_ORIGIN_BL IPL_ORIGIN_TL));

print constant_types(), "\n"; # macro defs
foreach (C_constant ("Cv::CxCore", 'constant', 'IV', $types, undef, 3, @names) ) {
    print $_, "\n"; # C constant subs
}
print "\n#### XS Section:\n";
print XS_constant ("Cv::CxCore", $types);
__END__
   */

  switch (len) {
  case 4:
    if (memEQ(name, "CV_C", 4)) {
#ifdef CV_C
      *iv_return = CV_C;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 5:
    return constant_5 (aTHX_ name, iv_return);
    break;
  case 6:
    return constant_6 (aTHX_ name, iv_return);
    break;
  case 7:
    return constant_7 (aTHX_ name, iv_return);
    break;
  case 8:
    return constant_8 (aTHX_ name, iv_return);
    break;
  case 9:
    return constant_9 (aTHX_ name, iv_return);
    break;
  case 10:
    return constant_10 (aTHX_ name, iv_return);
    break;
  case 11:
    return constant_11 (aTHX_ name, iv_return);
    break;
  case 12:
    return constant_12 (aTHX_ name, iv_return);
    break;
  case 13:
    return constant_13 (aTHX_ name, iv_return);
    break;
  case 14:
    return constant_14 (aTHX_ name, iv_return);
    break;
  case 15:
    return constant_15 (aTHX_ name, iv_return);
    break;
  case 16:
    return constant_16 (aTHX_ name, iv_return);
    break;
  case 17:
    return constant_17 (aTHX_ name, iv_return);
    break;
  case 18:
    return constant_18 (aTHX_ name, iv_return);
    break;
  case 19:
    return constant_19 (aTHX_ name, iv_return);
    break;
  case 20:
    return constant_20 (aTHX_ name, iv_return);
    break;
  case 21:
    return constant_21 (aTHX_ name, iv_return);
    break;
  case 22:
    return constant_22 (aTHX_ name, iv_return);
    break;
  case 23:
    return constant_23 (aTHX_ name, iv_return);
    break;
  case 24:
    return constant_24 (aTHX_ name, iv_return);
    break;
  case 25:
    return constant_25 (aTHX_ name, iv_return);
    break;
  case 26:
    return constant_26 (aTHX_ name, iv_return);
    break;
  case 27:
    return constant_27 (aTHX_ name, iv_return);
    break;
  case 28:
    return constant_28 (aTHX_ name, iv_return);
    break;
  case 29:
    /* Names all of length 29.  */
    /* CV_ADAPTIVE_THRESH_GAUSSIAN_C CV_FONT_HERSHEY_COMPLEX_SMALL */
    /* Offset 8 gives the best switch position.  */
    switch (name[8]) {
    case 'H':
      if (memEQ(name, "CV_FONT_HERSHEY_COMPLEX_SMALL", 29)) {
      /*                       ^                           */
#ifdef CV_FONT_HERSHEY_COMPLEX_SMALL
        *iv_return = CV_FONT_HERSHEY_COMPLEX_SMALL;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'I':
      if (memEQ(name, "CV_ADAPTIVE_THRESH_GAUSSIAN_C", 29)) {
      /*                       ^                           */
#ifdef CV_ADAPTIVE_THRESH_GAUSSIAN_C
        *iv_return = CV_ADAPTIVE_THRESH_GAUSSIAN_C;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 30:
    return constant_30 (aTHX_ name, iv_return);
    break;
  case 32:
    /* Names all of length 32.  */
    /* CV_BGFG_MOG_BACKGROUND_THRESHOLD CV_STEREO_BM_NORMALIZED_RESPONSE */
    /* Offset 31 gives the best switch position.  */
    switch (name[31]) {
    case 'D':
      if (memEQ(name, "CV_BGFG_MOG_BACKGROUND_THRESHOL", 31)) {
      /*                                              D      */
#ifdef CV_BGFG_MOG_BACKGROUND_THRESHOLD
        *iv_return = CV_BGFG_MOG_BACKGROUND_THRESHOLD;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'E':
      if (memEQ(name, "CV_STEREO_BM_NORMALIZED_RESPONS", 31)) {
      /*                                              E      */
#ifdef CV_STEREO_BM_NORMALIZED_RESPONSE
        *iv_return = CV_STEREO_BM_NORMALIZED_RESPONSE;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 34:
    /* Names all of length 34.  */
    /* CV_CNN_LEARN_RATE_DECREASE_LOG_INV CV_GLCMDESC_OPTIMIZATION_HISTOGRAM */
    /* Offset 4 gives the best switch position.  */
    switch (name[4]) {
    case 'L':
      if (memEQ(name, "CV_GLCMDESC_OPTIMIZATION_HISTOGRAM", 34)) {
      /*                   ^                                    */
#ifdef CV_GLCMDESC_OPTIMIZATION_HISTOGRAM
        *iv_return = CV_GLCMDESC_OPTIMIZATION_HISTOGRAM;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'N':
      if (memEQ(name, "CV_CNN_LEARN_RATE_DECREASE_LOG_INV", 34)) {
      /*                   ^                                    */
#ifdef CV_CNN_LEARN_RATE_DECREASE_LOG_INV
        *iv_return = CV_CNN_LEARN_RATE_DECREASE_LOG_INV;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 35:
    if (memEQ(name, "CV_CNN_LEARN_RATE_DECREASE_SQRT_INV", 35)) {
#ifdef CV_CNN_LEARN_RATE_DECREASE_SQRT_INV
      *iv_return = CV_CNN_LEARN_RATE_DECREASE_SQRT_INV;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 40:
    /* Names all of length 40.  */
    /* CV_GLCMDESC_OPTIMIZATION_ALLOWDOUBLENEST
       CV_GLCMDESC_OPTIMIZATION_ALLOWTRIPLENEST */
    /* Offset 31 gives the best switch position.  */
    switch (name[31]) {
    case 'O':
      if (memEQ(name, "CV_GLCMDESC_OPTIMIZATION_ALLOWDOUBLENEST", 40)) {
      /*                                              ^               */
#ifdef CV_GLCMDESC_OPTIMIZATION_ALLOWDOUBLENEST
        *iv_return = CV_GLCMDESC_OPTIMIZATION_ALLOWDOUBLENEST;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'R':
      if (memEQ(name, "CV_GLCMDESC_OPTIMIZATION_ALLOWTRIPLENEST", 40)) {
      /*                                              ^               */
#ifdef CV_GLCMDESC_OPTIMIZATION_ALLOWTRIPLENEST
        *iv_return = CV_GLCMDESC_OPTIMIZATION_ALLOWTRIPLENEST;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 41:
    if (memEQ(name, "CV_CNN_LEARN_RATE_DECREASE_HYPERBOLICALLY", 41)) {
#ifdef CV_CNN_LEARN_RATE_DECREASE_HYPERBOLICALLY
      *iv_return = CV_CNN_LEARN_RATE_DECREASE_HYPERBOLICALLY;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

