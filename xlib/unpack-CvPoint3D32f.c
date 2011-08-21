/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvPoint3D32f) for INPUT: */
CvPoint3D32f XS_unpack_CvPoint3D32f(SV* arg)
{
	if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVAV) {
		return cvPoint3D32f(
			SvNV((SV*)(*av_fetch((AV*)SvRV(arg), 0, 0))),
			SvNV((SV*)(*av_fetch((AV*)SvRV(arg), 1, 0))),
			SvNV((SV*)(*av_fetch((AV*)SvRV(arg), 2, 0)))
			);
	}
	croak("not a CvPoint");
}