# -*- mode: text; coding: utf-8; tab-width: 4 -*-

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

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2002

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
