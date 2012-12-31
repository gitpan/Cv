# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 24;

BEGIN {
	use_ok('Cv', -more);
}

is(CV_8U, 0);
is(CV_8S, 1);
is(CV_16U, 2);
is(CV_16S, 3);
is(CV_32S, 4);
is(CV_32F, 5);
is(CV_64F, 6);

is(CV_8UC(1), CV_8UC1);
is(CV_8SC(1), CV_8SC1);
is(CV_16UC(1), CV_16UC1);
is(CV_16SC(1), CV_16SC1);
is(CV_32SC(1), CV_32SC1);
is(CV_32FC(1), CV_32FC1);
is(CV_64FC(1), CV_64FC1);

is(CV_MAT_CN(CV_8UC1), 1);
is(CV_MAT_TYPE(CV_8UC2), CV_8UC2);

is(CV2IPL_DEPTH(CV_8UC1), IPL_DEPTH_8U);
is(IPL2CV_DEPTH(IPL_DEPTH_8U), CV_8U);
is(IPL2CV_DEPTH(IPL_DEPTH_8S), CV_8S);

is(CV_MAKETYPE(CV_8U, 1), CV_8UC1);
is(CV_MAKE_TYPE(CV_8U, 1), CV_8UC1);
eval { CV_MAKETYPE(CV_8U, 0) };
ok($@);
eval { CV_MAKETYPE(CV_8U, CV_CN_MAX + 1) };
ok($@);

for (qw(

CV_16SC1 CV_16SC2 CV_16SC3 CV_16SC4 CV_16UC1 CV_16UC2 CV_16UC3
CV_16UC4 CV_32FC1 CV_32FC2 CV_32FC3 CV_32FC4 CV_32SC1 CV_32SC2
CV_32SC3 CV_32SC4 CV_64FC1 CV_64FC2 CV_64FC3 CV_64FC4 CV_8SC1 CV_8SC2
CV_8SC3 CV_8SC4 CV_8UC1 CV_8UC2 CV_8UC3 CV_8UC4 CV_DIFF_C CV_DIFF_L1
CV_DIFF_L2 CV_DXT_INVERSE_SCALE CV_DXT_INV_SCALE CV_FM_LMEDS
CV_FM_LMEDS_ONLY CV_FM_RANSAC CV_FM_RANSAC_ONLY CV_FONT_VECTOR0
CV_FOURCC_DEFAULT CV_GRAPH CV_HIST_TREE CV_MAT32F CV_MAT3x1_32F
CV_MAT3x1_64D CV_MAT3x3_32F CV_MAT3x3_64D CV_MAT4x1_32F CV_MAT4x1_64D
CV_MAT4x4_32F CV_MAT4x4_64D CV_MAT64D CV_MAT_CONT_FLAG CV_NODE_FLOAT
CV_NODE_INTEGER CV_NODE_STRING CV_ORIENTED_GRAPH CV_RELATIVE_C
CV_RELATIVE_L1 CV_RELATIVE_L2 CV_SEQ_CHAIN CV_SEQ_CHAIN_CONTOUR
CV_SEQ_CONNECTED_COMP CV_SEQ_CONTOUR CV_SEQ_ELTYPE_MASK
CV_SEQ_ELTYPE_PPOINT CV_SEQ_ELTYPE_PTR CV_SEQ_FLAG_CLOSED
CV_SEQ_FLAG_CONVEX CV_SEQ_FLAG_HOLE CV_SEQ_FLAG_SIMPLE CV_SEQ_INDEX
CV_SEQ_KIND_MASK CV_SEQ_KIND_SUBDIV2D CV_SEQ_POINT3D_SET
CV_SEQ_POINT_SET CV_SEQ_POLYGON CV_SEQ_POLYGON_TREE CV_SEQ_POLYLINE
CV_SEQ_SIMPLE_POLYGON CV_STORAGE_WRITE_BINARY CV_STORAGE_WRITE_TEXT
CV_TERMCRIT_NUMBER CV_WHOLE_ARR CV_WHOLE_SEQ

)) {
	no strict 'refs';
	eval { &$_ };
	diag $_ if $@;
}
