/* -*- mode: text; coding: utf-8; tab-width: 4 -*- */

#include "Cv-c.inc"
#include "const-c.inc"		/* AUTOLOAD constant */

MODULE = Cv		PACKAGE = Cv
# ====================
INCLUDE: const-xs.inc

INCLUDE_COMMAND: $^X -lpe 's{\bvoid\s*\*}{VOID*}g' Cv-misc.inc

INCLUDE_COMMAND: $^X -lpe 's{\bvoid\s*\*}{VOID*}g' Cv-core.inc

#if WITH_IMGPROC
INCLUDE_COMMAND: $^X -lpe 's{\bvoid\s*\*}{VOID*}g' Cv-imgproc.inc

#endif
#if WITH_FEATURES2D
INCLUDE_COMMAND: $^X -lpe 's{\bvoid\s*\*}{VOID*}g' Cv-features2d.inc

#endif
#if WITH_FLANN
INCLUDE_COMMAND: $^X -lpe 's{\bvoid\s*\*}{VOID*}g' Cv-flann.inc

#endif
#if WITH_OBJDETECT
INCLUDE_COMMAND: $^X -lpe 's{\bvoid\s*\*}{VOID*}g' Cv-objdetect.inc

#endif
#if WITH_VIDEO
INCLUDE_COMMAND: $^X -lpe 's{\bvoid\s*\*}{VOID*}g' Cv-video.inc

#endif
#if WITH_HIGHGUI
INCLUDE_COMMAND: $^X -lpe 's{\bvoid\s*\*}{VOID*}g' Cv-highgui.inc

#endif
#if WITH_CALIB3D
INCLUDE_COMMAND: $^X -lpe 's{\bvoid\s*\*}{VOID*}g' Cv-calib3d.inc

#endif
#if WITH_ML
INCLUDE_COMMAND: $^X -lpe 's{\bvoid\s*\*}{VOID*}g' Cv-ml.inc

#endif
#if WITH_CONTRIB
INCLUDE_COMMAND: $^X -lpe 's{\bvoid\s*\*}{VOID*}g' Cv-contrib.inc

#endif
