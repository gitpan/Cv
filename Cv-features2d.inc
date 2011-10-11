# -*- mode: text; coding: utf-8; tab-width: 4 -*-

# ============================================================
#  features2d. Feature Detection and Descriptor Extraction:
#    Feature detection and description
# ============================================================

MODULE = Cv		PACKAGE = Cv::Arr
# ====================
#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

void
cvExtractSURF(const CvArr* image, const CvArr* mask, keypoints, descriptors, CvMemStorage* storage, CvSURFParams params, int useProvidedKeyPts = 0)
INPUT:
	CvSeq* &keypoints = NO_INIT
	CvSeq* &descriptors = NO_INIT
OUTPUT:
	keypoints
	descriptors

#else

void
cvExtractSURF(const CvArr* image, const CvArr* mask, keypoints, descriptors, CvMemStorage* storage, CvSURFParams params)
INPUT:
	CvSeq* &keypoints = NO_INIT
	CvSeq* &descriptors = NO_INIT
OUTPUT:
	keypoints
	descriptors

#endif

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

void
cvExtractMSER(CvArr* img, CvArr* mask, contours, CvMemStorage* storage, CvMSERParams params)
INPUT:
	CvSeq* &contours = NO_INIT
OUTPUT:
	contours

#endif

#TBD# CvSeq* cvGetStarKeypoints(const CvArr* image, CvMemStorage* storage, CvStarDetectorParams params=cvStarDetectorParams())
