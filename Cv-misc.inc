# -*- mode: text; coding: utf-8; tab-width: 4 -*-

MODULE = Cv		PACKAGE = Cv
# ====================
BOOT:
	/* Setup Global Data */
	MY_CXT_INIT;
	MY_CXT.cb_trackbar_list = newAV();
	MY_CXT.cb_mouse = (SV*)0;
	MY_CXT.cb_error = (SV*)0;

void
CLONE(...)
CODE:
	MY_CXT_CLONE;

MODULE = Cv		PACKAGE = Cv
# ====================
double
cvVersion(...)
CODE:
	RETVAL =  CV_MAJOR_VERSION
			+ CV_MINOR_VERSION    * 1e-3
			+ CV_SUBMINOR_VERSION * 1e-6;
OUTPUT:
	RETVAL

SV*
CV_VERSION(...)
CODE:
	const char* v = CV_VERSION;
	RETVAL = newSVpvn(v, strlen(v));
OUTPUT:
	RETVAL

int
CV_MAKETYPE(int depth, int cn)
ALIAS: Cv::MAKETYPE = 1

int
CV_MAT_DEPTH(int flags)
ALIAS: Cv::MAT_DEPTH = 1

int
CV_IPL_DEPTH(int elemtype)
ALIAS: Cv::IPL_DEPTH = 1
CODE:
	RETVAL = elemtype2ipldepth(elemtype);
OUTPUT:
	RETVAL

int
CV_MAT_CN(int flags)
ALIAS: Cv::MAT_CN = 1

int
CV_NODE_TYPE(int type)
ALIAS: Cv::NODE_TYPE = 1

int
CV_IS_SET_ELEM(void* p)
ALIAS: Cv::IS_SET_ELEM = 1

double
CV_PI(...)
CODE:
	RETVAL = CV_PI;
OUTPUT:
	RETVAL

CvSlice
CV_WHOLE_SEQ(...)
CODE:
	RETVAL = CV_WHOLE_SEQ;
OUTPUT:
	RETVAL

int
CV_FOURCC(char c1, char c2, char c3, char c4)
