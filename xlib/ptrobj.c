/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PTROBJ_EX (CvXXX*) for INPUT: */
int XS_ptrobj(SV* arg, const char* obj)
{
    if (SvROK(arg) && SvIOK(SvRV(arg)) && SvIV(SvRV(arg)) == 0)
        return 0;
	if (SvROK(arg) && sv_isobject(arg) && sv_derived_from(arg, obj))
		return SvIV((SV*)SvRV(arg));
	return -1;
}
