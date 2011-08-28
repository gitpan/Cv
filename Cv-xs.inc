# -*- mode: text; coding: utf-8; tab-width: 4 -*-

MODULE = Cv		PACKAGE = Cv
# ====================
BOOT:
	/* Setup Global Data */
	MY_CXT_INIT;
	MY_CXT.cb_trackbar_list = newAV();
	MY_CXT.cb_mouse = (SV*)0;
	MY_CXT.cb_error = (SV*)0;

void
CLONE(...)
CODE:
	MY_CXT_CLONE;

double
cvVersion(...)
CODE:
	RETVAL =  CV_MAJOR_VERSION
			+ CV_MINOR_VERSION    * 1e-3
			+ CV_SUBMINOR_VERSION * 1e-6;
OUTPUT:
	RETVAL

SV*
CV_VERSION(...)
CODE:
	const char* v = CV_VERSION;
	RETVAL = newSVpvn(v, strlen(v));
OUTPUT:
	RETVAL

int
CV_MAKETYPE(int depth, int cn)
ALIAS: Cv::MAKETYPE = 1

int
CV_MAT_DEPTH(int flags)
ALIAS: Cv::MAT_DEPTH = 1

int
CV_IPL_DEPTH(int elemtype)
ALIAS: Cv::IPL_DEPTH = 1
CODE:
	RETVAL = elemtype2ipldepth(elemtype);
OUTPUT:
	RETVAL

int
CV_MAT_CN(int flags)
ALIAS: Cv::MAT_CN = 1

int
CV_NODE_TYPE(int type)
ALIAS: Cv::NODE_TYPE = 1

int
CV_IS_SET_ELEM(void* p)
ALIAS: Cv::IS_SET_ELEM = 1

double
CV_PI(...)
CODE:
	RETVAL = CV_PI;
OUTPUT:
	RETVAL

CvSlice
CV_WHOLE_SEQ(...)
CODE:
	RETVAL = CV_WHOLE_SEQ;
OUTPUT:
	RETVAL


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

#if CV_MAJOR_VERSION >= 2

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

int64
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

#if CV_MAJOR_VERSION >= 2

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

#C# CvMat* cvGetCol(const CvArr* arr, CvMat* submat, int col)

CvMat*
cvGetCols(const CvArr* arr, CvMat* submat, int startCol, int endCol)
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

#C# CvMat* cvGetRow(const CvArr* arr, CvMat* submat, int row)

CvMat*
cvGetRows(const CvArr* arr, CvMat* submat, int startRow, int endRow, int deltaRow=1)
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

#TBD# uchar* cvPtr1D(const CvArr* arr, int idx0, int* type=NULL)
#TBD# uchar* cvPtr2D(const CvArr* arr, int idx0, int idx1, int* type=NULL)
#TBD# uchar* cvPtr3D(const CvArr* arr, int idx0, int idx1, int idx2, int* type=NULL)
#TBD# uchar* cvPtrND(const CvArr* arr, int* idx, int* type=NULL, int createNode=1, unsigned* precalcHashval=NULL)


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
cvCloneSeq(CvSeq* seq)


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
#C# void cvSeqPop(CvSeq* seq, void* element=NULL)
#C# void cvSeqPopFront(CvSeq* seq, void* element=NULL)
#C# void cvSeqPopMulti(CvSeq* seq, void* elements, int count, int in_front=0)
#C# char* cvSeqPush(CvSeq* seq, void* element=NULL)
#C# char* cvSeqPushFront(CvSeq* seq, void* element=NULL)
#C# void cvSeqPushMulti(CvSeq* seq, void* elements, int count, int in_front=0)

CvPoint
cvSeqPop_Point(CvSeq* seq)
ALIAS: Cv::Seq::Point::cvSeqPop = 1
CODE:
	cvSeqPop(seq, &RETVAL);
OUTPUT:
	RETVAL

CvPoint
cvSeqShift_Point(CvSeq* seq)
ALIAS: Cv::Seq::Point::cvSeqShift = 1
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
cvSeqUnshift_Point(CvSeq* seq, CvPoint element)
ALIAS: Cv::Seq::Point::cvSeqUnshift = 1
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

#TBD# void cvStartAppendToSeq(CvSeq* seq, CvSeqWriter* writer)

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

#TBD# void cvStartWriteSeq(int seq_flags, int header_size, int elem_size, CvMemStorage* storage, CvSeqWriter* writer)

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
cvDrawContours(CvArr *img, CvSeq* contour, CvScalar external_color, CvScalar hole_color, int max_level, int thickness=1, int lineType=8)
POSTCALL:
	XSRETURN(1);

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
#if CV_MAJOR_VERSION == 2 && CV_MINOR_VERSION == 1
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

CvFileStorage*
cvOpenFileStorage(const char* filename, int flags, CvMemStorage* memstorage = NULL)
C_ARGS: filename, memstorage, flags


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
cvSave(const char* filename, const void* structPtr, const char* name=NULL, const char* comment=NULL, CvAttrList attributes=cvAttrList())


MODULE = Cv		PACKAGE = Cv::FileStorage
# ====================
void
cvStartNextStream(CvFileStorage* fs)

void
cvStartReadRawData(const CvFileStorage* fs, const CvFileNode* src, CvSeqReader* reader)

void
cvStartWriteStruct(CvFileStorage* fs, const char* name, int struct_flags, const char* typeName=NULL, CvAttrList attributes=cvAttrList( ))


MODULE = Cv		PACKAGE = Cv
# ====================
CvTypeInfo*
cvTypeOf(const void* structPtr)

void
cvUnregisterType(const char* typeName)


MODULE = Cv		PACKAGE = Cv::FileStorage
# ====================
void
cvWrite(CvFileStorage* fs, const char* name, const void* ptr, CvAttrList attributes=cvAttrList())

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

#if CV_MAJOR_VERSION >= 2

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


# ============================================================
#  imgproc. Image Processing: Histograms
# ============================================================

MODULE = Cv		PACKAGE = Cv::Histogram
# ====================
int
type(CvHistogram* hist)
CODE:
	RETVAL = hist->type;
OUTPUT:
	RETVAL

CvArr*
bins(CvHistogram* hist)
CODE:
	RETVAL = hist->bins;
OUTPUT:
	RETVAL

AV*
thresh(CvHistogram* hist)
CODE:
	RETVAL = newAV();
	int dims = cvGetDims(&hist->mat, NULL); int i;
	for (i = 0; i < dims; i++) {
		AV* av = newAV();
		av_push(av, newSViv(hist->thresh[i][0]));
		av_push(av, newSViv(hist->thresh[i][1]));
		av_push(RETVAL, newRV_inc(sv_2mortal((SV*)av)));
	}
OUTPUT:
	RETVAL

AV*
sizes(CvHistogram* hist)
CODE:
	int sizes[CV_MAX_DIM];
	int dims = cvGetDims(&hist->mat, sizes); int i;
	RETVAL = newAV();
	for (i = 0; i < dims; i++) {
		av_push(RETVAL, newSViv(sizes[i]));
	}
OUTPUT:
	RETVAL

MODULE = Cv		PACKAGE = Cv::Histogram
# ====================
void
cvCalcBackProject(const CvHistogram* hist, IplImage** images, CvArr* back_project)
C_ARGS: images, back_project, hist
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvCalcBackProjectPatch(CvHistogram* hist, IplImage** images, CvArr* dst, CvSize patch_size, int method, double factor)
C_ARGS: images, dst, patch_size, hist, method, factor
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvCalcHist(CvHistogram* hist, IplImage** image, int accumulate=0, const CvArr* mask=NULL)
C_ARGS: image, hist, accumulate, mask
POSTCALL:
	XSRETURN(1);

void
cvCalcProbDensity(const CvHistogram* hist1, const CvHistogram* hist2, CvHistogram* dst_hist, double scale=255)
POSTCALL:
	XSRETURN(1);

void
cvClearHist(CvHistogram* hist)
POSTCALL:
	XSRETURN(1);

double
cvCompareHist(const CvHistogram* hist1, const CvHistogram* hist2, int method)

void
cvCopyHist(const CvHistogram* src, CvHistogram* dst)
C_ARGS: src, &dst
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);


MODULE = Cv		PACKAGE = Cv
# ====================
CvHistogram*
cvCreateHist(int* sizes, int type, float** ranges=NULL, int uniform=1)
C_ARGS: length(sizes), sizes, type, ranges=NULL, uniform


MODULE = Cv		PACKAGE = Cv::Histogram
# ====================
#TBD# float* cvGetHistValue_1D(CvHistogram* hist, int idx0)
#TBD# float* cvGetHistValue_2D(CvHistogram* hist, int idx0, int idx1)
#TBD# float* cvGetHistValue_3D(CvHistogram* hist, int idx0, int idx1, int idx2)
#TBD# float* cvGetHistValue_nD(CvHistogram* hist, int* idx)

#C# void cvGetMinMaxHistValue(const CvHistogram* hist, float* min_value, float* max_value, int* min_idx=NULL, int* max_idx=NULL)

void
cvGetMinMaxHistValue(const CvHistogram* hist, min_value, max_value, min_idx = NO_INIT, max_idx = NO_INIT)
INPUT:
	float &min_value = NO_INIT
	float &max_value = NO_INIT
	int &min_idx = NO_INIT
	int &max_idx = NO_INIT
POSTCALL:
	if (items >= 4) sv_setiv(ST(3), min_idx);
	if (items >= 5) sv_setiv(ST(4), max_idx);
OUTPUT:
	min_value
	max_value


MODULE = Cv		PACKAGE = Cv
# ====================
#TBD# CvHistogram* cvMakeHistHeaderForArray(int dims, int* sizes, CvHistogram* hist, float* data, float** ranges=NULL, int uniform=1)


MODULE = Cv		PACKAGE = Cv::Histogram
# ====================
void
cvNormalizeHist(CvHistogram* hist, double factor)
POSTCALL:
	XSRETURN(1);

float
cvQueryHistValue_1D(CvHistogram* hist, int idx0)

float
cvQueryHistValue_2D(CvHistogram* hist, int idx0, int idx1)

float
cvQueryHistValue_3D(CvHistogram* hist, int idx0, int idx1, int idx2)

float
cvQueryHistValue_nD(CvHistogram* hist, int* idx)

void
cvReleaseHist(CvHistogram* &hist)
ALIAS: Cv::Histogram::DESTROY = 1

void
cvSetHistBinRanges(CvHistogram* hist, float** ranges, int uniform=1)

void
cvThreshHist(CvHistogram* hist, double threshold)
POSTCALL:
	XSRETURN(1);


# ============================================================
#  imgproc. Image Processing: Image Filtering
# ============================================================

MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvCopyMakeBorder(const CvArr* src, CvArr* dst, CvPoint offset, int bordertype, CvScalar value=cvScalarAll(0))
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);


MODULE = Cv		PACKAGE = Cv
# ====================
IplConvKernel*
cvCreateStructuringElementEx(int cols, int rows, int anchorX, int anchorY, int shape, int* values=NULL)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvDilate(const CvArr* src, CvArr* dst, IplConvKernel* element=NULL, int iterations=1)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvErode(const CvArr* src, CvArr* dst, IplConvKernel* element=NULL, int iterations=1)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvFilter2D(const CvArr* src, CvArr* dst, const CvMat* kernel, CvPoint anchor=cvPoint(-1, -1))
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvLaplace(const CvArr* src, CvArr* dst, int apertureSize=3)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvMorphologyEx(const CvArr* src, CvArr* dst, CvArr* temp, IplConvKernel* element, int operation, int iterations=1)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvPyrDown(const CvArr* src, CvArr* dst, int filter=CV_GAUSSIAN_5x5)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvPyrUp(const CvArr* src, CvArr* dst, int filter=CV_GAUSSIAN_5x5)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);


MODULE = Cv		PACKAGE = Cv::ConvKernel
# ====================
void
cvReleaseStructuringElement(IplConvKernel* &element)
ALIAS: Cv::ConvKernel::DESTROY = 1


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvSmooth(const CvArr* src, CvArr* dst, int smoothType=CV_GAUSSIAN, int param1=3, int param2=0, double param3=0, double param4=0)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvSobel(const CvArr* src, CvArr* dst, int xorder, int yorder, int apertureSize=3)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

# ============================================================
#  imgproc. Image Processing: Geometric Image Transformations
# ============================================================

MODULE = Cv		PACKAGE = Cv
# ====================
CvMat*
cv2DRotationMatrix(CvPoint2D32f center, double angle, double scale, CvMat* mapMatrix)

CvMat*
cvGetAffineTransform(const CvPoint2D32f* src, const CvPoint2D32f* dst, CvMat* mapMatrix)

CvMat*
cvGetPerspectiveTransform(const CvPoint2D32f* src, const CvPoint2D32f* dst, CvMat* mapMatrix)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvGetQuadrangleSubPix(const CvArr* src, CvArr* dst, const CvMat* mapMatrix)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvGetRectSubPix(const CvArr* src, CvArr* dst, CvPoint2D32f center)

void
cvLogPolar(const CvArr* src, CvArr* dst, CvPoint2D32f center, double M, int flags=CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

#if CV_MAJOR_VERSION >= 2

void
cvLinearPolar(const CvArr* src, CvArr* dst, CvPoint2D32f center, double maxRadius, int flags = CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS);
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

#endif

void
cvRemap(const CvArr* src, CvArr* dst, const CvArr* mapx, const CvArr* mapy, int flags=CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS, CvScalar fillval=cvScalarAll(0))
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvResize(const CvArr* src, CvArr* dst, int interpolation=CV_INTER_LINEAR)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvWarpAffine(const CvArr* src, CvArr* dst, const CvMat* mapMatrix, int flags=CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS, CvScalar fillval=cvScalarAll(0))
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvWarpPerspective(const CvArr* src, CvArr* dst, const CvMat* mapMatrix, int flags=CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS, CvScalar fillval=cvScalarAll(0))
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

# ============================================================
#  imgproc. Image Processing: Miscellaneous Image Transformations
# ============================================================

MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvAdaptiveThreshold(const CvArr* src, CvArr* dst, double maxValue, int adaptive_method=CV_ADAPTIVE_THRESH_MEAN_C, int thresholdType=CV_THRESH_BINARY, int blockSize=3, double param1=5)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvCvtColor(const CvArr* src, CvArr* dst, int code)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvDistTransform(const CvArr* src, CvArr* dst, int distance_type=CV_DIST_L2, int mask_size=3, float* mask=NULL, CvArr* labels=NULL)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvEqualizeHist(const CvArr* src, CvArr* dst);
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvFloodFill(CvArr* image, CvPoint seed_point, CvScalar new_val, CvScalar lo_diff=cvScalarAll(0), CvScalar up_diff=cvScalarAll(0), comp = NO_INIT, int flags=4, CvArr* mask=NULL)
INPUT:
	CvConnectedComp &comp = NO_INIT
POSTCALL:
	if (items >= 6) XS_pack_CvConnectedComp(ST(5), comp);

void
cvWatershed(const CvArr* image, CvArr* markers)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvInpaint(const CvArr* src, const CvArr* mask, CvArr* dst, double inpaintRadius, int flags)
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);

void
cvIntegral(const CvArr* image, CvArr* sum, CvArr* sqsum=NULL, CvArr* tiltedSum=NULL)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvPyrMeanShiftFiltering(const CvArr* src, CvArr* dst, double sp, double sr, int max_level=1, CvTermCriteria termcrit= cvTermCriteria(CV_TERMCRIT_ITER+CV_TERMCRIT_EPS, 5, 1))

void
cvPyrSegmentation(IplImage* src, IplImage* dst, CvMemStorage* storage, comp, int level, double threshold1, double threshold2)
INPUT:
	CvSeq* &comp = NO_INIT
OUTPUT:
	comp

NO_OUTPUT double
cvThreshold(const CvArr* src, CvArr* dst, double threshold, double maxValue, int thresholdType)
POSTCALL:
	if (thresholdType == CV_THRESH_OTSU) {
		/* SvREFCNT_dec(ST(2)); */
		sv_setnv(ST(2), RETVAL);
	}
	/* SvREFCNT_dec(ST(1)); */
	ST(0) = ST(1);
	XSRETURN(1);


# ============================================================
#  imgproc. Image Processing: Structural Analysis and Shape Descriptors
# ============================================================

MODULE = Cv		PACKAGE = Cv::Seq
# ====================
CvSeq*
cvApproxChains(CvSeq* src_seq, CvMemStorage* storage, int method=CV_CHAIN_APPROX_SIMPLE, double parameter=0, int minimal_perimeter=0, int recursive=0)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
CvSeq*
cvApproxPoly(const void* src_seq, int header_size, CvMemStorage* storage, int method, double parameter, int parameter2=0)

double
cvArcLength(const void* curve, CvSlice slice=CV_WHOLE_SEQ, int isClosed=-1)

CvRect
cvBoundingRect(CvArr* points, int update=0)


MODULE = Cv		PACKAGE = Cv
# ====================
void
cvBoxPoints(CvBox2D box)
PPCODE:
	CvPoint2D32f pts[4];
	cvBoxPoints(box, pts);
	EXTEND(SP, 4);
	for (int i = 0; i < 4; i++) {
		SV* sv = sv_newmortal();
		XS_pack_CvPoint2D32f(sv, pts[i]);
		PUSHs(sv);
	}


MODULE = Cv		PACKAGE = Cv::Seq
# ====================
void
cvCalcPGH(const CvSeq* contour, CvHistogram* hist)

#TBD# float cvCalcEMD2(const CvArr* signature1, const CvArr* signature2, int distance_type, CvDistanceFunction distance_func=NULL, const CvArr* cost_matrix=NULL, CvArr* flow=NULL, float* lower_bound=NULL, void* userdata=NULL)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
int
cvCheckContourConvexity(const CvArr* contour)

double
cvContourArea(const CvArr* contour, CvSlice slice=CV_WHOLE_SEQ)


MODULE = Cv		PACKAGE = Cv::ContourTree
# ====================
CvSeq*
cvContourFromContourTree(const CvContourTree* tree, CvMemStorage* storage, CvTermCriteria criteria)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
CvSeq*
cvConvexHull2(const CvArr* input, void* storage=NULL, int orientation=CV_CLOCKWISE, int return_points=1)

CvSeq*
cvConvexityDefects(const CvArr* contour, const CvArr* convexhull, CvMemStorage* storage=NULL)


MODULE = Cv		PACKAGE = Cv::Seq
# ====================
CvContourTree*
cvCreateContourTree(const CvSeq* contour, CvMemStorage* storage, double threshold)

#TBD# CvSeq* cvEndFindContours(CvContourScanner* scanner)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
int
cvFindContours(CvArr* image, CvMemStorage* storage, first_contour, int header_size=sizeof(CvContour), int mode=CV_RETR_LIST, int method=CV_CHAIN_APPROX_SIMPLE, CvPoint offset=cvPoint(0, 0))
INPUT:
	CvSeq* &first_contour = NO_INIT
OUTPUT:
	RETVAL
	first_contour

#TBD# CvSeq* cvFindNextContour(CvContourScanner scanner)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
CvBox2D
cvFitEllipse2(const CvArr* points)
ALIAS: Cv::Arr::cvFitEllipse = 1

void
cvFitLine(const CvArr* points, int dist_type, double param, double reps, double aeps, float* line)


MODULE = Cv		PACKAGE = Cv::Moments
# ====================
double
cvGetCentralMoment(CvMoments* moments, int x_order, int y_order)

CvHuMoments*
cvGetHuMoments(CvMoments* moments)
INIT:
	Newx(RETVAL, 1, CvHuMoments);
CODE:
	cvGetHuMoments(moments, RETVAL);
OUTPUT:
	RETVAL

double
cvGetNormalizedCentralMoment(CvMoments* moments, int x_order, int y_order)

double
cvGetSpatialMoment(CvMoments* moments, int x_order, int y_order)


double
m00(const CvMoments* moments)
CODE:
	RETVAL = moments->m00;
OUTPUT:
	RETVAL

double
m10(const CvMoments* moments)
CODE:
	RETVAL = moments->m10;
OUTPUT:
	RETVAL

double
m01(const CvMoments* moments)
CODE:
	RETVAL = moments->m01;
OUTPUT:
	RETVAL

double
m20(const CvMoments* moments)
CODE:
	RETVAL = moments->m20;
OUTPUT:
	RETVAL

double
m11(const CvMoments* moments)
CODE:
	RETVAL = moments->m11;
OUTPUT:
	RETVAL

double
m02(const CvMoments* moments)
CODE:
	RETVAL = moments->m02;
OUTPUT:
	RETVAL

double
m30(const CvMoments* moments)
CODE:
	RETVAL = moments->m30;
OUTPUT:
	RETVAL

double
m21(const CvMoments* moments)
CODE:
	RETVAL = moments->m21;
OUTPUT:
	RETVAL

double
m12(const CvMoments* moments)
CODE:
	RETVAL = moments->m12;
OUTPUT:
	RETVAL

double
m03(const CvMoments* moments)
CODE:
	RETVAL = moments->m03;
OUTPUT:
	RETVAL

double
inv_sqrt_m00(const CvMoments* moments)
CODE:
	RETVAL = moments->inv_sqrt_m00;
OUTPUT:
	RETVAL

MODULE = Cv		PACKAGE = Cv::HuMoments
# ====================
void
DESTROY(CvHuMoments* hu_moments)
CODE:
	safefree(hu_moments);

double
hu1(const CvHuMoments* hu_moments)
CODE:
	RETVAL = hu_moments->hu1;
OUTPUT:
	RETVAL

double
hu2(const CvHuMoments* hu_moments)
CODE:
	RETVAL = hu_moments->hu2;
OUTPUT:
	RETVAL

double
hu3(const CvHuMoments* hu_moments)
CODE:
	RETVAL = hu_moments->hu3;
OUTPUT:
	RETVAL

double
hu4(const CvHuMoments* hu_moments)
CODE:
	RETVAL = hu_moments->hu4;
OUTPUT:
	RETVAL

double
hu5(const CvHuMoments* hu_moments)
CODE:
	RETVAL = hu_moments->hu5;
OUTPUT:
	RETVAL

double
hu6(const CvHuMoments* hu_moments)
CODE:
	RETVAL = hu_moments->hu6;
OUTPUT:
	RETVAL

double
hu7(const CvHuMoments* hu_moments)
CODE:
	RETVAL = hu_moments->hu7;
OUTPUT:
	RETVAL


MODULE = Cv		PACKAGE = Cv::ContourTree
# ====================
double
cvMatchContourTrees(const CvContourTree* tree1, const CvContourTree* tree2, int method, double threshold)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
double
cvMatchShapes(const void* object1, const void* object2, int method, double parameter=0)

CvBox2D
cvMinAreaRect2(const CvArr* points, CvMemStorage* storage=NULL)
ALIAS: Cv::Arr::cvMinAreaRect = 1

int
cvMinEnclosingCircle(const CvArr* points, center, radius)
INPUT:
	CvPoint2D32f &center = NO_INIT
	float &radius = NO_INIT
OUTPUT:
	center
	radius

CvMoments*
cvMoments(const CvArr* arr, int binary=0)
INIT:
	Newx(RETVAL, 1, CvMoments);
CODE:
	int type = cvGetElemType(arr);
	int channels = CV_MAT_CN(type);
	int coi = cvGetImageCOI((IplImage*)arr);
	if (channels == 1 || coi != 0) {
		cvMoments(arr, RETVAL, binary);
	} else {
		cvSetImageCOI((IplImage*)arr, 1);
		cvMoments(arr, RETVAL, binary);
		cvSetImageCOI((IplImage*)arr, coi);
	}
OUTPUT:
	RETVAL


MODULE = Cv		PACKAGE = Cv::Moments
# ====================
void
DESTROY(CvMoments* moments)
CODE:
	safefree(moments);


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
double
cvPointPolygonTest(const CvArr* contour, CvPoint2D32f pt, int measure_dist)


MODULE = Cv		PACKAGE = Cv
# ====================
CvSeq*
cvPointSeqFromMat(int seq_kind, const CvArr* mat, CvContour* contour_header, CvSeqBlock* block)


MODULE = Cv		PACKAGE = Cv::ChainPtReader
# ====================
CvPoint
cvReadChainPoint(CvChainPtReader* reader)


#TBD# CvContourScanner cvStartFindContours(CvArr* image, CvMemStorage* storage, int header_size=sizeof(CvContour), int mode=CV_RETR_LIST, int method=CV_CHAIN_APPROX_SIMPLE, CvPoint offset=cvPoint(0, 0))

MODULE = Cv		PACKAGE = Cv::Chain
# ====================
void
cvStartReadChainPoints(CvChain* chain, CvChainPtReader* reader)

#TBD# void cvSubstituteContour(CvContourScanner scanner, CvSeq* new_contour)

# ============================================================
#  imgproc. Image Processing: Planar Subdivisions
# ============================================================

MODULE = Cv		PACKAGE = Cv::Subdiv2D
# ====================
CvSeq*
edges(CvSubdiv2D* subdiv)
CODE:
	RETVAL = (CvSeq*)subdiv->edges;
OUTPUT:
	RETVAL		

void
cvCalcSubdivVoronoi2D(CvSubdiv2D* subdiv)

void
cvClearSubdivVoronoi2D(CvSubdiv2D* subdiv)


MODULE = Cv		PACKAGE = Cv
# ====================
CvSubdiv2D*
cvCreateSubdivDelaunay2D(CvRect rect, CvMemStorage* storage)


MODULE = Cv		PACKAGE = Cv::Subdiv2D
# ====================
CvSubdiv2DPoint
cvFindNearestPoint2D(CvSubdiv2D* subdiv, CvPoint2D32f pt)
CODE:
	CvSubdiv2DPoint* p = cvFindNearestPoint2D(subdiv, pt);
	if (p) RETVAL = *p; else XSRETURN_UNDEF;
OUTPUT:
	RETVAL


MODULE = Cv		PACKAGE = Cv
# ====================
CvSubdiv2DPoint
cvSubdiv2DEdgeOrg(CvSubdiv2DEdge edge)
CODE:
	CvSubdiv2DPoint* p = cvSubdiv2DEdgeOrg(edge);
	if (p) RETVAL = *p; else XSRETURN_UNDEF;
OUTPUT:
	RETVAL

CvSubdiv2DPoint
cvSubdiv2DEdgeDst(CvSubdiv2DEdge edge)
CODE:
	CvSubdiv2DPoint* p = cvSubdiv2DEdgeDst(edge);
	if (p) RETVAL = *p; else XSRETURN_UNDEF;
OUTPUT:
	RETVAL

CvSubdiv2DEdge
cvSubdiv2DGetEdge(CvSubdiv2DEdge edge, CvNextEdgeType type)

CvSubdiv2DEdge
cvSubdiv2DNextEdge(CvSubdiv2DEdge edge)

CvSubdiv2DPointLocation
cvSubdiv2DLocate(CvSubdiv2D* subdiv, CvPoint2D32f pt, edge, vertex = NO_INIT)
ALIAS: Cv::Subdiv2D::cvSubdiv2DLocate = 1
INPUT:
	CvSubdiv2DEdge &edge = NO_INIT
	CvSubdiv2DPoint* &vertex = NO_INIT
CODE:
	if (items <= 3) {
		RETVAL = cvSubdiv2DLocate(subdiv, pt, &edge);
	} else {
		vertex = NULL;
		RETVAL = cvSubdiv2DLocate(subdiv, pt, &edge, &vertex);
		if (vertex) XS_pack_CvSubdiv2DPoint(ST(3), *vertex);
		else ST(3) = &PL_sv_undef;
	}
OUTPUT:
	edge

CvSubdiv2DEdge
cvSubdiv2DRotateEdge(CvSubdiv2DEdge edge, int rotate)


MODULE = Cv		PACKAGE = Cv::Subdiv2D
# ====================
CvSubdiv2DPoint
cvSubdivDelaunay2DInsert(CvSubdiv2D* subdiv, CvPoint2D32f pt)
CODE:
	CvSubdiv2DPoint* p = cvSubdivDelaunay2DInsert(subdiv, pt);
	if (p) RETVAL = *p; else XSRETURN_UNDEF;
OUTPUT:
	RETVAL


# ============================================================
#  imgproc. Image Processing: Motion Analysis and Object Tracking
# ============================================================

MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvAcc(const CvArr* image, CvArr* sum, const CvArr* mask=NULL)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvMultiplyAcc(const CvArr* image1, const CvArr* image2, CvArr* acc, const CvArr* mask=NULL)

void
cvRunningAvg(const CvArr* image, CvArr* acc, double alpha, const CvArr* mask=NULL)

void
cvSquareAcc(const CvArr* image, CvArr* sqsum, const CvArr* mask=NULL)


# ============================================================
#  imgproc. Image Processing: Feature Detection
# ============================================================

MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvCanny(const CvArr* image, CvArr* edges, double threshold1, double threshold2, int aperture_size=3)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvCornerEigenValsAndVecs(const CvArr* image, CvArr* eigenvv, int blockSize, int aperture_size=3)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvCornerHarris(const CvArr* image, CvArr* harris_dst, int blockSize, int aperture_size=3, double k=0.04)
POSTCALL:
	ST(0) = ST(1);
	XSRETURN(1);

void
cvCornerMinEigenVal(const CvArr* image, CvArr* eigenval, int blockSize, int aperture_size=3)

void
cvFindCornerSubPix(const CvArr* image, CvPoint2D32f* corners, CvSize win, CvSize zero_zone, CvTermCriteria criteria)
C_ARGS:
	image, corners, length(corners), win, zero_zone, criteria
OUTPUT:
	corners

void
cvGoodFeaturesToTrack(const CvArr* image, CvArr* eigImage, CvArr* tempImage, corners, int cornerCount, double qualityLevel, double minDistance, const CvArr* mask=NULL, int blockSize=3, int useHarris=0, double k=0.04)
INPUT:
	CvPoint2D32f* corners = NO_INIT
INIT:
	int length(corners) = cornerCount;
	corners = (CvPoint2D32f*)alloca(sizeof(CvPoint2D32f) * cornerCount);
C_ARGS:
	image, eigImage, tempImage, corners, &length(corners), qualityLevel, minDistance, mask, blockSize, useHarris, k
OUTPUT:
	corners

CvSeq*
cvHoughLines2(CvArr* image, void* storage, int method, double rho, double theta, int threshold, double param1=0, double param2=0)

void
cvPreCornerDetect(const CvArr* image, CvArr* corners, int apertureSize=3)

int
cvSampleLine(const CvArr* image, CvPoint pt1, CvPoint pt2, void* buffer, int connectivity=8)


# ============================================================
#  imgproc. Image Processing: Object Detection
# ============================================================

MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvMatchTemplate(const CvArr* image, const CvArr* templ, CvArr* result, int method)


# ============================================================
#  features2d. Feature Detection and Descriptor Extraction:
#    Feature detection and description
# ============================================================

MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvExtractSURF(const CvArr* image, const CvArr* mask, keypoints, descriptors, CvMemStorage* storage, CvSURFParams params)
INPUT:
	CvSeq* &keypoints = NO_INIT
	CvSeq* &descriptors = NO_INIT
OUTPUT:
	keypoints
	descriptors

#if CV_MAJOR_VERSION >= 2

void
cvExtractMSER(CvArr* img, CvArr* mask, contours, CvMemStorage* storage, CvMSERParams params)
INPUT:
	CvSeq* &contours = NO_INIT
OUTPUT:
	contours

#endif

#TBD# CvSeq* cvGetStarKeypoints(const CvArr* image, CvMemStorage* storage, CvStarDetectorParams params=cvStarDetectorParams())

# ============================================================
#  flann. Clustering and Search in Multi-Dimensional Spaces:
#    Fast Approximate Nearest Neighbor Search
# ============================================================

# ============================================================
#  objdetect. Object Detection: Cascade Classification:
#    Haar Feature-based Cascade Classifier for Object Detection
# ============================================================
=xxx
          o CvHaarFeature
		  o CvHaarClassifier
		  o CvHaarStageClassifier
		  o CvHaarClassifierCascade
=cut


MODULE = Cv		PACKAGE = Cv
# ====================
CvHaarClassifierCascade*
cvLoadHaarClassifierCascade(const char* directory, CvSize orig_window_size)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================

#if CV_MAJOR_VERSION >= 2 && CV_MINOR_VERSION >= 2

CvSeq*
cvHaarDetectObjects(const CvArr* image, CvHaarClassifierCascade* cascade, CvMemStorage* storage, double scaleFactor=1.1, int minNeighbors=3, int flags=0, CvSize minSize=cvSize(0, 0), CvSize maxSize=cvSize(0, 0))

#else

CvSeq*
cvHaarDetectObjects(const CvArr* image, CvHaarClassifierCascade* cascade, CvMemStorage* storage, double scaleFactor=1.1, int minNeighbors=3, int flags=0, CvSize minSize=cvSize(0, 0))

#endif


MODULE = Cv		PACKAGE = Cv::HaarClassifierCascade
# ====================
void
cvSetImagesForHaarClassifierCascade(CvHaarClassifierCascade* cascade, const CvArr* sum, const CvArr* sqsum, const CvArr* tilted_sum, double scale)

void
cvReleaseHaarClassifierCascade(CvHaarClassifierCascade* &cascade)

int
cvRunHaarClassifierCascade(CvHaarClassifierCascade* cascade, CvPoint pt, int start_stage=0)


# ============================================================
#  video. Video Analysis: Motion Analysis and Object Tracking
# ============================================================

MODULE = Cv		PACKAGE = Cv::Arr
# ====================
double
cvCalcGlobalOrientation(const CvArr* orientation, const CvArr* mask, const CvArr* mhi, double timestamp, double duration)

void
cvCalcMotionGradient(const CvArr* mhi, CvArr* mask, CvArr* orientation, double delta1, double delta2, int apertureSize=3)
ALIAS: Cv::cvCalcMotionGradient = 1

void
cvCalcOpticalFlowBM(const CvArr* prev, const CvArr* curr, CvSize blockSize, CvSize shiftSize, CvSize max_range, int usePrevious, CvArr* velx, CvArr* vely)
ALIAS: Cv::cvCalcOpticalFlowBM = 1

void
cvCalcOpticalFlowHS(const CvArr* prev, const CvArr* curr, int usePrevious, CvArr* velx, CvArr* vely, double lambda, CvTermCriteria criteria)
ALIAS: Cv::cvCalcOpticalFlowHS = 1

void
cvCalcOpticalFlowLK(const CvArr* prev, const CvArr* curr, CvSize winSize, CvArr* velx, CvArr* vely)
ALIAS: Cv::cvCalcOpticalFlowLK = 1

void
cvCalcOpticalFlowPyrLK(const CvArr* prev, const CvArr* curr, CvArr* prevPyr, CvArr* currPyr, const CvPoint2D32f* prevFeatures, currFeatures, CvSize winSize, int level, status, track_error, CvTermCriteria criteria, int flags)
ALIAS: Cv::cvCalcOpticalFlowPyrLK = 1
INPUT:
	CvPoint2D32f* currFeatures = NO_INIT
	tiny* status = NO_INIT
	float* track_error = NO_INIT
INIT:
	int count = length(prevFeatures);
	int length(currFeatures) = count;
	currFeatures = (CvPoint2D32f*)alloca(sizeof(CvPoint2D32f) * count);
	int length(status) = count;
	status = (char*)alloca(sizeof(char) * count);
	int length(track_error) = count;
	track_error = (float*)alloca(sizeof(float) * count);
C_ARGS:
	prev, curr, prevPyr, currPyr, prevFeatures, currFeatures, length(prevFeatures), winSize, level, status, track_error, criteria, flags
OUTPUT:
	currFeatures
	status
	track_error


#if CV_MAJOR_VERSION >= 2

void
cvCalcOpticalFlowFarneback(const CvArr* prev, const CvArr* next, CvArr* flow, double pyr_scale, int levels, int winsize, int iterations, int poly_n, double poly_sigma, int flags);
ALIAS: Cv::cvCalcOpticalFlowFarneback = 1

#endif

int
cvCamShift(const CvArr* prob_image, CvRect window, CvTermCriteria criteria, comp, box)
ALIAS: Cv::cvCamShift = 1
INPUT:
	CvConnectedComp &comp = NO_INIT
	CvBox2D &box = NO_INIT
OUTPUT:
	comp
	box


MODULE = Cv		PACKAGE = Cv
# ====================
CvConDensation*
cvCreateConDensation(int dynam_params, int measure_params, int sample_count)


MODULE = Cv		PACKAGE = Cv::ConDensation
# ====================
void
cvConDensInitSampleSet(CvConDensation* condens, CvMat* lower_bound, CvMat* upper_bound)


MODULE = Cv		PACKAGE = Cv::Kalman
# ====================
int
MP(CvKalman* kalman)
CODE:
	RETVAL = kalman->MP;
OUTPUT:
	RETVAL

int
DP(CvKalman* kalman)
CODE:
	RETVAL = kalman->DP;
OUTPUT:
	RETVAL

int
CP(CvKalman* kalman)
CODE:
	RETVAL = kalman->CP;
OUTPUT:
	RETVAL

CvMat*
state_pre(CvKalman* kalman)
CODE:
	RETVAL = kalman->state_pre;
OUTPUT:
	RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Mat::Ghost", (void*)RETVAL);

CvMat*
state_post(CvKalman* kalman)
CODE:
	RETVAL = kalman->state_post;
OUTPUT:
	RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Mat::Ghost", (void*)RETVAL);

CvMat*
transition_matrix(CvKalman* kalman)
CODE:
	RETVAL = kalman->transition_matrix;
OUTPUT:
	RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Mat::Ghost", (void*)RETVAL);

CvMat*
control_matrix(CvKalman* kalman)
CODE:
	RETVAL = kalman->control_matrix;
OUTPUT:
	RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Mat::Ghost", (void*)RETVAL);

CvMat*
measurement_matrix(CvKalman* kalman)
CODE:
	RETVAL = kalman->measurement_matrix;
OUTPUT:
	RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Mat::Ghost", (void*)RETVAL);

CvMat*
process_noise_cov(CvKalman* kalman)
CODE:
	RETVAL = kalman->process_noise_cov;
OUTPUT:
	RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Mat::Ghost", (void*)RETVAL);

CvMat*
measurement_noise_cov(CvKalman* kalman)
CODE:
	RETVAL = kalman->measurement_noise_cov;
OUTPUT:
	RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Mat::Ghost", (void*)RETVAL);

CvMat*
error_cov_pre(CvKalman* kalman)
CODE:
	RETVAL = kalman->error_cov_pre;
OUTPUT:
	RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Mat::Ghost", (void*)RETVAL);

CvMat*
gain(CvKalman* kalman)
CODE:
	RETVAL = kalman->gain;
OUTPUT:
	RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Mat::Ghost", (void*)RETVAL);

CvMat*
error_cov_post(CvKalman* kalman)
CODE:
	RETVAL = kalman->error_cov_post;
OUTPUT:
	RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Mat::Ghost", (void*)RETVAL);

MODULE = Cv		PACKAGE = Cv
# ====================
CvKalman*
cvCreateKalman(int dynam_params, int measure_params, int control_params=0)


MODULE = Cv		PACKAGE = Cv::Kalman
# ====================
const CvMat*
cvKalmanCorrect(CvKalman* kalman, const CvMat* measurement)
OUTPUT:
	RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Mat::Ghost", (void*)RETVAL);

const CvMat*
cvKalmanPredict(CvKalman* kalman, const CvMat* control=NULL)
OUTPUT:
	RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Mat::Ghost", (void*)RETVAL);


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
int
cvMeanShift(const CvArr* prob_image, CvRect window, CvTermCriteria criteria, comp)
INPUT:
	CvConnectedComp &comp = NO_INIT
OUTPUT:
	comp


MODULE = Cv		PACKAGE = Cv::ConDensation
# ====================
void
cvReleaseConDensation(CvConDensation* &condens)
ALIAS: Cv::ConDensation::DESTROY = 2


MODULE = Cv		PACKAGE = Cv::Kalman
# ====================
void
cvReleaseKalman(CvKalman* &kalman)
ALIAS: Cv::Kalman::DESTROY = 1


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
CvSeq*
cvSegmentMotion(const CvArr* mhi, CvArr* seg_mask, CvMemStorage* storage, double timestamp, double seg_thresh)

void
cvSnakeImage(const IplImage* image, CvPoint* points, int length, float* alpha, float* beta, float* gamma, int coeff_usage, CvSize win, CvTermCriteria criteria, int calc_gradient=1)

void
cvUpdateMotionHistory(const CvArr* silhouette, CvArr* mhi, double timestamp, double duration)


# ============================================================
#  highgui. High-level GUI and Media I/O: User Interface
# ============================================================

MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvConvertImage(const CvArr* src, CvArr* dst, int flags=0)

void
cvShowImage(const CvArr* image, const char* name = "Cv", int flags = CV_WINDOW_AUTOSIZE)
CODE:
	void* win = cvGetWindowHandle(name);
	if (!win) {
		cvNamedWindow(name, flags);
		win = cvGetWindowHandle(name);
	}
	if (win) {
		cvShowImage(name, image);
	}
	XSRETURN(1);

MODULE = Cv		PACKAGE = Cv
# ====================
int
cvCreateTrackbar(const char* trackbarName, const char* windowName, SV* value, int count, SV* onChange = NULL)
CODE:
	RETVAL = -1;
	trackbar_t* trackbar; Newx(trackbar, 1, trackbar_t);
	if (!trackbar) Perl_croak(aTHX_ "cvCreateTrackbar: no core");
	trackbar->callback = 0;
	if (onChange && SvROK(onChange) && SvTYPE(SvRV(onChange)) == SVt_PVCV) {
		SvREFCNT_inc(trackbar->callback = (SV*)SvRV(onChange));
	}
	trackbar->value = 0;
	trackbar->lastpos = trackbar->pos = 0;
	if (SvOK(value) && SvTYPE(value) == SVt_IV) {
		SvREFCNT_inc(trackbar->value = value);
		trackbar->lastpos = trackbar->pos = SvIV(value);
		RETVAL = cvCreateTrackbar(trackbarName,	windowName,
					&trackbar->pos, count, cb_trackbar);
		sv_magic(value, NULL, PERL_MAGIC_ext, windowName, strlen(windowName)+1);
		mg_find(value, PERL_MAGIC_ext)->mg_obj = (SV*) trackbar;
		dMY_CXT; av_push(MY_CXT.cb_trackbar_list, value);
	} else {
		safefree(trackbar);
	}
OUTPUT:
	RETVAL

void
cvDestroyAllWindows(...)
CODE:
	cvDestroyAllWindows();
	dMY_CXT; SV* t;
	while ((t = av_shift(MY_CXT.cb_trackbar_list)) && t != &PL_sv_undef) {
		MAGIC* mg = mg_find(t, PERL_MAGIC_ext);
		trackbar_t* trackbar = (trackbar_t*)mg->mg_obj;
		if (trackbar) {
			if (trackbar->callback) SvREFCNT_dec(trackbar->callback);
			if (trackbar->value) SvREFCNT_dec(trackbar->value);
		}
		SvREFCNT_dec((SV*)mg->mg_obj);
		sv_unmagic(t, PERL_MAGIC_ext);
		safefree(mg->mg_obj);
	}

void
cvDestroyWindow(const char* name)
CODE:
	cvDestroyWindow(name);
	dMY_CXT; SV* t; AV *tmp = newAV();
	while ((t = av_shift(MY_CXT.cb_trackbar_list)) && t != &PL_sv_undef) {
		MAGIC* mg = mg_find(t, PERL_MAGIC_ext);
		if (strcmp(name, mg->mg_ptr) == 0) {
			trackbar_t* trackbar = (trackbar_t*)mg->mg_obj;
			if (trackbar) {
				if (trackbar->callback) SvREFCNT_dec(trackbar->callback);
				if (trackbar->value) SvREFCNT_dec(trackbar->value);
			}
			SvREFCNT_dec((SV*)mg->mg_obj);
			sv_unmagic(t, PERL_MAGIC_ext);
			safefree(mg->mg_obj);
		} else {
			av_push(tmp, t);
		}
	}
	while ((t = av_shift(tmp)) && t != &PL_sv_undef) {
		av_push(MY_CXT.cb_trackbar_list, t);
	}
	SvREFCNT_dec((SV*)tmp);

int
cvGetTrackbarPos(const char* trackbarName, const char* windowName)

void*
cvGetWindowHandle(const char* name)

const char*
cvGetWindowName(void* windowHandle)

#TBD# int cvInitSystem(int argc, char** argv)

void
cvMoveWindow(const char* name, int x, int y)

int
cvNamedWindow(const char* name, int flags = CV_WINDOW_AUTOSIZE)

void
cvResizeWindow(const char* name, int width, int height)

void
cvSetMouseCallback(const char* windowName, CvMouseCallback onMouse = NULL, void* param=NULL)

void
cvSetTrackbarPos(const char* trackbarName, const char* windowName, int pos)

int
cvWaitKey(int delay=0)

# ============================================================
#  highgui. High-level GUI and Media I/O: Reading and Writing Images and Video
# ============================================================

MODULE = Cv		PACKAGE = Cv
# ====================
IplImage*
cvLoadImage(const char* filename, int iscolor=CV_LOAD_IMAGE_COLOR)

CvMat*
cvLoadImageM(const char* filename, int iscolor=CV_LOAD_IMAGE_COLOR)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
NO_OUTPUT int
cvSaveImage(const CvArr* image, const char* filename)
C_ARGS:	filename, image
POSTCALL:
	if (!RETVAL) XSRETURN_UNDEF;
	XSRETURN(1);


MODULE = Cv		PACKAGE = Cv
# ====================
CvCapture*
cvCaptureFromCAM(int index)
ALIAS: Cv::cvCreateCameraCapture = 1

CvCapture*
cvCaptureFromFile(const char* filename)
ALIAS: Cv::cvCaptureFromAVI = 1

MODULE = Cv		PACKAGE = Cv::Capture
# ====================
double
cvGetCaptureProperty(CvCapture* capture, int property_id)

int
cvGrabFrame(CvCapture* capture)

IplImage*
cvQueryFrame(CvCapture* capture)
OUTPUT: RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Image::Ghost", (void*)RETVAL);

void
cvReleaseCapture(CvCapture* &capture)
ALIAS: Cv::Capture::DESTROY = 1

IplImage*
cvRetrieveFrame(CvCapture* capture)
OUTPUT: RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Image::Ghost", (void*)RETVAL);

int
cvSetCaptureProperty(CvCapture* capture, int property_id, double value)


MODULE = Cv		PACKAGE = Cv
# ====================
CvVideoWriter*
cvCreateVideoWriter(const char* filename, int fourcc, double fps, CvSize frame_size, int is_color=1)


MODULE = Cv		PACKAGE = Cv::VideoWriter
# ====================
void
cvReleaseVideoWriter(CvVideoWriter* &writer)
ALIAS: Cv::VideoWriter::DESTROY = 1

int
cvWriteFrame(CvVideoWriter* writer, const IplImage* image)


# ============================================================
#  highgui. High-level GUI and Media I/O: Qt new functions
# ============================================================


MODULE = Cv		PACKAGE = Cv
# ====================

#if WITH_QT

#if CV_MAJOR_VERSION >= 2

void
cvSetWindowProperty(const char* name, int prop_id, double prop_value)

void
cvGetWindowProperty(const char* name, int prop_id)

#endif

#if CV_MAJOR_VERSION >= 2 && CV_MINOR_VERSION >= 2

CvFont*
cvFontQt(const char* nameFont, int pointSize = -1, CvScalar color = cvScalarAll(0), int weight = CV_FONT_NORMAL, int style = CV_STYLE_NORMAL, int spacing = 0)
CODE:
	Newx(RETVAL, 1, CvFont);
	if (!RETVAL) Perl_croak(aTHX_ "cvFontQt: no core");
	*RETVAL = cvFontQt(nameFont, pointSize, color, weight, style, spacing);
OUTPUT:
	RETVAL

MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvAddText(const CvArr* img, const char* text, CvPoint location, CvFont *font)

MODULE = Cv		PACKAGE = Cv
# ====================
void
cvDisplayOverlay(const char* name, const char* text, int delay)

void
cvDisplayStatusBar(const char* name, const char* text, int delayms)

#TBD# void cvCreateOpenGLCallback(const char* window_name, CvOpenGLCallback callbackOpenGL, void* userdata = NULL, double angle = -1, double zmin = -1, double zmax = -1)

void
cvSaveWindowParameters(const char* name)

void
cvLoadWindowParameters(const char* name)

#TBD# int cvCreateButton(const char* button_name=NULL, CvButtonCallback on_change = NULL, void* userdata = NULL, int button_type = CV_PUSH_BUTTON, int initial_button_state = 0)

#endif

#endif /* WITH_QT */


# ============================================================
#  calib3d. Camera Calibration, Pose Estimation and Stereo: Camera
#   Calibration and 3d Reconstruction
# ============================================================

MODULE = Cv		PACKAGE = Cv
# ====================
void
cvCalcImageHomography(float* line, CvPoint3D32f* center, float* intrinsic, float* homography)

#if CV_MAJOR_VERSION >= 2

double
cvCalibrateCamera2(const CvMat* objectPoints, const CvMat* imagePoints, const CvMat* pointCounts, CvSize imageSize, CvMat* cameraMatrix, CvMat* distCoeffs, CvMat* rvecs=NULL, CvMat* tvecs=NULL, int flags=0)
ALIAS: Cv::Mat::cvCalibrateCamera2 = 1

#else

void
cvCalibrateCamera2(const CvMat* objectPoints, const CvMat* imagePoints, const CvMat* pointCounts, CvSize imageSize, CvMat* cameraMatrix, CvMat* distCoeffs, CvMat* rvecs=NULL, CvMat* tvecs=NULL, int flags=0)
ALIAS: Cv::Mat::cvCalibrateCamera2 = 1

#endif

MODULE = Cv		PACKAGE = Cv::Mat
# ====================
void
cvComputeCorrespondEpilines(const CvMat* points, int whichImage, const CvMat* F, CvMat* lines)

void
cvConvertPointsHomogeneous(const CvMat* src, CvMat* dst)

#TBD# CvPOSITObject* cvCreatePOSITObject(CvPoint3D32f* points, int point_count)


MODULE = Cv		PACKAGE = Cv
# ====================
CvStereoBMState*
cvCreateStereoBMState(int preset=CV_STEREO_BM_BASIC, int numberOfDisparities=0)


MODULE = Cv		PACKAGE = Cv::StereoBMState
# ====================
void
cvFindStereoCorrespondenceBM(CvStereoBMState* state, const CvArr* left, const CvArr* right, CvArr* disparity)
C_ARGS: left, right, disparity, state

int
preFilterType(CvStereoBMState* state, int value = NO_INIT)
CODE:
	RETVAL = state->preFilterType;
	if (items == 2) state->preFilterType = value;
OUTPUT:
	RETVAL

int
preFilterSize(CvStereoBMState* state, int value = NO_INIT)
CODE:
	RETVAL = state->preFilterSize;
	if (items == 2) state->preFilterSize = value;
OUTPUT:
	RETVAL

int
preFilterCap(CvStereoBMState* state, int value = NO_INIT)
CODE:
	RETVAL = state->preFilterCap;
	if (items == 2) state->preFilterCap = value;
OUTPUT:
	RETVAL

int
SADWindowSize(CvStereoBMState* state, int value = NO_INIT)
CODE:
	RETVAL = state->SADWindowSize;
	if (items == 2) state->SADWindowSize = value;
OUTPUT:
	RETVAL

int
minDisparity(CvStereoBMState* state, int value = NO_INIT)
CODE:
	RETVAL = state->minDisparity;
	if (items == 2) state->minDisparity = value;
OUTPUT:
	RETVAL

int
numberOfDisparities(CvStereoBMState* state, int value = NO_INIT)
CODE:
	RETVAL = state->numberOfDisparities;
	if (items == 2) state->numberOfDisparities = value;
OUTPUT:
	RETVAL

int
textureThreshold(CvStereoBMState* state, int value = NO_INIT)
CODE:
	RETVAL = state->textureThreshold;
	if (items == 2) state->textureThreshold = value;
OUTPUT:
	RETVAL

int
uniquenessRatio(CvStereoBMState* state, int value = NO_INIT)
CODE:
	RETVAL = state->uniquenessRatio;
	if (items == 2) state->uniquenessRatio = value;
OUTPUT:
	RETVAL

int
speckleWindowSize(CvStereoBMState* state, int value = NO_INIT)
CODE:
	RETVAL = state->speckleWindowSize;
	if (items == 2) state->speckleWindowSize = value;
OUTPUT:
	RETVAL

int
set_speckleRange(CvStereoBMState* state, int value = NO_INIT)
CODE:
	RETVAL = state->speckleRange;
	if (items == 2) state->speckleRange = value;
OUTPUT:
	RETVAL

CvMat*
preFilteredImg0(CvStereoBMState* state, CvMat* value = NO_INIT)
CODE:
	RETVAL = state->preFilteredImg0;
	if (items == 2) state->preFilteredImg0 = value;
OUTPUT:
	RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Mat::Ghost", (void*)RETVAL);

CvMat*
preFilteredImg1(CvStereoBMState* state, CvMat* value = NO_INIT)
CODE:
	RETVAL = state->preFilteredImg1;
	if (items == 2) state->preFilteredImg1 = value;
OUTPUT:
	RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Mat::Ghost", (void*)RETVAL);

CvMat*
slidingSumBuf(CvStereoBMState* state, CvMat* value = NO_INIT)
CODE:
	RETVAL = state->slidingSumBuf;
	if (items == 2) state->slidingSumBuf = value;
OUTPUT:
	RETVAL sv_setref_pv(ST(0) = sv_newmortal(), "Cv::Mat::Ghost", (void*)RETVAL);


MODULE = Cv		PACKAGE = Cv
# ====================
CvStereoGCState*
cvCreateStereoGCState(int numberOfDisparities, int maxIters)


MODULE = Cv		PACKAGE = Cv::Mat
# ====================
void
cvDecomposeProjectionMatrix(const CvMat *projMatrix, CvMat *cameraMatrix, CvMat *rotMatrix, CvMat *transVect, CvMat *rotMatrX=NULL, CvMat *rotMatrY=NULL, CvMat *rotMatrZ=NULL, CvPoint3D64f *eulerAngles=NULL)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================
void
cvDrawChessboardCorners(CvArr* image, CvSize patternSize, CvPoint2D32f* corners, int patternWasFound)
C_ARGS: image, patternSize, corners, length(corners), patternWasFound

int
cvFindChessboardCorners(const CvArr* image, CvSize patternSize, corners, int flags=CV_CALIB_CB_ADAPTIVE_THRESH)
INPUT:
	CvPoint2D32f* corners = NO_INIT
PROTOTYPE: $$\@$
PREINIT:
	int length(corners) = 0;
INIT:
	corners = (CvPoint2D32f*)alloca(sizeof(CvPoint2D32f) * patternSize.width * patternSize.height);
C_ARGS:
	image, patternSize, corners, &length(corners), flags
OUTPUT:
	RETVAL
	corners


MODULE = Cv		PACKAGE = Cv
# ====================

#if CV_MAJOR_VERSION >= 2

void
cvFindExtrinsicCameraParams2(const CvMat* objectPoints, const CvMat* imagePoints, const CvMat* cameraMatrix, const CvMat* distCoeffs, CvMat* rvec, CvMat* tvec, int useExtrinsicGuess=0)
ALIAS: Cv::Mat::cvFindExtrinsicCameraParams2 = 1

#else

void
cvFindExtrinsicCameraParams2(const CvMat* objectPoints, const CvMat* imagePoints, const CvMat* cameraMatrix, const CvMat* distCoeffs, CvMat* rvec, CvMat* tvec)
ALIAS: Cv::Mat::cvFindExtrinsicCameraParams2 = 1

#endif

int
cvFindFundamentalMat(const CvMat* points1, const CvMat* points2, CvMat* fundamentalMatrix, int  method=CV_FM_RANSAC, double param1=1., double param2=0.99, CvMat* status=NULL)

void
cvFindHomography(const CvMat* srcPoints, const CvMat* dstPoints, CvMat* H, int method=0, double ransacReprojThreshold=3, CvMat* status=NULL)
ALIAS: Cv::Mat::cvFindHomography = 1

#C# void cvFindStereoCorrespondenceBM(const CvArr* left, const CvArr* right, CvArr* disparity, CvStereoBMState* state)

#TBD# void cvFindStereoCorrespondenceGC(const CvArr* left, const CvArr* right, CvArr* dispLeft, CvArr* dispRight, CvStereoGCState* state, int useDisparityGuess = CV_DEFAULT(0))

#TBD# void cvGetOptimalNewCameraMatrix(const CvMat* cameraMatrix, const CvMat* distCoeffs, CvSize imageSize, double alpha, CvMat* newCameraMatrix, CvSize newImageSize=cvSize(0, 0), CvRect* validPixROI=0)

#TBD# void cvInitIntrinsicParams2D(const CvMat* objectPoints, const CvMat* imagePoints, const CvMat* npoints, CvSize imageSize, CvMat* cameraMatrix, double aspectRatio=1.)

void
cvInitUndistortMap(const CvMat* cameraMatrix, const CvMat* distCoeffs, CvArr* map1, CvArr* map2)

void
cvInitUndistortRectifyMap(const CvMat* cameraMatrix, const CvMat* distCoeffs, const CvMat* R, const CvMat* newCameraMatrix, CvArr* map1, CvArr* map2)

#TBD# void cvPOSIT(CvPOSITObject* posit_object, CvPoint2D32f* imagePoints, double focal_length, CvTermCriteria criteria, CvMatr32f rotationMatrix, CvVect32f translation_vector)

void
cvProjectPoints2(const CvMat* objectPoints, const CvMat* rvec, const CvMat* tvec, const CvMat* cameraMatrix, const CvMat* distCoeffs, CvMat* imagePoints, CvMat* dpdrot=NULL, CvMat* dpdt=NULL, CvMat* dpdf=NULL, CvMat* dpdc=NULL, CvMat* dpddist=NULL)


MODULE = Cv		PACKAGE = Cv::Arr
# ====================

#if CV_MAJOR_VERSION >= 2

void
cvReprojectImageTo3D(const CvArr* disparity, CvArr* _3dImage, const CvMat* Q, int handleMissingValues=0)

#else

void
cvReprojectImageTo3D(const CvArr* disparity, CvArr* _3dImage, const CvMat* Q);

#endif


MODULE = Cv		PACKAGE = Cv::Mat
# ====================
void
cvRQDecomp3x3(const CvMat *M, CvMat *R, CvMat *Q, CvMat *Qx=NULL, CvMat *Qy=NULL, CvMat *Qz=NULL, CvPoint3D64f *eulerAngles=NULL)

#TBD# void cvReleasePOSITObject(CvPOSITObject* &posit_object)


MODULE = Cv		PACKAGE = Cv::StereoBMState
# ====================
void
cvReleaseStereoBMState(CvStereoBMState* &state)
ALIAS: Cv::StereoBMState::DESTROY = 1


MODULE = Cv		PACKAGE = Cv::StereoGCState
# ====================
void
cvReleaseStereoGCState(CvStereoGCState* &state)
ALIAS: Cv::StereoGCState::DESTROY = 1


MODULE = Cv		PACKAGE = Cv::Mat
# ====================
int
cvRodrigues2(const CvMat* src, CvMat* dst, CvMat* jacobian=0)


MODULE = Cv		PACKAGE = Cv
# ====================

#if CV_MAJOR_VERSION >= 2

double
cvStereoCalibrate(const CvMat* objectPoints, const CvMat* imagePoints1, const CvMat* imagePoints2, const CvMat* pointCounts, CvMat* cameraMatrix1, CvMat* distCoeffs1, CvMat* cameraMatrix2, CvMat* distCoeffs2, CvSize imageSize, CvMat* R, CvMat* T, CvMat* E=0, CvMat* F=0, CvTermCriteria term_crit=cvTermCriteria(CV_TERMCRIT_ITER+CV_TERMCRIT_EPS, 30, 1e-6), int flags=CV_CALIB_FIX_INTRINSIC)

#else
void
cvStereoCalibrate(const CvMat* objectPoints, const CvMat* imagePoints1, const CvMat* imagePoints2, const CvMat* pointCounts, CvMat* cameraMatrix1, CvMat* distCoeffs1, CvMat* cameraMatrix2, CvMat* distCoeffs2, CvSize imageSize, CvMat* R, CvMat* T, CvMat* E=0, CvMat* F=0, CvTermCriteria term_crit=cvTermCriteria(CV_TERMCRIT_ITER+CV_TERMCRIT_EPS,30,1e-6), int flags=CV_CALIB_FIX_INTRINSIC)

#endif

#if CV_MAJOR_VERSION >= 2

void
cvStereoRectify(const CvMat* cameraMatrix1, const CvMat* cameraMatrix2, const CvMat* distCoeffs1, const CvMat* distCoeffs2, CvSize imageSize, const CvMat* R, const CvMat* T, CvMat* R1, CvMat* R2, CvMat* P1, CvMat* P2, CvMat* Q=0, int flags=CV_CALIB_ZERO_DISPARITY, double alpha=-1, CvSize newImageSize=cvSize(0, 0), roi1, roi2)
INPUT:
	CvRect &roi1 = NO_INIT
	CvRect &roi2 = NO_INIT
OUTPUT:
	roi1
	roi2

#else

void
cvStereoRectify(const CvMat* cameraMatrix1, const CvMat* cameraMatrix2, const CvMat* distCoeffs1, const CvMat* distCoeffs2, CvSize imageSize, const CvMat* R, const CvMat* T, CvMat* R1, CvMat* R2, CvMat* P1, CvMat* P2, CvMat* Q=0, int flags=CV_CALIB_ZERO_DISPARITY)

#endif

void
cvStereoRectifyUncalibrated(const CvMat* points1, const CvMat* points2, const CvMat* F, CvSize imageSize, CvMat* H1, CvMat* H2, double threshold=5)
ALIAS: Cv::Mat::cvStereoRectifyUncalibrated = 1


MODULE = Cv		PACKAGE = Cv::Arr
# ====================

#if CV_MAJOR_VERSION >= 2

void
cvUndistort2(const CvArr* src, CvArr* dst, const CvMat* cameraMatrix, const CvMat* distCoeffs, const CvMat* newCameraMatrix = NULL)

#else

void
cvUndistort2(const CvArr* src, CvArr* dst, const CvMat* cameraMatrix, const CvMat* distCpeffs)

#endif

MODULE = Cv		PACKAGE = Cv::Mat
# ====================
void
cvUndistortPoints(const CvMat* src, CvMat* dst, const CvMat* cameraMatrix, const CvMat* distCoeffs, const CvMat* R=NULL, const CvMat* P=NULL)


# ============================================================
#  ml. Machine Learning
# ============================================================


# ============================================================
#  Background/foreground segmentation
# ============================================================

MODULE = Cv		PACKAGE = Cv
# ====================

#ifdef __cplusplus
CvBGCodeBookModel*
cvCreateBGCodeBookModel()

MODULE = Cv		PACKAGE = Cv::BGCodeBookModel
# ====================
void
cvReleaseBGCodeBookModel(CvBGCodeBookModel* &model)
ALIAS: Cv::BGCodeBookModel::DESTROY = 1

void
cvBGCodeBookUpdate(CvBGCodeBookModel* model, const CvArr* image, CvRect roi = cvRect(0, 0, 0, 0), const CvArr* mask = 0)

int
cvBGCodeBookDiff(const CvBGCodeBookModel* model, const CvArr* image, CvArr* fgmask, CvRect roi = cvRect(0, 0, 0, 0))

void
cvBGCodeBookClearStale(CvBGCodeBookModel* model, int staleThresh, CvRect roi = cvRect(0, 0, 0, 0), const CvArr* mask = 0)

MODULE = Cv		PACKAGE = Cv::Arr
# ====================
CvSeq*
cvSegmentFGMask(CvArr *fgmask, int poly1Hull0 = 1, float perimScale = 4.0, CvMemStorage* storage = 0, CvPoint offset = cvPoint(0, 0))


MODULE = Cv		PACKAGE = Cv::BGCodeBookModel
# ====================
AV*
modMin(CvBGCodeBookModel* model, AV* value = NO_INIT)
INIT:
	RETVAL = newAV();
CODE:
	for (int i = 0; i < DIM(model->modMin); i++) {
		av_push(RETVAL, newSViv(model->modMin[i]));
		if (items == 2 && i <= av_len(value))
			model->modMin[i] = SvIV((SV*)(*av_fetch(value, i, 0)));
	}
OUTPUT:
	RETVAL

AV*
modMax(CvBGCodeBookModel* model, AV* value = NO_INIT)
INIT:
	RETVAL = newAV();
CODE:
	for (int i = 0; i < DIM(model->modMax); i++) {
		av_push(RETVAL, newSViv(model->modMax[i]));
		if (items == 2 && i <= av_len(value))
			model->modMax[i] = SvIV((SV*)(*av_fetch(value, i, 0)));
	}
OUTPUT:
	RETVAL

AV*
cbBounds(CvBGCodeBookModel* model, AV* value = NO_INIT)
INIT:
	RETVAL = newAV();
CODE:
	for (int i = 0; i < DIM(model->cbBounds); i++) {
		av_push(RETVAL, newSViv(model->cbBounds[i]));
		if (items == 2 && i <= av_len(value))
			model->cbBounds[i] = SvIV((SV*)(*av_fetch(value, i, 0)));
	}
OUTPUT:
	RETVAL

int
t(CvBGCodeBookModel* model)
CODE:
	RETVAL = model->t;
OUTPUT:
	RETVAL

#endif
