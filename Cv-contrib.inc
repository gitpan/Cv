# -*- mode: text; coding: utf-8; tab-width: 4 -*-

MODULE = Cv		PACKAGE = Cv
# ====================

#ifdef __cplusplus
#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2002

int
cvChamerMatching(CvMat* img, CvMat* templ, results = NO_INIT, costs = NO_INIT, double templScale=1, int maxMatches = 20, double minMatchDistance = 1.0, int padX = 3, int padY = 3, int scales = 5, double minScale = 0.6, double maxScale = 1.6, double orientationWeight = 0.5, double truncate = 20)
INIT:
	Mat _img(img);
	Mat _templ(templ);
	vector<vector<Point> > results;
	vector<float> costs;
CODE:
	RETVAL = chamerMatching(_img, _templ, results, costs, templScale, maxMatches, minMatchDistance, padX, padY, scales, minScale, maxScale, orientationWeight, truncate);
	XS_pack_PointVecVec(ST(2), results);
	XS_pack_floatVec(ST(3), costs);
OUTPUT:
	RETVAL

#endif
#endif
