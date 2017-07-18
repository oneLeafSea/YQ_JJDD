// Copyright (c) 2011-2014, Zhejiang Uniview Technologies Co., Ltd. All rights reserved.
// --------------------------------------------------------------------------------
// UVErrorCode.h
//
// Project Code: AirIMOSIphoneSDK
// Module Name:
// Date Created: 2013-11-19
// Author: chenjiaxin/00891
// Description:错误码定义文件
//
// --------------------------------------------------------------------------------
// Modification History
// DATE        NAME             DESCRIPTION
// --------------------------------------------------------------------------------
//

#ifndef AirIMOSIphoneSDK_UVErrorCode_h
#define AirIMOSIphoneSDK_UVErrorCode_h

#define ERROR_START_POS (50000)

typedef enum
{
    UV_STATUS_SUCCESS = 0,
    UV_ERROR_COMMON_FAILURE = ERROR_START_POS + 1,
    UV_ERROR_NETWORK_UNREACHABLE,
    UV_ERROR_LOGIN_FAILURE,
    UV_ERROR_NO_MEMORY,
    UV_ERROR_NOT_LOGIN,
    UV_ERROR_SOCKET_CONNECT,
    UV_ERROR_SOCKET_BIND,
    UV_ERROR_SOCKET_SEND,
    UV_ERROR_SOCKET_RECEIVE,
    //
    UV_ERROR_PLAYER_OPENED,
    UV_ERROR_PLAYER_CONNECT,
    UV_ERROR_PLAYER_SEND_SESSION,
    UV_ERROR_PLAYER_RECORD,
    UV_ERROR_PLAYER_INIT,
    UV_ERROR_PLAYER_CLOSED,
    UV_ERROR_FILE_NOT_EXISTS,
    UV_ERROR_WRITE_FILE,
    UV_ERROR_OPEN_FILE_FAILURE,

}UV_ERROR_CODE_E;

#endif
