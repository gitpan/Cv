# -*- mode: text; coding: utf-8; tab-width: 4 -*-

# ============================================================
#  core. The Core Functionality: Basic Structures
# ============================================================

MODULE = Cv		PACKAGE = Cv
# ====================
CvPoint
cvPoint(int x, int y)

CvPoint2D32f
cvPoint2D32f(float x, float y)

CvPoint3D32f
cvPoint3D32f(float x, float y, float z)

CvPoint2D64f
cvPoint2D64f(double x, double y)

CvPoint3D64f
cvPoint3D64f(double x, double y, double z)

CvPoint
cvPointFrom32f(CvPoint2D32f pt)

CvPoint2D32f
cvPointTo32f(CvPoint pt)

CvSize
cvSize(int width, int height)

CvRect
cvRect(int x, int y, int width, int height)

CvSize2D32f
cvSize2D32f(float width, float height)

CvScalar
cvScalar(double val0, double val1=0, double val2=0, double val3=0)

CvScalar
cvScalarAll(double val0123);

CvScalar
cvRealScalar(double val0)

CvSURFParams
cvSURFParams(double hessianThreshold, int extended = 0)

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

CvMSERParams
cvMSERParams(int delta = 5, int min_area = 60, int max_area = 14400, float max_variation = 0.25f, float min_diversity = 0.2f, int max_evolution = 200, double area_threshold = 1.01, double min_margin = 0.003, int edge_blur_size = 5)

#endif

CvTermCriteria
cvTermCriteria(int type, int max_iter, double epsilon)


MODULE = Cv		PACKAGE = Cv::Mat
# ====================
int refcount(const CvMat* mat)
CODE:
	if (CV_IS_MAT(mat) && mat->refcount) {
		RETVAL = *mat->refcount;
	} else {
		RETVAL = -1;
	}
OUTPUT:
	RETVAL

void
cvReleaseMat(CvMat* &mat)
ALIAS: Cv::Mat::DESTROY = 1

double
cvmGet(const CvMat* mat, int row, int col)

void
cvmSet(CvMat* mat, int row, int col, double value)

CvMat*
cvCloneMat(const CvMat* mat)


MODULE = Cv		PACKAGE = Cv::MatND
# ====================
int refcount(const CvMatND* mat)
CODE:
	if (CV_IS_MATND(mat) && mat->refcount) {
		RETVAL = *mat->refcount;
	} else {
		RETVAL = -1;
	}
OUTPUT:
	RETVAL

void
cvReleaseMatND(CvMatND* &mat)
ALIAS: Cv::MatND::DESTROY = 1

CvMatND*
cvCloneMatND(const CvMatND* mat)


MODULE = Cv		PACKAGE = Cv::SparseMat
# ====================
int refcount(const CvSparseMat* mat)
CODE:
	if (CV_IS_SPARSE_MAT(mat) && mat->refcount) {
		RETVAL = *mat->refcount;
	} else {
		RETVAL = -1;
	}
OUTPUT:
	RETVAL

void
cvReleaseSparseMat(CvSparseMat* &mat)
ALIAS: Cv::SparseMat::DESTROY = 1

CvSparseMat*
cvCloneSparseMat(const CvSparseMat* mat)


MODULE = Cv		PACKAGE = Cv::Image
# ====================
int
depth(IplImage* image)
CODE:
	RETVAL = image->depth;
OUTPUT:
	RETVAL

int
origin(IplImage* image, int value = NO_INIT)
CODE:
	RETVAL = image->origin;
	if (items == 2) image->origin = value;
OUTPUT:
	RETVAL

void
cvReleaseImage(IplImage* &image)
ALIAS: Cv::Image::DESTROY = 1

void
cvResetImageROI(IplImage* image)

void
cvSetImageCOI(IplImage* image, int coi)

void
cvSetImageROI(IplImage* image, CvRect rect)
POSTCALL:
	XSRETURN(1);

IplImage*
cvCloneImage(const IplImage* image)

int
cvGetImageCOI(const IplImage* image)

CvRect
cvGetImageROI(IplImage* image)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
int
nChannels(CvArr* arr)
ALIAS: Cv::Arr::channels = 1
CODE:
	int type = cvGetElemType(arr);
	RETVAL = CV_MAT_CN(type);
OUTPUT:
	RETVAL

int
depth(CvArr* arr)
CODE:
	RETVAL = elemtype2ipldepth(cvGetElemType(arr));
	if (RETVAL == 0) XSRETURN_UNDEF;
OUTPUT:
	RETVAL

int
dims(CvArr* arr)
CODE:
	RETVAL = cvGetDims(arr, NULL);
OUTPUT:
	RETVAL

int
rows(CvArr* arr)
ALIAS: Cv::Arr::height = 1
CODE:
	int sizes[CV_MAX_DIM];
	int dims = cvGetDims(arr, sizes);
	if (dims >= 1) {
		RETVAL = sizes[0];
	} else {
		RETVAL = 0;
	}
OUTPUT:
	RETVAL

int
cols(CvArr* arr)
ALIAS: Cv::Arr::width = 1
CODE:
	int sizes[CV_MAX_DIM];
	int dims = cvGetDims(arr, sizes);
	if (dims >= 2) {
		RETVAL = sizes[1];
	} else {
		RETVAL = 0;
	}
OUTPUT:
	RETVAL

AV*
sizes(CvArr* arr)
CODE:
	int sizes[CV_MAX_DIM];
	int dims = cvGetDims(arr, sizes); int i;
	RETVAL = newAV();
	for (i = 0; i < dims; i++) {
		av_push(RETVAL, newSViv(sizes[i]));
	}
OUTPUT:
	RETVAL

STRLEN
total(CvArr* arr)
CODE:
	int sizes[CV_MAX_DIM];
	int dims = cvGetDims(arr, sizes); int i;
	RETVAL = sizes[0];
	for (i = 1; i < dims; i++)
		RETVAL *= sizes[i];
OUTPUT:
	RETVAL


MODULE = Cv		PACKAGE = Cv::Sizeof
# ====================
int
CvContour(...)
CODE:
	RETVAL = sizeof(CvContour);
OUTPUT:
	RETVAL

int
CvPoint(...)
CODE:
	RETVAL = sizeof(CvPoint);
OUTPUT:
	RETVAL

int
CvSeq(...)
CODE:
	RETVAL = sizeof(CvSeq);
OUTPUT:
	RETVAL

# ============================================================
#  core. The Core Functionality: Operations on Arrays
# ============================================================

MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvAbsDiff(const CvArr* src1, const CvArr* src2, CvArr* dst)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvAbsDiffS(const CvArr* src, CvScalar value, CvArr* dst)
C_ARGS: src, dst, value
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvAdd(const CvArr* src1, const CvArr* src2, CvArr* dst, const CvArr* mask=NULL)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvAddS(const CvArr* src, CvScalar value, CvArr* dst, const CvArr* mask=NULL)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvAddWeighted(const CvArr* src1, double alpha, const CvArr* src2, double beta, double gamma, CvArr* dst)
POSTCALL:
	ST(0) = ST(5);
	XSRETURN(1);

void
cvAnd(const CvArr* src1, const CvArr* src2, CvArr* dst, const CvArr* mask=NULL)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvAndS(const CvArr* src, CvScalar value, CvArr* dst, const CvArr* mask=NULL)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

CvScalar
cvAvg(const CvArr* arr, const CvArr* mask=NULL)

void
cvAvgSdv(const CvArr* arr, mean, stdDev, const CvArr* mask=NULL)
INPUT:
	CvScalar &mean = NO_INIT
	CvScalar &stdDev = NO_INIT
OUTPUT:
	mean
	stdDev


MODULE = Cv		PACKAGE = Cv
# ====================
void
cvCalcCovarMatrix(const CvArr** vects, CvArr* covMat, CvArr* avg, int flags)
C_ARGS: vects, length(vects), covMat, avg, flags
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvCartToPolar(const CvArr* x, const CvArr* y, CvArr* magnitude, CvArr* angle=NULL, int angleInDegrees=0)

float
cvCbrt(float value)

int
cvCeil(double value)

MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvClearND(CvArr* arr, int* idx)

#MOVED# IplImage* cvCloneImage(const IplImage* image)
#MOVED# CvMat* cvCloneMat(const CvMat* mat)
#MOVED# CvMatND* cvCloneMatND(const CvMatND* mat)
#MOVED# CvSparseMat* cvCloneSparseMat(const CvSparseMat* mat)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvCmp(const CvArr* src1, const CvArr* src2, CvArr* dst, int cmpOp)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvCmpS(const CvArr* src, double value, CvArr* dst, int cmpOp)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvConvertScale(const CvArr* src, CvArr* dst, double scale=1, double shift=0)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvConvertScaleAbs(const CvArr* src, CvArr* dst, double scale=1, double shift=0)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);


MODULE = Cv		PACKAGE = Cv
# ====================
IplImage*
cvCreateImage(CvSize size, int depth, int channels)

IplImage*
cvCreateImageHeader(CvSize size, int depth, int channels)

CvMat*
cvCreateMat(int rows, int cols, int type)

CvMat*
cvCreateMatHeader(int rows, int cols, int type)

CvMatND*
cvCreateMatND(int* sizes, int type)
C_ARGS: length(sizes), sizes, type

CvMatND*
cvCreateMatNDHeader(const int* sizes, int type)
C_ARGS: length(sizes), sizes, type

CvSparseMat*
cvCreateSparseMat(int* sizes, int type)
C_ARGS: length(sizes), sizes, type


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvCopy(const CvArr* src, CvArr* dst, const CvArr* mask=NULL)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

int
cvCountNonZero(const CvArr* arr)

void
cvCrossProduct(const CvArr* src1, const CvArr* src2, CvArr* dst)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvDCT(const CvArr* src, CvArr* dst, int flags)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvDFT(const CvArr* src, CvArr* dst, int flags, int nonzeroRows=0)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvDecRefData(CvArr* arr)
POSTCALL:
	XSRETURN(1);

double
cvDet(const CvArr* mat)

void
cvDiv(const CvArr* src1, const CvArr* src2, CvArr* dst, double scale=1)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

double
cvDotProduct(const CvArr* src1, const CvArr* src2)

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

void
cvEigenVV(CvArr* mat, CvArr* evects, CvArr* evals, double eps=0, int lowindex = -1, int highindex = -1)

#else

void
cvEigenVV( CvArr* mat, CvArr* evects, CvArr* evals, double eps=0)

#endif

void
cvExp(const CvArr* src, CvArr* dst)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);


MODULE = Cv		PACKAGE = Cv
# ====================
float
cvFastArctan(float y, float x)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvFlip(const CvArr* src, CvArr* dst=NULL, int flipMode=0)
POSTCALL:
	if (dst) ST(0) = ST(1);
	XSRETURN(1);


MODULE = Cv		PACKAGE = Cv
# ====================
int
cvFloor(double value)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvGEMM(const CvArr* src1, const CvArr* src2, double alpha, const CvArr* src3, double beta, CvArr* dst, int tABC=0)
POSTCALL:
	ST(0) = ST(5);
	XSRETURN(1);

CvScalar
cvGet1D(const CvArr* arr, int idx0)

CvScalar
cvGet2D(const CvArr* arr, int idx0, int idx1)

CvScalar
cvGet3D(const CvArr* arr, int idx0, int idx1, int idx2)

CvScalar
cvGetND(const CvArr* arr, int* idx)

CvMat*
cvGetCols(const CvArr* arr, CvMat* submat, int startCol, int endCol = NO_INIT)
ALIAS: cvArr::cvGetCol = 1
INIT:
	if (items <= 3) endCol = startCol;
OUTPUT: RETVAL ST(0) = SvREFCNT_inc(ST(1));

CvMat*
cvGetDiag(const CvArr* arr, CvMat* submat, int diag=0)
OUTPUT: submat
OUTPUT: RETVAL ST(0) = SvREFCNT_inc(ST(1));

#C# int cvGetDims(const CvArr* arr, int* sizes=NULL)
void
cvGetDims(const CvArr* arr, ...)
ALIAS: Cv::Arr::cvGetDims = 1
ALIAS: Cv::Arr::cvSizes = 2
PROTOTYPE: $;\@
PPCODE:
	int verbose = 0;
	int sizes[CV_MAX_DIM]; int i;
	int dims = cvGetDims(arr, sizes);
	if (items == 2) {
		AV* av_sizes = (AV*)SvRV(ST(1)); av_clear(av_sizes);
		for (i = 0; i < dims; i++) {
			av_push(av_sizes, newSVnv(sizes[i]));
		}
	}
	I32 gimme = GIMME_V; /* wantarray */
	if (gimme == G_VOID) {
		if (verbose) fprintf(stderr, "Context is Void\n");
	} else if (gimme == G_SCALAR) {
		if (verbose) fprintf(stderr, "Context is Scalar\n");
		XPUSHs(sv_2mortal(newSViv(dims)));
	} else if (gimme == G_ARRAY) {
		if (verbose) fprintf(stderr, "Context is Array\n");
		EXTEND(SP, dims);
		for (i = 0; i < dims; i++) {
			PUSHs(sv_2mortal(newSViv(sizes[i])));
		}
	}

int
cvGetDimSize(const CvArr* arr, int index)

int
cvGetElemType(const CvArr* arr)
ALIAS: Cv::Arr::cvType = 2

IplImage*
cvGetImage(const CvArr* arr, IplImage* imageHeader)

#MOVED# int cvGetImageCOI(const IplImage* image)

#MOVED# CvRect cvGetImageROI(IplImage* image)

CvMat*
cvGetMat(const CvArr* arr, CvMat* header, int* coi=NULL, int allowND=0)

#TBD# CvSparseNode* cvGetNextSparseNode(CvSparseMatIterator* matIterator)


MODULE = Cv		PACKAGE = Cv
# ====================
int
cvGetOptimalDFTSize(int size0)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
#TBD# void cvGetRawData(const CvArr* arr, uchar** data, int* step=NULL, CvSize* roiSize=NULL)

double
cvGetReal1D(const CvArr* arr, int idx0)

double
cvGetReal2D(const CvArr* arr, int idx0, int idx1)

double
cvGetReal3D(const CvArr* arr, int idx0, int idx1, int idx2)

double
cvGetRealND(const CvArr* arr, int* idx)

CvMat*
cvGetRows(const CvArr* arr, CvMat* submat, int startRow, int endRow = NO_INIT, int deltaRow=1)
INIT:
	if (items <= 3) endRow = startRow;
OUTPUT: RETVAL ST(0) = SvREFCNT_inc(ST(1));

CvSize
cvGetSize(const CvArr* arr)
ALIAS: Cv::Arr::cvSize = 2

CvMat*
cvGetSubRect(const CvArr* arr, CvMat* submat, CvRect rect)
OUTPUT: RETVAL ST(0) = SvREFCNT_inc(ST(1));


MODULE = Cv		PACKAGE = Cv
# ====================
float
cvInvSqrt(float value)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvInRange(const CvArr* src, const CvArr* lower, const CvArr* upper, CvArr* dst)
POSTCALL:
	ST(0) = ST(3);
	XSRETURN(1);

void
cvInRangeS(const CvArr* src, CvScalar lower, CvScalar upper, CvArr* dst)
POSTCALL:
	ST(0) = ST(3);
	XSRETURN(1);

int
cvIncRefData(CvArr* arr)

#TBD# IplImage* cvInitImageHeader(IplImage* image, CvSize size, int depth, int channels, int origin=0, int align=4)

#TBD# CvMat* cvInitMatHeader(CvMat* mat, int rows, int cols, int type, void* data=NULL, int step=CV_AUTOSTEP)

#TBD# CvMatND* cvInitMatNDHeader(CvMatND* mat, int dims, const int* sizes, int type, void* data=NULL)

#TBD# CvSparseNode* cvInitSparseMatIterator(const CvSparseMat* mat, CvSparseMatIterator* matIterator)

double
cvInv(const CvArr* src, CvArr* dst, int method=CV_LU)
ALIAS: Cv::Arr::cvInvert = 1


MODULE = Cv		PACKAGE = Cv
# ====================
int
cvIsInf(double value)

int
cvIsNaN(double value)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvLUT(const CvArr* src, CvArr* dst, const CvArr* lut)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvLog(const CvArr* src, CvArr* dst)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

double
cvMahalanobis(const CvArr* vec1, const CvArr* vec2, CvArr* mat)

void
cvMax(const CvArr* src1, const CvArr* src2, CvArr* dst)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvMaxS(const CvArr* src, double value, CvArr* dst)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);


MODULE = Cv		PACKAGE = Cv
# ====================
void
cvMerge(const CvArr** srcs, CvArr* dst = NO_INIT)
INIT:
	const CvArr* src0 = length(srcs) >= 1 ? srcs[0] : NULL;
	const CvArr* src1 = length(srcs) >= 2 ? srcs[1] : NULL;
	const CvArr* src2 = length(srcs) >= 3 ? srcs[2] : NULL;
	const CvArr* src3 = length(srcs) >= 4 ? srcs[3] : NULL;
C_ARGS: src0, src1, src2, src3, dst
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvMin(const CvArr* src1, const CvArr* src2, CvArr* dst)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvMinMaxLoc(const CvArr *arr, min_val, max_val, min_loc = NO_INIT, max_loc = NO_INIT, const CvArr* mask = NULL)
INPUT:
	double &min_val = NO_INIT
	double &max_val = NO_INIT
	CvPoint &min_loc = NO_INIT
	CvPoint &max_loc = NO_INIT
POSTCALL:
	if (items >= 4) XS_pack_CvPoint(ST(3), min_loc);
	if (items >= 5) XS_pack_CvPoint(ST(4), max_loc);
OUTPUT:
	min_val
	max_val

void
cvMinS(const CvArr* src, double value, CvArr* dst)


MODULE = Cv		PACKAGE = Cv
# ====================
void
cvMixChannels(const CvArr** src, CvArr** dst, const int* fromTo)
C_ARGS: src, length(src), dst, length(dst), fromTo, length(fromTo)/2


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvMul(const CvArr* src1, const CvArr* src2, CvArr* dst, double scale=1)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvMulSpectrums(const CvArr* src1, const CvArr* src2, CvArr* dst, int flags)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvMulTransposed(const CvArr* src, CvArr* dst, int order, const CvArr* delta=NULL, double scale=1.0)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

double
cvNorm(const CvArr* arr1, const CvArr* arr2=NULL, int normType=CV_L2, const CvArr* mask=NULL)

void
cvNormalize(const CvArr* src, CvArr* dst, double a = 1.0, double b = 0.0, int norm_type = CV_L2, const CvArr* mask = NULL)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvNot(const CvArr* src, CvArr* dst)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvOr(const CvArr* src1, const CvArr* src2, CvArr* dst, const CvArr* mask=NULL)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvOrS(const CvArr* src, CvScalar value, CvArr* dst, const CvArr* mask=NULL)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvPerspectiveTransform(const CvArr* src, CvArr* dst, const CvMat* mat)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvPolarToCart(const CvArr* magnitude, const CvArr* angle, CvArr* x, CvArr* y, int angleInDegrees=0)

void
cvPow(const CvArr* src, CvArr* dst, double power)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

SV *
cvPtr1D(const CvArr* arr, int idx0, int type = NO_INIT)
CODE:
	uchar* s = cvPtr1D(arr, idx0, &type);
	int n = cvGetDimSize(arr, 0);
	if (items >= 3) sv_setiv(ST(2), type);
	RETVAL = newSVpvn((const char*)s, n*CV_ELEM_SIZE(type));
OUTPUT:
	RETVAL

SV *
cvPtr2D(const CvArr* arr, int idx0, int idx1, int type = NO_INIT)
CODE:
	uchar* s = cvPtr2D(arr, idx0, idx1, &type);
	int n = cvGetDimSize(arr, 0);
	if (items >= 4) sv_setiv(ST(3), type);
	RETVAL = newSVpvn((const char*)s, n*CV_ELEM_SIZE(type));
OUTPUT:
	RETVAL

SV *
cvPtr3D(const CvArr* arr, int idx0, int idx1, int idx2, int type = NO_INIT)
CODE:
	uchar* s = cvPtr3D(arr, idx0, idx1, idx2, &type);
	int n = cvGetDimSize(arr, 0);
	if (items >= 5) sv_setiv(ST(4), type);
	RETVAL = newSVpvn((const char*)s, n*CV_ELEM_SIZE(type));
OUTPUT:
	RETVAL

SV *
cvPtrND(const CvArr* arr, int* idx, int type = NO_INIT, int createNode = 1, unsigned precalcHashval = NO_INIT)
CODE:
	uchar* s = (items <= 4)? cvPtrND(arr, idx, &type, createNode, NULL) :
		cvPtrND(arr, idx, &type, createNode, &precalcHashval);
	int n = cvGetDimSize(arr, 0);
	if (items >= 3) sv_setiv(ST(2), type);
	if (items >= 5) sv_setuv(ST(4), precalcHashval);
	// Obviously, 1x1 or 1xN matrices are always continuous.
	if (n == 1 && length(idx) >= 2) n = cvGetDimSize(arr, 1);
	RETVAL = newSVpvn((const char*)s, n*CV_ELEM_SIZE(type));
OUTPUT:
	RETVAL


MODULE = Cv		PACKAGE = Cv
# ====================
float
cvSqrt(float value)

CvRNG*
cvRNG(int64 seed = -1)
CODE:
	Newx(RETVAL, 1, CvRNG);
	*RETVAL = cvRNG(seed);
OUTPUT:
	RETVAL

MODULE = Cv		PACKAGE = Cv::RNG
# ====================
void
DESTROY(CvRNG* rng)
CODE:
	if (rng) safefree(rng);

void
cvRandArr(CvRNG* rng, CvArr* arr, int distType, CvScalar param1, CvScalar param2)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

unsigned
cvRandInt(CvRNG* rng)

double
cvRandReal(CvRNG* rng)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvReduce(const CvArr* src, CvArr* dst, int dim = -1, int op=CV_REDUCE_SUM)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

#TBD# void cvReleaseData(CvArr* arr)
#MOVED# void cvReleaseImage(IplImage* &image)
#MOVED# void cvReleaseMat(CvMat* &mat)
#MOVED# void cvReleaseMatND(CvMatND* &mat)
#MOVED# void cvReleaseSparseMat(CvSparseMat* &mat)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvRepeat(const CvArr* src, CvArr* dst)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

#MOVED# void cvResetImageROI(IplImage* image)

CvMat*
cvReshape(const CvArr* arr, CvMat* header, int newCn, int newRows=0)

CvArr*
cvReshapeMatND(const CvArr* arr, int sizeofHeader, CvArr* header, int newCn, int newDims, int* newSizes)


MODULE = Cv		PACKAGE = Cv
# ====================
int
cvRound(double value)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvScaleAdd(const CvArr* src1, CvScalar scale, const CvArr* src2, CvArr* dst)
POSTCALL:
	ST(0) = ST(3);
	XSRETURN(1);

#MOVED# void cvSetImageCOI(IplImage* image, int coi)
#MOVED# void cvSetImageROI(IplImage* image, CvRect rect)

void
cvSet(CvArr* arr, CvScalar value, const CvArr* mask=NULL)
ALIAS: Cv::Arr::cvFill = 1
POSTCALL:
	XSRETURN(1);

void
cvSet1D(CvArr* arr, int idx0, CvScalar value)
POSTCALL:
	XSRETURN(1);

void
cvSet2D(CvArr* arr, int idx0, int idx1, CvScalar value)
POSTCALL:
	XSRETURN(1);

void
cvSet3D(CvArr* arr, int idx0, int idx1, int idx2, CvScalar value)
POSTCALL:
	XSRETURN(1);

void
cvSetND(CvArr* arr, int* idx, CvScalar value)
POSTCALL:
	XSRETURN(1);

void
cvSetData(CvArr* arr, SV* data, int step)
CODE:
	if (!SvPOK(data)) XSRETURN_UNDEF;
	cvSetData(arr, SvPV_nolen(data), step);
	XSRETURN(1);

void
cvSetIdentity(CvArr* mat, CvScalar value=cvRealScalar(1))
POSTCALL:
	XSRETURN(1);

void
cvSetReal1D(CvArr* arr, int idx0, double value)
POSTCALL:
	XSRETURN(1);

void
cvSetReal2D(CvArr* arr, int idx0, int idx1, double value)
POSTCALL:
	XSRETURN(1);

void
cvSetReal3D(CvArr* arr, int idx0, int idx1, int idx2, double value)
POSTCALL:
	XSRETURN(1);

void
cvSetRealND(CvArr* arr, int* idx, double value)
POSTCALL:
	XSRETURN(1);

void
cvSetZero(CvArr* arr)
ALIAS: Cv::Arr::cvZero = 1
POSTCALL:
	XSRETURN(1);

int
cvSolve(const CvArr* src1, const CvArr* src2, CvArr* dst, int method=CV_LU)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);


MODULE = Cv		PACKAGE = Cv::Mat
# ====================
void
cvSolveCubic(const CvMat* coeffs, CvMat* roots)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvSplit(const CvArr* src, CvArr* dst0, CvArr* dst1 = NULL, CvArr* dst2 = NULL, CvArr* dst3 = NULL)

void
cvSub(const CvArr* src1, const CvArr* src2, CvArr* dst, const CvArr* mask=NULL)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvSubRS(const CvArr* src, CvScalar value, CvArr* dst, const CvArr* mask=NULL)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvSubS(const CvArr* src, CvScalar value, CvArr* dst, const CvArr* mask=NULL)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

CvScalar
cvSum(const CvArr* arr)

void
cvSVBkSb(const CvArr* W, const CvArr* U, const CvArr* V, const CvArr* B, CvArr* X, int flags)

void
cvSVD(CvArr* A, CvArr* W, CvArr* U=NULL, CvArr* V=NULL, int flags=0)

CvScalar
cvTrace(const CvArr* mat)

void
cvTransform(const CvArr* src, CvArr* dst, const CvMat* transmat, const CvMat* shiftvec=NULL)
POSTCALL:
	XSRETURN(1);

void
cvTranspose(const CvArr* src, CvArr* dst)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvXor(const CvArr* src1, const CvArr* src2, CvArr* dst, const CvArr* mask=NULL)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvXorS(const CvArr* src, CvScalar value, CvArr* dst, const CvArr* mask=NULL)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

#MOVED# double cvmGet(const CvMat* mat, int row, int col)
#MOVED# void cvmSet(CvMat* mat, int row, int col, double value)


# ============================================================
#  core. The Core Functionality: Dynamic Structures
# ============================================================

MODULE = Cv		PACKAGE = Cv::MemStorage
# ====================
CvMemBlock*
bottom(CvMemStorage* stor)
CODE:
	RETVAL = stor->bottom;
OUTPUT:
	RETVAL

CvMemBlock*
top(CvMemStorage* stor)
CODE:
	RETVAL = stor->top;
OUTPUT:
	RETVAL

CvMemStorage*
parent(CvMemStorage* stor)
CODE:
	RETVAL = stor->parent;
OUTPUT:
	RETVAL

int
block_size(CvMemStorage* stor)
CODE:
	RETVAL = stor->block_size;
OUTPUT:
	RETVAL

int
free_space(CvMemStorage* stor)
CODE:
	RETVAL = stor->free_space;
OUTPUT:
	RETVAL


MODULE = Cv		PACKAGE = Cv::Seq
# ====================
int
flags(CvSeq* seq)
CODE:
	RETVAL = seq->flags;
OUTPUT:
	RETVAL

int
header_size(CvSeq* seq)
CODE:
	RETVAL = seq->header_size;
OUTPUT:
	RETVAL

CvSeq*
h_prev(CvSeq* seq)
CODE:
	RETVAL = seq->h_prev;
OUTPUT:
	RETVAL

CvSeq*
h_next(CvSeq* seq)
CODE:
	RETVAL = seq->h_next;
OUTPUT:
	RETVAL

CvSeq*
v_prev(CvSeq* seq)
CODE:
	RETVAL = seq->v_prev;
OUTPUT:
	RETVAL

CvSeq*
v_next(CvSeq* seq)
CODE:
	RETVAL = seq->v_next;
OUTPUT:
	RETVAL

int
total(CvSeq* seq)
CODE:
	RETVAL = seq->total;
OUTPUT:
	RETVAL

int
elem_size(CvSeq* seq)
CODE:
	RETVAL = seq->elem_size;
OUTPUT:
	RETVAL

void*
block_max(CvSeq* seq)
CODE:
	RETVAL = seq->block_max;
OUTPUT:
	RETVAL

void*
ptr(CvSeq* seq)
CODE:
	RETVAL = seq->ptr;
OUTPUT:
	RETVAL

int
delta_elems(CvSeq* seq)
CODE:
	RETVAL = seq->delta_elems;
OUTPUT:
	RETVAL

CvMemStorage*
storage(CvSeq* seq)
CODE:
	RETVAL = seq->storage;
OUTPUT:
	RETVAL

CvSeqBlock*
free_blocks(CvSeq* seq)
CODE:
	RETVAL = seq->free_blocks;
OUTPUT:
	RETVAL

CvSeqBlock*
first(CvSeq* seq)
CODE:
	RETVAL = seq->first;
OUTPUT:
	RETVAL


MODULE = Cv		PACKAGE = Cv::SeqBlock
# ====================
CvSeqBlock*
prev(CvSeqBlock* seq)
CODE:
	RETVAL = seq->prev;
OUTPUT:
	RETVAL

CvSeqBlock*
next(CvSeqBlock* seq)
CODE:
	RETVAL = seq->next;
OUTPUT:
	RETVAL

int
start_index(CvSeqBlock* seq)
CODE:
	RETVAL = seq->start_index;
OUTPUT:
	RETVAL

int
count(CvSeqBlock* seq)
CODE:
	RETVAL = seq->count;
OUTPUT:
	RETVAL

void*
data(CvSeqBlock* seq)
CODE:
	RETVAL = seq->data;
OUTPUT:
	RETVAL


MODULE = Cv		PACKAGE = Cv
# ====================
CvSlice
cvSlice(int start_index, int end_index)

int
cvSliceLength(CvSlice slice, const CvSeq* seq)


MODULE = Cv		PACKAGE = Cv::Set
# ====================


MODULE = Cv		PACKAGE = Cv::SetElem
# ====================
int
flags(CvSetElem* elem)
CODE:
	RETVAL = elem->flags;
OUTPUT:
	RETVAL

CvSetElem*
next_free(CvSetElem* elem)
CODE:
	RETVAL = elem->next_free;
OUTPUT:
	RETVAL

MODULE = Cv		PACKAGE = Cv::Graph
# ====================
CvSet*
edges(CvGraph* p)
CODE:
	RETVAL = p->edges;
OUTPUT:
	RETVAL

MODULE = Cv		PACKAGE = Cv::GraphScanner
# ====================
CvGraphVtx*
vtx(CvGraphScanner* p)
CODE:
	RETVAL = p->vtx;
OUTPUT:
	RETVAL

CvGraphVtx*
dst(CvGraphScanner* p)
CODE:
	RETVAL = p->dst;
OUTPUT:
	RETVAL

CvGraphEdge*
edge(CvGraphScanner* p)
CODE:
	RETVAL = p->edge;
OUTPUT:
	RETVAL

CvGraph*
graph(CvGraphScanner* p)
CODE:
	RETVAL = p->graph;
OUTPUT:
	RETVAL

CvSeq*
stack(CvGraphScanner* p)
CODE:
	RETVAL = p->stack;
OUTPUT:
	RETVAL

int
index(CvGraphScanner* p)
CODE:
	RETVAL = p->index;
OUTPUT:
	RETVAL

int
mask(CvGraphScanner* p)
CODE:
	RETVAL = p->mask;
OUTPUT:
	RETVAL


MODULE = Cv		PACKAGE = Cv::TreeNodeIterator
# ====================
const void*
node(CvTreeNodeIterator* p)
CODE:
	RETVAL = p->node;
OUTPUT:
	RETVAL

int
level(CvTreeNodeIterator* p)
CODE:
	RETVAL = p->level;
OUTPUT:
	RETVAL

int
max_level(CvTreeNodeIterator* p)
CODE:
	RETVAL = p->max_level;
OUTPUT:
	RETVAL


MODULE = Cv		PACKAGE = Cv::Graph
# ====================
void
cvClearGraph(CvGraph* graph)


MODULE = Cv		PACKAGE = Cv::MemStorage
# ====================
void
cvClearMemStorage(CvMemStorage* storage)


MODULE = Cv		PACKAGE = Cv::Seq
# ====================
void
cvClearSeq(CvSeq* seq)


MODULE = Cv		PACKAGE = Cv::Set
# ====================
void
cvClearSet(CvSet* setHeader)


MODULE = Cv		PACKAGE = Cv::Graph
# ====================
CvGraph*
cvCloneGraph(const CvGraph* graph, CvMemStorage* storage)


MODULE = Cv		PACKAGE = Cv::Seq
# ====================
CvSeq*
cvCloneSeq(const CvSeq* seq, CvMemStorage* storage=NULL)

MODULE = Cv		PACKAGE = Cv::MemStorage
# ====================
CvMemStorage*
cvCreateChildMemStorage(CvMemStorage* parent)


MODULE = Cv		PACKAGE = Cv
# ====================
CvGraph*
cvCreateGraph(int graph_flags, int header_size, int vtx_size, int edge_size, CvMemStorage* storage)


MODULE = Cv		PACKAGE = Cv::Graph
# ====================
CvGraphScanner*
cvCreateGraphScanner(CvGraph* graph, CvGraphVtx* vtx=NULL, int mask=CV_GRAPH_ALL_ITEMS)


MODULE = Cv		PACKAGE = Cv
# ====================
CvMemStorage*
cvCreateMemStorage(int blockSize=0)

CvSeq*
cvCreateSeq(int seqFlags, int headerSize, int elemSize, CvMemStorage* storage)

CvSet*
cvCreateSet(int set_flags, int header_size, int elem_size, CvMemStorage* storage)


MODULE = Cv		PACKAGE = Cv::Seq
# ====================

#C# void* cvCvtSeqToArray(const CvSeq* seq, void* elements, CvSlice slice=CV_WHOLE_SEQ)

AV*
cvCvtSeqToArray(const CvSeq* seq, AV* elements, CvSlice slice=CV_WHOLE_SEQ)
PROTOTYPE: $\@;$
CODE:
	av_clear(elements);
	if (seq->total > 0) {
		CvPoint pt[seq->total]; int i;
		cvCvtSeqToArray(seq, pt, slice);
		for (i = 0; i < seq->total; i++) {
			AV* av_point = newAV();
			av_push(av_point, newSVnv(pt[i].x));
			av_push(av_point, newSVnv(pt[i].y));
			av_push(elements, newRV_inc((SV *)av_point));
		}
	}
	RETVAL = elements;
OUTPUT:
	RETVAL


MODULE = Cv		PACKAGE = Cv::SeqWriter
# ====================
CvSeq*
cvEndWriteSeq(CvSeqWriter* writer)


MODULE = Cv		PACKAGE = Cv::Graph
# ====================
CvGraphEdge*
cvFindGraphEdge(const CvGraph* graph, int start_idx, int end_idx)

CvGraphEdge*
cvFindGraphEdgeByPtr(const CvGraph* graph, const CvGraphVtx* startVtx, const CvGraphVtx* endVtx)


MODULE = Cv		PACKAGE = Cv::SeqWriter
# ====================
void
cvFlushSeqWriter(CvSeqWriter* writer)


MODULE = Cv		PACKAGE = Cv::Graph
# ====================
CvGraphVtx*
cvGetGraphVtx(CvGraph* graph, int vtx_idx)


MODULE = Cv		PACKAGE = Cv::Seq
# ====================
#C# char* cvGetSeqElem(const CvSeq* seq, int index)

SV *
cvGetSeqElem(const CvSeq* seq, int index)
CODE:
	if (CV_IS_SEQ(seq)) {
		char s[seq->elem_size];
		memcpy(s, cvGetSeqElem(seq, index), sizeof(s));
		RETVAL = newSVpvn(s, sizeof(s));
	} else {
		RETVAL = newSVpvn("", 0);
	}
OUTPUT:
	RETVAL

CvPoint
cvGetSeqElem_Point(const CvSeq* seq, int index)
ALIAS: Cv::Seq::Point::cvGetSeqElem = 1
CODE:
	if (sizeof(RETVAL) == seq->elem_size) {
		memcpy(&RETVAL, cvGetSeqElem(seq, index), sizeof(RETVAL));
	} else {
	    Perl_croak(aTHX_ "%s: %s is not of type %s",
			"cvGetSeqElem", "SeqElem", "CvPoint");
	}
OUTPUT:
	RETVAL

CvCircle
cvGetSeqElem_Circle(const CvSeq* seq, int index)
ALIAS: Cv::Seq::Circle::cvGetSeqElem = 1
CODE:
	if (sizeof(RETVAL) == seq->elem_size) {
		memcpy(&RETVAL, cvGetSeqElem(seq, index), sizeof(RETVAL));
	} else {
	    Perl_croak(aTHX_ "%s: %s is not of type %s",
			"cvGetSeqElem", "SeqElem", "CvCircle");
	}
OUTPUT:
	RETVAL

CvSeq*
cvGetSeqElem_Seq(const CvSeq* seq, int index)
ALIAS: Cv::Seq::Seq::cvGetSeqElem = 1
CODE:
	if (sizeof(RETVAL) == seq->elem_size) {
		memcpy(&RETVAL, cvGetSeqElem(seq, index), sizeof(RETVAL));
	} else {
	    Perl_croak(aTHX_ "%s: %s is not of type %s",
			"cvGetSeqElem", "SeqElem", "CvSeq*");
	}
OUTPUT:
	RETVAL

CvContour*
cvGetSeqElem_Contour(const CvSeq* seq, int index)
ALIAS: Cv::Seq::Contour::cvGetSeqElem = 1
CODE:
	if (sizeof(RETVAL) == seq->elem_size) {
		memcpy(&RETVAL, cvGetSeqElem(seq, index), sizeof(RETVAL));
	} else {
	    Perl_croak(aTHX_ "%s: %s is not of type %s",
			"cvGetSeqElem", "SeqElem", "CvContour*");
	}
OUTPUT:
	RETVAL

CvSURFPoint
cvGetSeqElem_SURFPoint(const CvSeq* seq, int index)
ALIAS: Cv::Seq::SURFPoint::cvGetSeqElem = 1
CODE:
	if (sizeof(RETVAL) == seq->elem_size) {
		memcpy(&RETVAL, cvGetSeqElem(seq, index), sizeof(RETVAL));
	} else {
	    Perl_croak(aTHX_ "%s: %s is not of type %s",
			"cvGetSeqElem", "SeqElem", "CvSURFPoint");
	}
OUTPUT:
	RETVAL


MODULE = Cv		PACKAGE = Cv::SeqReader
# ====================
int
cvGetSeqReaderPos(CvSeqReader* reader)


MODULE = Cv		PACKAGE = Cv::Set
# ====================
CvSetElem*
cvGetSetElem(const CvSet* setHeader, int index)


MODULE = Cv		PACKAGE = Cv::Graph
# ====================
#TBD# int cvGraphAddEdge(CvGraph* graph, int start_idx, int end_idx, const CvGraphEdge* edge=NULL, CvGraphEdge** inserted_edge=NULL)

#TBD# int cvGraphAddEdgeByPtr(CvGraph* graph, CvGraphVtx* start_vtx, CvGraphVtx* end_vtx, const CvGraphEdge* edge=NULL, CvGraphEdge** inserted_edge=NULL)

#TBD# int cvGraphAddVtx(CvGraph* graph, const CvGraphVtx* vtx=NULL, CvGraphVtx** inserted_vtx=NULL)

int
cvGraphEdgeIdx(CvGraph* graph, CvGraphEdge* edge)

void
cvGraphRemoveEdge(CvGraph* graph, int start_idx, int end_idx)

void
cvGraphRemoveEdgeByPtr(CvGraph* graph, CvGraphVtx* start_vtx, CvGraphVtx* end_vtx)

int
cvGraphRemoveVtx(CvGraph* graph, int index)

int
cvGraphRemoveVtxByPtr(CvGraph* graph, CvGraphVtx* vtx)

int
cvGraphVtxDegree(const CvGraph* graph, int vtxIdx)

int
cvGraphVtxDegreeByPtr(const CvGraph* graph, const CvGraphVtx* vtx)

int
cvGraphVtxIdx(CvGraph* graph, CvGraphVtx* vtx)

#TBD# void cvInitTreeNodeIterator(CvTreeNodeIterator* tree_iterator, const void* first, int max_level)

#TBD# void cvInsertNodeIntoTree(void* node, void* parent, void* frame)


MODULE = Cv		PACKAGE = Cv
# ====================
CvSeq*
cvMakeSeqHeaderForArray(int seq_type, int header_size, int elem_size, void* elements, int total, CvSeq* seq, CvSeqBlock* block)


MODULE = Cv		PACKAGE = Cv::MemStorage
# ====================
void*
cvMemStorageAlloc(CvMemStorage* storage, size_t size)

CvString
cvMemStorageAllocString(CvMemStorage* storage, const char* ptr, int len=-1)


MODULE = Cv		PACKAGE = Cv::String
# ====================
char*
ptr(CvString str)
CODE:
	RETVAL = str.ptr;
OUTPUT:
	RETVAL

int
len(CvString str)
CODE:
	RETVAL = str.len;
OUTPUT:
	RETVAL


MODULE = Cv		PACKAGE = Cv::GraphScanner
# ====================
int
cvNextGraphItem(CvGraphScanner* scanner)


MODULE = Cv		PACKAGE = Cv::TreeNodeIterator
# ====================
void*
cvNextTreeNode(CvTreeNodeIterator* tree_iterator)

void*
cvPrevTreeNode(CvTreeNodeIterator* tree_iterator)

void
cvReleaseGraphScanner(CvGraphScanner* &scanner)
ALIAS: Cv::GraphScanner::DESTROY = 1


MODULE = Cv		PACKAGE = Cv::MemStorage
# ====================
void
cvReleaseMemStorage(CvMemStorage* &storage)
ALIAS: Cv::MemStorage::DESTROY = 1

#C# void cvRestoreMemStoragePos(CvMemStorage* storage, CvMemStoragePos* pos)
void
cvRestoreMemStoragePos(CvMemStorage* storage, CvMemStoragePos pos)
C_ARGS:	storage, &pos

#C# void cvSaveMemStoragePos(const CvMemStorage* storage, CvMemStoragePos* pos)
void
cvSaveMemStoragePos(const CvMemStorage* storage, pos)
INPUT:
	CvMemStoragePos &pos = NO_INIT
OUTPUT:
	pos
	
#TBD# int cvSeqElemIdx(const CvSeq* seq, const void* element, CvSeqBlock** block=NULL)


MODULE = Cv		PACKAGE = Cv::Seq
# ====================
void
cvSeqInvert(CvSeq* seq)

#C# char* cvSeqInsert(CvSeq* seq, int beforeIndex, void* element=NULL)
#C# void cvSeqInsertSlice(CvSeq* seq, int beforeIndex, const CvArr* fromArr)
#C# void cvSeqPopMulti(CvSeq* seq, void* elements, int count, int in_front=0)
#C# void cvSeqPushMulti(CvSeq* seq, void* elements, int count, int in_front=0)

CvPoint
cvSeqPop_Point(CvSeq* seq)
ALIAS: Cv::Seq::Point::cvSeqPop = 1
CODE:
	cvSeqPop(seq, &RETVAL);
OUTPUT:
	RETVAL

CvPoint
cvSeqPopFront_Point(CvSeq* seq)
ALIAS: Cv::Seq::Point::cvSeqPopFront = 1
CODE:
	cvSeqPopFront(seq, &RETVAL);
OUTPUT:
	RETVAL

void
cvSeqPush_Point(CvSeq* seq, CvPoint element)
ALIAS: Cv::Seq::Point::cvSeqPush = 1
CODE:
	cvSeqPush(seq, &element);

void
cvSeqPushFront_Point(CvSeq* seq, CvPoint element)
ALIAS: Cv::Seq::Point::cvSeqPushFront = 1
CODE:
	cvSeqPushFront(seq, &element);

void
cvSeqRemove(CvSeq* seq, int index)

void
cvSeqRemoveSlice(CvSeq* seq, CvSlice slice)

#TBD# char* cvSeqSearch(CvSeq* seq, const void* elem, CvCmpFunc func, int is_sorted, int* elem_idx, void* userdata=NULL)

CvSeq*
cvSeqSlice(const CvSeq* seq, CvSlice slice, CvMemStorage* storage=NULL, int copy_data=0)

#TBD# void cvSeqSort(CvSeq* seq, CvCmpFunc func, void* userdata=NULL)

#TBD# int cvSetAdd(CvSet* setHeader, CvSetElem* elem=NULL, CvSetElem** inserted_elem=NULL)

#TBD# CvSetElem* cvSetNew(CvSet* setHeader)

#TBD# void cvSetRemove(CvSet* setHeader, int index)

#TBD# void cvSetRemoveByPtr(CvSet* setHeader, void* elem)

#TBD# void cvSetSeqBlockSize(CvSeq* seq, int deltaElems)

#TBD# void cvSetSeqReaderPos(CvSeqReader* reader, int index, int is_relative=0)

void
cvStartAppendToSeq(CvSeq* seq, CvSeqWriter* writer)

#TBD# void cvStartReadSeq(const CvSeq* seq, CvSeqReader* reader, int reverse=0)
void
cvStartReadSeq(const CvSeq* seq, reader, int reverse = 0)
INPUT:
	CvSeqReader* reader = NO_INIT
INIT:
	Newx(reader, 1, CvSeqReader);
CODE:
	cvStartReadSeq(seq, reader, reverse);
OUTPUT:
	reader

void
cvStartWriteSeq(int seq_flags, int header_size, int elem_size, CvMemStorage* storage, CvSeqWriter* writer)

#TBD# CvSeq* cvTreeToNodeSeq(const void* first, int header_size, CvMemStorage* storage)

MODULE = Cv		PACKAGE = Cv::SeqReader
# ====================
void
DESTROY(CvSeqReader* reader)
CODE:
	if (reader) safefree(reader);

void*
ptr(CvSeqReader* reader)
CODE:
	RETVAL = reader->ptr;
OUTPUT:
	RETVAL

SV *
cvReadSeqElem(CvSeqReader* reader)
CODE:
	if (CV_IS_SEQ(reader->seq)) {
		RETVAL = newSVpvn((const char*)reader->ptr, reader->seq->elem_size);
		CV_NEXT_SEQ_ELEM(reader->seq->elem_size, *reader);
	} else if (CV_IS_SET((CvSet*)reader->seq)) {
		RETVAL = newSVpvn((const char*)reader->ptr, ((CvSet*)reader->seq)->elem_size);
		CV_NEXT_SEQ_ELEM(((CvSet*)reader->seq)->elem_size, *reader);
	} else {
		RETVAL = newSVpvn("", 0);
	}
OUTPUT:
	RETVAL

void
cvNextSeqElem(CvSeqReader* reader)
CODE:
	if (CV_IS_SEQ(reader->seq)) {
		CV_NEXT_SEQ_ELEM(reader->seq->elem_size, *reader);
	} else if (CV_IS_SET((CvSet*)reader->seq)) {
		CV_NEXT_SEQ_ELEM(((CvSet*)reader->seq)->elem_size, *reader);
	}


# ============================================================
#  core. The Core Functionality: Drawing Functions
# ============================================================

MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvCircle(CvArr* img, CvPoint center, int radius, CvScalar color, int thickness=1, int lineType=8, int shift=0)
POSTCALL:
	XSRETURN(1);


MODULE = Cv		PACKAGE = Cv
# ====================
int
cvClipLine(CvSize imgSize, CvPoint* pt1, CvPoint* pt2)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvDrawContours(CvArr *img, CvSeq* contour, CvScalar external_color, CvScalar hole_color, int max_level, int thickness=1, int line_type=8, CvPoint offset=cvPoint(0,0));

void
cvEllipse(CvArr* img, CvPoint center, CvSize axes, double angle, double start_angle, double end_angle, CvScalar color, int thickness=1, int lineType=8, int shift=0)
POSTCALL:
	XSRETURN(1);

void
cvEllipseBox(CvArr* img, CvBox2D box, CvScalar color, int thickness=1, int lineType=8, int shift=0)
POSTCALL:
	XSRETURN(1);

void
cvFillConvexPoly(CvArr* img, CvPoint* pts, CvScalar color, int lineType=8, int shift=0)
C_ARGS:	img, pts, length(pts), color, lineType, shift
POSTCALL:
	XSRETURN(1);

void
cvFillPoly(CvArr* img, CvPoint** pts, CvScalar color, int lineType=8, int shift=0)
C_ARGS: img, pts, length(inner_pts), length(pts), color, lineType, shift
POSTCALL:
	XSRETURN(1);


MODULE = Cv		PACKAGE = Cv::Font
# ====================
void
cvGetTextSize(const CvFont* font, const char* textString, textSize, baseline)
INPUT:
	CvSize &textSize = NO_INIT
	int &baseline = NO_INIT
C_ARGS:
	textString, font, &textSize, &baseline
OUTPUT:
	textSize
	baseline


MODULE = Cv		PACKAGE = Cv
# ====================
CvFont*
cvInitFont(int fontFace, double hscale, double vscale, double shear=0, int thickness=1, int lineType=8)
INIT:
	Newx(RETVAL, 1, CvFont);
	if (!RETVAL) Perl_croak(aTHX_ "cvInitFont: no core");
#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) == 2001
	if (lineType & CV_AA) lineType |= 1;
#endif
CODE:
	cvInitFont(RETVAL, fontFace, hscale, vscale, shear, thickness, lineType);
OUTPUT:
	RETVAL


MODULE = Cv		PACKAGE = Cv::Font
# ====================
void
cvReleaseFont(CvFont* font)
ALIAS: Cv::Font::DESTROY = 1
CODE:
	safefree(font);


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
#TBD# int cvInitLineIterator(const CvArr* image, CvPoint pt1, CvPoint pt2, CvLineIterator* line_iterator, int connectivity=8, int left_to_right=0)

void
cvLine(CvArr* img, CvPoint pt1, CvPoint pt2, CvScalar color, int thickness=1, int lineType=8, int shift=0)
POSTCALL:
	XSRETURN(1);

void
cvPolyLine(CvArr* img, CvPoint** pts, int is_closed, CvScalar color, int thickness = 1, int line_type = 8, int shift = 0)
C_ARGS: img, pts, length(inner_pts), length(pts), is_closed, color, thickness, line_type, shift
POSTCALL:
	XSRETURN(1);

void
cvPutText(CvArr* img, const char* text, CvPoint org, const CvFont* font, CvScalar color)
POSTCALL:
	XSRETURN(1);

void
cvRectangle(CvArr* img, CvPoint pt1, CvPoint pt2, CvScalar color, int thickness=1, int lineType=8, int shift=0)
POSTCALL:
	XSRETURN(1);


MODULE = Cv		PACKAGE = Cv
# ====================
CvScalar
CV_RGB(double r, double g, double b)


# ============================================================
#  core. The Core Functionality: XML/YAML Persistence
# ============================================================

MODULE = Cv		PACKAGE = Cv::TypeInfo
# ====================
const char*
type_name(CvTypeInfo* info)
CODE:
	RETVAL = info->type_name;
OUTPUT:
	RETVAL


MODULE = Cv		PACKAGE = Cv::FileStorage
# ====================
void
cvEndWriteStruct(CvFileStorage* fs)

MODULE = Cv		PACKAGE = Cv
# ====================
CvTypeInfo*
cvFindType(const char* typeName)

CvTypeInfo*
cvFirstType(...)


MODULE = Cv		PACKAGE = Cv::StringHashNode
# ====================

unsigned
hashval(CvStringHashNode *np)
CODE:
	RETVAL = np->hashval;
OUTPUT:
	RETVAL

CvString
str(CvStringHashNode *np)
CODE:
	RETVAL = np->str;
OUTPUT:
	RETVAL

CvStringHashNode*
next(CvStringHashNode *np)
CODE:
	RETVAL = np->next;
OUTPUT:
	RETVAL


MODULE = Cv		PACKAGE = Cv::FileStorage
# ====================
CvFileNode*
cvGetFileNode(CvFileStorage* fs, CvFileNode* map, const CvStringHashNode* key, int createMissing=0)

CvFileNode*
cvGetFileNodeByName(const CvFileStorage* fs, const CvFileNode* map, const char* name)


MODULE = Cv		PACKAGE = Cv::FileNode
# ====================
const char*
cvGetFileNodeName(const CvFileNode* node)


MODULE = Cv		PACKAGE = Cv::FileStorage
# ====================
CvStringHashNode*
cvGetHashedKey(CvFileStorage* fs, const char* name, int len=-1, int createMissing=0)

CvFileNode*
cvGetRootFileNode(const CvFileStorage* fs, int stream_index=0)


MODULE = Cv		PACKAGE = Cv
# ====================
void*
cvLoad(const char* filename, CvMemStorage* storage=NULL, const char* name=NULL, const char* &realName=NO_INIT)

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2003

CvFileStorage*
cvOpenFileStorage(const char* filename, int flags, CvMemStorage* memstorage = NULL, const char* encoding=NULL)
C_ARGS: filename, memstorage, flags, encoding

#else

CvFileStorage*
cvOpenFileStorage(const char* filename, int flags, CvMemStorage* memstorage = NULL)
C_ARGS: filename, memstorage, flags

#endif

MODULE = Cv		PACKAGE = Cv::FileStorage
# ====================
void*
cvRead(CvFileStorage* fs, CvFileNode* node, CvAttrList* attributes=NULL)

void*
cvReadByName(CvFileStorage* fs, const CvFileNode* map, const char* name, CvAttrList* attributes=NULL)


MODULE = Cv		PACKAGE = Cv::FileNode
# ====================
int
cvReadInt(const CvFileNode* node, int defaultValue=0)


MODULE = Cv		PACKAGE = Cv::FileStorage
# ====================
int
cvReadIntByName(const CvFileStorage* fs, const CvFileNode* map, const char* name, int defaultValue=0)

void
cvReadRawData(const CvFileStorage* fs, const CvFileNode* src, void* dst, const char* dt)

void
cvReadRawDataSlice(const CvFileStorage* fs, CvSeqReader* reader, int count, void* dst, const char* dt)


MODULE = Cv		PACKAGE = Cv::FileNode
# ====================
double
cvReadReal(const CvFileNode* node, double defaultValue=0.0)


MODULE = Cv		PACKAGE = Cv::FileStorage
# ====================
double
cvReadRealByName(const CvFileStorage* fs, const CvFileNode* map, const char* name, double defaultValue=0.0)


MODULE = Cv		PACKAGE = Cv::FileNode
# ====================
const char*
cvReadString(const CvFileNode* node, const char* defaultValue=NULL)

const char*
cvReadStringByName(const CvFileStorage* fs, const CvFileNode* map, const char* name, const char* defaultValue=NULL)


MODULE = Cv		PACKAGE = Cv::TypeInfo
# ====================
void
cvRegisterType(const CvTypeInfo* info)


MODULE = Cv		PACKAGE = Cv
# ====================
void
cvRelease(void* &structPtr)


MODULE = Cv		PACKAGE = Cv::FileStorage
# ====================
void
cvReleaseFileStorage(CvFileStorage* &fs)
ALIAS: Cv::FileStorage::DESTROY = 1


MODULE = Cv		PACKAGE = Cv
# ====================
void
cvSave(const char* filename, const void* structPtr, const char* name=NULL, const char* comment=NULL, CvAttrList attributes=cvAttrList(NULL, NULL))


MODULE = Cv		PACKAGE = Cv::FileStorage
# ====================
void
cvStartNextStream(CvFileStorage* fs)

void
cvStartReadRawData(const CvFileStorage* fs, const CvFileNode* src, CvSeqReader* reader)

void
cvStartWriteStruct(CvFileStorage* fs, const char* name, int struct_flags, const char* typeName=NULL, CvAttrList attributes=cvAttrList(NULL, NULL))


MODULE = Cv		PACKAGE = Cv
# ====================
CvTypeInfo*
cvTypeOf(const void* structPtr)

void
cvUnregisterType(const char* typeName)


MODULE = Cv		PACKAGE = Cv::FileStorage
# ====================
void
cvWrite(CvFileStorage* fs, const char* name, const void* ptr, CvAttrList attributes=cvAttrList(NULL, NULL))

void
cvWriteComment(CvFileStorage* fs, const char* comment, int eolComment)

void
cvWriteFileNode(CvFileStorage* fs, const char* new_node_name, const CvFileNode* node, int embed)

void
cvWriteInt(CvFileStorage* fs, const char* name, int value)

void
cvWriteRawData(CvFileStorage* fs, const void* src, int len, const char* dt)

void
cvWriteReal(CvFileStorage* fs, const char* name, double value)

void
cvWriteString(CvFileStorage* fs, const char* name, const char* str, int quote=0)


# ============================================================
#  core. The Core Functionality: Clustering
# ============================================================

MODULE = Cv		PACKAGE = Cv::Arr
# ====================

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

int
cvKMeans2(const CvArr* samples, int nclusters, CvArr* labels, CvTermCriteria termcrit, int attempts=1, CvRNG* rng=0, int flags=0, CvArr* centers=0, double* compactness=0)

#else

void
cvKMeans2(const CvArr* samples, int nclusters, CvArr* labels, CvTermCriteria termcrit);

#endif

#TBD# int cvSeqPartition(const CvSeq* seq, CvMemStorage* storage, CvSeq** labels, CvCmpFunc is_equal, void* userdata)


# ============================================================
#  core. The Core Functionality: Utility and System Functions and Macros
# ============================================================

MODULE = Cv		PACKAGE = Cv
# ====================
int
cvGetErrStatus(...)

void
cvSetErrStatus(int status)

int
cvGetErrMode(...)

int
cvSetErrMode(int mode)

void
cvError(int status, const char* func_name, const char* err_msg, const char* filename, int line)

const char*
cvErrorStr(int status)

#TBD# CvErrorCallback cvRedirectError(CvErrorCallback error_handler, void* userdata=NULL, void* &prevUserdata=NULL)

void
cvRedirectError(CvErrorCallback error_handler, void* userdata=NULL, void* &prevUserdata=NULL)

int
cvNulDevReport(int status, const char* func_name, const char* err_msg, const char* file_name, int line, void* userdata)

int
cvStdErrReport(int status, const char* func_name, const char* err_msg, const char* file_name, int line, void* userdata)

int
cvGuiBoxReport(int status, const char* func_name, const char* err_msg, const char* file_name, int line, void* userdata)

void*
cvAlloc(size_t size)

void
cvFree(void* &ptr)

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2003

int
cvCheckHardwareSupport(int feature)

#endif

int64
cvGetTickCount(...)

double
cvGetTickFrequency(...)

#TBD# int cvRegisterModule(const CvModuleInfo* moduleInfo)

#TBD# void cvGetModuleInfo(const char* moduleName, const char** version, const char** loadedAddonPlugins)

int
cvUseOptimized(int onoff)

#TBD# void cvSetMemoryManager(CvAllocFunc allocFunc=NULL, CvFreeFunc freeFunc=NULL, void* userdata=NULL)

#TBT# void cvSetIPLAllocators(Cv_iplCreateImageHeader create_header, Cv_iplAllocateImageData allocate_data, Cv_iplDeallocate deallocate, Cv_iplCreateROI create_roi, Cv_iplCloneImage clone_image)

