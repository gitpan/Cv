# -*- mode: text; coding: utf-8; tab-width: 4 -*-


# ===========================================================
#  IplImage
# ===========================================================
int
IplImage_depth(arr)
	INPUT:
		const CvArr* arr;
	CODE:
		IplImage* img = (IplImage*)arr;
		RETVAL = img->depth;
	OUTPUT:
		RETVAL

int
IplImage_nChannels(arr)
	INPUT:
		const CvArr* arr;
	CODE:
		IplImage* img = (IplImage*)arr;
		RETVAL = img->nChannels;
	OUTPUT:
		RETVAL

int
IplImage_get_origin(image)
	INPUT:
		IplImage* image
	CODE:
		RETVAL = image->origin;
	OUTPUT:
		RETVAL

int
IplImage_set_origin(image, origin)
	INPUT:
		IplImage* image
		int origin
	CODE:
		RETVAL = image->origin;
		image->origin = origin;
	OUTPUT:
		RETVAL

SV *
IplImage_get_imagedata(image)
	INPUT:
		IplImage* image
	CODE:
		SV *sv;
		CvRect roi = cvGetImageROI((const IplImage *)image);
		int h = roi.height ? roi.height : image->height;
		int w = roi.width  ? roi.width  : image->width;
		int d = image->depth & ~IPL_DEPTH_SIGN;
		w *= image->nChannels * d/8;
		if (w * h > 0) {
			char s[w*h]; int j;
			for (j = 0; j < h; j++) {
				memcpy(s + w*j, cvPtr2D(image, j, 0, NULL), w);
			}
			sv = newSVpvn(s, w*h);
		} else {
			sv = newSVpvn("", 0);
		}
		RETVAL = sv;
	OUTPUT:
		RETVAL

void
IplImage_set_imagedata(image, data)
	INPUT:
		IplImage* image
		SV *data
	CODE:
		int n = sv_len(data);
		CvRect roi = cvGetImageROI((const IplImage *)image);
		int h = roi.height ? roi.height : image->height;
		int w = roi.width  ? roi.width  : image->width;
		int d = image->depth & ~IPL_DEPTH_SIGN;
		w *= image->nChannels * d/8;
		if (w * h > 0) {
			unsigned char *s = SvPV(data, n); int j;
			for (j = 0; j < h; j++) {
				memcpy(cvPtr2D(image, j, 0, NULL), s + w*j, w);
			}
		}


# ===========================================================
#  CvKalman
# ===========================================================

CvMat*
CvKalman_transition_matrix(kalman)
	INPUT:
		CvKalman* kalman
	CODE:
		RETVAL = kalman->transition_matrix;
	OUTPUT:
		RETVAL

CvMat*
CvKalman_measurement_matrix(kalman)
	INPUT:
		CvKalman* kalman
	CODE:
		RETVAL = kalman->measurement_matrix;
	OUTPUT:
		RETVAL

CvMat*
CvKalman_process_noise_cov(kalman)
	INPUT:
		CvKalman* kalman
	CODE:
		RETVAL = kalman->process_noise_cov;
	OUTPUT:
		RETVAL

CvMat*
CvKalman_measurement_noise_cov(kalman)
	INPUT:
		CvKalman* kalman
	CODE:
		RETVAL = kalman->measurement_noise_cov;
	OUTPUT:
		RETVAL

CvMat*
CvKalman_error_cov_pre(kalman)
	INPUT:
		CvKalman* kalman
	CODE:
		RETVAL = kalman->error_cov_pre;
	OUTPUT:
		RETVAL

CvMat*
CvKalman_error_cov_post(kalman)
	INPUT:
		CvKalman* kalman
	CODE:
		RETVAL = kalman->error_cov_post;
	OUTPUT:
		RETVAL

CvMat*
xv_state_pre(kalman)
	INPUT:
		CvKalman* kalman
	CODE:
		RETVAL = kalman->state_pre;
	OUTPUT:
		RETVAL

CvMat*
CvKalman_state_post(kalman)
	INPUT:
		CvKalman* kalman
	CODE:
		RETVAL = kalman->state_post;
	OUTPUT:
		RETVAL


# ===========================================================
#  CvMat
# ===========================================================
int
CvMat_refcount(mat)
	INPUT:
		const CvMat *mat
	CODE:
		RETVAL = -1;
		if (CV_IS_MAT(mat)) {
			if (mat->refcount) {
				RETVAL = *(mat->refcount);
			}
		}
	OUTPUT:
		RETVAL


int
CV_IS_MAT(mat)
	INPUT:
		const CvArr* mat


# ===========================================================
#  CvSet
# ===========================================================

int
CV_IS_SET(seq)
	INPUT:
		const CvSeq* seq

int
CV_IS_SET_ELEM(ptr)
	INPUT:
		const CvSetElem* ptr


# ===========================================================
#  CvSeq
# ===========================================================
int
CvSeq_header_size(seq)
	INPUT:
		CvSeq *seq
	CODE:
		if (CV_IS_SEQ(seq)) {
			RETVAL = seq->header_size;
		} else if (CV_IS_SET((CvSet*)seq)) {
			RETVAL = ((CvSet*)seq)->header_size;
		} else {
			RETVAL = -1;
		}
	OUTPUT:
		RETVAL

int
CvSeq_elem_size(seq)
	INPUT:
		CvSeq *seq
	CODE:
		if (CV_IS_SEQ(seq)) {
			RETVAL = seq->elem_size;
		} else if (CV_IS_SET((CvSet*)seq)) {
			RETVAL = ((CvSet*)seq)->elem_size;
		} else {
			RETVAL = -1;
		}
	OUTPUT:
		RETVAL

int
CvSeq_total(seq)
	INPUT:
		CvSeq *seq
	CODE:
		if (CV_IS_SEQ(seq)) {
			RETVAL = seq->total;
		} else if (CV_IS_SET((CvSet*)seq)) {
			RETVAL = ((CvSet*)seq)->total;
		} else {
			RETVAL = -1;
		}
	OUTPUT:
		RETVAL

CvSeq*
CvSeq_h_next(seq)
	INPUT:
		CvSeq *seq
	CODE:
		RETVAL = seq->h_next;
	OUTPUT:
		RETVAL

CvSeq*
CvSeq_h_prev(seq)
	INPUT:
		CvSeq *seq
	CODE:
		RETVAL = seq->h_prev;
	OUTPUT:
		RETVAL

CvSeq*
CvSeq_v_next(seq)
	INPUT:
		CvSeq *seq
	CODE:
        RETVAL = seq->v_next;
	OUTPUT:
		RETVAL

CvSeq*
CvSeq_v_prev(seq)
	INPUT:
		CvSeq *seq
	CODE:
        RETVAL = seq->v_prev;
	OUTPUT:
		RETVAL


int
CV_SEQ_ELTYPE(seq)
	INPUT:
		const CvSeq* seq

int
CV_IS_SEQ(seq)
	INPUT:
		const CvSeq* seq


# ===========================================================
#  CvSeqReader
# ===========================================================

void*
CvSeqReader_ptr(reader)
	INPUT:
		CvSeqReader* reader
	CODE:
		RETVAL = reader->ptr;
	OUTPUT:
		RETVAL

=pod
SV *
CvReadSeqElem(reader)
	INPUT:
		CvSeqReader reader
	CODE:
		if (CV_IS_SEQ(reader.seq)) {
			RETVAL = newSVpvn(reader.ptr, reader.seq->elem_size);
			CV_NEXT_SEQ_ELEM(reader.seq->elem_size, reader);
		} else if (CV_IS_SET((CvSet*)reader.seq)) {
			RETVAL = newSVpvn(reader.ptr, ((CvSet*)reader.seq)->elem_size);
			CV_NEXT_SEQ_ELEM(((CvSet*)reader.seq)->elem_size, reader);
		} else {
			RETVAL = newSVpvn("", 0);
		}
	OUTPUT:
		RETVAL
		reader

void
cvNextSeqElem(reader)
	INPUT:
		CvSeqReader reader
	CODE:
		if (CV_IS_SEQ(reader.seq)) {
			CV_NEXT_SEQ_ELEM(reader.seq->elem_size, reader);
		} else if (CV_IS_SET((CvSet*)reader.seq)) {
			CV_NEXT_SEQ_ELEM(((CvSet*)reader.seq)->elem_size, reader);
		}
	OUTPUT:
		reader
=cut

SV *
cvReadSeqElem(reader)
	INPUT:
		CvSeqReader* reader
	CODE:
		if (CV_IS_SEQ(reader->seq)) {
			RETVAL = newSVpvn(reader->ptr, reader->seq->elem_size);
			CV_NEXT_SEQ_ELEM(reader->seq->elem_size, *reader);
		} else if (CV_IS_SET((CvSet*)reader->seq)) {
			RETVAL = newSVpvn(reader->ptr, ((CvSet*)reader->seq)->elem_size);
			CV_NEXT_SEQ_ELEM(((CvSet*)reader->seq)->elem_size, *reader);
		} else {
			RETVAL = newSVpvn("", 0);
		}
	OUTPUT:
		RETVAL

void
cvNextSeqElem(reader)
	INPUT:
		CvSeqReader* reader
	CODE:
		if (CV_IS_SEQ(reader->seq)) {
			CV_NEXT_SEQ_ELEM(reader->seq->elem_size, *reader);
		} else if (CV_IS_SET((CvSet*)reader->seq)) {
			CV_NEXT_SEQ_ELEM(((CvSet*)reader->seq)->elem_size, *reader);
		}



# ===========================================================
#  CvSubdiv2D
# ===========================================================
CvSeq*
CvSubdiv2D_edges(subdiv)
	INPUT:
		CvSubdiv2D* subdiv
	CODE:
		RETVAL = (CvSeq *)subdiv->edges;
	OUTPUT:
		RETVAL		


# ===========================================================
#  CvMoments
# ===========================================================
double
CvMoments_m00(moments)
	INPUT:
		const CvMoments* moments
	CODE:
		RETVAL = moments->m00;
	OUTPUT:
		RETVAL

double
CvMoments_m10(moments)
	INPUT:
		const CvMoments* moments
	CODE:
		RETVAL = moments->m10;
	OUTPUT:
		RETVAL

double
CvMoments_m01(moments)
	INPUT:
		const CvMoments* moments
	CODE:
		RETVAL = moments->m01;
	OUTPUT:
		RETVAL

double
CvMoments_m20(moments)
	INPUT:
		const CvMoments* moments
	CODE:
		RETVAL = moments->m20;
	OUTPUT:
		RETVAL

double
CvMoments_m11(moments)
	INPUT:
		const CvMoments* moments
	CODE:
		RETVAL = moments->m11;
	OUTPUT:
		RETVAL

double
CvMoments_m02(moments)
	INPUT:
		const CvMoments* moments
	CODE:
		RETVAL = moments->m02;
	OUTPUT:
		RETVAL

double
CvMoments_m30(moments)
	INPUT:
		const CvMoments* moments
	CODE:
		RETVAL = moments->m30;
	OUTPUT:
		RETVAL

double
CvMoments_m21(moments)
	INPUT:
		const CvMoments* moments
	CODE:
		RETVAL = moments->m21;
	OUTPUT:
		RETVAL

double
CvMoments_m12(moments)
	INPUT:
		const CvMoments* moments
	CODE:
		RETVAL = moments->m12;
	OUTPUT:
		RETVAL

double
CvMoments_m03(moments)
	INPUT:
		const CvMoments* moments
	CODE:
		RETVAL = moments->m03;
	OUTPUT:
		RETVAL

double
CvMoments_inv_sqrt_m00(moments)
	INPUT:
		const CvMoments* moments
	CODE:
		RETVAL = moments->inv_sqrt_m00;
	OUTPUT:
		RETVAL


# ===========================================================
#  CvHuMoments
# ===========================================================
double
CvHuMoments_hu1(hu_moments)
	INPUT:
		const CvHuMoments* hu_moments
	CODE:
		RETVAL = hu_moments->hu1;
	OUTPUT:
		RETVAL

double
CvHuMoments_hu2(hu_moments)
	INPUT:
		const CvHuMoments* hu_moments
	CODE:
		RETVAL = hu_moments->hu2;
	OUTPUT:
		RETVAL

double
CvHuMoments_hu3(hu_moments)
	INPUT:
		const CvHuMoments* hu_moments
	CODE:
		RETVAL = hu_moments->hu3;
	OUTPUT:
		RETVAL

double
CvHuMoments_hu4(hu_moments)
	INPUT:
		const CvHuMoments* hu_moments
	CODE:
		RETVAL = hu_moments->hu4;
	OUTPUT:
		RETVAL

double
CvHuMoments_hu5(hu_moments)
	INPUT:
		const CvHuMoments* hu_moments
	CODE:
		RETVAL = hu_moments->hu5;
	OUTPUT:
		RETVAL

double
CvHuMoments_hu6(hu_moments)
	INPUT:
		const CvHuMoments* hu_moments
	CODE:
		RETVAL = hu_moments->hu6;
	OUTPUT:
		RETVAL

double
CvHuMoments_hu7(hu_moments)
	INPUT:
		const CvHuMoments* hu_moments
	CODE:
		RETVAL = hu_moments->hu7;
	OUTPUT:
		RETVAL


# ===========================================================
#  CvStereoBMState
# ===========================================================

int
CvStereoBMState_get_preFilterType(state)
	INPUT:
		CvStereoBMState *state
	CODE:
		RETVAL = state->preFilterType;
	OUTPUT:
		RETVAL

int
CvStereoBMState_set_preFilterType(state, value)
	INPUT:
		CvStereoBMState *state
		int value
	CODE:
		RETVAL = state->preFilterType;
		state->preFilterType = value;
	OUTPUT:
		RETVAL

int
CvStereoBMState_get_preFilterSize(state)
	INPUT:
		CvStereoBMState *state
	CODE:
		RETVAL = state->preFilterSize;
	OUTPUT:
		RETVAL

int
CvStereoBMState_set_preFilterSize(state, value)
	INPUT:
		CvStereoBMState *state
		int value
	CODE:
		RETVAL = state->preFilterSize;
		state->preFilterSize = value;
	OUTPUT:
		RETVAL

int
CvStereoBMState_get_preFilterCap(state)
	INPUT:
		CvStereoBMState *state
	CODE:
		RETVAL = state->preFilterCap;
	OUTPUT:
		RETVAL

int
CvStereoBMState_set_preFilterCap(state, value)
	INPUT:
		CvStereoBMState *state
		int value
	CODE:
		RETVAL = state->preFilterCap;
		state->preFilterCap = value;
	OUTPUT:
		RETVAL

int
CvStereoBMState_get_SADWindowSize(state)
	INPUT:
		CvStereoBMState *state
	CODE:
		RETVAL = state->SADWindowSize;
	OUTPUT:
		RETVAL

int
CvStereoBMState_set_SADWindowSize(state, value)
	INPUT:
		CvStereoBMState *state
		int value
	CODE:
		RETVAL = state->SADWindowSize;
		state->SADWindowSize = value;
	OUTPUT:
		RETVAL

int
CvStereoBMState_get_minDisparity(state)
	INPUT:
		CvStereoBMState *state
	CODE:
		RETVAL = state->minDisparity;
	OUTPUT:
		RETVAL

int
CvStereoBMState_set_minDisparity(state, value)
	INPUT:
		CvStereoBMState *state
		int value
	CODE:
		RETVAL = state->minDisparity;
		state->minDisparity = value;
	OUTPUT:
		RETVAL

int
CvStereoBMState_get_numberOfDisparities(state)
	INPUT:
		CvStereoBMState *state
	CODE:
		RETVAL = state->numberOfDisparities;
	OUTPUT:
		RETVAL

int
CvStereoBMState_set_numberOfDisparities(state, value)
	INPUT:
		CvStereoBMState *state
		int value
	CODE:
		RETVAL = state->numberOfDisparities;
		state->numberOfDisparities = value;
	OUTPUT:
		RETVAL

int
CvStereoBMState_get_textureThreshold(state)
	INPUT:
		CvStereoBMState *state
	CODE:
		RETVAL = state->textureThreshold;
	OUTPUT:
		RETVAL

int
CvStereoBMState_set_textureThreshold(state, value)
	INPUT:
		CvStereoBMState *state
		int value
	CODE:
		RETVAL = state->textureThreshold;
		state->textureThreshold = value;
	OUTPUT:
		RETVAL

int
CvStereoBMState_get_uniquenessRatio(state)
	INPUT:
		CvStereoBMState *state
	CODE:
		RETVAL = state->uniquenessRatio;
	OUTPUT:
		RETVAL

int
CvStereoBMState_set_uniquenessRatio(state, value)
	INPUT:
		CvStereoBMState *state
		int value
	CODE:
		RETVAL = state->uniquenessRatio;
		state->uniquenessRatio = value;
	OUTPUT:
		RETVAL

int
CvStereoBMState_get_speckleWindowSize(state)
	INPUT:
		CvStereoBMState *state
	CODE:
		RETVAL = state->speckleWindowSize;
	OUTPUT:
		RETVAL

int
CvStereoBMState_set_speckleWindowSize(state, value)
	INPUT:
		CvStereoBMState *state
		int value
	CODE:
		RETVAL = state->speckleWindowSize;
		state->speckleWindowSize = value;
	OUTPUT:
		RETVAL

int
CvStereoBMState_get_speckleRange(state)
	INPUT:
		CvStereoBMState *state
	CODE:
		RETVAL = state->speckleRange;
	OUTPUT:
		RETVAL

int
CvStereoBMState_set_speckleRange(state, value)
	INPUT:
		CvStereoBMState *state
		int value
	CODE:
		RETVAL = state->speckleRange;
		state->speckleRange = value;
	OUTPUT:
		RETVAL

CvMat*
CvStereoBMState_get_preFilteredImg0(state)
	INPUT:
		CvStereoBMState *state
	CODE:
		RETVAL = state->preFilteredImg0;
	OUTPUT:
		RETVAL

CvMat*
CvStereoBMState_set_preFilteredImg0(state, value)
	INPUT:
		CvStereoBMState *state
		CvMat *value
	CODE:
		RETVAL = state->preFilteredImg0;
		state->preFilteredImg0 = value;
	OUTPUT:
		RETVAL

CvMat*
CvStereoBMState_get_preFilteredImg1(state)
	INPUT:
		CvStereoBMState *state
	CODE:
		RETVAL = state->preFilteredImg1;
	OUTPUT:
		RETVAL

CvMat*
CvStereoBMState_set_preFilteredImg1(state, value)
	INPUT:
		CvStereoBMState *state
		CvMat* value
	CODE:
		RETVAL = state->preFilteredImg1;
		state->preFilteredImg1 = value;
	OUTPUT:
		RETVAL

CvMat*
CvStereoBMState_get_slidingSumBuf(state)
	INPUT:
		CvStereoBMState *state
	CODE:
		RETVAL = state->slidingSumBuf;
	OUTPUT:
		RETVAL

CvMat*
CvStereoBMState_set_slidingSumBuf(state, value)
	INPUT:
		CvStereoBMState *state
		CvMat* value
	CODE:
		RETVAL = state->slidingSumBuf;
		state->slidingSumBuf = value;
	OUTPUT:
		RETVAL

# ===========================================================
#  SizeOf_Cv*
# ===========================================================

int
SizeOf_CvContour()
	CODE:
		RETVAL = sizeof(CvContour);
	OUTPUT:
		RETVAL

int
SizeOf_CvChain()
	CODE:
		RETVAL = sizeof(CvChain);
	OUTPUT:
		RETVAL

int
SizeOf_CvPoint()
	CODE:
		RETVAL = sizeof(CvPoint);
	OUTPUT:
		RETVAL

int
SizeOf_CvSeq()
	CODE:
		RETVAL = sizeof(CvSeq);
	OUTPUT:
		RETVAL
