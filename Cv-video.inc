# -*- mode: text; coding: utf-8; tab-width: 4 -*-

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


#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

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


#ifdef __cplusplus

MODULE = Cv		PACKAGE = Cv
# ====================
CvConDensation*
cvCreateConDensation(int dynam_params, int measure_params, int sample_count)

MODULE = Cv		PACKAGE = Cv::ConDensation
# ====================
void
cvConDensInitSampleSet(CvConDensation* condens, CvMat* lower_bound, CvMat* upper_bound)

#endif


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
	RETVAL bless(ST(0), "Cv::Mat::Ghost", RETVAL);

CvMat*
state_post(CvKalman* kalman)
CODE:
	RETVAL = kalman->state_post;
OUTPUT:
	RETVAL bless(ST(0), "Cv::Mat::Ghost", RETVAL);

CvMat*
transition_matrix(CvKalman* kalman)
CODE:
	RETVAL = kalman->transition_matrix;
OUTPUT:
	RETVAL bless(ST(0), "Cv::Mat::Ghost", RETVAL);

CvMat*
control_matrix(CvKalman* kalman)
CODE:
	RETVAL = kalman->control_matrix;
OUTPUT:
	RETVAL bless(ST(0), "Cv::Mat::Ghost", RETVAL);

CvMat*
measurement_matrix(CvKalman* kalman)
CODE:
	RETVAL = kalman->measurement_matrix;
OUTPUT:
	RETVAL bless(ST(0), "Cv::Mat::Ghost", RETVAL);

CvMat*
process_noise_cov(CvKalman* kalman)
CODE:
	RETVAL = kalman->process_noise_cov;
OUTPUT:
	RETVAL bless(ST(0), "Cv::Mat::Ghost", RETVAL);

CvMat*
measurement_noise_cov(CvKalman* kalman)
CODE:
	RETVAL = kalman->measurement_noise_cov;
OUTPUT:
	RETVAL bless(ST(0), "Cv::Mat::Ghost", RETVAL);

CvMat*
error_cov_pre(CvKalman* kalman)
CODE:
	RETVAL = kalman->error_cov_pre;
OUTPUT:
	RETVAL bless(ST(0), "Cv::Mat::Ghost", RETVAL);

CvMat*
gain(CvKalman* kalman)
CODE:
	RETVAL = kalman->gain;
OUTPUT:
	RETVAL bless(ST(0), "Cv::Mat::Ghost", RETVAL);

CvMat*
error_cov_post(CvKalman* kalman)
CODE:
	RETVAL = kalman->error_cov_post;
OUTPUT:
	RETVAL bless(ST(0), "Cv::Mat::Ghost", RETVAL);

MODULE = Cv		PACKAGE = Cv
# ====================
CvKalman*
cvCreateKalman(int dynam_params, int measure_params, int control_params=0)


MODULE = Cv		PACKAGE = Cv::Kalman
# ====================
const CvMat*
cvKalmanCorrect(CvKalman* kalman, const CvMat* measurement)
OUTPUT: RETVAL bless(ST(0), "Cv::Mat::Ghost", RETVAL);

const CvMat*
cvKalmanPredict(CvKalman* kalman, const CvMat* control=NULL)
OUTPUT: RETVAL bless(ST(0), "Cv::Mat::Ghost", RETVAL);


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
#ifdef __cplusplus

void
cvReleaseConDensation(CvConDensation* &condens)
ALIAS: Cv::ConDensation::DESTROY = 2

#endif

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

