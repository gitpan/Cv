# -*- mode: text; coding: utf-8; tab-width: 4 -*-

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
#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

NO_OUTPUT int
cvSaveImage(const CvArr* image, const char* filename, const int* params=0)
C_ARGS:	filename, image, params
POSTCALL:
	if (!RETVAL) XSRETURN_UNDEF;
	XSRETURN(1);

#else

NO_OUTPUT int
cvSaveImage(const CvArr* image, const char* filename)
C_ARGS:	filename, image
POSTCALL:
	if (!RETVAL) XSRETURN_UNDEF;
	XSRETURN(1);

#endif

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

MODULE = Cv		PACKAGE = Cv::Arr
# ====================

CvMat*
cvEncodeImage(const CvArr* image, const char* ext, const int* params = 0)
C_ARGS:	ext, image, params


MODULE = Cv		PACKAGE = Cv::Mat
# ====================
#C# IplImage* cvDecodeImage(const CvMat* buf, int iscolor=CV_LOAD_IMAGE_COLOR)
#C# CvMat* cvDecodeImageM(const CvMat* buf, int iscolor=CV_LOAD_IMAGE_COLOR)

IplImage*
cvDecodeImage(SV* buf, int iscolor=CV_LOAD_IMAGE_COLOR)
ALIAS:	Cv::cvDecodeImage = 1
INIT:
	RETVAL = (IplImage*)0;
CODE:
	if (SvROK(buf)) {
		if (sv_isobject(buf)) {
			if (sv_derived_from(buf, "Cv::Mat")) {
				IV tmp = SvIV((SV*)SvRV(buf));
				RETVAL = cvDecodeImage(*(const CvMat**)&tmp, iscolor);
			} else {
				char *obj = (char*)sv_reftype(SvRV(buf), TRUE);
				croak("unsuported object %s\n", obj);
			}
		} else {
			croak("unsuported reference SvTYPE = %d\n", SvTYPE(SvRV(buf)));
		}
	} else if (SvPOK(buf)) {
		CvMat m; int rows = 1, cols = SvCUR(buf);
		cvInitMatHeader(&m, rows, cols, CV_8UC1, SvPV_nolen(buf), cols);
		RETVAL = cvDecodeImage(&m, iscolor);
	} else {
		croak("unsuported SvTYPE = %d\n", SvTYPE(buf));
	}
OUTPUT:
	RETVAL

CvMat*
cvDecodeImageM(SV* buf, int iscolor=CV_LOAD_IMAGE_COLOR)
ALIAS:	Cv::cvDecodeImageM = 1
INIT:
	RETVAL = (CvMat*)0;
CODE:
	if (SvROK(buf)) {
		if (sv_isobject(buf)) {
			if (sv_derived_from(buf, "Cv::Mat")) {
				IV tmp = SvIV((SV*)SvRV(buf));
				RETVAL = cvDecodeImageM(*(const CvMat**)&tmp, iscolor);
			} else {
				char *obj = (char*)sv_reftype(SvRV(buf), TRUE);
				croak("unsuported object %s\n", obj);
			}
		} else {
			croak("unsuported reference SvTYPE = %d\n", SvTYPE(SvRV(buf)));
		}
	} else if (SvPOK(buf)) {
		CvMat m; int rows = 1, cols = SvCUR(buf);
		cvInitMatHeader(&m, rows, cols, CV_8UC1, SvPV_nolen(buf), cols);
		RETVAL = cvDecodeImageM(&m, iscolor);
	} else {
		croak("unsuported SvTYPE = %d\n", SvTYPE(buf));
	}
OUTPUT:
	RETVAL

#endif

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
OUTPUT: RETVAL bless(ST(0), "Cv::Image::Ghost", RETVAL);

void
cvReleaseCapture(CvCapture* &capture)
ALIAS: Cv::Capture::DESTROY = 1

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

IplImage*
cvRetrieveFrame(CvCapture* capture, int streamIdx=0)
OUTPUT: RETVAL bless(ST(0), "Cv::Image::Ghost", RETVAL);

#else

IplImage*
cvRetrieveFrame(CvCapture* capture)
OUTPUT: RETVAL bless(ST(0), "Cv::Image::Ghost", RETVAL);

#endif

int
cvSetCaptureProperty(CvCapture* capture, int property_id, double value)


MODULE = Cv		PACKAGE = Cv
# ====================
CvVideoWriter*
cvCreateVideoWriter(const char* filename, SV* fourcc, double fps, CvSize frame_size, int is_color=1)
INIT:
	int cc;
	if (SvPOK(fourcc)) {
		char* cp = SvPV_nolen(fourcc);
		cc = CV_FOURCC(cp[0], cp[1], cp[2], cp[3]);
	} else if (SvIOK(fourcc)) {
		cc = SvIV(fourcc);
	} else {
		croak("fourcc: expected \"MJPG\" or CV_FOURCC('M', 'J', 'P', 'G')");
	}
C_ARGS:	filename, cc, fps, frame_size, is_color


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

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2000

void
cvSetWindowProperty(const char* name, int prop_id, double prop_value)

void
cvGetWindowProperty(const char* name, int prop_id)

#endif

#if (CV_MAJOR_VERSION * 1000 + CV_MINOR_VERSION) >= 2002

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
