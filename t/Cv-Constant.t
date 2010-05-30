# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv-Constant.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use Test::More tests => 2;
BEGIN {
    use_ok('Cv');
}
my $fail = 0;
foreach my $constname (qw(

    CV_16S CV_16SC1 CV_16SC2 CV_16SC3 CV_16SC4 CV_16U CV_16UC1 CV_16UC2
    CV_16UC3 CV_16UC4 CV_32F CV_32FC1 CV_32FC2 CV_32FC3 CV_32FC4 CV_32S
    CV_32SC1 CV_32SC2 CV_32SC3 CV_32SC4 CV_64F CV_64FC1 CV_64FC2 CV_64FC3
    CV_64FC4 CV_8S CV_8SC1 CV_8SC2 CV_8SC3 CV_8SC4 CV_8U CV_8UC1 CV_8UC2
    CV_8UC3 CV_8UC4 CV_AA CV_ADAPTIVE_THRESH_GAUSSIAN_C
    CV_ADAPTIVE_THRESH_MEAN_C CV_ARRAY CV_AUTOSTEP CV_AUTO_STEP CV_BACK
    CV_BGFG_FGD_ALPHA_1 CV_BGFG_FGD_ALPHA_2 CV_BGFG_FGD_ALPHA_3
    CV_BGFG_FGD_BG_UPDATE_TRESH CV_BGFG_FGD_DELTA CV_BGFG_FGD_LC
    CV_BGFG_FGD_LCC CV_BGFG_FGD_MINAREA CV_BGFG_FGD_N1C CV_BGFG_FGD_N1CC
    CV_BGFG_FGD_N2C CV_BGFG_FGD_N2CC CV_BGFG_FGD_T
    CV_BGFG_MOG_BACKGROUND_THRESHOLD CV_BGFG_MOG_MAX_NGAUSSIANS
    CV_BGFG_MOG_MINAREA CV_BGFG_MOG_NCOLORS CV_BGFG_MOG_NGAUSSIANS
    CV_BGFG_MOG_SIGMA_INIT CV_BGFG_MOG_STD_THRESHOLD
    CV_BGFG_MOG_WEIGHT_INIT CV_BGFG_MOG_WINDOW_SIZE CV_BGR2BGR555
    CV_BGR2BGR565 CV_BGR2BGRA CV_BGR2GRAY CV_BGR2HLS CV_BGR2HSV CV_BGR2Lab
    CV_BGR2Luv CV_BGR2RGB CV_BGR2RGBA CV_BGR2XYZ CV_BGR2YCrCb
    CV_BGR5552BGR CV_BGR5552BGRA CV_BGR5552GRAY CV_BGR5552RGB
    CV_BGR5552RGBA CV_BGR5652BGR CV_BGR5652BGRA CV_BGR5652GRAY
    CV_BGR5652RGB CV_BGR5652RGBA CV_BGRA2BGR CV_BGRA2BGR555 CV_BGRA2BGR565
    CV_BGRA2GRAY CV_BGRA2RGB CV_BGRA2RGBA CV_BG_MODEL_FGD
    CV_BG_MODEL_FGD_SIMPLE CV_BG_MODEL_MOG CV_BILATERAL CV_BLUR
    CV_BLUR_NO_SCALE CV_BadAlign CV_BadAlphaChannel CV_BadCOI
    CV_BadCallBack CV_BadDataPtr CV_BadDepth CV_BadImageSize
    CV_BadModelOrChSeq CV_BadNumChannel1U CV_BadNumChannels CV_BadOffset
    CV_BadOrder CV_BadOrigin CV_BadROISize CV_BadStep CV_BadTileSize
    CV_BayerBG2BGR CV_BayerBG2RGB CV_BayerGB2BGR CV_BayerGB2RGB
    CV_BayerGR2BGR CV_BayerGR2RGB CV_BayerRG2BGR CV_BayerRG2RGB CV_C
    CV_CALIB_CB_ADAPTIVE_THRESH CV_CALIB_CB_FILTER_QUADS
    CV_CALIB_CB_NORMALIZE_IMAGE CV_CALIB_FIX_ASPECT_RATIO
    CV_CALIB_FIX_FOCAL_LENGTH CV_CALIB_FIX_INTRINSIC CV_CALIB_FIX_K1
    CV_CALIB_FIX_K2 CV_CALIB_FIX_K3 CV_CALIB_FIX_PRINCIPAL_POINT
    CV_CALIB_SAME_FOCAL_LENGTH CV_CALIB_USE_INTRINSIC_GUESS
    CV_CALIB_ZERO_DISPARITY CV_CALIB_ZERO_TANGENT_DIST CV_CAMERA_TO_WARP
    CV_CANNY_L2_GRADIENT CV_CAP_ANY CV_CAP_CMU1394 CV_CAP_DC1394
    CV_CAP_DSHOW CV_CAP_FIREWARE CV_CAP_FIREWIRE CV_CAP_IEEE1394
    CV_CAP_MIL CV_CAP_PROP_BRIGHTNESS CV_CAP_PROP_CONTRAST
    CV_CAP_PROP_CONVERT_RGB CV_CAP_PROP_FORMAT CV_CAP_PROP_FOURCC
    CV_CAP_PROP_FPS CV_CAP_PROP_FRAME_COUNT CV_CAP_PROP_FRAME_HEIGHT
    CV_CAP_PROP_FRAME_WIDTH CV_CAP_PROP_GAIN CV_CAP_PROP_HUE
    CV_CAP_PROP_MODE CV_CAP_PROP_POS_AVI_RATIO CV_CAP_PROP_POS_FRAMES
    CV_CAP_PROP_POS_MSEC CV_CAP_PROP_SATURATION CV_CAP_QT CV_CAP_STEREO
    CV_CAP_TYZX CV_CAP_UNICAP CV_CAP_V4L CV_CAP_V4L2 CV_CAP_VFW
    CV_CHAIN_APPROX_NONE CV_CHAIN_APPROX_SIMPLE CV_CHAIN_APPROX_TC89_KCOS
    CV_CHAIN_APPROX_TC89_L1 CV_CHAIN_CODE CV_CHECK_QUIET CV_CHECK_RANGE
    CV_CLOCKWISE CV_CMP_EQ CV_CMP_GE CV_CMP_GT CV_CMP_LE CV_CMP_LT
    CV_CMP_NE CV_CN_MAX CV_CN_SHIFT CV_COLORCVT_MAX CV_COMP_BHATTACHARYYA
    CV_COMP_CHISQR CV_COMP_CORREL CV_COMP_INTERSECT CV_CONTOURS_MATCH_I1
    CV_CONTOURS_MATCH_I2 CV_CONTOURS_MATCH_I3 CV_CONTOUR_TREES_MATCH_I1
    CV_COUNTER_CLOCKWISE CV_COVAR_COLS CV_COVAR_NORMAL CV_COVAR_ROWS
    CV_COVAR_SCALE CV_COVAR_SCRAMBLED CV_COVAR_USE_AVG CV_CVTIMG_FLIP
    CV_CVTIMG_SWAP_RB CV_DEPTH_MAX CV_DIFF CV_DIFF_C CV_DIFF_L1 CV_DIFF_L2
    CV_DISPARITY_BIRCHFIELD CV_DIST_C CV_DIST_FAIR CV_DIST_HUBER
    CV_DIST_L1 CV_DIST_L12 CV_DIST_L2 CV_DIST_MASK_3 CV_DIST_MASK_5
    CV_DIST_MASK_PRECISE CV_DIST_USER CV_DIST_WELSCH CV_DOMINANT_IPAN
    CV_DXT_FORWARD CV_DXT_INVERSE CV_DXT_INVERSE_SCALE CV_DXT_INV_SCALE
    CV_DXT_MUL_CONJ CV_DXT_ROWS CV_DXT_SCALE CV_EIGOBJ_BOTH_CALLBACK
    CV_EIGOBJ_INPUT_CALLBACK CV_EIGOBJ_NO_CALLBACK
    CV_EIGOBJ_OUTPUT_CALLBACK CV_EVENT_FLAG_ALTKEY CV_EVENT_FLAG_CTRLKEY
    CV_EVENT_FLAG_LBUTTON CV_EVENT_FLAG_MBUTTON CV_EVENT_FLAG_RBUTTON
    CV_EVENT_FLAG_SHIFTKEY CV_EVENT_LBUTTONDBLCLK CV_EVENT_LBUTTONDOWN
    CV_EVENT_LBUTTONUP CV_EVENT_MBUTTONDBLCLK CV_EVENT_MBUTTONDOWN
    CV_EVENT_MBUTTONUP CV_EVENT_MOUSEMOVE CV_EVENT_RBUTTONDBLCLK
    CV_EVENT_RBUTTONDOWN CV_EVENT_RBUTTONUP CV_ErrModeLeaf
    CV_ErrModeParent CV_ErrModeSilent CV_FILLED CV_FLOODFILL_FIXED_RANGE
    CV_FLOODFILL_MASK_ONLY CV_FM_7POINT CV_FM_8POINT CV_FM_LMEDS
    CV_FM_LMEDS_ONLY CV_FM_RANSAC CV_FM_RANSAC_ONLY
    CV_FONT_HERSHEY_COMPLEX CV_FONT_HERSHEY_COMPLEX_SMALL
    CV_FONT_HERSHEY_DUPLEX CV_FONT_HERSHEY_PLAIN
    CV_FONT_HERSHEY_SCRIPT_COMPLEX CV_FONT_HERSHEY_SCRIPT_SIMPLEX
    CV_FONT_HERSHEY_SIMPLEX CV_FONT_HERSHEY_TRIPLEX CV_FONT_ITALIC
    CV_FONT_VECTOR0 CV_FOURCC_DEFAULT CV_FOURCC_PROMPT CV_FRONT
    CV_GAUSSIAN CV_GEMM_A_T CV_GEMM_B_T CV_GEMM_C_T
    CV_GLCMDESC_CLUSTERSHADE CV_GLCMDESC_CLUSTERTENDENCY
    CV_GLCMDESC_CONTRAST CV_GLCMDESC_CORRELATION
    CV_GLCMDESC_CORRELATIONINFO1 CV_GLCMDESC_CORRELATIONINFO2
    CV_GLCMDESC_ENERGY CV_GLCMDESC_ENTROPY CV_GLCMDESC_HOMOGENITY
    CV_GLCMDESC_MAXIMUMPROBABILITY
    CV_GLCMDESC_OPTIMIZATION_ALLOWDOUBLENEST
    CV_GLCMDESC_OPTIMIZATION_ALLOWTRIPLENEST
    CV_GLCMDESC_OPTIMIZATION_HISTOGRAM CV_GLCM_ALL CV_GLCM_DESC
    CV_GLCM_GLCM CV_GLCM_OPTIMIZATION_HISTOGRAM CV_GLCM_OPTIMIZATION_LUT
    CV_GLCM_OPTIMIZATION_NONE CV_GRAPH CV_GRAPH_ALL_ITEMS
    CV_GRAPH_ANY_EDGE CV_GRAPH_BACKTRACKING CV_GRAPH_BACK_EDGE
    CV_GRAPH_CROSS_EDGE CV_GRAPH_FLAG_ORIENTED CV_GRAPH_FORWARD_EDGE
    CV_GRAPH_FORWARD_EDGE_FLAG CV_GRAPH_ITEM_VISITED_FLAG
    CV_GRAPH_NEW_TREE CV_GRAPH_OVER CV_GRAPH_SEARCH_TREE_NODE_FLAG
    CV_GRAPH_TREE_EDGE CV_GRAPH_VERTEX CV_GRAY2BGR CV_GRAY2BGR555
    CV_GRAY2BGR565 CV_GRAY2BGRA CV_GRAY2RGB CV_GRAY2RGBA
    CV_HAAR_DO_CANNY_PRUNING CV_HAAR_DO_ROUGH_SEARCH CV_HAAR_FEATURE_MAX
    CV_HAAR_FIND_BIGGEST_OBJECT CV_HAAR_MAGIC_VAL CV_HAAR_SCALE_IMAGE
    CV_HIST_ARRAY CV_HIST_MAGIC_VAL CV_HIST_RANGES_FLAG CV_HIST_SPARSE
    CV_HIST_TREE CV_HIST_UNIFORM CV_HIST_UNIFORM_FLAG CV_HLS2BGR
    CV_HLS2RGB CV_HOUGH_GRADIENT CV_HOUGH_MULTI_SCALE
    CV_HOUGH_PROBABILISTIC CV_HOUGH_STANDARD CV_HSV2BGR CV_HSV2RGB
    CV_HeaderIsNull CV_IDP_BIRCHFIELD_PARAM1 CV_IDP_BIRCHFIELD_PARAM2
    CV_IDP_BIRCHFIELD_PARAM3 CV_IDP_BIRCHFIELD_PARAM4
    CV_IDP_BIRCHFIELD_PARAM5 CV_INPAINT_NS CV_INPAINT_TELEA CV_INTER_AREA
    CV_INTER_CUBIC CV_INTER_LINEAR CV_INTER_NN CV_L1 CV_L2 CV_LINK_RUNS
    CV_LKFLOW_GET_MIN_EIGENVALS CV_LKFLOW_INITIAL_GUESSES
    CV_LKFLOW_PYR_A_READY CV_LKFLOW_PYR_B_READY CV_LMEDS
    CV_LOAD_IMAGE_ANYCOLOR CV_LOAD_IMAGE_ANYDEPTH CV_LOAD_IMAGE_COLOR
    CV_LOAD_IMAGE_GRAYSCALE CV_LOAD_IMAGE_UNCHANGED CV_LOG2 CV_LSQ CV_LU
    CV_Lab2BGR CV_Lab2RGB CV_Luv2BGR CV_Luv2RGB CV_MAGIC_MASK
    CV_MAJOR_VERSION CV_MAT32F CV_MAT3x1_32F CV_MAT3x1_64D CV_MAT3x3_32F
    CV_MAT3x3_64D CV_MAT4x1_32F CV_MAT4x1_64D CV_MAT4x4_32F CV_MAT4x4_64D
    CV_MAT64D CV_MATND_MAGIC_VAL CV_MAT_CN_MASK CV_MAT_CONT_FLAG
    CV_MAT_CONT_FLAG_SHIFT CV_MAT_DEPTH_MASK CV_MAT_MAGIC_VAL
    CV_MAT_TEMP_FLAG CV_MAT_TEMP_FLAG_SHIFT CV_MAT_TYPE_MASK CV_MAX_ARR
    CV_MAX_DIM CV_MAX_DIM_HEAP CV_MAX_SOBEL_KSIZE CV_MEDIAN CV_MINMAX
    CV_MINOR_VERSION CV_MOP_BLACKHAT CV_MOP_CLOSE CV_MOP_GRADIENT
    CV_MOP_OPEN CV_MOP_TOPHAT CV_MaskIsTiled CV_NODE_EMPTY CV_NODE_FLOAT
    CV_NODE_FLOW CV_NODE_INT CV_NODE_INTEGER CV_NODE_MAP CV_NODE_NAMED
    CV_NODE_NONE CV_NODE_REAL CV_NODE_REF CV_NODE_SEQ CV_NODE_SEQ_SIMPLE
    CV_NODE_STR CV_NODE_STRING CV_NODE_TYPE_MASK CV_NODE_USER CV_NORM_MASK
    CV_NO_CN_CHECK CV_NO_DEPTH_CHECK CV_NO_SIZE_CHECK CV_NUM_FACE_ELEMENTS
    CV_ORIENTED_GRAPH CV_PCA_DATA_AS_COL CV_PCA_DATA_AS_ROW CV_PCA_USE_AVG
    CV_PI CV_POLY_APPROX_DP CV_RAND_NORMAL CV_RAND_UNI CV_RANSAC
    CV_REDUCE_AVG CV_REDUCE_MAX CV_REDUCE_MIN CV_REDUCE_SUM CV_RELATIVE
    CV_RELATIVE_C CV_RELATIVE_L1 CV_RELATIVE_L2 CV_RETR_CCOMP
    CV_RETR_EXTERNAL CV_RETR_LIST CV_RETR_TREE CV_RGB2BGR CV_RGB2BGR555
    CV_RGB2BGR565 CV_RGB2BGRA CV_RGB2GRAY CV_RGB2HLS CV_RGB2HSV CV_RGB2Lab
    CV_RGB2Luv CV_RGB2RGBA CV_RGB2XYZ CV_RGB2YCrCb CV_RGBA2BGR
    CV_RGBA2BGR555 CV_RGBA2BGR565 CV_RGBA2BGRA CV_RGBA2GRAY CV_RGBA2RGB
    CV_RODRIGUES_M2V CV_RODRIGUES_V2M CV_SCHARR CV_SEQ_CHAIN
    CV_SEQ_CHAIN_CONTOUR CV_SEQ_CONNECTED_COMP CV_SEQ_CONTOUR
    CV_SEQ_ELTYPE_BITS CV_SEQ_ELTYPE_CODE CV_SEQ_ELTYPE_CONNECTED_COMP
    CV_SEQ_ELTYPE_GENERIC CV_SEQ_ELTYPE_GRAPH_EDGE
    CV_SEQ_ELTYPE_GRAPH_VERTEX CV_SEQ_ELTYPE_INDEX CV_SEQ_ELTYPE_MASK
    CV_SEQ_ELTYPE_POINT CV_SEQ_ELTYPE_POINT3D CV_SEQ_ELTYPE_PPOINT
    CV_SEQ_ELTYPE_PTR CV_SEQ_ELTYPE_TRIAN_ATR CV_SEQ_FLAG_CLOSED
    CV_SEQ_FLAG_CONVEX CV_SEQ_FLAG_HOLE CV_SEQ_FLAG_SHIFT
    CV_SEQ_FLAG_SIMPLE CV_SEQ_INDEX CV_SEQ_KIND_BIN_TREE CV_SEQ_KIND_BITS
    CV_SEQ_KIND_CURVE CV_SEQ_KIND_GENERIC CV_SEQ_KIND_GRAPH
    CV_SEQ_KIND_MASK CV_SEQ_KIND_SUBDIV2D CV_SEQ_MAGIC_VAL
    CV_SEQ_POINT3D_SET CV_SEQ_POINT_SET CV_SEQ_POLYGON CV_SEQ_POLYGON_TREE
    CV_SEQ_POLYLINE CV_SEQ_SIMPLE_POLYGON CV_SET_ELEM_FREE_FLAG
    CV_SET_ELEM_IDX_MASK CV_SET_MAGIC_VAL CV_SHAPE_CROSS CV_SHAPE_CUSTOM
    CV_SHAPE_ELLIPSE CV_SHAPE_RECT CV_SHIFT_DOWN CV_SHIFT_LD CV_SHIFT_LEFT
    CV_SHIFT_LU CV_SHIFT_NONE CV_SHIFT_RD CV_SHIFT_RIGHT CV_SHIFT_RU
    CV_SHIFT_UP CV_SORT_ASCENDING CV_SORT_DESCENDING CV_SORT_EVERY_COLUMN
    CV_SORT_EVERY_ROW CV_SPARSE_MAT_MAGIC_VAL CV_SSE2 CV_STEREO_BM_BASIC
    CV_STEREO_BM_FISH_EYE CV_STEREO_BM_NARROW
    CV_STEREO_BM_NORMALIZED_RESPONSE CV_STEREO_GC_OCCLUDED
    CV_STORAGE_APPEND CV_STORAGE_MAGIC_VAL CV_STORAGE_READ
    CV_STORAGE_WRITE CV_STORAGE_WRITE_BINARY CV_STORAGE_WRITE_TEXT
    CV_SUBDIV2D_VIRTUAL_POINT_FLAG CV_SUBMINOR_VERSION CV_SVD
    CV_SVD_MODIFY_A CV_SVD_SYM CV_SVD_U_T CV_SVD_V_T CV_StsAutoTrace
    CV_StsBackTrace CV_StsBadArg CV_StsBadFlag CV_StsBadFunc CV_StsBadMask
    CV_StsBadMemBlock CV_StsBadPoint CV_StsBadSize CV_StsDivByZero
    CV_StsError CV_StsFilterOffsetErr CV_StsFilterStructContentErr
    CV_StsInplaceNotSupported CV_StsInternal CV_StsKernelStructContentErr
    CV_StsNoConv CV_StsNoMem CV_StsNotImplemented CV_StsNullPtr
    CV_StsObjectNotFound CV_StsOk CV_StsOutOfRange CV_StsParseError
    CV_StsUnmatchedFormats CV_StsUnmatchedSizes CV_StsUnsupportedFormat
    CV_StsVecLengthErr CV_TERMCRIT_EPS CV_TERMCRIT_ITER CV_TERMCRIT_NUMBER
    CV_THRESH_BINARY CV_THRESH_BINARY_INV CV_THRESH_MASK CV_THRESH_OTSU
    CV_THRESH_TOZERO CV_THRESH_TOZERO_INV CV_THRESH_TRUNC CV_TM_CCOEFF
    CV_TM_CCOEFF_NORMED CV_TM_CCORR CV_TM_CCORR_NORMED CV_TM_SQDIFF
    CV_TM_SQDIFF_NORMED CV_TYZX_COLOR CV_TYZX_LEFT CV_TYZX_RIGHT CV_TYZX_Z
    CV_UNDEF_SC_PARAM CV_USRTYPE1 CV_VALUE CV_WARP_FILL_OUTLIERS
    CV_WARP_INVERSE_MAP CV_WARP_TO_CAMERA CV_WHOLE_SEQ_END_INDEX
    CV_WINDOW_AUTOSIZE CV_XYZ2BGR CV_XYZ2RGB CV_YCrCb2BGR CV_YCrCb2RGB
    IPL_ALIGN_16BYTES IPL_ALIGN_32BYTES IPL_ALIGN_4BYTES IPL_ALIGN_8BYTES
    IPL_ALIGN_DWORD IPL_ALIGN_QWORD IPL_BORDER_CONSTANT IPL_BORDER_REFLECT
    IPL_BORDER_REFLECT_101 IPL_BORDER_REPLICATE IPL_BORDER_WRAP
    IPL_DATA_ORDER_PIXEL IPL_DATA_ORDER_PLANE IPL_DEPTH_16S IPL_DEPTH_16U
    IPL_DEPTH_1U IPL_DEPTH_32F IPL_DEPTH_32S IPL_DEPTH_64F IPL_DEPTH_8S
    IPL_DEPTH_8U IPL_DEPTH_SIGN IPL_GAUSSIAN_5x5 IPL_IMAGE_DATA
    IPL_IMAGE_HEADER IPL_IMAGE_MAGIC_VAL IPL_IMAGE_ROI IPL_ORIGIN_BL
    IPL_ORIGIN_TL

	)) {
    eval {
	no strict 'refs';
	&$constname;
    };
    if ($@ =~ /^Undefined subroutine/) {
	print STDERR "# fail: $@";
	$fail++;
    }
}

ok( $fail == 0 , 'Constants' );
#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.
