# -*- mode: text; coding: utf-8; tab-width: 4 -*-

# ============================================================
#  calib3d. Camera Calibration, Pose Estimation and Stereo: Camera
#   Calibration and 3d Reconstruction
# ============================================================

MODULE = Cv		PACKAGE = Cv
# ====================
void
cvCalcImageHomography(float* line, CvPoint3D32f* center, float* intrinsic, float* homography)

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

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
POSTCALL:
	ST(0) = ST(3);
	XSRETURN(1);

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
speckleRange(CvStereoBMState* state, int value = NO_INIT)
CODE:
	RETVAL = state->speckleRange;
	if (items == 2) state->speckleRange = value;
OUTPUT:
	RETVAL

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

int
trySmallerWindows(CvStereoBMState* state, int value = NO_INIT)
CODE:
	RETVAL = state->trySmallerWindows;
	if (items == 2) state->trySmallerWindows = value;
OUTPUT:
	RETVAL

CvRect
roi1(CvStereoBMState* state, CvRect value = NO_INIT)
CODE:
	RETVAL = state->roi1;
	if (items == 2) state->roi1 = value;
OUTPUT:
	RETVAL

CvRect
roi2(CvStereoBMState* state, CvRect value = NO_INIT)
CODE:
	RETVAL = state->roi2;
	if (items == 2) state->roi2 = value;
OUTPUT:
	RETVAL

int
disp12MaxDiff(CvStereoBMState* state, int value = NO_INIT)
CODE:
	RETVAL = state->disp12MaxDiff;
	if (items == 2) state->disp12MaxDiff = value;
OUTPUT:
	RETVAL

#endif

CvMat*
preFilteredImg0(CvStereoBMState* state, CvMat* value = NO_INIT)
CODE:
	RETVAL = state->preFilteredImg0;
	if (items == 2) state->preFilteredImg0 = value;
OUTPUT:
	RETVAL bless(ST(0), "Cv::Mat::Ghost", RETVAL);

CvMat*
preFilteredImg1(CvStereoBMState* state, CvMat* value = NO_INIT)
CODE:
	RETVAL = state->preFilteredImg1;
	if (items == 2) state->preFilteredImg1 = value;
OUTPUT:
	RETVAL bless(ST(0), "Cv::Mat::Ghost", RETVAL);

CvMat*
slidingSumBuf(CvStereoBMState* state, CvMat* value = NO_INIT)
CODE:
	RETVAL = state->slidingSumBuf;
	if (items == 2) state->slidingSumBuf = value;
OUTPUT:
	RETVAL bless(ST(0), "Cv::Mat::Ghost", RETVAL);


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

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

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

#TBD# void cvFindStereoCorrespondenceGC(const CvArr* left, const CvArr* right, CvArr* dispLeft, CvArr* dispRight, CvStereoGCState* state, int useDisparityGuess = CV_DEFAULT(0))

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2003

void
cvGetOptimalNewCameraMatrix(const CvMat* cameraMatrix, const CvMat* distCoeffs, CvSize imageSize, double alpha, CvMat* newCameraMatrix, CvSize newImageSize=cvSize(0, 0), validPixROI = NO_INIT, centerPrincipalPoint = NO_INIT)
INPUT:
	CvRect& validPixROI;
	int centerPrincipalPoint = 0;
OUTPUT:
	validPixROI if (items >= 7) XS_pack_CvRect(ST(6), validPixROI);

#else
#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

void
cvGetOptimalNewCameraMatrix(const CvMat* cameraMatrix, const CvMat* distCoeffs, CvSize imageSize, double alpha, CvMat* newCameraMatrix, CvSize newImageSize=cvSize(0, 0), validPixROI = NO_INIT)
INPUT:
	CvRect& validPixROI = NO_INIT;
OUTPUT:
	validPixROI if (items >= 7) XS_pack_CvRect(ST(6), validPixROI);

#endif
#endif

void
cvInitIntrinsicParams2D(const CvMat* objectPoints, const CvMat* imagePoints, const CvMat* npoints, CvSize imageSize, CvMat* cameraMatrix, double aspectRatio=1.)

void
cvInitUndistortMap(const CvMat* cameraMatrix, const CvMat* distCoeffs, CvArr* map1, CvArr* map2)

void
cvInitUndistortRectifyMap(const CvMat* cameraMatrix, const CvMat* distCoeffs, const CvMat* R, const CvMat* newCameraMatrix, CvArr* map1, CvArr* map2)

#TBD# void cvPOSIT(CvPOSITObject* posit_object, CvPoint2D32f* imagePoints, double focal_length, CvTermCriteria criteria, CvMatr32f rotationMatrix, CvVect32f translation_vector)

void
cvProjectPoints2(const CvMat* objectPoints, const CvMat* rvec, const CvMat* tvec, const CvMat* cameraMatrix, const CvMat* distCoeffs, CvMat* imagePoints, CvMat* dpdrot=NULL, CvMat* dpdt=NULL, CvMat* dpdf=NULL, CvMat* dpdc=NULL, CvMat* dpddist=NULL, double aspect_ratio=0)

MODULE = Cv		PACKAGE = Cv::Arr
# ====================

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

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

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

double
cvStereoCalibrate(const CvMat* objectPoints, const CvMat* imagePoints1, const CvMat* imagePoints2, const CvMat* pointCounts, CvMat* cameraMatrix1, CvMat* distCoeffs1, CvMat* cameraMatrix2, CvMat* distCoeffs2, CvSize imageSize, CvMat* R, CvMat* T, CvMat* E=0, CvMat* F=0, CvTermCriteria term_crit=cvTermCriteria(CV_TERMCRIT_ITER+CV_TERMCRIT_EPS, 30, 1e-6), int flags=CV_CALIB_FIX_INTRINSIC)

#else
void
cvStereoCalibrate(const CvMat* objectPoints, const CvMat* imagePoints1, const CvMat* imagePoints2, const CvMat* pointCounts, CvMat* cameraMatrix1, CvMat* distCoeffs1, CvMat* cameraMatrix2, CvMat* distCoeffs2, CvSize imageSize, CvMat* R, CvMat* T, CvMat* E=0, CvMat* F=0, CvTermCriteria term_crit=cvTermCriteria(CV_TERMCRIT_ITER+CV_TERMCRIT_EPS,30,1e-6), int flags=CV_CALIB_FIX_INTRINSIC)

#endif

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

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

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

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


MODULE = Cv		PACKAGE = Cv::StereoSGBM
# ====================

#ifdef __cplusplus
#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

StereoSGBM*
StereoSGBM::new()

void
StereoSGBM::DESTROY()

void
StereoSGBM::cvFindStereoCorrespondenceSGBM(const CvMat* left, const CvMat* right, CvMat* disp)
INIT:
	Mat l(left);
	Mat r(right);
	Mat d(disp);
CODE:
	(*THIS)(l, r, d);
POSTCALL:
	ST(0) = ST(3);
	XSRETURN(1);
	
int
StereoSGBM::minDisparity(int value = NO_INIT)
CODE:
	RETVAL = THIS->minDisparity;
	if (items == 2) THIS->minDisparity = value;
OUTPUT:
	RETVAL

int
StereoSGBM::numberOfDisparities(int value = NO_INIT)
CODE:
	RETVAL = THIS->numberOfDisparities;
	if (items == 2) THIS->numberOfDisparities = value;
OUTPUT:
	RETVAL

int
StereoSGBM::SADWindowSize(int value = NO_INIT)
CODE:
	RETVAL = THIS->SADWindowSize;
	if (items == 2) THIS->SADWindowSize = value;
OUTPUT:
	RETVAL

int
StereoSGBM::preFilterCap(int value = NO_INIT)
CODE:
	RETVAL = THIS->preFilterCap;
	if (items == 2) THIS->preFilterCap = value;
OUTPUT:
	RETVAL

int
StereoSGBM::uniquenessRatio(int value = NO_INIT)
CODE:
	RETVAL = THIS->uniquenessRatio;
	if (items == 2) THIS->uniquenessRatio = value;
OUTPUT:
	RETVAL

int
StereoSGBM::P1(int value = NO_INIT)
CODE:
	RETVAL = THIS->P1;
	if (items == 2) THIS->P1 = value;
OUTPUT:
	RETVAL

int
StereoSGBM::P2(int value = NO_INIT)
CODE:
	RETVAL = THIS->P2;
	if (items == 2) THIS->P2 = value;
OUTPUT:
	RETVAL

int
StereoSGBM::speckleWindowSize(int value = NO_INIT)
CODE:
	RETVAL = THIS->speckleWindowSize;
	if (items == 2) THIS->speckleWindowSize = value;
OUTPUT:
	RETVAL

int
StereoSGBM::speckleRange(int value = NO_INIT)
CODE:
	RETVAL = THIS->speckleRange;
	if (items == 2) THIS->speckleRange = value;
OUTPUT:
	RETVAL

int
StereoSGBM::disp12MaxDiff(int value = NO_INIT)
CODE:
	RETVAL = THIS->disp12MaxDiff;
	if (items == 2) THIS->disp12MaxDiff = value;
OUTPUT:
	RETVAL

bool
StereoSGBM::fullDP(bool value = NO_INIT)
CODE:
	RETVAL = THIS->fullDP;
	if (items == 2) THIS->fullDP = value;
OUTPUT:
	RETVAL

#endif
#endif

