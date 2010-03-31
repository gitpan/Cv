/* -*- mode: text; coding: utf-8; tab-width: 4 -*- */
#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif

#include "ppport.h"

#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <opencv/cvaux.h>

#define DIM(x) (sizeof(x)/sizeof((x)[0]))
#ifndef max
#define max(a, b) ((a)>(b)?(a):(b))
#endif

//------------------------------------------------------------
//  CvMouseCallback
//------------------------------------------------------------

static SV* perl_cb_mouse = (SV*)0;

static void cb_mouse(int event, int x, int y, int flags, void* param) {
    if (perl_cb_mouse) {
		dSP;
		ENTER;
		SAVETMPS;
		PUSHMARK(SP);
		XPUSHs(sv_2mortal(newSViv(event)));
		XPUSHs(sv_2mortal(newSViv(x)));
		XPUSHs(sv_2mortal(newSViv(y)));
		XPUSHs(sv_2mortal(newSViv(flags)));
		XPUSHs(sv_2mortal(newSViv((int)param)));
		PUTBACK;
		call_sv(perl_cb_mouse, G_EVAL|G_VOID);
		FREETMPS;
		LEAVE;
	}
}

CvMouseCallback make_perl_cb_CvMouseCallback(SV *callback)
{
	if (perl_cb_mouse) SvREFCNT_dec(perl_cb_mouse);
	perl_cb_mouse = (SV*)0;
	if (SvROK(callback) && SvTYPE(SvRV(callback)) == SVt_PVCV) {
		perl_cb_mouse = (SV *)SvRV(callback);
		if (perl_cb_mouse) SvREFCNT_inc(perl_cb_mouse);
		return &cb_mouse;
	}
	return (CvMouseCallback)0;
}


//------------------------------------------------------------
//  CvTrackbarCallback
//------------------------------------------------------------

typedef struct elem {
    struct elem *next;
} elem_t;

typedef struct array {
    elem_t *head;
    elem_t *tail;
} array_t;

static elem_t *my_push(array_t *a, elem_t *e)
{
    if (a != (array_t *)0) {
        if (a->head != (elem_t *)0)
            a->tail = a->tail->next = e;
        else
            a->tail = a->head = e;
        if (e != (elem_t *)0)
            e->next = (elem_t *)0;
        return a->head;
    }
    return (elem_t *)0;
}

static elem_t *my_shift(array_t *a)
{
    if (a != (array_t *)0) {
        elem_t *e;
        if ((e = a->head) != (elem_t *)0) {
            if (a->head == a->tail)
                a->head = a->tail = (elem_t *)0;
            else
                a->head = a->head->next;
        }
        return e;
    }
    return (elem_t *)0;
}

typedef struct CvTrackbar {
	struct CvTrackbar* next;
	SV* callback;
	SV* value;
	int pos;
	int lastpos;
} CvTrackbar;

static array_t trackbar_list;

static void cb_trackbar(int pos)
{
	CvTrackbar* p;
	for (p = (CvTrackbar*)trackbar_list.head; p; p = p->next) {
		if (p->pos != p->lastpos) {
			p->lastpos = p->pos;
			if (p->value) {
				sv_setiv(p->value, p->pos);
			}
			if (p->callback) {
				dSP;
				ENTER;
				SAVETMPS;
				PUSHMARK(SP);
				XPUSHs(sv_2mortal(newSViv(p->pos)));
				PUTBACK;
				call_sv(p->callback, G_EVAL|G_VOID);
				FREETMPS;
				LEAVE;
			}
		}
	}
}


//------------------------------------------------------------
//  CvPoint
//------------------------------------------------------------
static int xspoint(SV *svp, CvPoint *p)
{
    if (SvROK(svp)) {
        if (SvTYPE(SvRV(svp)) == SVt_PVAV) {
            if (av_len((AV *)SvRV(svp)) + 1 == 2) {
                p->x = SvNV(*av_fetch((AV *)SvRV(svp), 0, 0));
                p->y = SvNV(*av_fetch((AV *)SvRV(svp), 1, 0));
                return 1;
            }
        } else if (SvTYPE(SvRV(svp)) == SVt_PVHV) {
            if (hv_exists((HV *)SvRV(svp), "x", 1) &&
                hv_exists((HV *)SvRV(svp), "y", 1)) {
                p->x = SvNV(*hv_fetch((HV *)SvRV(svp), "x", 1, 0));
                p->y = SvNV(*hv_fetch((HV *)SvRV(svp), "y", 1, 0));
                return 1;
            }
        }
    }
    return 0;
}

static HV *plpoint(CvPoint point)
{
	HV *hv = (HV *)sv_2mortal((SV *)newHV());
	hv_store(hv, "x", 1, newSViv(point.x), 0);
	hv_store(hv, "y", 1, newSViv(point.y), 0);
	return hv;
}

//-----------------------------------------------------------
// CvPoint2D32f
//-----------------------------------------------------------
static int xspoint2d32f(SV *svp, CvPoint2D32f *p)
{
    if (SvROK(svp)) {
        if (SvTYPE(SvRV(svp)) == SVt_PVAV) {
            if (av_len((AV *)SvRV(svp)) + 1 == 2) {
                p->x = SvNV(*av_fetch((AV *)SvRV(svp), 0, 0));
                p->y = SvNV(*av_fetch((AV *)SvRV(svp), 1, 0));
                return 1;
            }
        } else if (SvTYPE(SvRV(svp)) == SVt_PVHV) {
            if (hv_exists((HV *)SvRV(svp), "x", 1) &&
                hv_exists((HV *)SvRV(svp), "y", 1)) {
                p->x = SvNV(*hv_fetch((HV *)SvRV(svp), "x", 1, 0));
                p->y = SvNV(*hv_fetch((HV *)SvRV(svp), "y", 1, 0));
                return 1;
            }
        }
    }
    return 0;
}

static HV *plpoint2d32f(CvPoint2D32f point)
{
	HV *hv = (HV *)sv_2mortal((SV *)newHV());
	hv_store(hv, "x", 1, newSVnv(point.x), 0);
	hv_store(hv, "y", 1, newSVnv(point.y), 0);
	return hv;
}

typedef struct {
		CvPoint2D32f pt[4];
} CvPoint2D32f4;




MODULE = Cv		PACKAGE = Cv::CxCore

INCLUDE: Cv-Struct.inc

# #####################################################################
#  get Cv version
# #####################################################################

SV*
CV_VERSION()
	CODE:
		char* v = CV_VERSION;
		RETVAL = newSVpvn(v, strlen(v));
	OUTPUT:
		RETVAL

int
CV_MAJOR_VERSION()
	CODE:
		RETVAL = CV_MAJOR_VERSION;
	OUTPUT:
		RETVAL

int
CV_MINOR_VERSION()
	CODE:
		RETVAL = CV_MINOR_VERSION;
	OUTPUT:
		RETVAL

int
CV_SUBMINOR_VERSION()
	CODE:
		RETVAL = CV_SUBMINOR_VERSION;
	OUTPUT:
		RETVAL


# ######################################################################
#   CXCORE
#   - http://opencv.jp/opencv-1.1.0_org/docs/ref/opencvref_cxcore.htm
# ######################################################################

#============================================================
#  Operations on Arrays
#============================================================

#------------------------------------------------------------
# CvPoint
#------------------------------------------------------------

#------------------------------------------------------------
# CvPoint2D32f
#------------------------------------------------------------

#------------------------------------------------------------
# CvPoint3D32f
#------------------------------------------------------------

#------------------------------------------------------------
# CvPoint2D64f
#------------------------------------------------------------

#------------------------------------------------------------
# CvPoint3D64f
#------------------------------------------------------------

#------------------------------------------------------------
# CvSize
#------------------------------------------------------------

#------------------------------------------------------------
# CvSize2D32f
#------------------------------------------------------------

#------------------------------------------------------------
# CvRect
#------------------------------------------------------------

#------------------------------------------------------------
# CvScalar
#------------------------------------------------------------

#------------------------------------------------------------
# CvTermCriteria
#------------------------------------------------------------

#------------------------------------------------------------
# CvMatND
#------------------------------------------------------------

#------------------------------------------------------------
# CvSparseMat
#------------------------------------------------------------

#------------------------------------------------------------
# IplImage
#------------------------------------------------------------

#------------------------------------------------------------
# CvArr
#------------------------------------------------------------

#------------------------------------------------------------
# CreateImage
#------------------------------------------------------------
IplImage*
cvCreateImage(size, depth, channels)
	INPUT:
		CvSize size
		int depth
		int channels

#------------------------------------------------------------
# CreateImageHeader
#------------------------------------------------------------

#------------------------------------------------------------
# ReleaseImageHeader
#------------------------------------------------------------

#------------------------------------------------------------
# ReleaseImage
#------------------------------------------------------------
void
cvReleaseImage(image)
	INPUT:
		IplImage* image
	CODE:
		cvReleaseImage(&image);
	OUTPUT:
		image

#------------------------------------------------------------
# InitImageHeader
#------------------------------------------------------------

#------------------------------------------------------------
# CloneImage
#------------------------------------------------------------
IplImage*
cvCloneImage(image)
	INPUT:
		IplImage* image;

#------------------------------------------------------------
# SetImageCOI
#------------------------------------------------------------
void
cvSetImageCOI(image, coi)
	INPUT:
		IplImage* image
		int coi

#------------------------------------------------------------
# GetImageCOI
#------------------------------------------------------------
int
cvGetImageCOI(image)
	INPUT:
		IplImage* image

#------------------------------------------------------------
# SetImageROI
#------------------------------------------------------------
void
cvSetImageROI(image, rect)
	INPUT:
		IplImage* image
		CvRect rect

#------------------------------------------------------------
# ResetImageROI
#------------------------------------------------------------
void
cvResetImageROI(image)
	INPUT:
		IplImage* image

#------------------------------------------------------------
# GetImageROI
#------------------------------------------------------------
CvRect
cvGetImageROI(image)
	INPUT:
		IplImage* image

#------------------------------------------------------------
# CreateMat
#------------------------------------------------------------
CvMat *
cvCreateMat(rows, cols, type)
	INPUT:
		int rows
		int cols
		int type

#------------------------------------------------------------
# CreateMatHeader
#------------------------------------------------------------

#------------------------------------------------------------
# ReleaseMat
#------------------------------------------------------------
void
cvReleaseMat(mat)
	INPUT:
		CvMat* mat
	CODE:
		cvReleaseMat(&mat);
	OUTPUT:
		mat

#------------------------------------------------------------
# InitMatHeader
#------------------------------------------------------------

#------------------------------------------------------------
# Mat
#------------------------------------------------------------

#------------------------------------------------------------
# CloneMat
#------------------------------------------------------------

#------------------------------------------------------------
# CreateMatND
#------------------------------------------------------------

#------------------------------------------------------------
# CreateMatNDHeader
#------------------------------------------------------------

#------------------------------------------------------------
# ReleaseMatND
#------------------------------------------------------------

#------------------------------------------------------------
# InitMatNDHeader
#------------------------------------------------------------

#------------------------------------------------------------
# CloneMatND
#------------------------------------------------------------

#------------------------------------------------------------
# DecRefData
#------------------------------------------------------------

#------------------------------------------------------------
# IncRefData
#------------------------------------------------------------

#------------------------------------------------------------
# CreateData
#------------------------------------------------------------

#------------------------------------------------------------
# ReleaseData
#------------------------------------------------------------

#------------------------------------------------------------
# SetData
#------------------------------------------------------------

#------------------------------------------------------------
# GetRawData
#------------------------------------------------------------

#------------------------------------------------------------
# GetMat
#------------------------------------------------------------

#------------------------------------------------------------
# GetImage
#------------------------------------------------------------

#------------------------------------------------------------
# CreateSparseMat
#------------------------------------------------------------

#------------------------------------------------------------
# ReleaseSparseMat
#------------------------------------------------------------

#------------------------------------------------------------
# CloneSparseMat
#------------------------------------------------------------

#------------------------------------------------------------
# GetSubRect
#------------------------------------------------------------
CvMat *
cvGetSubRect(arr, submat, rect)
	INPUT:
		const CvArr* arr
		CvMat* submat
		CvRect rect

#------------------------------------------------------------
# GetRow, GetRows
#------------------------------------------------------------
CvMat *
cvGetRow(arr, submat, row)
	INPUT:
		const CvArr* arr
		CvMat* submat
		int row

CvMat *
cvGetRows(arr, submat, start_row, end_row, delta_row)
	INPUT:
		const CvArr* arr
		CvMat* submat
		int start_row
		int end_row
		int delta_row

#------------------------------------------------------------
# GetCol, GetCols
#------------------------------------------------------------
CvMat *
cvGetCol(arr, submat, col)
	INPUT:
		const CvArr* arr
		CvMat* submat
		int col

CvMat *
cvGetCols(arr, submat, start_col, end_col)
	INPUT:
		const CvArr* arr
		CvMat* submat
		int start_col
		int end_col

#------------------------------------------------------------
# GetDiag
#------------------------------------------------------------
CvMat *
cvGetDiag(arr, submat, diag)
	INPUT:
		const CvArr* arr
		CvMat* submat
		int diag

#------------------------------------------------------------
# GetSize
#------------------------------------------------------------
CvSize
cvGetSize(arr)
	INPUT:
		const CvArr* arr;

#------------------------------------------------------------
# InitSparseMatIterator
#------------------------------------------------------------

#------------------------------------------------------------
# GetNextSparseNode
#------------------------------------------------------------

#------------------------------------------------------------
# GetElemType
#------------------------------------------------------------
int
cvGetElemType(arr)
	INPUT:
		const CvArr* arr


#------------------------------------------------------------
# GetDims, GetDimSize
#------------------------------------------------------------
SV *
cvGetDims(arr)
	INPUT:
		const CvArr *arr
	CODE:
		AV *results = (AV *)sv_2mortal((SV *)newAV());
		int size[CV_MAX_DIM]; int dims = cvGetDims(arr, size); int i;
		for (i = 0; i < dims; i++) {
			av_push(results, newSVnv(size[i]));
		}
		RETVAL = newRV((SV *)results);
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# Ptr*D
#------------------------------------------------------------

#------------------------------------------------------------
# Get*D
#------------------------------------------------------------
CvScalar
cvGet1D(arr, idx0)
	INPUT:
		const CvArr* arr
		int idx0

CvScalar
cvGet2D(arr, idx0, idx1)
	INPUT:
		const CvArr* arr
		int idx0
		int idx1

CvScalar
cvGet3D(arr, idx0, idx1, idx2)
	INPUT:
		const CvArr* arr
		int idx0
		int idx1
		int idx2

CvScalar
cvGetND(arr, idx)
	INPUT:
		const CvArr* arr
		int *idx

#------------------------------------------------------------
# GetReal*D
#------------------------------------------------------------
double
cvGetReal1D(arr, idx0)
	INPUT:
		const CvArr* arr
		int idx0

double
cvGetReal2D(arr, idx0, idx1)
	INPUT:
		const CvArr* arr
		int idx0
		int idx1

double
cvGetReal3D(arr, idx0, idx1, idx2)
	INPUT:
		const CvArr* arr
		int idx0
		int idx1
		int idx2

double
cvGetRealND(arr, idx)
	INPUT:
		const CvArr* arr
		int *idx

#------------------------------------------------------------
# mGet
#------------------------------------------------------------

#------------------------------------------------------------
# Set*D
#------------------------------------------------------------
void
cvSet1D(arr, idx0, value)
	INPUT:
		CvArr* arr
		int idx0
		CvScalar value

void
cvSet2D(arr, idx0, idx1, value)
	INPUT:
		CvArr* arr
		int idx0
		int idx1
		CvScalar value

void
cvSet3D(arr, idx0, idx1, idx2, value)
	INPUT:
		CvArr* arr
		int idx0
		int idx1
		int idx2
		CvScalar value

void
cvSetND(arr, idx, value)
	INPUT:
		CvArr* arr
		int *idx
		CvScalar value

#------------------------------------------------------------
# SetReal*D
#------------------------------------------------------------
void
cvSetReal1D(arr, idx0, value)
	INPUT:
		CvArr* arr
		int idx0
		double value

void
cvSetReal2D(arr, idx0, idx1, value)
	INPUT:
		CvArr* arr
		int idx0
		int idx1
		double value

void
cvSetReal3D(arr, idx0, idx1, idx2, value)
	INPUT:
		CvArr* arr
		int idx0
		int idx1
		int idx2
		double value

void
cvSetRealND(arr, idx, value)
	INPUT:
		CvArr* arr
		int *idx
		double value

#------------------------------------------------------------
# mSet
#------------------------------------------------------------

#------------------------------------------------------------
# ClearND
#------------------------------------------------------------

#------------------------------------------------------------
# Copy
#------------------------------------------------------------
void
cvCopy(src, dst, mask)
	INPUT:
		const CvArr* src
		CvArr* dst
		const CvArr* mask

#------------------------------------------------------------
# Set
#------------------------------------------------------------
void
cvSet(img, value, mask)
	INPUT:
		CvArr* img
		CvScalar value
		const CvArr* mask

#------------------------------------------------------------
# SetZero
#------------------------------------------------------------
void
cvZero(img)
	INPUT:
		CvArr* img

#------------------------------------------------------------
# SetIdentity
#------------------------------------------------------------
void
cvSetIdentity(mat, value)
	INPUT:
		CvArr* mat
		CvScalar value

#------------------------------------------------------------
# Range
#------------------------------------------------------------

#------------------------------------------------------------
# Reshape
#------------------------------------------------------------

#------------------------------------------------------------
# ReshapeMatND
#------------------------------------------------------------

#------------------------------------------------------------
# Repeat
#------------------------------------------------------------
void
cvRepeat(src, dst)
	INPUT:
		const CvArr* src
		CvArr* dst

#------------------------------------------------------------
# Flip
#------------------------------------------------------------
void
cvFlip(src, dst, flip_mode)
	INPUT:
		const CvArr* src
		CvArr* dst
		int flip_mode

#------------------------------------------------------------
# Split
#------------------------------------------------------------
void
cvSplit(src, dst0, dst1, dst2, dst3)
	INPUT:
		const CvArr* src
		CvArr* dst0
		CvArr* dst1
		CvArr* dst2
		CvArr* dst3

#------------------------------------------------------------
# Merge
#------------------------------------------------------------
void
cvMerge(src0, src1, src2, src3, dst)
	INPUT:
		const CvArr* src0
		const CvArr* src1
		const CvArr* src2
		const CvArr* src3
		CvArr* dst

#------------------------------------------------------------
# MixChannels
#------------------------------------------------------------

#------------------------------------------------------------
# RandShuffle
#------------------------------------------------------------

#------------------------------------------------------------
# LUT
#------------------------------------------------------------
void
cvLUT(src, dst, lut)
	INPUT:		   
		const CvArr* src
		CvArr* dst
		const CvArr* lut

#------------------------------------------------------------
# ConvertScale
#------------------------------------------------------------
void
cvConvertScale( src, dst, scale, shift )
	INPUT:
		const CvArr* src
		CvArr* dst
		double scale
		double shift

#------------------------------------------------------------
# ConvertScaleAbs
#------------------------------------------------------------
void
cvConvertScaleAbs( src, dst, scale, shift )
	INPUT:
		const CvArr* src
		CvArr* dst
		double scale
		double shift

#------------------------------------------------------------
# Add
#------------------------------------------------------------
void
cvAdd(src1, src2, dst, mask)
	INPUT:
		const CvArr* src1
		const CvArr* src2
		CvArr* dst
		const CvArr* mask

#------------------------------------------------------------
# AddS
#------------------------------------------------------------
void
cvAddS(src, value, dst, mask)
	INPUT:
		const CvArr *src
		CvScalar value
		CvArr *dst
		const CvArr *mask

#------------------------------------------------------------
# AddWeighted
#------------------------------------------------------------
void
cvAddWeighted(src1, alpha, src2, beta, gamma, dst)
	INPUT:
		const CvArr* src1
		double alpha
		const CvArr* src2
		double beta
		double gamma
		CvArr* dst

#------------------------------------------------------------
# Sub
#------------------------------------------------------------
void
cvSub(src1, src2, dst, mask)
	INPUT:
		const CvArr *src1
		const CvArr *src2
		CvArr *dst
		const CvArr *mask

#------------------------------------------------------------
# SubS
#------------------------------------------------------------
void
cvSubS(src, value, dst, mask)
	INPUT:
		const CvArr *src
		CvScalar value
		CvArr *dst
		const CvArr *mask

#------------------------------------------------------------
# SubRS
#------------------------------------------------------------
void
cvSubRS(src, value, dst, mask)
	INPUT:
		const CvArr *src
		CvScalar value
		CvArr *dst
		const CvArr *mask

#------------------------------------------------------------
# Mul
#------------------------------------------------------------
void
cvMul(src1, src2, dst, scale)
	INPUT:
		const CvArr* src1
		const CvArr* src2
		CvArr* dst
		double scale

#------------------------------------------------------------
# Div
#------------------------------------------------------------
void
cvDiv(src1, src2, dst, scale)
	INPUT:
		const CvArr* src1
		const CvArr* src2
		CvArr* dst
		double scale

#------------------------------------------------------------
# And
#------------------------------------------------------------
void
cvAnd(src1, src2, dst, mask)
	INPUT:
		const CvArr* src1
		const CvArr* src2
		CvArr* dst
		const CvArr* mask

#------------------------------------------------------------
# AndS
#------------------------------------------------------------
void
cvAndS(src, value, dst, mask)
	INPUT:
		const CvArr *src
		CvScalar value
		CvArr *dst
		const CvArr *mask

#------------------------------------------------------------
# Or
#------------------------------------------------------------
void
cvOr(src1, src2, dst, mask)
	INPUT:
		const CvArr* src1
		const CvArr* src2
		CvArr* dst
		const CvArr* mask

#------------------------------------------------------------
# OrS
#------------------------------------------------------------
void
cvOrS(src, value, dst, mask)
	INPUT:
		const CvArr *src
		CvScalar value
		CvArr *dst
		const CvArr *mask

#------------------------------------------------------------
# Xor
#------------------------------------------------------------
void
cvXor(src1, src2, dst, mask)
	INPUT:
		const CvArr* src1
		const CvArr* src2
		CvArr* dst
		const CvArr* mask

#------------------------------------------------------------
# XorS
#------------------------------------------------------------
void
cvXorS(src, value, dst, mask)
	INPUT:
		const CvArr *src
		CvScalar value
		CvArr *dst
		const CvArr *mask

#------------------------------------------------------------
# Not
#------------------------------------------------------------
void
cvNot(src, dst)
	INPUT:
		const CvArr* src
		CvArr* dst

#------------------------------------------------------------
# Cmp
#------------------------------------------------------------
void
cvCmp(src1, src2, dst, cmp_op)
	INPUT:
		const CvArr* src1
		const CvArr* src2
		CvArr* dst
		int cmp_op

#------------------------------------------------------------
# CmpS
#------------------------------------------------------------
void
cvCmpS(src, value, dst, cmp_op)
	INPUT:
		const CvArr *src
		double value
		CvArr *dst
		int cmp_op

#------------------------------------------------------------
# InRange
#------------------------------------------------------------
void
cvInRange(src, lower, upper, dst)
	INPUT:
		const CvArr* src
		const CvArr* lower
		const CvArr* upper
		CvArr* 		 dst

#------------------------------------------------------------
# InRangeS
#------------------------------------------------------------
void
cvInRangeS(src, lower, upper, dst)
	INPUT:
		const CvArr* src
		CvScalar lower
		CvScalar upper
		CvArr* dst

#------------------------------------------------------------
# Max
#------------------------------------------------------------
void
cvMax(src1, src2, dst)
	INPUT:
		const CvArr* src1
		const CvArr* src2
		CvArr* dst

#------------------------------------------------------------
# MaxS
#------------------------------------------------------------
void
cvMaxS(src, value, dst)
	INPUT:
		const CvArr* src
		double value
		CvArr* dst

#------------------------------------------------------------
# Min
#------------------------------------------------------------
void
cvMin(src1, src2, dst)
	INPUT:
		const CvArr* src1
		const CvArr* src2
		CvArr* dst

#------------------------------------------------------------
# MinS
#------------------------------------------------------------
void
cvMinS(src, value, dst)
	INPUT:
		const CvArr* src
		double value
		CvArr* dst

#------------------------------------------------------------
# AbsDiff
#------------------------------------------------------------
void
cvAbsDiff(src1, src2, dst)
	INPUT:
		const CvArr* src1
		const CvArr* src2
		CvArr* dst

#------------------------------------------------------------
# AbsDiffS
#------------------------------------------------------------
void
cvAbsDiffS(src, dst, value)
	INPUT:
		const CvArr* src
		CvArr* dst
		CvScalar value

#------------------------------------------------------------
# CountNonZero
#------------------------------------------------------------
int
cvCountNonZero(arr)
	INPUT:
		const CvArr* arr

#------------------------------------------------------------
# Sum
#------------------------------------------------------------
SV *
cvSum(arr)
	INPUT:
		const CvArr* arr
	CODE:
		CvScalar scalar = cvSum(arr);
		int et = cvGetElemType(arr);
		int cn = CV_MAT_CN(et);
		int i;
		AV *results = (AV *)sv_2mortal((SV *)newAV());
		for (i = 0; i < cn; i++) {
			av_push(results, newSVnv(scalar.val[i]));
		}
		RETVAL = newRV((SV *)results);

#------------------------------------------------------------
# Avg
#------------------------------------------------------------
SV *
cvAvg(arr, mask)
	INPUT:
		const CvArr* arr
		const CvArr* mask
	CODE:
		CvScalar scalar = cvAvg(arr, mask);
		int et = cvGetElemType(arr);
		int cn = CV_MAT_CN(et);
		int i;
		AV *results = (AV *)sv_2mortal((SV *)newAV());
		for (i = 0; i < cn; i++) {
			av_push(results, newSVnv(scalar.val[i]));
		}
		RETVAL = newRV((SV *)results);

#------------------------------------------------------------
# AvgSdv
#------------------------------------------------------------
SV *
cvAvgSdv(arr, mask)
	INPUT:
		const CvArr* arr
		const CvArr* mask
	CODE:
		CvScalar avg, sdv;
		cvAvgSdv(arr, &avg, &sdv, mask);
		int et = cvGetElemType(arr);
		int cn = CV_MAT_CN(et);
		int i;
		AV *av = (AV *)sv_2mortal((SV *)newAV());
		for (i = 0; i < cn; i++) {
			HV *rh = (HV *)sv_2mortal((SV *)newHV());
			hv_store(rh, "avg", 3, newSVnv(avg.val[i]), 0);
			hv_store(rh, "sdv", 3, newSVnv(sdv.val[i]), 0);
			av_push(av, newRV((SV *)rh));
		}
		RETVAL = newRV((SV *)av);

#------------------------------------------------------------
# MinMaxLoc
#------------------------------------------------------------
void
cvMinMaxLoc(arr, min_val, max_val, min_loc, max_loc, mask)
	INPUT:
		const CvArr *arr
		double min_val = NO_INIT
		double max_val = NO_INIT
		CvPoint min_loc = NO_INIT
		CvPoint max_loc = NO_INIT
		const CvArr *mask
	CODE:
		cvMinMaxLoc(arr, &min_val, &max_val, &min_loc, &max_loc, mask);
	OUTPUT:
		min_val
		max_val
		min_loc
		max_loc

#------------------------------------------------------------
# Norm
#------------------------------------------------------------
double
cvNorm(arr1, arr2, norm_type, mask)
	INPUT:
		const CvArr* arr1
		const CvArr* arr2
		int norm_type
		const CvArr* mask

#------------------------------------------------------------
# Reduce
#------------------------------------------------------------
void
cvReduce(src, dst, dim, op)
	INPUT:
		const CvArr* src
		CvArr* dst
		int dim
		int op

#------------------------------------------------------------
# DotProduct
#------------------------------------------------------------
double
cvDotProduct(src1, src2)
	INPUT:
		const CvArr* src1
		const CvArr* src2

#------------------------------------------------------------
# Normalize
#------------------------------------------------------------
void
cvNormalize(src, dst, a, b, norm_type, mask)
	INPUT:
		const CvArr* src
		CvArr* dst
		double a
		double b
		int norm_type
		const CvArr* mask

#------------------------------------------------------------
# CrossProduct
#------------------------------------------------------------
void
cvCrossProduct(src1, src2, dst)
	INPUT:
		const CvArr* src1
		const CvArr* src2
		CvArr* dst

#------------------------------------------------------------
# ScaleAdd
#------------------------------------------------------------
void
cvScaleAdd(src1, scale, src2, dst)
	INPUT:
		const CvArr* src1
		CvScalar scale
		const CvArr* src2
		CvArr* dst

#------------------------------------------------------------
# GEMM
#------------------------------------------------------------
void
cvGEMM(src1, src2, alpha, src3, beta, dst, tABC)
	INPUT:
		const CvArr* src1
		const CvArr* src2
		double alpha
		const CvArr* src3
		double beta
		CvArr* dst
		int tABC

#------------------------------------------------------------
# Transform
#------------------------------------------------------------
void
cvTransform(src, dst, transmat, shiftvec)
	INPUT:
		const CvArr* src
		CvArr* dst
		const CvMat* transmat
		const CvMat* shiftvec

#------------------------------------------------------------
# PerspectiveTransform
#------------------------------------------------------------
void
cvPerspectiveTransform(src, dst, mat)
	INPUT:
		const CvArr* src
		CvArr* dst
		const CvMat* mat

#------------------------------------------------------------
# MulTransposed
#------------------------------------------------------------
void
cvMulTransposed(src, dst, order, delta, scale)
	INPUT:
		const CvArr* src
		CvArr* dst
		int order
		const CvArr* delta
		double scale

#------------------------------------------------------------
# Trace
#------------------------------------------------------------
SV *
cvTrace(mat)
	INPUT:
		const CvArr* mat
	CODE:
		CvScalar scalar = cvTrace(mat);
		int et = cvGetElemType(mat);
		int cn = CV_MAT_CN(et);
		int i;
		AV *results = (AV *)sv_2mortal((SV *)newAV());
		for (i = 0; i < cn; i++) {
			av_push(results, newSVnv(scalar.val[i]));
		}
		RETVAL = newRV((SV *)results);

#------------------------------------------------------------
# Transpose
#------------------------------------------------------------
void
cvTranspose(src, dst)
	INPUT:
		const CvArr* src
		CvArr* dst

#------------------------------------------------------------
# Det
#------------------------------------------------------------
double
cvDet(mat)
	INPUT:
		const CvArr* mat

#------------------------------------------------------------
# Invert
#------------------------------------------------------------
double
cvInvert(src, dst, method)
	INPUT:
		const CvArr* src
		CvArr* dst
		int method

#------------------------------------------------------------
# Solve
#------------------------------------------------------------

#------------------------------------------------------------
# SVD
#------------------------------------------------------------
void
cvSVD(A, W, U, V, flags)
	INPUT:
		CvArr* A
		CvArr* W
		CvArr* U
		CvArr* V
		int flags

#------------------------------------------------------------
# SVBkSb
#------------------------------------------------------------
void
cvSVBkSb(W, U, V, B, X, flags)
	INPUT:
		const CvArr* W
		const CvArr* U
		const CvArr* V
		const CvArr* B
		CvArr* X
		int flags

#------------------------------------------------------------
# EigenVV
#------------------------------------------------------------
void
cvEigenVV(mat, evects, evals, eps, lowindex, highindex)
	INPUT:
		CvArr* mat
		CvArr* evects
		CvArr* evals
		double eps
		int	   lowindex
		int	   highindex
	CODE:
#if CV_MAJOR_VERSION == 2
		cvEigenVV(mat, evects, evals, eps, lowindex, highindex);
#elif CV_MAJOR_VERSION == 1
		cvEigenVV(mat, evects, evals, eps);
#else
#error "?cvEigenVV"
#endif

#------------------------------------------------------------
# CalcCovarMatrix
#------------------------------------------------------------

#------------------------------------------------------------
# Mahalonobis
#------------------------------------------------------------
double
cvMahalanobis(vec1, vec2, mat)
	INPUT:
		const CvArr* vec1
		const CvArr* vec2
		CvArr* mat

#------------------------------------------------------------
# CalcPCA
#------------------------------------------------------------

#------------------------------------------------------------
# ProjectPCA
#------------------------------------------------------------

#------------------------------------------------------------
# BackProjectPCA
#------------------------------------------------------------

#------------------------------------------------------------
# Round, Floor, Ceil
#------------------------------------------------------------
int
cvRound( value )
	INPUT:
		double value

int
cvFloor( value )
	INPUT:
		double value

int
cvCeil( value )
	INPUT:
		double value

#------------------------------------------------------------
# Sqrt
#------------------------------------------------------------

#------------------------------------------------------------
# InvSqrt
#------------------------------------------------------------

#------------------------------------------------------------
# Cbrt
#------------------------------------------------------------

#------------------------------------------------------------
# FastArctan
#------------------------------------------------------------

#------------------------------------------------------------
# IsNaN
#------------------------------------------------------------

#------------------------------------------------------------
# IsInf
#------------------------------------------------------------

#------------------------------------------------------------
# CartToPolar
#------------------------------------------------------------

#------------------------------------------------------------
# PolarToCart
#------------------------------------------------------------

#------------------------------------------------------------
# Pow
#------------------------------------------------------------
void
cvPow(src, dst, pow)
	INPUT:
		const CvArr* src
		CvArr* dst
		double pow

#------------------------------------------------------------
# Exp
#------------------------------------------------------------

#------------------------------------------------------------
# Log
#------------------------------------------------------------
void
cvLog(src, dst)
	INPUT:
		const CvArr* src
		CvArr* dst

#------------------------------------------------------------
# SolveCubic
#------------------------------------------------------------

#------------------------------------------------------------
# SolvePoly
#------------------------------------------------------------
void
cvSolvePoly(coeffs, roots, maxiter, fig)
	INPUT:
		const CvMat* coeffs
		CvMat *roots
		int maxiter
		int fig
#if CV_MAJOR_VERSION == 2 || CV_MAJOR_VERSION == 1 && CV_MAJOR_MINOR > 0
	CODE:
		cvSolvePoly(coeffs, roots, maxiter, fig);
#endif

#------------------------------------------------------------
# RNG
#------------------------------------------------------------
CvRNG*
cvRNG(seed)
	INPUT:
		CvRNG seed
	CODE:
		RETVAL = (CvRNG*)malloc(sizeof(CvRNG));
		*RETVAL = cvRNG(seed);
	OUTPUT:
		RETVAL

void
cvReleaseRNG(rng)
	INPUT:
		CvRNG* rng
	CODE:
		if (rng) free(rng);
		rng = 0;

#------------------------------------------------------------
# RandArr
#------------------------------------------------------------
void
cvRandArr(rng, arr, dist_type, param1, param2)
	INPUT:
		CvRNG* rng
		CvArr* arr
		int dist_type
		CvScalar param1
		CvScalar param2
	CODE:
		cvRandArr(rng, arr, dist_type, param1, param2);
	OUTPUT:
		rng

#------------------------------------------------------------
# RandInt
#------------------------------------------------------------
unsigned
cvRandInt(rng)
	INPUT:
		CvRNG* rng
	CODE:
		RETVAL = cvRandInt(rng);
	OUTPUT:
		RETVAL
		rng

#------------------------------------------------------------
# RandReal
#------------------------------------------------------------
double
cvRandReal(rng)
	INPUT:
		CvRNG* rng
	CODE:
		RETVAL = cvRandReal(rng);
	OUTPUT:
		RETVAL
		rng

#------------------------------------------------------------
# DFT
#------------------------------------------------------------
void
cvDFT(src, dst, flags, nonzero_rows)
	INPUT:
		const CvArr* src
		CvArr* dst
		int flags
		int nonzero_rows

#------------------------------------------------------------
# GetOptimalDFTSize
#------------------------------------------------------------
int
cvGetOptimalDFTSize(size0)
	INPUT:
		int size0

#------------------------------------------------------------
# MulSpectrums
#------------------------------------------------------------

#------------------------------------------------------------
# DCT
#------------------------------------------------------------


#============================================================
#  Dynamic Structures
#============================================================

#------------------------------------------------------------
# CvMemStorage
#------------------------------------------------------------

#------------------------------------------------------------
# CvMemBlock
#------------------------------------------------------------

#------------------------------------------------------------
# CvMemStoragePos
#------------------------------------------------------------

#------------------------------------------------------------
# CreateMemStorage
#------------------------------------------------------------
CvMemStorage *
cvCreateMemStorage(block_size)
    INPUT:
        int block_size

#------------------------------------------------------------
# CreateChildMemStorage
#------------------------------------------------------------

#------------------------------------------------------------
# ReleaseMemStorage
#------------------------------------------------------------
void
cvReleaseMemStorage(storage)
    INPUT:
        CvMemStorage*& storage
    CODE:
        cvReleaseMemStorage(&storage);
	OUTPUT:
		storage

#------------------------------------------------------------
# ClearMemStorage
#------------------------------------------------------------
void
cvClearMemStorage(storage)
    INPUT:
        CvMemStorage* storage

#------------------------------------------------------------
# MemStorageAlloc
#------------------------------------------------------------

#------------------------------------------------------------
# MemStorageAllocString
#------------------------------------------------------------

#------------------------------------------------------------
# SaveMemStoragePos
#------------------------------------------------------------

#------------------------------------------------------------
# RestoreMemStoragePos
#------------------------------------------------------------

#------------------------------------------------------------
# CvSeq
#------------------------------------------------------------

#------------------------------------------------------------
# CvSeqBlock
#------------------------------------------------------------

#------------------------------------------------------------
# CvSlice
#------------------------------------------------------------

#------------------------------------------------------------
# CreateSeq
#------------------------------------------------------------
CvSeq*
cvCreateSeq(seq_flags, header_size, elem_size, storage)
	INPUT:
		int seq_flags
		int header_size
		int elem_size
		CvMemStorage* storage

#------------------------------------------------------------
# SetSeqBlockSize
#------------------------------------------------------------

#------------------------------------------------------------
# SeqPush
#------------------------------------------------------------
char *
cvSeqPush(seq, element)
	INPUT:
		CvSeq *seq
		SV* element
	CODE:
		if (CV_IS_SEQ(seq)) {
			int size = sv_len(element);
			if (seq->elem_size == size) {
				char *s = SvPV(element, size);
				RETVAL = (char *)cvSeqPush(seq, s);
			} else {
				RETVAL = (char *)0;
			}
		} else {
			RETVAL = (char *)0;
		}
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# SeqPop
#------------------------------------------------------------
SV *
cvSeqPop(seq)
	INPUT:
		CvSeq *seq
	CODE:
		if (CV_IS_SEQ(seq)) {
			char s[seq->elem_size];
			cvSeqPop(seq, s);
			RETVAL = newSVpvn(s, sizeof(s));
		} else {
			RETVAL = newSVpvn("", 0);
		}
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# SeqPushFront
#------------------------------------------------------------
char *
cvSeqPushFront(seq, element)
	INPUT:
		CvSeq *seq
		SV* element
	CODE:
		if (CV_IS_SEQ(seq)) {
			int size = sv_len(element);
			if (seq->elem_size == size) {
				char *s = SvPV(element, size);
				RETVAL = (char *)cvSeqPushFront(seq, s);
			} else {
				RETVAL = (char *)0;
			}
		} else {
			RETVAL = (char *)0;
		}
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# SeqPopFront
#------------------------------------------------------------
SV *
cvSeqPopFront(seq)
	INPUT:
		CvSeq *seq
	CODE:
		if (CV_IS_SEQ(seq)) {
			char s[seq->elem_size];
			cvSeqPopFront(seq, s);
			RETVAL = newSVpvn(s, sizeof(s));
		} else {
			RETVAL = newSVpvn("", 0);
		}
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# SeqPushMulti
#------------------------------------------------------------

#------------------------------------------------------------
# SeqPopMulti
#------------------------------------------------------------

#------------------------------------------------------------
# SeqInsert
#------------------------------------------------------------

#------------------------------------------------------------
# SeqRemove
#------------------------------------------------------------
void
cvSeqRemove(seq, index)
	INPUT:
		CvSeq* seq
		int index

#------------------------------------------------------------
# ClearSeq
#------------------------------------------------------------

#------------------------------------------------------------
# GetSeqElem
#------------------------------------------------------------
SV *
cvGetSeqElem(seq, index)
	INPUT:
		CvSeq* seq
		int index
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


#------------------------------------------------------------
# SeqElemIdx
#------------------------------------------------------------

#------------------------------------------------------------
# CvtSeqToArray
#------------------------------------------------------------
SV *
cvCvtSeqToArray(seq, element, slice)
	INPUT:
		const CvSeq* seq
		SV *element
		CvSlice slice
	CODE:
		AV *av_element;
		if (SvROK(element) && SvTYPE(SvRV(element)) == SVt_PVAV) {
			av_element = (AV*)SvRV(element);
			av_clear(av_element);
		} else {
			XSRETURN_UNDEF;
		}
		if (seq->total > 0) {
			CvPoint pt[seq->total]; int i;
			cvCvtSeqToArray(seq, pt, slice);
			for (i = 0; i < seq->total; i++) {
				HV *hv_point = (HV *)sv_2mortal((SV *)newHV());
				hv_store(hv_point, "x", 1, newSVnv(pt[i].x), 0);
				hv_store(hv_point, "y", 1, newSVnv(pt[i].y), 0);
				av_push(av_element, newRV((SV *)hv_point));
			}
		}
		RETVAL = newRV((SV *)av_element);
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# MakeSeqHeaderForArray
#------------------------------------------------------------

#------------------------------------------------------------
# SeqSlice
#------------------------------------------------------------
CvSeq*
cvSeqSlice(seq, start_index, end_index, storage, copy_data)
	INPUT:
		const CvSeq* seq
		int start_index
		int end_index
		CvMemStorage* storage
		int copy_data
	CODE:
		cvSeqSlice(seq, cvSlice(start_index, end_index), storage, copy_data);

#------------------------------------------------------------
# CloneSeq
#------------------------------------------------------------

#------------------------------------------------------------
# SeqRemoveSlice
#------------------------------------------------------------

#------------------------------------------------------------
# SeqInsertSlice
#------------------------------------------------------------

#------------------------------------------------------------
# SeqInvert
#------------------------------------------------------------

#------------------------------------------------------------
# SeqSort
#------------------------------------------------------------

#------------------------------------------------------------
# SeqSearch
#------------------------------------------------------------

#------------------------------------------------------------
# StartAppendToSeq
#------------------------------------------------------------

#------------------------------------------------------------
# StartWriteSeq
#------------------------------------------------------------

#------------------------------------------------------------
# EndWriteSeq
#------------------------------------------------------------

#------------------------------------------------------------
# FlushSeqWriter
#------------------------------------------------------------

#------------------------------------------------------------
# StartReadSeq
#------------------------------------------------------------
CvSeqReader*
cvStartReadSeq(seq, reverse)
	INPUT:
		const CvSeq* seq
		int reverse
	CODE:
		CvSeqReader* reader = (CvSeqReader*)malloc(sizeof(CvSeqReader));
		if (reader) cvStartReadSeq(seq, reader, reverse);
		RETVAL = reader;
	OUTPUT:
		RETVAL

void
cvReleaseReader(reader)
	INPUT:
		CvSeqReader* reader
	CODE:
		free(reader);

#------------------------------------------------------------
# GetSeqReaderPos
#------------------------------------------------------------

#------------------------------------------------------------
# SetSeqReaderPos
#------------------------------------------------------------

#------------------------------------------------------------
# CvSet
#------------------------------------------------------------

#------------------------------------------------------------
# CreateSet
#------------------------------------------------------------

#------------------------------------------------------------
# SetAdd
#------------------------------------------------------------

#------------------------------------------------------------
# SetRemove
#------------------------------------------------------------

#------------------------------------------------------------
# SetNew
#------------------------------------------------------------

#------------------------------------------------------------
# SetRemoveByPtr
#------------------------------------------------------------

#------------------------------------------------------------
# GetSetElem
#------------------------------------------------------------

#------------------------------------------------------------
# ClearSet
#------------------------------------------------------------

#------------------------------------------------------------
# CvGraph
#------------------------------------------------------------

#------------------------------------------------------------
# CreateGraph
#------------------------------------------------------------

#------------------------------------------------------------
# GraphAddVtx
#------------------------------------------------------------

#------------------------------------------------------------
# GraphRemoveVtx
#------------------------------------------------------------

#------------------------------------------------------------
# GraphRemoveVtxByPtr
#------------------------------------------------------------

#------------------------------------------------------------
# GetGraphVtx
#------------------------------------------------------------

#------------------------------------------------------------
# GraphVtxIdx
#------------------------------------------------------------

#------------------------------------------------------------
# GraphAddEdge
#------------------------------------------------------------

#------------------------------------------------------------
# GraphAddEdgeByPtr
#------------------------------------------------------------

#------------------------------------------------------------
# GraphRemoveEdge
#------------------------------------------------------------

#------------------------------------------------------------
# GraphRemoveEdgeByPtr
#------------------------------------------------------------

#------------------------------------------------------------
# FindGraphEdge
#------------------------------------------------------------

#------------------------------------------------------------
# FindGraphEdgeByPtr
#------------------------------------------------------------

#------------------------------------------------------------
# GraphEdgeIdx
#------------------------------------------------------------

#------------------------------------------------------------
# GraphVtxDegree
#------------------------------------------------------------

#------------------------------------------------------------
# GraphVtxDegreeByPtr
#------------------------------------------------------------

#------------------------------------------------------------
# ClearGraph
#------------------------------------------------------------

#------------------------------------------------------------
# CloneGraph
#------------------------------------------------------------

#------------------------------------------------------------
# CvGraphScanner
#------------------------------------------------------------

#------------------------------------------------------------
# CreateGraphScanner
#------------------------------------------------------------

#------------------------------------------------------------
# NextGraphItem
#------------------------------------------------------------

#------------------------------------------------------------
# ReleaseGraphScanner
#------------------------------------------------------------

#------------------------------------------------------------
# CV_TREE_NODE_FIELDS
#------------------------------------------------------------

#------------------------------------------------------------
# CvTreeNodeIterator
#------------------------------------------------------------

#------------------------------------------------------------
# InitTreeNodeIterator
#------------------------------------------------------------

#------------------------------------------------------------
# NextTreeNode
#------------------------------------------------------------

#------------------------------------------------------------
# PrevTreeNode
#------------------------------------------------------------

#------------------------------------------------------------
# TreeToNodeSeq
#------------------------------------------------------------

#------------------------------------------------------------
# InsertNodeIntoTree
#------------------------------------------------------------

#------------------------------------------------------------
# RemoveNodeFromTree
#------------------------------------------------------------


#============================================================
#  Drawing Functions
#============================================================

#------------------------------------------------------------
# CV_RGB
#------------------------------------------------------------

#------------------------------------------------------------
# Line
#------------------------------------------------------------
void
cvLine(img, pt1, pt2, color, thickness, line_type, shift)
	INPUT:
		CvArr* img
		CvPoint pt1
		CvPoint pt2
		CvScalar color
		int thickness
		int line_type
		int shift

#------------------------------------------------------------
# Rectangle
#------------------------------------------------------------
void
cvRectangle(img, pt1, pt2, color, thickness, line_type, shift)
	INPUT:
		CvArr* img
		CvPoint pt1
		CvPoint pt2
		CvScalar color
		int thickness
		int line_type
		int shift

#------------------------------------------------------------
# Circle
#------------------------------------------------------------
void
cvCircle(img, center, radius, color, thickness, line_type, shift)
	INPUT:
		CvArr* img
		CvPoint center
		int radius
		CvScalar color
		int thickness
		int line_type
		int shift

#------------------------------------------------------------
# Ellipse
#------------------------------------------------------------
void
cvEllipse(img, center, axes, angle, start_angle, end_angle, color, thickness, line_type, shift)
	INPUT:
		CvArr* img
		CvPoint center
		CvSize axes
		double angle
		double start_angle
		double end_angle
		CvScalar color
		int thickness
		int line_type
		int shift

#------------------------------------------------------------
# EllipseBox
#------------------------------------------------------------
void
cvEllipseBox(img, box, color, thickness, line_type, shift)
	INPUT:
		CvArr* img
		CvBox2D box
		CvScalar color
		int thickness
		int line_type
		int shift
		

#------------------------------------------------------------
# FillPoly
#------------------------------------------------------------
int
cvFillPoly(img, pts, npts, contours, color, line_type, shift)
	INPUT:
		CvArr* img
		SV *pts
		SV *npts
		int contours
		CvScalar color
		int line_type
		int shift
	CODE:
		if (SvROK(pts)) {
			if (SvTYPE(SvRV(pts)) == SVt_PVAV) {
				int i, j;
				CvPoint* cvpts[contours];
				int cvnpts[contours];
				for (i = 0; i < contours; i++) {
                    int n = SvNV(*av_fetch((AV *)SvRV(npts), i, 0));
                    cvnpts[i] = max(n, 1);
                    cvpts[i] = (CvPoint*)alloca(sizeof(CvPoint)*cvnpts[i]);
                }
				for (i = 0; i < contours; i++) {
					SV *sv = (SV *)(*av_fetch((AV *)SvRV(pts), i, 0));
                    if (SvTYPE(SvRV(sv)) == SVt_PVAV) {
                        for (j = 0; j < cvnpts[i]; j++) {
                            SV *pt = (SV *)(*av_fetch((AV *)SvRV(sv), j, 0));
                            if (!xspoint(pt, &cvpts[i][j])) {
                                XSRETURN(0);
                            }
                        }
                    }
                }
				cvFillPoly(img, cvpts, cvnpts, contours, color, line_type, shift);
                XSRETURN(1);
			}
		}
        XSRETURN(0);

#------------------------------------------------------------
# FillConvexPoly
#------------------------------------------------------------
void
cvFillConvexPoly(img, pts, color, line_type, shift)
	INPUT:
		CvArr* img
		SV *pts
		CvScalar color
		int line_type
		int shift
	CODE:
		if (SvROK(pts) && SvTYPE(SvRV(pts)) == SVt_PVAV) {
			int i, n = av_len((AV *)SvRV(pts)) + 1;
			if (n > 0) {
				CvPoint cvpts[n];
				for (i = 0; i < n; i++) {
					SV *sv = (SV *)(*av_fetch((AV *)SvRV(pts), i, 0));
					if (!xspoint(sv, &cvpts[i])) break;
				}
				if (i == n) {
					cvFillConvexPoly(img, cvpts, n, color, line_type, shift);
				}
			}
		}

#------------------------------------------------------------
# PolyLine
#------------------------------------------------------------
void
cvPolyLine(img, pts, npts, contours, is_closed, color, thickness, line_type, shift)
	INPUT:
		CvArr* img
		SV *pts
		SV *npts
		int contours
		int is_closed
		CvScalar color
		int thickness
		int line_type
		int shift
	CODE:
		if (SvROK(pts) && SvTYPE(SvRV(pts)) == SVt_PVAV) {
			int i, j;
			CvPoint* cvpts[contours];
			int cvnpts[contours];
			for (i = 0; i < contours; i++) {
				int n = SvNV(*av_fetch((AV *)SvRV(npts), i, 0));
				cvnpts[i] = max(n, 1);
				cvpts[i] = (CvPoint*)alloca(sizeof(CvPoint)*cvnpts[i]);
			}
			for (i = 0; i < contours; i++) {
				SV *sv = (SV *)(*av_fetch((AV *)SvRV(pts), i, 0));
				if (SvTYPE(SvRV(sv)) == SVt_PVAV) {
					for (j = 0; j < cvnpts[i]; j++) {
						SV *pt = (SV *)(*av_fetch((AV *)SvRV(sv), j, 0));
						if (!xspoint(pt, &cvpts[i][j])) break;
					}
					if (j < cvnpts[i]) break;
				}
			}
			if (i >= contours) {
				cvPolyLine(img, cvpts, cvnpts, contours, is_closed, color, thickness, line_type, shift);
			}
		}

#------------------------------------------------------------
# InitFont
#------------------------------------------------------------
CvFont *
cvInitFont(font_face, hscale, vscale, shear, thickness, line_type)
	INPUT:
		int font_face
		double hscale
		double vscale
		double shear
		int thickness
		int line_type
	CODE:
		CvFont* font = (CvFont *)malloc(sizeof(*font));
		if (!font) Perl_croak(aTHX_ "cvInitFont: no core");
		cvInitFont(font, font_face, hscale, vscale, shear, thickness, line_type);
		RETVAL = font;
	OUTPUT:
		RETVAL

void
cvReleaseFont(font)
	INPUT:
		CvFont *font
	CODE:
		free((void *)font);
		font = (CvFont*)0;
	OUTPUT:
		font

#------------------------------------------------------------
# PutText
#------------------------------------------------------------
void
cvPutText(img, text, org, font, color)
	INPUT:
		CvArr* img
		const char* text
		CvPoint org
		CvFont *font
		CvScalar color

#------------------------------------------------------------
# GetTextSize
#------------------------------------------------------------
SV *
cvGetTextSize(text_string, font)
	INPUT:
		const char *text_string;
		const CvFont *font;
	CODE:
		AV *results = (AV *)sv_2mortal((SV *)newAV());
		CvSize text_size; int baseline = 0;
		cvGetTextSize(text_string, font, &text_size, &baseline);
		av_push(results, newSVnv(text_size.width));
		av_push(results, newSVnv(text_size.height));
		av_push(results, newSVnv(baseline));
		RETVAL = newRV((SV *)results);
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# DrawContours
#------------------------------------------------------------
void
cvDrawContours(img, contour, external_color, hole_color, max_level, thickness, line_type, offset)
	INPUT:
		CvArr *img
		CvSeq* contour
		CvScalar external_color
		CvScalar hole_color
		int max_level
		int thickness
		int line_type
		CvPoint offset

#------------------------------------------------------------
# InitLineIterator
#------------------------------------------------------------

#------------------------------------------------------------
# ClipLine
#------------------------------------------------------------

#------------------------------------------------------------
# Ellipse2Poly
#------------------------------------------------------------


# ===========================================================
#  Data Persistence and RTTI
# ===========================================================

#------------------------------------------------------------
# CvFileStorage
#------------------------------------------------------------

#------------------------------------------------------------
# CvFileNode
#------------------------------------------------------------

#------------------------------------------------------------
# CvAttrList
#------------------------------------------------------------
CvAttrList
cvAttrList(attr, next)
	INPUT:
		const char* attr
		CvAttrList* next
	CODE:
		cvAttrList(&attr, next);

#------------------------------------------------------------
# OpenFileStorage
#------------------------------------------------------------
CvFileStorage*
cvOpenFileStorage(filename, memstorage, flags)
	INPUT:
		const char* filename
		CvMemStorage* memstorage
		int flags

#------------------------------------------------------------
# ReleaseFileStorage
#------------------------------------------------------------
void
cvReleaseFileStorage(fs)
	INPUT:
		CvFileStorage* fs
	CODE:
		cvReleaseFileStorage(&fs);
	OUTPUT:
		fs


#------------------------------------------------------------
# StartWriteStruct
#------------------------------------------------------------

#------------------------------------------------------------
# EndWriteStruct
#------------------------------------------------------------

#------------------------------------------------------------
# WriteInt
#------------------------------------------------------------

#------------------------------------------------------------
# WriteReal
#------------------------------------------------------------

#------------------------------------------------------------
# WriteString
#------------------------------------------------------------

#------------------------------------------------------------
# WriteComment
#------------------------------------------------------------

#------------------------------------------------------------
# StartNextStream
#------------------------------------------------------------

#------------------------------------------------------------
# Write
#------------------------------------------------------------
void
cvWrite(fs, name, ptr, attributes)
	INPUT:
		CvFileStorage* fs
		const char* name
		const void* ptr
		CvAttrList attributes

#------------------------------------------------------------
# WriteRawData
#------------------------------------------------------------

#------------------------------------------------------------
# WriteFileNode
#------------------------------------------------------------

#------------------------------------------------------------
# GetRootFileNode
#------------------------------------------------------------

#------------------------------------------------------------
# GetFileNodeByName
#------------------------------------------------------------
CvFileNode*
cvGetFileNodeByName(fs, map, name)
	INPUT:
		const CvFileStorage* fs
		const CvFileNode* map
		const char* name


#------------------------------------------------------------
# GetHashedKey
#------------------------------------------------------------

#------------------------------------------------------------
# GetFileNode
#------------------------------------------------------------

#------------------------------------------------------------
# GetFileNodeName
#------------------------------------------------------------

#------------------------------------------------------------
# ReadInt
#------------------------------------------------------------

#------------------------------------------------------------
# ReadIntByName
#------------------------------------------------------------

#------------------------------------------------------------
# ReadReal
#------------------------------------------------------------

#------------------------------------------------------------
# ReadRealByName
#------------------------------------------------------------

#------------------------------------------------------------
# ReadString
#------------------------------------------------------------

#------------------------------------------------------------
# ReadStringByName
#------------------------------------------------------------

#------------------------------------------------------------
# Read
#------------------------------------------------------------
void*
cvRead(fs, node, attributes)
	INPUT:
		CvFileStorage* fs
		CvFileNode* node
		CvAttrList* attributes


#------------------------------------------------------------
# ReadByName
#------------------------------------------------------------

#------------------------------------------------------------
# ReadRawData
#------------------------------------------------------------

#------------------------------------------------------------
# StartReadRawData
#------------------------------------------------------------

#------------------------------------------------------------
# ReadRawDataSlice
#------------------------------------------------------------

#------------------------------------------------------------
# CvTypeInfo
#------------------------------------------------------------

#------------------------------------------------------------
# RegisterType
#------------------------------------------------------------

#------------------------------------------------------------
# UnregisterType
#------------------------------------------------------------

#------------------------------------------------------------
# FirstType
#------------------------------------------------------------

#------------------------------------------------------------
# FindType
#------------------------------------------------------------

#------------------------------------------------------------
# TypeOf
#------------------------------------------------------------

#------------------------------------------------------------
# Release
#------------------------------------------------------------

#------------------------------------------------------------
# Clone
#------------------------------------------------------------

#------------------------------------------------------------
# Save
#------------------------------------------------------------

#------------------------------------------------------------
# Load
#------------------------------------------------------------
void*
cvLoad(filename, memstorage, name, real_name)
	INPUT:
		const char* filename
		CvMemStorage* memstorage
		const char* name
		const char* real_name
	CODE:
		RETVAL = cvLoad(filename, memstorage, name, &real_name);
	OUTPUT:
		RETVAL

CvHaarClassifierCascade*
cvLoadCascade(filename)
	INPUT:
		const char* filename
	CODE:
		RETVAL = cvLoad(filename, 0, 0, 0);
	OUTPUT:
		RETVAL

# ===========================================================
#  Miscellaneous Functions
# ===========================================================

#------------------------------------------------------------
# CheckArr
#------------------------------------------------------------

#------------------------------------------------------------
# KMeans2
#------------------------------------------------------------
void
cvKMeans2(samples, cluster_count, labels, termcrit)
	INPUT:
		const CvArr* samples
		int cluster_count
		CvArr* labels
		CvTermCriteria termcrit
	CODE:
#if CV_MAJOR_VERSION == 2
		int attempts = 1;
		CvRNG* rng = 0;
		int flags = 0;
		CvArr* _centers = 0;
		double* compactness = 0;
		cvKMeans2(samples, cluster_count, labels, termcrit, attempts, rng, flags, _centers, compactness);
#elif CV_MAJOR_VERSION == 1
		cvKMeans2(samples, cluster_count, labels, termcrit);
#else
#error "?cvKMeans2"
#endif

#------------------------------------------------------------
# SeqPartition
#------------------------------------------------------------


# ===========================================================
#  Error Handling and System Functions
# ===========================================================

#------------------------------------------------------------
# ERROR Handling Macros
#------------------------------------------------------------

#------------------------------------------------------------
# GetErrStatus
#------------------------------------------------------------

#------------------------------------------------------------
# SetErrStatus
#------------------------------------------------------------

#------------------------------------------------------------
# GetErrMode
#------------------------------------------------------------

#------------------------------------------------------------
# SetErrMode
#------------------------------------------------------------

#------------------------------------------------------------
# Error
#------------------------------------------------------------

#------------------------------------------------------------
# ErrorStr
#------------------------------------------------------------

#------------------------------------------------------------
# RedirectError
#------------------------------------------------------------

#------------------------------------------------------------
# cvNulDevReport
#------------------------------------------------------------

#------------------------------------------------------------
# cvStdErrReport
#------------------------------------------------------------

#------------------------------------------------------------
# cvGuiBoxReport
#------------------------------------------------------------

#------------------------------------------------------------
# Alloc
#------------------------------------------------------------

#------------------------------------------------------------
# Free
#------------------------------------------------------------

#------------------------------------------------------------
# GetTickCount
#------------------------------------------------------------

#------------------------------------------------------------
# GetTickFrequency
#------------------------------------------------------------

#------------------------------------------------------------
# RegisterModule
#------------------------------------------------------------

#------------------------------------------------------------
# GetModuleInfo
#------------------------------------------------------------

#------------------------------------------------------------
# UseOptimized
#------------------------------------------------------------

#------------------------------------------------------------
# SetMemoryManager
#------------------------------------------------------------

#------------------------------------------------------------
# SetIPLAllocators
#------------------------------------------------------------

#------------------------------------------------------------
# GetNumThreads
#------------------------------------------------------------

#------------------------------------------------------------
# SetNumThreads
#------------------------------------------------------------

#------------------------------------------------------------
# GetThreadNum
#------------------------------------------------------------


# ######################################################################
#   CV
#   - http://opencv.jp/opencv-1.1.0_org/docs/ref/opencvref_cv.htm
# ######################################################################

# ===========================================================
#  Image Processing
# ===========================================================

#------------------------------------------------------------
# Sobel
#------------------------------------------------------------
void
cvSobel(image, edges, xorder, yorder, aperture_size)
	INPUT:
		const CvArr* image
		CvArr* edges
		int xorder
		int yorder
		int aperture_size

#------------------------------------------------------------
# Laplace
#------------------------------------------------------------
void
cvLaplace(src, dst, aperture_size)
	INPUT:
		const CvArr* src
		CvArr* dst
		int aperture_size

#------------------------------------------------------------
# Canny
#------------------------------------------------------------
void
cvCanny(image, edges, threshold1, threshold2, aperture_size)
	INPUT:
		const CvArr* image
		CvArr* edges
		double threshold1
		double threshold2
		int aperture_size

#------------------------------------------------------------
# PreCornerDetect
#------------------------------------------------------------

#------------------------------------------------------------
# CornerEigenValsAndVecs
#------------------------------------------------------------

#------------------------------------------------------------
# CornerMinEigenVal
#------------------------------------------------------------

#------------------------------------------------------------
# CornerHarris
#------------------------------------------------------------

#------------------------------------------------------------
# FindCornerSubPix
#------------------------------------------------------------
int
cvFindCornerSubPix(image, corners, win, zero_zone, criteria)
	INPUT:
		const CvArr* image
		SV* corners
		CvSize win
		CvSize zero_zone
		CvTermCriteria criteria
	CODE:
		RETVAL = -1;
		if (SvROK(corners) && SvTYPE(SvRV(corners)) == SVt_PVAV) {
			int count = av_len((AV *)SvRV(corners)) + 1;
			if (count > 0) {
				CvPoint2D32f cv_corners[count]; int i;
				for (i = 0; i < count; i++) {
					SV *sv = (SV *)(*av_fetch((AV *)SvRV(corners), i, 0));
					if (!xspoint2d32f(sv, &cv_corners[i])) XSRETURN(-1);
				}
				cvFindCornerSubPix(
					image, cv_corners, count, win, zero_zone, criteria);
				AV *av_corners = (AV*)SvRV(corners);
				av_clear(av_corners);
				for (i = 0; i < count; i++) {
					HV *hv = (HV *)sv_2mortal((SV *)newHV());
					hv_store(hv, "x", 1, newSVnv(cv_corners[i].x), 0);
					hv_store(hv, "y", 1, newSVnv(cv_corners[i].y), 0);
					av_push(av_corners, newRV((SV*)hv));
				}
			}
			RETVAL = count;
		}
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# GoodFeaturesToTrack
#------------------------------------------------------------
int
cvGoodFeaturesToTrack(image, eig_image, temp_image, corners, corner_count, quality_level, min_distance, mask, block_size, use_harris, k)
	INPUT:
		const CvArr* image
		CvArr* eig_image
		CvArr* temp_image
		SV* corners
		int corner_count
		double quality_level
		double min_distance
		const CvArr* mask
		int block_size
		int use_harris
		double k
	CODE:
		RETVAL = 0;
		if (corner_count > 0) {
			int original_corner_count = corner_count;
			CvPoint2D32f cv_corners[corner_count];
			cvGoodFeaturesToTrack(
				image, eig_image, temp_image, cv_corners, &corner_count,
				quality_level, min_distance, mask, block_size, use_harris, k);
			int i;
			AV *av_corners = (AV*)SvRV(corners);
			av_clear(av_corners);
			for (i = 0; i < corner_count; i++) {
				HV *hv = (HV *)sv_2mortal((SV *)newHV());
				hv_store(hv, "x", 1, newSVnv(cv_corners[i].x), 0);
				hv_store(hv, "y", 1, newSVnv(cv_corners[i].y), 0);
				av_push(av_corners, newRV((SV*)hv));
			}
			RETVAL = corner_count;
		}
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# ExtractSURF
#------------------------------------------------------------

#------------------------------------------------------------
# SampleLine
#------------------------------------------------------------

#------------------------------------------------------------
# GetRectSubPix
#------------------------------------------------------------
void
cvGetRectSubPix(src, dst, center)
	INPUT:
		const CvArr* src
		CvArr* 		 dst
		CvPoint2D32f center

#------------------------------------------------------------
# GetQuadrangleSubPix
#------------------------------------------------------------
void
cvGetQuadrangleSubPix(src, dst, map_matrix)
	INPUT:
		const CvArr* src
		CvArr* dst
		const CvMat* map_matrix

#------------------------------------------------------------
# Resize
#------------------------------------------------------------
void
cvResize(src, dst, interpolation)
	INPUT:
		const CvArr* src
		CvArr* dst
		int interpolation

#------------------------------------------------------------
# WarpAffine
#------------------------------------------------------------

#------------------------------------------------------------
# GetAffineTransform
#------------------------------------------------------------

#------------------------------------------------------------
# WarpPerspective
#------------------------------------------------------------

#------------------------------------------------------------
# GetPerspectiveTransform
#------------------------------------------------------------

#------------------------------------------------------------
# Remap
#------------------------------------------------------------
void
cvRemap(src, dst, mapx, mapy, flags, fillval)
	INPUT:
		const CvArr* src
		CvArr* dst
		const CvArr* mapx
		const CvArr* mapy
		int flags
		CvScalar fillval

#------------------------------------------------------------
# LogPolar
#------------------------------------------------------------

#------------------------------------------------------------
# CreateStructuringElementEx
#------------------------------------------------------------
IplConvKernel *
cvCreateStructuringElementEx(cols, rows, anchor_x, anchor_y, shape, values)
	INPUT:
		int cols
		int rows
		int anchor_x
		int anchor_y
		int shape
		SV * values
	CODE:
		IplConvKernel *element =
			cvCreateStructuringElementEx(cols, rows, anchor_x, anchor_y, shape, (int *)0);
		RETVAL = element;
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# ReleaseStructuringElement
#------------------------------------------------------------
void
cvReleaseStructuringElement(element)
	INPUT:
		IplConvKernel* element
	CODE:
		cvReleaseStructuringElement(&element);
	OUTPUT:
		element

#------------------------------------------------------------
# Erode
#------------------------------------------------------------
void
cvErode(src, dst, element, iterations)
	INPUT:
		const CvArr* src
		CvArr* dst
		IplConvKernel* element
		int iterations

#------------------------------------------------------------
# Dilate
#------------------------------------------------------------
void
cvDilate(src, dst, element, iterations)
	INPUT:
		const CvArr* src
		CvArr* dst
		IplConvKernel* element
		int iterations

#------------------------------------------------------------
# MorphologyEx
#------------------------------------------------------------
void
cvMorphologyEx(src, dst, temp, element, operation, iterations)
	INPUT:
		const CvArr* src
		CvArr* dst
		CvArr* temp
		IplConvKernel* element
		int operation
		int iterations

#------------------------------------------------------------
# Smooth
#------------------------------------------------------------
void
cvSmooth(src, dst, smoothtype, size1, size2, sigma1, sigma2)
	INPUT:
		const CvArr* src
		CvArr* dst
		int smoothtype
		int size1
		int size2
		double sigma1
		double sigma2

#------------------------------------------------------------
# Filter2D
#------------------------------------------------------------
void
cvFilter2D(src, dst, kernel, anchor)
	INPUT:
		CvArr* src
		CvArr* dst
		CvMat* kernel
		CvPoint anchor

#------------------------------------------------------------
# CopyMakeBorder
#------------------------------------------------------------

#------------------------------------------------------------
# Integral
#------------------------------------------------------------

#------------------------------------------------------------
# CvtColor
#------------------------------------------------------------
void
cvCvtColor(src, dst, code)
	INPUT:
		const CvArr* src
		CvArr* dst
		int code

#------------------------------------------------------------
# Threshold
#------------------------------------------------------------
void
cvThreshold(src, dst, threshold, max_value, threshold_type)
	INPUT:
		const CvArr* src
		CvArr* dst
		double threshold
		double max_value
		int threshold_type

#------------------------------------------------------------
# AdaptiveThreshold
#------------------------------------------------------------
void
cvAdaptiveThreshold(src, dst, max_value, adaptive_method, threshold_type, block_size, param1)
	INPUT:
		const CvArr* src
		CvArr* dst
		double max_value
		int adaptive_method
		int threshold_type
		int block_size
		double param1

#------------------------------------------------------------
# PyrDown
#------------------------------------------------------------
void
cvPyrDown(src, dst, filter)
	INPUT:
		const CvArr* src
		CvArr* dst
		int filter

#------------------------------------------------------------
# PyrUp
#------------------------------------------------------------
void
cvPyrUp(src, dst, filter)
	INPUT:
		const CvArr* src
		CvArr* dst
		int filter

#------------------------------------------------------------
# CvConnectedComp
#------------------------------------------------------------

#------------------------------------------------------------
# FloodFill
#------------------------------------------------------------
void
cvFloodFill(image, seed_point, new_val, lo_diff, up_diff, comp, flags, mask)
	INPUT:
		CvArr* image
		CvPoint seed_point
		CvScalar new_val
		CvScalar lo_diff
		CvScalar up_diff
		CvConnectedComp* comp
		int flags
		CvArr* mask

#------------------------------------------------------------
# FindContours
#------------------------------------------------------------
int
cvFindContours(image, storage, contour, header_size, mode, method, offset)
	INPUT:
		CvArr* image
		CvMemStorage* storage
		CvSeq* contour = NO_INIT
		int header_size
		int mode
		int method
		CvPoint offset
	CODE:
		RETVAL = cvFindContours(image, storage, (CvSeq **)&contour, header_size, mode, method, offset);
	OUTPUT:
		RETVAL
		contour

#------------------------------------------------------------
# StartFindContours
#------------------------------------------------------------

#------------------------------------------------------------
# FindNextContour
#------------------------------------------------------------

#------------------------------------------------------------
# SubstituteContour
#------------------------------------------------------------

#------------------------------------------------------------
# EndFindContours
#------------------------------------------------------------

#------------------------------------------------------------
# PyrSegmentation
#------------------------------------------------------------
void
cvPyrSegmentation(src, dst, storage, comp, level, threshold1, threshold2)
	INPUT:
		IplImage* src
		IplImage* dst
		CvMemStorage* storage
		CvSeq* comp = NO_INIT
		int level
		double threshold1
		double threshold2
	CODE:
		cvPyrSegmentation(src, dst, storage, &comp, level, threshold1, threshold2);
	OUTPUT:
		comp

#------------------------------------------------------------
# PyrMeanShiftFiltering
#------------------------------------------------------------

#------------------------------------------------------------
# Watershed
#------------------------------------------------------------
void
cvWatershed(image, markers)
	INPUT:
		const CvArr* image
		CvArr* markers

#------------------------------------------------------------
# Moments
#------------------------------------------------------------
CvMoments*
cvMoments(arr, binary)
	INPUT:
		const CvArr* arr
		int binary
	CODE:
		RETVAL = (CvMoments*) malloc(sizeof(CvMoments));
		cvMoments(arr, RETVAL, binary);
	OUTPUT:
		RETVAL

void
cvReleaseMoments(moments)
	INPUT:
		CvMoments* moments;
	CODE:
		free(moments); moments = 0;
	OUTPUT:
		moments

#------------------------------------------------------------
# GetSpatialMoment
#------------------------------------------------------------
double
cvGetSpatialMoment(moments, x_order, y_order)
	INPUT:
		CvMoments* moments
		int x_order
		int y_order

#------------------------------------------------------------
# GetCentralMoment
#------------------------------------------------------------
double
cvGetCentralMoment(moments, x_order, y_order)
	INPUT:
		CvMoments* moments
		int x_order
		int y_order

#------------------------------------------------------------
# GetNormalizedCentralMoment
#------------------------------------------------------------
double
cvGetNormalizedCentralMoment(moments, x_order, y_order)
	INPUT:
		CvMoments* moments
		int x_order
		int y_order

#------------------------------------------------------------
# GetHuMoments
#------------------------------------------------------------
CvHuMoments*
cvGetHuMoments(moments)
	INPUT:
		CvMoments* moments
	CODE:
		RETVAL = (CvHuMoments*) malloc(sizeof(CvHuMoments));
		cvGetHuMoments(moments, RETVAL);
	OUTPUT:
		RETVAL

void
cvReleaseHuMoments(hu_moments)
	INPUT:
		CvHuMoments* hu_moments
	CODE:
		free(hu_moments); hu_moments = 0;
	OUTPUT:
		hu_moments

#------------------------------------------------------------
# HoughLines2
#------------------------------------------------------------
CvSeq *
cvHoughLines2(image, storage, method, rho, theta, threshold, param1, param2)
	INPUT:
		CvArr* image
		CvMemStorage* storage
		int method
		double rho
		double theta
		int threshold
		double param1
		double param2

#------------------------------------------------------------
# HoughCircles
#------------------------------------------------------------
CvSeq*
cvHoughCircles(image, storage, method, dp, min_dist, param1, param2, min_radius, max_radius)
	INPUT:
		CvArr* image
		CvMemStorage *storage
		int method
		double dp
		double min_dist
		double param1
		double param2
		int min_radius
		int max_radius

#------------------------------------------------------------
# DistTransform
#------------------------------------------------------------
void
cvDistTransform( src, dst, distance_type, mask_size, mask, labels )
	INPUT:
		const CvArr* src
		CvArr* dst
		int distance_type
		int mask_size
		const float* mask
		CvArr* labels
	CODE:
		cvDistTransform( src, dst, distance_type, mask_size, mask, labels );

#------------------------------------------------------------
# Inpaint
#------------------------------------------------------------
void
cvInpaint(src, mask, dst, inpaintRadius, flags)
	INPUT:
		const CvArr* src
		const CvArr* mask
		CvArr* dst
		double inpaintRadius
		int flags

#------------------------------------------------------------
# CvHistogram
#------------------------------------------------------------

#------------------------------------------------------------
# CreateHist
#------------------------------------------------------------
CvHistogram*
cvCreateHist( dims, sz, type, rgs, uniform );
	INPUT:
		int dims
		SV* sz
		int type
		SV* rgs
		int uniform
	CODE:
		CvHistogram* hist;
		int sizes[dims]; int i;
		for (i = 0; i < dims; i++) {
			sizes[i] = SvNV(*av_fetch((AV *)SvRV(sz), i, 0));
		}
 		if (SvROK(rgs) && SvTYPE(SvRV(rgs)) == SVt_PVAV) {		
			float range[dims][2]; float *ranges[dims];
			for (i = 0; i < dims; i++) {
				AV *p = (AV *)*av_fetch((AV *)SvRV(rgs), i, 0);
				float a = SvNV(*av_fetch((AV *)SvRV(p), 0, 0));
				float b = SvNV(*av_fetch((AV *)SvRV(p), 1, 0));
				if (a > b) { range[i][1] = a; range[i][0] = b; }
				else       { range[i][0] = a; range[i][1] = b; }
				ranges[i] = range[i];
			}
			if (0) {
				printf("int dims = %d\n", dims);
				printf("int sizes[] = {\n");
				for (i = 0; i < dims; i++) {
					printf(" %d,", sizes[i]);
				}
				printf("\n};\n");
				printf("int ranges[] = {\n");
				for (i = 0; i < dims; i++) {
					printf(" { %g, %g },\n", range[i][0], range[i][1]);
				}
				printf("\n};\n");
			}
			RETVAL = cvCreateHist(dims, sizes, type, ranges, uniform);
		} else {
			RETVAL = cvCreateHist(dims, sizes, type, NULL, uniform);
		}
	OUTPUT:
		RETVAL


#------------------------------------------------------------
# SetHistBinRanges
#------------------------------------------------------------

#------------------------------------------------------------
# ReleaseHist
#------------------------------------------------------------
void
cvReleaseHist( hist )
	INPUT:
		CvHistogram* hist
	CODE:
		cvReleaseHist(&hist);

#------------------------------------------------------------
# ClearHist
#------------------------------------------------------------
void
cvClearHist(hist)
	INPUT:
		CvHistogram* hist

#------------------------------------------------------------
# MakeHistHeaderForArray
#------------------------------------------------------------

#------------------------------------------------------------
# QueryHistValue_*D
#------------------------------------------------------------
double
cvQueryHistValue_1D(hist, idx0)
	INPUT:
		CvHistogram *hist
		int idx0


double
cvQueryHistValue_2D(hist, idx0, idx1)
	INPUT:
		CvHistogram *hist
		int idx0
		int idx1

double
cvQueryHistValue_3D(hist, idx0, idx1, idx2)
	INPUT:
		CvHistogram *hist
		int idx0
		int idx1
		int idx2

#------------------------------------------------------------
# GetHistValue_*D
#------------------------------------------------------------

#------------------------------------------------------------
# GetMinMaxHistValue
#------------------------------------------------------------
SV *
cvGetMinMaxHistValue(hist)
	INPUT:
		const CvHistogram* hist
	INIT:
		float min_val;
		float max_val;
		int	  min_idx[4];
		int	  max_idx[4];

		HV *rh = (HV *)sv_2mortal((SV *)newHV());
		HV *rh_min = (HV *)sv_2mortal((SV *)newHV());
		HV *rh_max = (HV *)sv_2mortal((SV *)newHV());
	CODE:
		cvGetMinMaxHistValue(hist, &min_val, &max_val, min_idx, max_idx);
		int dims = hist->mat.dims; int i;
		// fprintf(stderr, "dims = %d\n", dims);

		HV *hv_min = (HV *)sv_2mortal((SV *)newHV());
		HV *hv_max = (HV *)sv_2mortal((SV *)newHV());
		AV *av_min = (AV *)sv_2mortal((SV *)newAV());
		AV *av_max = (AV *)sv_2mortal((SV *)newAV());
		hv_store(hv_min, "val", 3, newSVnv(min_val), 0);
		hv_store(hv_max, "val", 3, newSVnv(max_val), 0);

		for (i = 0; i < dims; i++) {
			av_push(av_min, newSVnv(min_idx[i]));
			av_push(av_max, newSVnv(max_idx[i]));
		}

		hv_store(hv_min, "idx", 3, newRV((SV *)av_min), 0);
		hv_store(hv_max, "idx", 3, newRV((SV *)av_max), 0);

		HV *hv = (HV *)sv_2mortal((SV *)newHV());
		hv_store(hv, "min", 3, newRV((SV *)hv_min), 0);
		hv_store(hv, "max", 3, newRV((SV *)hv_max), 0);
		RETVAL = newRV((SV *)hv);
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# NormalizeHist
#------------------------------------------------------------
void
cvNormalizeHist(hist, factor)
	INPUT:
		CvHistogram* hist
		double factor

#------------------------------------------------------------
# ThreshHist
#------------------------------------------------------------
void
cvThreshHist(hist, threshold)
	INPUT:
		CvHistogram* hist
		double threshold

#------------------------------------------------------------
# CompareHist
#------------------------------------------------------------
double
cvCompareHist(hist1, hist2, method)
	INPUT:
		CvHistogram* hist1
		CvHistogram* hist2
		int method

#------------------------------------------------------------
# CopyHist
#------------------------------------------------------------
void
cvCopyHist(src, dst)
	INPUT:
		const CvHistogram* src
		CvHistogram* dst
	CODE:
		cvCopyHist(src, &dst);
	OUTPUT:
		dst

#------------------------------------------------------------
# CalcHist
#------------------------------------------------------------
int
cvCalcHist( imgs, hist, accumulate, mask );
	INPUT:
		SV* imgs
		CvHistogram* hist
		int accumulate
		const CvArr* mask
	CODE:
 		if (SvROK(imgs) && SvTYPE(SvRV(imgs)) == SVt_PVAV) {
            int nimg = av_len((AV *)SvRV(imgs)) + 1;
			IplImage *images[nimg];
			int i;
            for (i = 0; i < nimg; i++) {
                SV* p = (SV *)(*av_fetch((AV *)SvRV(imgs), i, 0));
                images[i] = INT2PTR(IplImage *, SvIV(SvRV(p)));
			}
			cvCalcHist(images, hist, accumulate, mask);
			RETVAL = 1;
		} else {
			RETVAL = 0;
		}
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# CalcBackProject
#------------------------------------------------------------
int
cvCalcBackProject(imgs, back_project, hist)
	INPUT:
		SV* imgs
		CvArr* back_project
		const CvHistogram* hist
	CODE:
		if (SvROK(imgs) && SvTYPE(SvRV(imgs)) == SVt_PVAV) {
            int nimg = av_len((AV *)SvRV(imgs)) + 1;
			IplImage *images[nimg];
			int i;
            for (i = 0; i < nimg; i++) {
                SV* p = (SV *)(*av_fetch((AV *)SvRV(imgs), i, 0));
                images[i] = INT2PTR(IplImage *, SvIV(SvRV(p)));
			}
			cvCalcBackProject(images, back_project, hist);
			RETVAL = 1;
		} else {
			RETVAL = 0;
		}
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# CalcBackProjectPatch
#------------------------------------------------------------
int
cvCalcBackProjectPatch(images, dst, hist, patch_size, method, factor)
	INPUT:
		SV* images
		CvArr *dst
		CvSize patch_size
		CvHistogram* hist
		int method
		double factor
	CODE:
		if (SvROK(images) && SvTYPE(SvRV(images)) == SVt_PVAV) {
			int n = av_len((AV *)SvRV(images)) + 1, i; IplImage *cvimages[n];
			for (i = 0; i < n; i++) {
				SV* p = (SV *)(*av_fetch((AV *)SvRV(images), i, 0));
				cvimages[i] = INT2PTR(IplImage *, SvIV(SvRV(p)));
			}
			cvCalcBackProjectPatch(cvimages, dst, patch_size, hist, method, factor);
			RETVAL = 1;
		} else {
			RETVAL = 0;
		}
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# CalcProbDensity
#------------------------------------------------------------

#------------------------------------------------------------
# EqualizeHist
#------------------------------------------------------------
void
cvEqualizeHist( src, dst )
	INPUT:
		const CvArr* src
		CvArr* dst

void
cvScaleHist( hist1, hist2, scale, shift )
    INPUT:
        CvHistogram *hist1
        CvHistogram *hist2
        double scale
        double shift
    CODE:
        CvArr *src = hist1->bins;
        CvArr *dst = hist2->bins;
        cvConvertScale(src, dst, scale, shift);


#------------------------------------------------------------
# MatchTemplate
#------------------------------------------------------------
void
cvMatchTemplate(image, templ, result, method)
	INPUT:
		const CvArr* image
		const CvArr* templ
		CvArr* result
		int method

#------------------------------------------------------------
# MatchShapes
#------------------------------------------------------------

#------------------------------------------------------------
# CalcEMD2
#------------------------------------------------------------


# ===========================================================
#  Structural Analysis
# ===========================================================

#------------------------------------------------------------
# ApproxChains
#------------------------------------------------------------
CvSeq*
cvApproxChains(src_seq, storage, method, parameter, minimal_perimeter, recursive)
	INPUT:
		CvSeq* src_seq
		CvMemStorage* storage
		int method
		double parameter
		int minimal_perimeter
		int recursive

#------------------------------------------------------------
# StartReadChainPoints
#------------------------------------------------------------

#------------------------------------------------------------
# ReadChainPoint
#------------------------------------------------------------

#------------------------------------------------------------
# ApproxPoly
#------------------------------------------------------------
CvSeq*
cvApproxPoly(src_seq, header_size, storage, method, parameter, parameter2)
	INPUT:
		const CvSeq* src_seq
		int header_size
		CvMemStorage* storage
		int method
		double parameter
		int parameter2
	CODE:
		if (parameter < 0) parameter *= -cvArcLength(src_seq, CV_WHOLE_SEQ, -1);
		RETVAL = cvApproxPoly(src_seq, header_size, storage, method, parameter, parameter2);
	OUTPUT:
		RETVAL
		header_size

#------------------------------------------------------------
# BoundingRect
#------------------------------------------------------------
CvRect
cvBoundingRect(points, update)
	INPUT:
		CvArr* points
		int update
	CODE:
		RETVAL = cvBoundingRect(points, update);
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# ContourArea
#------------------------------------------------------------
double
cvContourArea(contour, slice)
	INPUT:
		const CvArr* contour
		CvSlice slice

#------------------------------------------------------------
# ArcLength
#------------------------------------------------------------
double
cvArcLength(curve, slice, is_closed)
	INPUT:
		const CvSeq* curve
		CvSlice slice
		int is_closed

#------------------------------------------------------------
# CreateContourTree
#------------------------------------------------------------

#------------------------------------------------------------
# ContourFromContourTree
#------------------------------------------------------------

#------------------------------------------------------------
# MatchContourTrees
#------------------------------------------------------------

#------------------------------------------------------------
# MaxRect
#------------------------------------------------------------
CvRect
_cvMaxRect(rect1, rect2)
	INPUT:
		CvRect rect1
		CvRect rect2
	CODE:
		RETVAL = cvMaxRect(&rect1, &rect2);
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# CvBox2D
#------------------------------------------------------------

#------------------------------------------------------------
# PointSeqFromMat
#------------------------------------------------------------

#------------------------------------------------------------
# BoxPoints
#------------------------------------------------------------
void
_cvBoxPoints(box, pt4)
	INPUT:
		CvBox2D box
		CvPoint2D32f4 pt4 = NO_INIT
	CODE:
		cvBoxPoints(box, pt4.pt);
	OUTPUT:
		pt4

#------------------------------------------------------------
# FitEllipse
#------------------------------------------------------------
CvBox2D32f
cvFitEllipse2(points)
	INPUT:
		const CvArr* points

#------------------------------------------------------------
# FitLine
#------------------------------------------------------------
int
cvFitLine(points, dist_type, param, reps, aeps, line)
	INPUT:
		const CvArr* points
		int dist_type
		double param
		double reps
		double aeps
		SV* line
	CODE:
		int cn;
		if (CV_IS_MAT(points)) {
			int et = cvGetElemType(points);
			cn = CV_MAT_CN(et);
		} else if (CV_IS_SEQ(points)) {
			int et = CV_SEQ_ELTYPE((CvSeq*)points);
			if (et == CV_SEQ_POINT3D_SET) {
				cn = 3;
			} else if (et == CV_SEQ_POINT_SET) {
				cn = 2;
			} else {
				cn = -1;
			}
		} else {
			cn = -1;
		}
		RETVAL = cn;
		if (cn > 0) {
			int n = 2*cn; int i;
			float cv_line[n];
			cvFitLine(points, dist_type, param, reps, aeps, cv_line);
			AV *av_line = (AV*)SvRV(line); av_clear(av_line);
			for (i = 0; i < n; i++) {
				av_push(av_line, newSVnv(cv_line[i]));
			}
		}
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# ConvexHull2
#------------------------------------------------------------
CvSeq*
cvConvexHull2(input, storage, orientation, return_points)
	INPUT:
		const CvArr* input
		CvMemStorage* storage
		int orientation
		int return_points

#------------------------------------------------------------
# CheckContourConvexity
#------------------------------------------------------------
int
cvCheckContourConvexity(contour)
	INPUT:
		const CvArr* contour

#------------------------------------------------------------
# CvConvexityDefect
#------------------------------------------------------------

#------------------------------------------------------------
# ConvexityDefects
#------------------------------------------------------------

#------------------------------------------------------------
# PointPolygonTest
#------------------------------------------------------------
double
cvPointPolygonTest(contour,	pt, measure_dist)
	INPUT:
		const CvArr* contour
		CvPoint2D32f pt
		int measure_dist

#------------------------------------------------------------
# MinAreaRect2
#------------------------------------------------------------
CvBox2D
cvMinAreaRect2(points, storage)
	INPUT:
		const CvArr* points
		CvMemStorage* storage

#------------------------------------------------------------
# MinEnclosingCircle
#------------------------------------------------------------
SV*
cvMinEnclosingCircle(points)
	INPUT:
		const CvArr* points
	CODE:
		CvPoint2D32f center; float radius;
		if (!cvMinEnclosingCircle(points, &center, &radius)) XSRETURN_UNDEF;
		HV *hv = (HV *)sv_2mortal((SV *)newHV());
		HV *hv_center = (HV *)sv_2mortal((SV *)newHV());
		hv_store(hv_center, "x", 1, newSVnv(center.x), 0);
		hv_store(hv_center, "y", 1, newSVnv(center.y), 0);
		hv_store(hv, "center", 6, newRV((SV *)hv_center), 0);
		hv_store(hv, "radius", 6, newSVnv(radius), 0);
		RETVAL = newRV((SV *)hv);
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# CalcPGH
#------------------------------------------------------------
void
cvCalcPGH(contour, hist)
	INPUT:
		const CvSeq *contour
		CvHistogram* hist

#------------------------------------------------------------
# CvQuadEdge2D
#------------------------------------------------------------

#------------------------------------------------------------
# CvSubdiv2DPoint
#------------------------------------------------------------

#------------------------------------------------------------
# Subdiv2DGetEdge
#------------------------------------------------------------
CvSubdiv2DEdge
cvSubdiv2DGetEdge(edge, type)
	INPUT:
		CvSubdiv2DEdge edge
		CvNextEdgeType type

#------------------------------------------------------------
# Subdiv2DRotateEdge
#------------------------------------------------------------
CvSubdiv2DEdge
cvSubdiv2DRotateEdge(edge, rotate)
	INPUT:
		CvSubdiv2DEdge edge
		int rotate

#------------------------------------------------------------
# Subdiv2DEdgeOrg
#------------------------------------------------------------
CvSubdiv2DPoint
cvSubdiv2DEdgeOrg(edge)
	INPUT:
		CvSubdiv2DEdge edge
	CODE:
		CvSubdiv2DPoint *pt = cvSubdiv2DEdgeOrg(edge);
		if (pt) {
			RETVAL = *pt;
		} else {
			XSRETURN_UNDEF;
		}
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# Subdiv2DEdgeDst
#------------------------------------------------------------
CvSubdiv2DPoint
cvSubdiv2DEdgeDst(edge)
	INPUT:
		CvSubdiv2DEdge edge
	CODE:
		CvSubdiv2DPoint *pt = cvSubdiv2DEdgeDst(edge);
		if (pt) {
			RETVAL = *pt;
		} else {
			XSRETURN_UNDEF;
		}
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# CreateSubdivDelaunay2D
#------------------------------------------------------------
CvSubdiv2D*
cvCreateSubdivDelaunay2D(rect, storage)
	INPUT:
		CvRect rect
		CvMemStorage* storage

#------------------------------------------------------------
# SubdivDelaunay2DInsert
#------------------------------------------------------------
CvSubdiv2DPoint
cvSubdivDelaunay2DInsert(subdiv, pt)
	INPUT:
		CvSubdiv2D* subdiv
		CvPoint2D32f pt
	CODE:
		CvSubdiv2DPoint *p = cvSubdivDelaunay2DInsert(subdiv, pt);
		if (p) {
			RETVAL = *p;
		}
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# Subdiv2DLocate
#------------------------------------------------------------
CvSubdiv2DPointLocation
cvSubdiv2DLocate(subdiv, pt, edge, vertex)
	INPUT:
		CvSubdiv2D* subdiv
		CvPoint2D32f pt
		CvSubdiv2DEdge edge
		SV* vertex
	CODE:
		CvSubdiv2DPoint* p = 0;
		RETVAL = cvSubdiv2DLocate(subdiv, pt, &edge, &p);
		if (SvROK(vertex) && SvTYPE(SvRV(vertex)) == SVt_PVHV) {
			HV *hv = (HV*)SvRV(vertex);
			hv_clear(hv);
			if (p) {
				hv_store(hv, "flags", 5, newSViv(p->flags), 0);
				hv_store(hv, "edge",  4, newSViv(p->first), 0);
				hv_store(hv, "pt",    2, (SV*)plpoint2d32f(p->pt), 0);
			}
		}
	OUTPUT:
		RETVAL
		edge
		vertex

#------------------------------------------------------------
# FindNearestPoint2D
#------------------------------------------------------------

#------------------------------------------------------------
# CalcSubdivVoronoi2D
#------------------------------------------------------------
void
cvCalcSubdivVoronoi2D(subdiv)
	INPUT:
		CvSubdiv2D* subdiv

#------------------------------------------------------------
# ClearSubdivVoronoi2D
#------------------------------------------------------------


# ===========================================================
#  Motion Analysis and Object Tracking
# ===========================================================

#------------------------------------------------------------
# Acc
#------------------------------------------------------------
void
cvAcc(img, sum, mask)
	INPUT:
		const CvArr* img
		CvArr* sum
		const CvArr* mask

#------------------------------------------------------------
# SquareAcc
#------------------------------------------------------------

#------------------------------------------------------------
# MultiplyAcc
#------------------------------------------------------------

#------------------------------------------------------------
# RunningAvg
#------------------------------------------------------------
void
cvRunningAvg(image, acc, alpha, mask)
	INPUT:
		const CvArr* image
		CvArr*		  acc
		double 		  alpha
		const CvArr*  mask

#------------------------------------------------------------
# UpdateMotionHistory
#------------------------------------------------------------
void
cvUpdateMotionHistory(silhouette, mhi, timestamp, duration)
	INPUT:
		const CvArr* silhouette
		CvArr* mhi
		double timestamp
		double duration

#------------------------------------------------------------
# CalcMotionGradient
#------------------------------------------------------------
void
cvCalcMotionGradient(mhi, mask, orientation, delta1, delta2, aperture_size)
	INPUT:
		const CvArr* mhi
		CvArr* mask
		CvArr* orientation
		double delta1
		double delta2
		int aperture_size

#------------------------------------------------------------
# CalcGlobalOrientation
#------------------------------------------------------------
double
cvCalcGlobalOrientation(orientation, mask, mhi, timestamp, duration)
	INPUT:
		const CvArr* orientation
		const CvArr* mask
		const CvArr* mhi
		double timestamp
		double duration

#------------------------------------------------------------
# SegmentMotion
#------------------------------------------------------------
CvSeq*
cvSegmentMotion(mhi, seg_mask, storage, timestamp, seg_thresh)
	INPUT:
		const CvArr* mhi
		CvArr* seg_mask
		CvMemStorage* storage
		double timestamp
		double seg_thresh

#------------------------------------------------------------
# MeanShift
#------------------------------------------------------------

#------------------------------------------------------------
# CamShift
#------------------------------------------------------------
SV*
cvCamShift(prob_image, window)
	INPUT:
		const CvArr* prob_image
		CvRect window;
	INIT:
		HV *rh_rect = (HV *)sv_2mortal((SV *)newHV());
		HV *rh_center = (HV *)sv_2mortal((SV *)newHV());
		HV *rh_size = (HV *)sv_2mortal((SV *)newHV());
		HV *rh_comp = (HV *)sv_2mortal((SV *)newHV());
		HV *rh_box = (HV *)sv_2mortal((SV *)newHV());
		HV *rh = (HV *)sv_2mortal((SV *)newHV());
	CODE:
		CvTermCriteria criteria = cvTermCriteria( CV_TERMCRIT_EPS | CV_TERMCRIT_ITER, 10, 1 );
		CvConnectedComp comp;
		CvBox2D box;
		cvCamShift( prob_image, window, criteria, &comp, &box );

		hv_store(rh_rect, "x", 1, newSVnv(comp.rect.x), 0);
		hv_store(rh_rect, "y", 1, newSVnv(comp.rect.y), 0);
		hv_store(rh_rect, "width", 5, newSVnv(comp.rect.width), 0);
		hv_store(rh_rect, "height", 6, newSVnv(comp.rect.height), 0);

		hv_store(rh_comp, "area", 4, newSVnv(comp.area), 0);
//		hv_store(rh_comp, "value", 5, newSVnv(comp.value), 0);
		hv_store(rh_comp, "rect", 4, newRV((SV *)rh_rect), 0);

		hv_store(rh_center, "x", 1, newSVnv(box.center.x), 0);
		hv_store(rh_center, "y", 1, newSVnv(box.center.y), 0);
		hv_store(rh_size, "width", 5, newSVnv(box.size.width), 0);
		hv_store(rh_size, "height", 6, newSVnv(box.size.height), 0);

		hv_store(rh_box, "center", 6, newRV((SV *)rh_center), 0);
		hv_store(rh_box, "size", 4, newRV((SV *)rh_size), 0);
		hv_store(rh_box, "angle", 5, newSVnv(box.angle), 0);

		hv_store(rh, "comp", 4, newRV((SV *)rh_comp), 0);
		hv_store(rh, "box", 3, newRV((SV *)rh_box), 0);

		RETVAL = newRV((SV *)rh);
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# SnakeImage
#------------------------------------------------------------

#------------------------------------------------------------
# CalcOpticalFlowHS
#------------------------------------------------------------

#------------------------------------------------------------
# CalcOpticalFlowLK
#------------------------------------------------------------

#------------------------------------------------------------
# CalcOpticalFlowBM
#------------------------------------------------------------

#------------------------------------------------------------
# CalcOpticalFlowPyrLK
#------------------------------------------------------------
void
cvCalcOpticalFlowPyrLK(prev, curr, prev_pyr, curr_pyr, prev_features, curr_features, win_size, level, status, track_error, criteria, flags)
	INPUT:
		const CvArr* prev
		const CvArr* curr
		CvArr* prev_pyr
		CvArr* curr_pyr
		SV* prev_features
		SV* curr_features
		CvSize win_size
		int level
		SV* status
		SV* track_error
		CvTermCriteria criteria
		int flags
	CODE:
		if (!prev_features || !SvROK(prev_features) ||
			SvTYPE(SvRV(prev_features)) != SVt_PVAV) {
			Perl_croak(aTHX_ "cvCalcOpticalFlowPyrLK: prev_features is not PVAV");
		}
		if (!curr_features || !SvROK(curr_features) ||
			SvTYPE(SvRV(curr_features)) != SVt_PVAV) {
			Perl_croak(aTHX_ "cvCalcOpticalFlowPyrLK: curr_features is not PVAV");
		}
		AV *av_status = (AV*)0;
		if (status) {
			if (!SvROK(status) || SvTYPE(SvRV(status)) != SVt_PVAV) {
				Perl_croak(aTHX_ "cvCalcOpticalFlowPyrLK: status is not PVAV");
			}
			av_status = (AV*)SvRV(status);
			av_clear(av_status);
		}
		AV *av_track_error = (AV*)0;
		if (track_error) {
			if (!SvROK(track_error) || SvTYPE(SvRV(track_error)) != SVt_PVAV) {
				Perl_croak(aTHX_ "cvCalcOpticalFlowPyrLK: track_error is not PVAV");
			}
			av_track_error = (AV*)SvRV(track_error);
			av_clear(av_track_error);
		}
		int prev_count = av_len((AV *)SvRV(prev_features)) + 1; int i;
		if (prev_count > 0) {
			CvPoint2D32f cv_prev_features[prev_count];
			CvPoint2D32f cv_curr_features[prev_count];
			float cv_track_error[prev_count];
			char cv_status[prev_count];
			for (i = 0; i < prev_count; i++) {
				SV *sv = (SV *)(*av_fetch((AV *)SvRV(prev_features), i, 0));
				if (!xspoint2d32f(sv, &cv_prev_features[i])) {
					Perl_croak(aTHX_ "cvCalcOpticalFlowPyrLK: prev_features[%d] is not CvPoint2d32f", i);
				}
			}
			cvCalcOpticalFlowPyrLK(
				prev, curr, prev_pyr, curr_pyr,
				cv_prev_features, cv_curr_features,
				prev_count, win_size, level, cv_status,
				cv_track_error, criteria, flags);

			AV *av_features = (AV*)SvRV(curr_features);
			av_clear(av_features);
			for (i = 0; i < prev_count; i++) {
				HV *hv = plpoint2d32f(cv_curr_features[i]);
				av_push(av_features, newRV((SV*)hv));
				if (av_status) {
					av_push(av_status, newSViv(cv_status[i]));
				}
				if (track_error) {
					av_push(av_track_error, newSViv(cv_track_error[i]));
				}
			}
		}


#------------------------------------------------------------
# CreateFeatureTree
#------------------------------------------------------------

#------------------------------------------------------------
# ReleaseFeatureTree
#------------------------------------------------------------

#------------------------------------------------------------
# FindFeatures
#------------------------------------------------------------

#------------------------------------------------------------
# FindFeaturesBoxed
#------------------------------------------------------------

#------------------------------------------------------------
# CreateKalman
#------------------------------------------------------------
CvKalman*
cvCreateKalman(dynam_params, measure_params, control_params)
	INPUT:
		int dynam_params
		int measure_params
		int control_params

#------------------------------------------------------------
# ReleaseKalman
#------------------------------------------------------------
void
cvReleaseKalman(kalman)
	INPUT:
		CvKalman* kalman
	CODE:
		cvReleaseKalman(&kalman);
	OUTPUT:
		kalman

#------------------------------------------------------------
# KalmanPredict
#------------------------------------------------------------
const CvMat*
cvKalmanPredict(kalman, control)
	INPUT:
		CvKalman* kalman
		const CvMat* control

#------------------------------------------------------------
# KalmanCorrect
#------------------------------------------------------------
const CvMat*
cvKalmanCorrect(kalman, measurement)
	INPUT:
		CvKalman* kalman
		const CvMat* measurement

#------------------------------------------------------------
# CvConDensation
#------------------------------------------------------------

#------------------------------------------------------------
# CreateConDensation
#------------------------------------------------------------

#------------------------------------------------------------
# ReleaseConDensation
#------------------------------------------------------------

#------------------------------------------------------------
# ConDensInitSampleSet
#------------------------------------------------------------

#------------------------------------------------------------
# ConDensUpdateByTime
#------------------------------------------------------------


# ===========================================================
#  Pattern Recognition
# ===========================================================

#------------------------------------------------------------
# CvHaarFeature, CvHaarClassifier, CvHaarStageClassifier, CvHaarClassifierCascade
#------------------------------------------------------------

#------------------------------------------------------------
# cvLoadHaarClassifierCascade
#------------------------------------------------------------

#------------------------------------------------------------
# cvReleaseHaarClassifierCascade
#------------------------------------------------------------

#------------------------------------------------------------
# cvHaarDetectObjects
#------------------------------------------------------------
CvSeq*
cvHaarDetectObjects(image, cascade, storage, scale_factor, min_neighbors, flags, min_size)
	INPUT:
		const CvArr* image
		CvHaarClassifierCascade* cascade
		CvMemStorage* storage
		double scale_factor
		int min_neighbors
		int flags
		CvSize min_size

#------------------------------------------------------------
# cvSetImagesForHaarClassifierCascade
#------------------------------------------------------------

#------------------------------------------------------------
# cvRunHaarClassifierCascade
#------------------------------------------------------------

#------------------------------------------------------------
# ProjectPoints2
#------------------------------------------------------------
void
cvProjectPoints2(object_points, rotation_vector, translation_vector, intrinsic_matrix, distortion_coeffs, image_points, dpdrot, dpdt, dpdf, dpdc, dpddist, aspect_ratio)
	INPUT:
		const CvMat* object_points
		const CvMat* rotation_vector
		const CvMat* translation_vector
		const CvMat* intrinsic_matrix
		const CvMat* distortion_coeffs
		CvMat* image_points
		CvMat* dpdrot
		CvMat* dpdt
		CvMat* dpdf
		CvMat* dpdc
		CvMat* dpddist
		double aspect_ratio

#------------------------------------------------------------
# FindHomography
#------------------------------------------------------------
void
cvFindHomography(src_points, dst_points, homography, method, ransacReprojThreshold, mask)
	INPUT:
		const CvMat* src_points
		const CvMat* dst_points
		CvMat* homography
		int method
		double ransacReprojThreshold
		CvMat* mask


#------------------------------------------------------------
# CalibrateCamera2
#------------------------------------------------------------
void
cvCalibrateCamera2(objectPoints, imagePoints, pointCounts, imageSize, cameraMatrix, distCoeffs, rvecs, tvecs, flags)
	INPUT:
		const CvMat* objectPoints
		const CvMat* imagePoints
		const CvMat* pointCounts
		CvSize imageSize
		CvMat* cameraMatrix
		CvMat* distCoeffs
		CvMat* rvecs
		CvMat* tvecs
		int flags

#------------------------------------------------------------
# CalibrationMatrixValues
#------------------------------------------------------------

#------------------------------------------------------------
# FindExtrinsicCameraParams2
#------------------------------------------------------------
void
cvFindExtrinsicCameraParams2(object_points, image_points, intrinsic_matrix, distortion_coeffs, rotation_vector, translation_vector, useExtrinsicGuess)
	INPUT:
		const CvMat* object_points
		const CvMat* image_points
		const CvMat* intrinsic_matrix
		const CvMat* distortion_coeffs
		CvMat* rotation_vector
		CvMat* translation_vector
		int useExtrinsicGuess
	CODE:
#if CV_MAJOR_VERSION == 2
		cvFindExtrinsicCameraParams2(object_points,
									 image_points,
									 intrinsic_matrix,
									 distortion_coeffs,
									 rotation_vector,
									 translation_vector,
									 useExtrinsicGuess);
#elif CV_MAJOR_VERSION == 1
	    cvFindExtrinsicCameraParams2(object_points,
									image_points,
									intrinsic_matrix,
									distortion_coeffs,
									rotation_vector,
									translation_vector);
#else
#error "?cvFindExtrinsicCameraParams2"
#endif


#------------------------------------------------------------
# StereoCalibrate
#------------------------------------------------------------
void
cvStereoCalibrate(object_points, image_points1, image_points2, point_counts, camera_matrix1, dist_coeffs1, camera_matrix2, dist_coeffs2, image_size, R, T, E, F, term_crit, flags)
	INPUT:
		const CvMat* object_points
		const CvMat* image_points1
		const CvMat* image_points2
		const CvMat* point_counts
		CvMat* camera_matrix1
		CvMat* dist_coeffs1
		CvMat* camera_matrix2
		CvMat* dist_coeffs2
		CvSize image_size
		CvMat* R
		CvMat* T
		CvMat* E
		CvMat* F
		CvTermCriteria term_crit
		int flags


#------------------------------------------------------------
# StereoRectify
#------------------------------------------------------------
void
cvStereoRectify(camera_matrix1, camera_matrix2, dist_coeffs1, dist_coeffs2, image_size, R, T, R1, R2, P1, P2, Q, flags)
	INPUT:
		const CvMat* camera_matrix1
		const CvMat* camera_matrix2
		const CvMat* dist_coeffs1
		const CvMat* dist_coeffs2
		CvSize image_size
		const CvMat* R
		const CvMat* T
		CvMat* R1
		CvMat* R2
		CvMat* P1
		CvMat* P2
		CvMat* Q
		int flags

#------------------------------------------------------------
# StereoRectifyUncalibrated
#------------------------------------------------------------
void
cvStereoRectifyUncalibrated(points1, points2, F, image_size, H1, H2, threshold)
	INPUT:
		const CvMat* points1
		const CvMat* points2
		const CvMat* F
		CvSize image_size
		CvMat* H1
		CvMat* H2
		double threshold

#------------------------------------------------------------
# Rodrigues2
#------------------------------------------------------------
int
cvRodrigues2(src, dst, jacobian)
	INPUT:
		const CvMat* src
		CvMat* dst
		CvMat* jacobian


#------------------------------------------------------------
# Undistort2
#------------------------------------------------------------
void
cvUndistort2(src, dst, intrinsic_matrix, distortion_coeffs)
	INPUT:
		const CvArr* src
		CvArr* dst
		const CvMat* intrinsic_matrix
		const CvMat* distortion_coeffs


#------------------------------------------------------------
# InitUndistortMap
#------------------------------------------------------------
void
cvInitUndistortMap(camera_matrix, distortion_coeffs, mapx, mapy)
	INPUT:
		const CvMat* camera_matrix
		const CvMat* distortion_coeffs
		CvArr* mapx
		CvArr* mapy


#------------------------------------------------------------
# InitUndistortRectifyMap
#------------------------------------------------------------
void
cvInitUndistortRectifyMap(camera_matrix, dist_coeffs, R, new_camera_matrix, mapx, mapy)
	INPUT:
		const CvMat* camera_matrix
		const CvMat* dist_coeffs
		const CvMat* R
		const CvMat* new_camera_matrix
		CvArr* mapx
		CvArr* mapy

#------------------------------------------------------------
# UndistortPoints
#------------------------------------------------------------
void
cvUndistortPoints(src, dst, camera_matrix, dist_coeffs, R, P)
	INPUT:
		const CvMat* src
		CvMat* dst
		const CvMat* camera_matrix
		const CvMat* dist_coeffs
		const CvMat* R
		const CvMat* P

#------------------------------------------------------------
# FindChessboardCorners
#------------------------------------------------------------
int
cvFindChessboardCorners(image, pattern_size, corners, corner_count, flags)
	INPUT:
		const CvArr* image
		CvSize pattern_size
		SV* corners
		int corner_count = NO_INIT
		int flags
	CODE:
		CvPoint2D32f cv_corners[pattern_size.width * pattern_size.height];
		RETVAL = cvFindChessboardCorners(image, pattern_size, cv_corners, &corner_count, flags);
		AV *av_corners = (AV*)SvRV(corners); av_clear(av_corners); int i;
		for (i = 0; i < corner_count; i++) {
			av_push(av_corners, newRV((SV*)plpoint2d32f(cv_corners[i])));
		}
	OUTPUT:
		RETVAL
		corners 
		corner_count 

#------------------------------------------------------------
# DrawChessBoardCorners
#------------------------------------------------------------
void
cvDrawChessboardCorners(image, pattern_size, corners, count, pattern_was_found)
	INPUT:
		CvArr* image
		CvSize pattern_size
		SV* corners
		int count
		int pattern_was_found
	CODE:
		if (SvROK(corners) && SvTYPE(SvRV(corners)) == SVt_PVAV) {
			CvPoint2D32f cv_corners[count]; int i;
			for (i = 0; i < count; i++) {
				SV *sv = (SV*)(*av_fetch((AV *)SvRV(corners), i, 0));
				if (!xspoint2d32f(sv, &cv_corners[i]))
				   break;
			}
			if (i == count)
				cvDrawChessboardCorners(image, pattern_size, cv_corners, count,
										pattern_was_found);
		}


#------------------------------------------------------------
# CreatePOSITObject
#------------------------------------------------------------
CvPOSITObject*
cvCreatePOSITObject(points, point_count)
	INPUT:
		CvPoint3D32f* points
		int point_count


#------------------------------------------------------------
# POSIT
#------------------------------------------------------------
void
cvPOSIT(posit_object, image_points, focal_length, criteria, rotation_matrix, translation_vector)
	INPUT:
		CvPOSITObject* posit_object
		CvPoint2D32f* image_points
		double focal_length
		CvTermCriteria criteria
		CvMatr32f rotation_matrix
		CvVect32f translation_vector


#------------------------------------------------------------
# ReleasePOSITObject
#------------------------------------------------------------
void
cvReleasePOSITObject(posit_object)
	INPUT:
		CvPOSITObject* posit_object
	CODE:
		cvReleasePOSITObject(&posit_object);
	OUTPUT:
		posit_object

#------------------------------------------------------------
# CalcImageHomography
#------------------------------------------------------------
void
cvCalcImageHomography(line, center, intrinsic, homography)
	INPUT:
		float* line
		CvPoint3D32f* center
		float* intrinsic
		float* homography


#------------------------------------------------------------
# FindFundamentalMat
#------------------------------------------------------------
int
cvFindFundamentalMat(points1, points2, fundamental_matrix, method, param1, param2, status)
	INPUT:
		const CvMat* points1
		const CvMat* points2
		CvMat* fundamental_matrix
		int method
		double param1
		double param2
		CvMat* status

#------------------------------------------------------------
# ComputeCorrespondEpilines
#------------------------------------------------------------
void
cvComputeCorrespondEpilines(points, which_image, fundamental_matrix, correspondent_lines)
	INPUT:
		const CvMat* points
		int which_image
		const CvMat* fundamental_matrix
		CvMat* correspondent_lines

#------------------------------------------------------------
# ConvertPointsHomogeneous
#------------------------------------------------------------
void
cvConvertPointsHomogeneous(src, dst)
	INPUT:
		const CvMat* src
		CvMat* dst

#------------------------------------------------------------
# CvStereoBMState
#------------------------------------------------------------

#------------------------------------------------------------
# CreateStereoBMState
#------------------------------------------------------------
CvStereoBMState*
cvCreateStereoBMState(preset, numberOfDisparities)
	INPUT:
		int preset
		int numberOfDisparities

#------------------------------------------------------------
# ReleaseStereoBMState
#------------------------------------------------------------
void
cvReleaseStereoBMState(state)
	INPUT:
		CvStereoBMState* state
	CODE:
		cvReleaseStereoBMState(&state);
	OUTPUT:
		state

#------------------------------------------------------------
# FindStereoCorrespondenceBM
#------------------------------------------------------------
void
cvFindStereoCorrespondenceBM(img1r, img2r, disparity, state)
	INPUT:
		const CvArr* img1r
 		const CvArr* img2r
		CvArr* disparity
		CvStereoBMState* state 
	CODE:
#if CV_MAJOR_VERSION == 2 || CV_MAJOR_VERSION == 1 && CV_MINOR_VERSION >= 1
		cvFindStereoCorrespondenceBM(img1r, img2r, disparity, state);
#else
		Perl_croak(aTHX_ "Can't call cvFindStereoCorrespondenceBM");
#endif

#------------------------------------------------------------
# CvStereoGCState
#------------------------------------------------------------

#------------------------------------------------------------
# CreateStereoGCState
#------------------------------------------------------------
CvStereoGCState*
cvCreateStereoGCState(numberOfDisparities, maxIters)
	INPUT:
		int numberOfDisparities
		int maxIters

#------------------------------------------------------------
# ReleaseStereoGCState
#------------------------------------------------------------
void
cvReleaseStereoGCState(state)
	INPUT:
		CvStereoGCState* state
	CODE:
		cvReleaseStereoGCState(&state);
	OUTPUT:
		state

#------------------------------------------------------------
# FindStereoCorrespondenceGC
#------------------------------------------------------------
void
cvFindStereoCorrespondenceGC(left, right, dispLeft, dispRight, state, useDisparityGuess)
	INPUT:
		const CvArr* left
		const CvArr* right
		CvArr* dispLeft
		CvArr* dispRight
		CvStereoGCState* state
		int useDisparityGuess

#------------------------------------------------------------
# ReprojectImageTo3D
#------------------------------------------------------------
void
cvReprojectImageTo3D(disparity, _3dImage, Q, handleMissingValues)
	INPUT:
		const CvArr* disparity
		CvArr* _3dImage
		const CvMat* Q
		int handleMissingValues
	CODE:
#if CV_MAJOR_VERSION == 2
		cvReprojectImageTo3D(disparity, _3dImage, Q, handleMissingValues);
#elif CV_MAJOR_VERSION == 1
		cvReprojectImageTo3D(disparity, _3dImage, Q);
#else
#error "?cvReprojectImageTo3D"
#endif

# #####################################################################
#   HighGUI
#   - http://opencv.jp/opencv-1.1.0_org/docs/ref/opencvref_highgui.htm
# #####################################################################

# ===========================================================
#  Simple GUI
# ===========================================================

#------------------------------------------------------------
# cvNamedWindow
#------------------------------------------------------------
int
cvNamedWindow(name, flags)
	INPUT:
		const char* name
		int flags

#------------------------------------------------------------
# cvDestroyWindow
#------------------------------------------------------------
void
cvDestroyWindow(name)
	INPUT:
		const char* name

#------------------------------------------------------------
# cvDestroyAllWindows
#------------------------------------------------------------
void
cvDestroyAllWindows()
	CODE:
		cvDestroyAllWindows();

#------------------------------------------------------------
# cvResizeWindow
#------------------------------------------------------------
void
cvResizeWindow(name, width, height)
	INPUT:
		const char *name
		int width
		int height

#------------------------------------------------------------
# cvMoveWindow
#------------------------------------------------------------
void
cvMoveWindow(name, x, y)
	INPUT:
		const char *name
		int x
		int y

#------------------------------------------------------------
# cvGetWindowHandle
#------------------------------------------------------------
void*
cvGetWindowHandle(name)
	INPUT:
		const char* name

#------------------------------------------------------------
# cvGetWindowName
#------------------------------------------------------------
const char*
cvGetWindowName(window_handle)
	INPUT:
		void* window_handle

#------------------------------------------------------------
# cvShowImage
#------------------------------------------------------------
void
cvShowImage(name, image)
	INPUT:
		const char* name
		CvArr* image

#------------------------------------------------------------
# cvCreateTrackbar
#------------------------------------------------------------
CvTrackbar*
cvCreateTrackbar(trackbar_name, window_name, value, count, callback)
	INPUT:
		const char* trackbar_name
		const char* window_name
		SV* value
		int count
		SV* callback
	CODE:
		CvTrackbar* trackbar = (CvTrackbar*)malloc(sizeof(CvTrackbar));
		if (!trackbar) Perl_croak(aTHX_ "cvCreateTrackbar: no core");
		trackbar->callback = 0;
		if (SvROK(callback) && SvTYPE(SvRV(callback)) == SVt_PVCV) {
			SvREFCNT_inc(trackbar->callback = (SV*)SvRV(callback));
		}
		trackbar->value = 0;
		if (SvROK(value) && SvTYPE(SvRV(value)) == SVt_IV) {
			SvREFCNT_inc(trackbar->value = (SV*)SvRV(value));
		}
		trackbar->lastpos = trackbar->pos = SvIV(trackbar->value);
		cvCreateTrackbar(trackbar_name,	window_name,
						&trackbar->pos, count, cb_trackbar);
		my_push(&trackbar_list, (elem_t*)trackbar);
		RETVAL = trackbar;
	OUTPUT:
		RETVAL

void
cvReleaseTrackbar(trackbar)
	INPUT:
		CvTrackbar* trackbar
	CODE:
		array_t tmp = { 0, 0 }; elem_t* p;
		while (p = my_shift(&trackbar_list))
			if (p != (elem_t*)trackbar)
				my_push(&tmp, p);
		trackbar_list = tmp;
		if (trackbar) {
			if (trackbar->callback) SvREFCNT_dec(trackbar->callback);
			if (trackbar->value) SvREFCNT_dec(trackbar->value);
			free(trackbar);
		}
		trackbar = 0;
	OUTPUT:
		trackbar

#------------------------------------------------------------
# cvGetTrackbarPos
#------------------------------------------------------------
int
cvGetTrackbarPos(trackbar_name, window_name)
	INPUT:
		const char *trackbar_name
		const char *window_name

#------------------------------------------------------------
# cvSetTrackbarPos
#------------------------------------------------------------
void
cvSetTrackbarPos(trackbar_name, window_name, pos)
	INPUT:
		const char *trackbar_name
		const char *window_name
		int pos

#------------------------------------------------------------
# cvSetMouseCallback
#------------------------------------------------------------
void
cvSetMouseCallback(window_name, callback, param)
	INPUT:
		const char* window_name
		CvMouseCallback callback
		void* param


#------------------------------------------------------------
# cvWaitKey
#------------------------------------------------------------
int 
cvWaitKey(delay)
	INPUT:
		int delay

# ===========================================================
#   Loading and Saving Images
# ===========================================================

#------------------------------------------------------------
# cvLoadImage
#------------------------------------------------------------
IplImage*
cvLoadImage(filename, flags)
	INPUT:
		const char* filename
		int flags

#------------------------------------------------------------
# cvSaveImage
#------------------------------------------------------------
int
cvSaveImage(filename, image)
	INPUT:
		const char* filename
		IplImage* image
	CODE:
#if CV_MAJOR_VERSION == 2
		const int *params = 0;
		RETVAL = cvSaveImage(filename, image, params);
#elif CV_MAJOR_VERSION == 1
		RETVAL = cvSaveImage(filename, image);
#else
#error "?cvSaveImage"
#endif
	OUTPUT:
		RETVAL

# ===========================================================
#   Video I/O
# ===========================================================

#------------------------------------------------------------
# CvCapture
#------------------------------------------------------------

#------------------------------------------------------------
# cvCreateFileCapture
#------------------------------------------------------------
CvCapture*
cvCreateFileCapture(filename)
	INPUT:
		const char *filename

#------------------------------------------------------------
# cvCreateCameraCapture
#------------------------------------------------------------
CvCapture*
cvCreateCameraCapture(index)
	INPUT:
		int index

#------------------------------------------------------------
# cvReleaseCapture
#------------------------------------------------------------
void
cvReleaseCapture(capture)
	INPUT:
		CvCapture* capture
	CODE:
		cvReleaseCapture(&capture);
	OUTPUT:
		capture

#------------------------------------------------------------
# cvGrabFrame
#------------------------------------------------------------
int
cvGrabFrame(capture)
	INPUT:
		CvCapture* capture

#------------------------------------------------------------
# cvRetrieveFrame
#------------------------------------------------------------
IplImage*
cvRetrieveFrame(capture)
	INPUT:
		CvCapture* capture
#if CV_MAJOR_VERSION == 2
	CODE:
		int streamIdx = 0;
		cvRetrieveFrame(capture, 0);
#endif

#------------------------------------------------------------
# cvQueryFrame
#------------------------------------------------------------
IplImage*
cvQueryFrame(capture)
  INPUT:
	CvCapture* capture

#------------------------------------------------------------
# cvGetCaptureProperty
#------------------------------------------------------------
double
cvGetCaptureProperty(capture, property_id)
	INPUT:
		CvCapture* capture
		int property_id
	CODE:
		RETVAL = cvGetCaptureProperty(capture, property_id);
	OUTPUT:
		RETVAL		

#------------------------------------------------------------
# cvSetCaptureProperty
#------------------------------------------------------------
int
cvSetCaptureProperty(capture, property_id, value)
  INPUT:
	CvCapture* capture
	int property_id
	double value

#------------------------------------------------------------
# cvCreateVideoWriter
#------------------------------------------------------------

#------------------------------------------------------------
# cvReleaseVideoWriter
#------------------------------------------------------------

#------------------------------------------------------------
# cvWriteFrame
#------------------------------------------------------------

# ===========================================================
#  Utility and System Functions
# ===========================================================

#------------------------------------------------------------
# cvInitSystem
#------------------------------------------------------------
=pod
int
cvInitSystem(argc, argv)
	INPUT:
		int argc
		char** argv
=cut

#------------------------------------------------------------
# cvConvertImage
#------------------------------------------------------------
void
cvConvertImage(src, dst, flags)
	INPUT:
		const CvArr* src
		CvArr* dst
		int flags


# #####################################################################
#   CVAUX
#   - http://opencv.jp/opencv-1.1.0/document/opencvref_cvaux.html
# #####################################################################

# ===========================================================
#  Stereo Correspondence Functions
# ===========================================================

#------------------------------------------------------------
# FindStereoCorrespondence
#------------------------------------------------------------
void
cvFindStereoCorrespondence( leftImage, rightImage, mode, depthImage, maxDisparity, param1, param2, param3, param4, param5 )
	INPUT:
		const	CvArr* leftImage
 		const	CvArr* rightImage
        int     mode
		CvArr*  depthImage
        int     maxDisparity
        double  param1
		double  param2
		double  param3
        double  param4
		double  param5


# #####################################################################
#   Other
#   - 
# #####################################################################

#------------------------------------------------------------
# cvbgfg_acmmm2003.cpp
#------------------------------------------------------------

CvBGStatModel*
cvCreateFGDStatModel(first_frame, parameters)
	INPUT:
		IplImage *first_frame
		CvFGDStatModelParams* parameters

int
cvUpdateBGStatModel(current_frame, bg_model)
	INPUT:
		IplImage *current_frame
		CvBGStatModel*  bg_model

void
cvReleaseBGStatModel(bg_model)
	INPUT:
		CvBGStatModel *bg_model
	CODE:
		cvReleaseBGStatModel(&bg_model);
	OUTPUT:
		bg_model

IplImage*
cvBGbackground(bg_model)
	INPUT:
		CvBGStatModel *bg_model
	CODE:
		RETVAL = bg_model->background;
	OUTPUT:
		RETVAL

IplImage*
cvBGforeground(bg_model)
	INPUT:
		CvBGStatModel *bg_model
	CODE:
		RETVAL = bg_model->foreground;
	OUTPUT:
		RETVAL

#------------------------------------------------------------
# cvbgfg_codebook.cpp
#------------------------------------------------------------

CvBGCodeBookModel*
cvCreateBGCodeBookModel()
	CODE:
		RETVAL = cvCreateBGCodeBookModel();
	OUTPUT:
		RETVAL

void
cvBGCodeBookUpdate(model, image, roi, mask)
	INPUT:
		CvBGCodeBookModel* model
		const CvArr* image
		CvRect roi
		const CvArr* mask

void
cvBGCodeBookClearStale(model, staleThresh, roi, mask)
	INPUT:
		CvBGCodeBookModel* model
		int staleThresh
		CvRect roi
		const CvArr* mask

int
cvBGCodeBookDiff(model, image, fgmask, roi)
	INPUT:
		const CvBGCodeBookModel* model
		const CvArr* image
		CvArr* fgmask
		CvRect roi

CvSeq*
cvSegmentFGMask(fgmask, poly1Hull0, perimScale, storage, offset)
	INPUT:
		CvArr* fgmask
		int poly1Hull0
		float perimScale
		CvMemStorage* storage
		CvPoint offset

SV*
cvGetmodMin(model)
	INPUT:
		CvBGCodeBookModel* model
	CODE:
		AV *av = (AV *)sv_2mortal((SV *)newAV());
		av_push(av, newSVnv(model->modMin[0]));
		av_push(av, newSVnv(model->modMin[1]));
		av_push(av, newSVnv(model->modMin[2]));
		RETVAL = newRV((SV *)av);
	OUTPUT:
		RETVAL

SV*
cvSetmodMin(model, v0, v1, v2)
	INPUT:
		CvBGCodeBookModel* model
		unsigned char v0
		unsigned char v1
		unsigned char v2
	CODE:
		model->modMin[0] = v0;
		model->modMin[1] = v1;
		model->modMin[2] = v2;
		AV *av = (AV *)sv_2mortal((SV *)newAV());
		av_push(av, newSVnv(model->modMin[0]));
		av_push(av, newSVnv(model->modMin[1]));
		av_push(av, newSVnv(model->modMin[2]));
		RETVAL = newRV((SV *)av);
	OUTPUT:
		RETVAL

SV*
cvGetmodMax(model)
	INPUT:
		CvBGCodeBookModel* model
	CODE:
		AV *av = (AV *)sv_2mortal((SV *)newAV());
		av_push(av, newSVnv(model->modMax[0]));
		av_push(av, newSVnv(model->modMax[1]));
		av_push(av, newSVnv(model->modMax[2]));
		RETVAL = newRV((SV *)av);
	OUTPUT:
		RETVAL

SV*
cvSetmodMax(model, v0, v1, v2)
	INPUT:
		CvBGCodeBookModel* model
		unsigned char v0
		unsigned char v1
		unsigned char v2
	CODE:
		model->modMax[0] = v0;
		model->modMax[1] = v1;
		model->modMax[2] = v2;
		AV *av = (AV *)sv_2mortal((SV *)newAV());
		av_push(av, newSVnv(model->modMax[0]));
		av_push(av, newSVnv(model->modMax[1]));
		av_push(av, newSVnv(model->modMax[2]));
		RETVAL = newRV((SV *)av);
	OUTPUT:
		RETVAL


SV*
cvSetcbBounds(model, v0, v1, v2)
	INPUT:
		CvBGCodeBookModel* model
		unsigned char v0
		unsigned char v1
		unsigned char v2
	CODE:
		model->cbBounds[0] = v0;
		model->cbBounds[1] = v1;
		model->cbBounds[2] = v2;
		AV *av = (AV *)sv_2mortal((SV *)newAV());
		av_push(av, newSVnv(model->cbBounds[0]));
		av_push(av, newSVnv(model->cbBounds[1]));
		av_push(av, newSVnv(model->cbBounds[2]));
		RETVAL = newRV((SV *)av);
	OUTPUT:
		RETVAL

int
cvGett(model)
	INPUT:
		CvBGCodeBookModel* model
	CODE:
		RETVAL = model->t;
	OUTPUT:
		RETVAL
