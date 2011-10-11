/* -*- mode: C; coding: utf-8; tab-width: 4 -*- */

#include "xlib/xs.h"

#define DIM(x) (sizeof(x)/sizeof((x)[0]))

#define length(x) length_ ## x
#define VOID void
#define bless(st0, class, retval) \
    sv_setref_pv(st0 = sv_newmortal(), class, (void*)retval);


/* Global Data */

#define MY_CXT_KEY "Cv::_guts" XS_VERSION

typedef struct {
	SV* callback;
	SV* value;
	int pos;
	int lastpos;
} trackbar_t;

typedef struct {
	AV* cb_trackbar_list;
	SV* cb_mouse;
	SV* cb_error;
} my_cxt_t;

START_MY_CXT

/* CvTrackbarCallback */

static void cb_trackbar(int pos)
{
	dMY_CXT;
	SV* t; AV *tmp = newAV();
	while ((t = av_shift(MY_CXT.cb_trackbar_list)) && t != &PL_sv_undef) {
		MAGIC* mg = mg_find(t, PERL_MAGIC_ext);
		trackbar_t* p = (trackbar_t*)mg->mg_obj;
		av_push(tmp, t);
		if (p && p->pos != p->lastpos) {
			p->lastpos = p->pos;
			if (p->value) sv_setiv(p->value, p->pos);
			if (p->callback) {
				dSP;
				ENTER;
				SAVETMPS;
				PUSHMARK(SP);
				XPUSHs(sv_2mortal(newSViv(p->pos)));
				PUTBACK;
				call_sv(p->callback, G_EVAL|G_DISCARD);
				FREETMPS;
				LEAVE;
			}
		}
	}
	while ((t = av_shift(tmp)) && t != &PL_sv_undef) {
		av_push(MY_CXT.cb_trackbar_list, t);
	}
	SvREFCNT_dec((SV*)tmp);
}

/* CvMouseCallback */

static void cb_mouse(int event, int x, int y, int flags, VOID* param)
{
	dMY_CXT;
    if (MY_CXT.cb_mouse) {
		dSP;
		ENTER;
		SAVETMPS;
		PUSHMARK(SP);
		EXTEND(SP, 5);
		PUSHs(sv_2mortal(newSViv(event)));
		PUSHs(sv_2mortal(newSViv(x)));
		PUSHs(sv_2mortal(newSViv(y)));
		PUSHs(sv_2mortal(newSViv(flags)));
		PUSHs(sv_2mortal(newSViv(*(IV*)&param)));
		PUTBACK;
		call_sv(MY_CXT.cb_mouse, G_EVAL|G_DISCARD);
		FREETMPS;
		LEAVE;
	}
}

CvMouseCallback make_perl_cb_CvMouseCallback(SV *callback)
{
	dMY_CXT;
	if (MY_CXT.cb_mouse) SvREFCNT_dec(MY_CXT.cb_mouse);
	MY_CXT.cb_mouse = (SV*)0;
	if (callback && SvROK(callback) && SvTYPE(SvRV(callback)) == SVt_PVCV) {
		MY_CXT.cb_mouse = (SV*)SvRV(callback);
		if (MY_CXT.cb_mouse) SvREFCNT_inc(MY_CXT.cb_mouse);
		return &cb_mouse;
	}
	return (CvMouseCallback)0;
}


/* CvErrorCallback */
static int cb_error(int status, const char* func_name, const char* err_msg,
					const char* file_name, int line, VOID* userdata)  {
	dMY_CXT;
    if (MY_CXT.cb_error) {
		dSP;
		ENTER;
		SAVETMPS;
		PUSHMARK(SP);
		EXTEND(SP, 6);
		PUSHs(sv_2mortal(newSViv(status)));
		PUSHs(sv_2mortal(newSVpvn(func_name, strlen(func_name))));
		PUSHs(sv_2mortal(newSVpvn(err_msg, strlen(err_msg))));
		PUSHs(sv_2mortal(newSVpvn(file_name, strlen(file_name))));
		PUSHs(sv_2mortal(newSViv(line)));
		PUSHs(sv_2mortal(newSViv(*(int*)&userdata)));
		PUTBACK;
		call_sv(MY_CXT.cb_error, G_EVAL|G_DISCARD);
		FREETMPS;
		LEAVE;
	}
	return 0;
}

CvErrorCallback make_perl_cb_CvErrorCallback(SV *callback)
{
	dMY_CXT;
	if (MY_CXT.cb_error) SvREFCNT_dec(MY_CXT.cb_error);
	MY_CXT.cb_error = (SV*)0;
	if (SvROK(callback) && SvTYPE(SvRV(callback)) == SVt_PVCV) {
		MY_CXT.cb_error = (SV*)SvRV(callback);
		if (MY_CXT.cb_error) SvREFCNT_inc(MY_CXT.cb_error);
		return &cb_error;
	}
	return (CvErrorCallback)0;
}

int
elemtype2ipldepth(int elemtype)
{
    switch (CV_MAT_DEPTH(elemtype)) {
	case CV_8U:  return IPL_DEPTH_8U;
	case CV_8S:  return IPL_DEPTH_8S;
	case CV_16U: return IPL_DEPTH_16U;
	case CV_16S: return IPL_DEPTH_16S;
	case CV_32S: return IPL_DEPTH_32S;
	case CV_32F: return IPL_DEPTH_32F;
	case CV_64F: return IPL_DEPTH_64F;
	default: return 0;
	}
}
