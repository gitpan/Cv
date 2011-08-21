/* -*- mode: text; coding: utf-8; tab-width: 4 -*- */

#include "Cv-c.inc"
#include "const-c.inc"		/* AUTOLOAD constant */

#define length(x) length_ ## x
#define VOID void

MODULE = Cv		PACKAGE = Cv
# ====================
INCLUDE: Cv-xs.inc.tmp

MODULE = Cv		PACKAGE = Cv
# ====================
INCLUDE: const-xs.inc
