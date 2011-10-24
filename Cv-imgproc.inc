# -*- mode: text; coding: utf-8; tab-width: 4 -*-

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
double
cvGetHistValue_1D(CvHistogram* hist, int idx0)
CODE:
	RETVAL = *(float*)cvPtr1D(hist->bins, idx0, 0);
OUTPUT:
	RETVAL

double
cvGetHistValue_2D(CvHistogram* hist, int idx0, int idx1)
CODE:
	RETVAL = *(float*)cvPtr2D(hist->bins, idx0, idx1, 0);
OUTPUT:
	RETVAL

double
cvGetHistValue_3D(CvHistogram* hist, int idx0, int idx1, int idx2)
CODE:
	RETVAL = *(float*)cvPtr3D(hist->bins, idx0, idx1, idx2, 0);
OUTPUT:
	RETVAL

double
cvGetHistValue_ND(CvHistogram* hist, int* idx)
CODE:
	RETVAL = *(float*)cvPtrND(hist->bins, idx, NULL, 1, NULL);
OUTPUT:
	RETVAL

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

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

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
OUTPUT: RETVAL bless(ST(0), "Cv::Seq::Point", RETVAL);

double
cvArcLength(const void* curve, CvSlice slice=CV_WHOLE_SEQ, int isClosed=-1)

CvRect
cvBoundingRect(CvArr* points, int update=0)


MODULE = Cv		PACKAGE = Cv
# ====================
void
cvBoxPoints(CvBox2D box)
PPCODE:
	CvPoint2D32f pts[4]; int i;
	cvBoxPoints(box, pts);
	EXTEND(SP, 4);
	for (i = 0; i < 4; i++) {
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

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

double
cvContourArea(const CvArr* contour, CvSlice slice=CV_WHOLE_SEQ, int oriented=0)

#else

double
cvContourArea(const CvArr* contour, CvSlice slice=CV_WHOLE_SEQ)

#endif

#if defined __cplusplus || (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) <= 2001

MODULE = Cv		PACKAGE = Cv::ContourTree
# ====================
CvSeq*
cvContourFromContourTree(const CvContourTree* tree, CvMemStorage* storage, CvTermCriteria criteria)

#endif

MODULE = Cv		PACKAGE = Cv::Arr
# ====================
CvSeq*
cvConvexHull2(const CvArr* input, void* storage=NULL, int orientation=CV_CLOCKWISE, int return_points=1)
OUTPUT: RETVAL bless(ST(0), "Cv::Seq::Point", RETVAL);

CvSeq*
cvConvexityDefects(const CvArr* contour, const CvArr* convexhull, CvMemStorage* storage=NULL)


#if defined __cplusplus || (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) <= 2001

MODULE = Cv		PACKAGE = Cv::Seq
# ====================
CvContourTree*
cvCreateContourTree(const CvSeq* contour, CvMemStorage* storage, double threshold)

#endif

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


#if defined __cplusplus || (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) <= 2001

MODULE = Cv		PACKAGE = Cv::ContourTree
# ====================
double
cvMatchContourTrees(const CvContourTree* tree1, const CvContourTree* tree2, int method, double threshold)

#endif

MODULE = Cv		PACKAGE = Cv::Arr
# ====================
double
cvMatchShapes(const void* object1, const void* object2, int method, double parameter=0)

CvBox2D
cvMinAreaRect2(const CvArr* points, CvMemStorage* storage=NULL)
ALIAS: Cv::Arr::cvMinAreaRect = 1

CvSeq*
cvHoughCircles(CvArr* image, CvMemStorage* circleStorage, int method, double dp, double minDist, double param1=100, double param2=100, int minRadius=0, int maxRadius=0)
OUTPUT: RETVAL bless(ST(0), "Cv::Seq::Circle", RETVAL);

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
		RETVAL = cvSubdiv2DLocate(subdiv, pt, &edge, NULL);
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
POSTCALL:
	ST(0) = ST(2);
	XSRETURN(1);
