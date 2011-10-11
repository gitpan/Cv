# -*- mode: text; coding: utf-8; tab-width: 4 -*-

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
