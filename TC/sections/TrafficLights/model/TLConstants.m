//
//  TLConstants.m
//  TC
//
//  Created by 郭志伟 on 15/10/22.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TLConstants.h"

NSString * const kAllSignalCtrlURL = @"http://10.100.8.107:8081/ItsWeb/devMtn/getAllSignalCtrl.do?params=1";

NSString * const kAllSitracsJunctionsURL = @"http://10.100.8.107:8081/ItsWeb/signalerCtrl/getAllSitracsJunctions.do";

NSString * const kCrossRunInfoURLFmt = @"http://10.100.8.107:8081/ItsWeb/signalerCtrl/getCrossRunInfo.do?phaseFlag=0&crossId=%@&junctionId";
NSString * const kSetCrossRunStageURL = @"http://10.100.8.107:8081/ItsWeb/signalerCtrl/setCrossRunStage.do";

NSString * const kArcgisMapSvrUrl = @"http://10.100.8.102/SIPSD/rest/services/SIPTPG/SIPMAP/MapServer";

NSString * const kArcgisTokenUrlFmt = @"http://10.100.8.102/SIPSD/tokens/?request=getToken&username=%@&password=%@";

NSString *const kElecPoliceUrl = @"http://10.100.8.107:8081/ItsWeb/devMtn/getAllElecPolice.do?params=1";

NSString *const kAllVideoRoadCamUrl = @"http://10.100.8.107:8081/ItsWeb/devMtn/getAllVideoCam.do?params=1&camLocTp=1";

NSString *const kAllVideoHighCamUrl = @"http://10.100.8.107:8081/ItsWeb/devMtn/getAllVideoCam.do?params=1&camLocTp=2";

NSString *const kLoginUrlFmt = @"http://10.100.8.107:8080/BizService/auth/login?username=%@&password=%@";

NSString *const kLastCrossSchemeUrlFmt = @"http://10.100.8.107:8081/ItsWeb/signalerCtrl/getLastCrossScheme.do?crossId=%@";

NSString *const kDWSignalCtrlStUrl = @"http://10.100.8.131:7001/ItsWeb/signalerCtrl/getDWSingalerFault.do";

NSString *const kDWSignalCtrlStaticInfoFmt = @"http://10.100.8.131:7001/ItsWeb/signalerCtrl/getDWCrossStaticData.do?crossId=%@";
NSString *const kDWCrossRunInfoURLFmt = @"http://10.100.8.131:7001/ItsWeb/signalerCtrl/getDWCrossRunInfo.do?crossId=%@";

NSString *const kDWSetCrossRunStageURL = @"http://10.100.8.131:7001/ItsWeb/signalerCtrl/setDWCrossStage.do";