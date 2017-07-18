//
//  TLConstants.m
//  TC
//
//  Created by 郭志伟 on 15/10/22.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TLConstants.h"


NSString * const kAllSignalCtrlURL = @"http://10.100.8.131:7001/ItsWeb/devMtn/getAllSignalCtrl.do?params=1";    

NSString * const kAllSitracsJunctionsURL = @"http://10.100.8.131:7001/ItsWeb/signalerCtrl/getAllSitracsJunctions.do";

NSString * const kCrossRunInfoURLFmt = @"http://10.100.8.131:7001/ItsWeb/signalerCtrl/getCrossRunInfo.do?phaseFlag=0&crossId=%@&junctionId";
NSString * const kSetCrossRunStageURL = @"http://10.100.8.131:7001/ItsWeb/signalerCtrl/setCrossRunStage.do";
NSString * const kArcgisMapSvrUrl = @"http://10.100.8.105:6080/arcgis/rest/services/SIPTPG/Basemap/MapServer";
NSString *const kArc= @"http://10.100.8.105/sipsd/rest/services/SIPTPG/Basemap/MapServer";
NSString *const kElecPoliceUrl = @"http://10.100.8.131:7001/ItsWeb/devMtn/getAllElecPolice.do?params=1";

NSString *const kAllVideoRoadCamUrl = @"http://10.100.8.131:7001/ItsWeb/devMtn/getAllVideoCam.do?params=1&camLocTp=1";//路口视频

NSString *const kAllVideoHighCamUrl = @"http://10.100.8.131:7001/ItsWeb/devMtn/getAllVideoCam.do?params=1&camLocTp=2";//高空视频

NSString *const kLoginUrlFmt = @"http://10.100.8.109:7001/BizService/auth/login?username=%@&password=%@";//注册登录

NSString *const kLastCrossSchemeUrlFmt = @"http://10.100.8.131:7001/ItsWeb/signalerCtrl/getLastCrossScheme.do?crossId=%@";
NSString *const kDWSignalCtrlStUrl = @"http://10.100.8.131:7001/ItsWeb/signalerCtrl/getDWSingalerFault.do";//大为信号控制

NSString *const kDWSignalCtrlStaticInfoFmt = @"http://10.100.8.131:7001/ItsWeb/signalerCtrl/getDWCrossStaticData.do?crossId=%@";
NSString *const kDWCrossRunInfoURLFmt = @"http://10.100.8.131:7001/ItsWeb/signalerCtrl/getDWCrossRunInfo.do?crossId=%@";

NSString *const kDWSetCrossRunStageURL = @"http://10.100.8.131:7001/ItsWeb/signalerCtrl/setDWCrossStage.do";//大为
NSString *const KDWSingalCtrlReq=@"http://10.100.8.131:7001/ItsWeb/signalerCtrlReq/applyReq.do";
NSString *const KOWFSingalCtrlReq=@"http://10.100.9.20:8082/sendStatus?id=%@";//公司提供申请控制接口的url
NSString *const KDWSingalCtrlRelease=@"http://10.100.8.131:7001/ItsWeb/signalerCtrlReq/release.do";
NSString *const KLoginDYUrl=@"http://10.101.5.1:8080/setVenPass";
NSString *const KGetDYUrl=@"http://10.100.9.20:8080/getVenPass";