/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#ifndef __xs_h
#define __xs_h 1

#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif

/* #define NEED_sv_2pv_nolen */
#include "ppport.h"

#include <opencv/cv.h>
#include <opencv/highgui.h>
#ifdef __cplusplus
#include <opencv/cvaux.h>
#ifdef __OPENCV_OLD_CV_H__
#include "opencv2/opencv.hpp"
#endif
#endif

#include "typemap.h"

#endif
