//
//  TCMapViewController.m
//  TC
//
//  Created by 郭志伟 on 15/11/12.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "TCMapViewController.h"

#import <ArcGIS/ArcGIS.h>
#import <Masonry/Masonry.h>

#import "RTSearchViewController.h"
#import "env.h"
#import "AppDelegate.h"
#import "TCSignalCtrllerCallOutViewController.h"
#import "TCHighCamCallOutViewController.h"
#import "TCCamCallOutViewController.h"
#import "TCMapLayerSelectionView.h"
#import "RTTextField.h"
#import "LogLevel.h"
#import "TCEPCCalloutViewController.h"
#import "TVElecPoliceInfo.h"

#ifdef YUAN_QU_DA_DUI
#define kBaseMap @"http://10.100.8.102/sipsd/rest/services/SIPTPG/Basemap/MapServer"
#else
#define kBaseMap @"http://www.arcgisonline.cn/ArcGIS/rest/services/ChinaOnlineCommunity/MapServer"
#endif

//NSString *kHcDeviceId = @"hcDeviceId";
//NSString *kRcDeviceId = @"rcDeviceId";
//NSString *kEpDeviceId = @"epDeviceId";
NSString *kCtrlerId = @"ctrlerId";
NSString *kCam = @"cam";

@interface TCMapViewController()<AGSCalloutDelegate, AGSLayerDelegate, TCMapLayerSelectionViewDelegate, RTTextFieldDelegate, UITextFieldDelegate, TLMgrDelegate, TCEPCCalloutViewControllerDelegate>

@property(nonatomic, strong) AGSMapView *mapView;
@property(nonatomic, strong) AGSGraphicsLayer *scGraphicsLayer;
@property(nonatomic, strong) AGSGraphicsLayer *highCamGraphicsLayer;
@property(nonatomic, strong) AGSGraphicsLayer *roadCamGraphicsLayer;
@property(nonatomic, strong) AGSGraphicsLayer *epGraphicsLayer;

@property(nonatomic, strong) TCMapLayerSelectionView *layerSelectionView;

@property(nonatomic, strong) TCEPCCalloutViewController *epcCalloutVC;


@property(nonatomic, strong) UIButton *shiftBtn;
@property(nonatomic, strong) NSMutableArray *mutableSelSCArray;
@property(nonatomic, strong) NSMutableArray *mutableSelCamArray;
@property(nonatomic, strong) NSMutableDictionary *wholeCams;


@end

@implementation TCMapViewController

- (void)dealloc {
    [APP_DELEGATE.tlMgr stopRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mutableSelSCArray = [[NSMutableArray alloc] initWithCapacity:32];
//    self.mutableSelHcArray = [[NSMutableArray alloc] initWithCapacity:4];
    self.mutableSelCamArray = [[NSMutableArray alloc] initWithCapacity:4];
    self.wholeCams = [[NSMutableDictionary alloc] initWithCapacity:1024];
    [self setupConstraints];
    [self setupMap];
    [self setupSearch];
    
}

- (void)deleteScInfo:(TLSignalCtrlerInfo *)scInfo {
    [self removeSelSignalCtrlerById:scInfo.ctrlerId];
    [self.scGraphicsLayer.graphics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AGSGraphic *g = obj;
        if ([g hasAttributeForKey:kCtrlerId]) {
            NSString *ctlerId = [g attributeForKey:kCtrlerId];
            if ([ctlerId isEqualToString:scInfo.ctrlerId]) {
                AGSPictureMarkerSymbol *graphicSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:[scInfo getSCImageByStatus]];
                g.symbol = graphicSymbol;
                *stop = YES;
            }
        }
    }];
}

- (void)deleteCamInfo:(TVCamInfo *)camInfo {
    __block NSInteger index = NSNotFound;
    [self.mutableSelCamArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AGSGraphic *graphic = obj;
        if ([graphic hasAttributeForKey:kCam]) {
            NSString *deviceId = [graphic attributeForKey:kCam];
            if ([deviceId isEqualToString:camInfo.deviceId]) {
                DDLogInfo(@"改变%@探头为正常模式", camInfo.deviceNam);
                graphic.symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:[camInfo getCamImagByStatus]];
                *stop = YES;
                index = idx;
            }
            
        }
    }];
    if (index != NSNotFound) {
        DDLogInfo(@"选中中移除摄像头。");
        [self.mutableSelCamArray removeObjectAtIndex:index];
    }
}

#pragma mark - setup

- (void)setupMap {
    NSURL *mapUrl = [NSURL URLWithString:kBaseMap];
#ifdef YUAN_QU_DA_DUI
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tl.mapToken"];
    AGSCredential *credential = [[AGSCredential alloc] initWithToken:token];
    AGSTiledMapServiceLayer *tiledLyr = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:mapUrl credential:credential];
    tiledLyr.delegate = self;
    [self.mapView addMapLayer:tiledLyr withName:@"Tiled Layer"];
    AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:57235.644737956158 ymin:42551.117602235208 xmax:65744.661755990179 ymax:47308.335450004241 spatialReference:nil];
    [self.mapView zoomToEnvelope:env animated:YES];
#else
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tl.mapToken"];
//    AGSCredential *credential = [[AGSCredential alloc] initWithToken:token];
    AGSTiledMapServiceLayer *tiledLyr = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:mapUrl];
    tiledLyr.delegate = self;
    [self.mapView addMapLayer:tiledLyr withName:@"Tiled Layer"];
//    AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:57235.644737956158 ymin:42551.117602235208 xmax:65744.661755990179 ymax:47308.335450004241 spatialReference:nil];
//    [self.mapView zoomToEnvelope:env animated:YES];
#endif
    self.mapView.callout.delegate = self;
    
    [self createScGraphics];
    [self createHighCamGraphics];
    [self createRoadCamGraphics];
    [self createEPGraphics];
    self.layerSelectionView.scOn = YES;
    [self.mapView addMapLayer:self.scGraphicsLayer withName:@"sc_graphicsLayer"];
}

#pragma mark - private method

- (void)createScGraphics {
    self.scGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [APP_DELEGATE.tlMgr.signaleCtrlerInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TLSignalCtrlerInfo *scInfo = obj;
        AGSGraphic *graphic = nil;
        AGSPoint *graphicPoint = nil;
        AGSPictureMarkerSymbol *graphicSymbol = nil;
        
        graphicPoint = [AGSPoint pointWithX:scInfo.tlPoint.x y:scInfo.tlPoint.y spatialReference:self.mapView.spatialReference];
        graphicSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:[scInfo getSCImageByStatus]];
        NSDictionary *d = @{kCtrlerId: scInfo.ctrlerId};
        graphic = [AGSGraphic graphicWithGeometry:graphicPoint symbol:graphicSymbol attributes:d];
        [self.scGraphicsLayer addGraphic:graphic];
    }];
//    [self.mapView addMapLayer:self.scGraphicsLayer withName:@"sc_graphicsLayer"];
}

- (void)createHighCamGraphics {
    self.highCamGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [APP_DELEGATE.tlMgr.highCamInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TVHighCamInfo *hci = obj;
        AGSGraphic *graphic = nil;
        AGSPoint *graphicPoint = nil;
        AGSPictureMarkerSymbol *graphicSymbol = nil;
        graphicPoint = [AGSPoint pointWithX:hci.pt.x y:hci.pt.y spatialReference:self.mapView.spatialReference];
        graphicSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:[hci getCamImagByStatus]];
        NSDictionary *d = @{kCam: hci.deviceId};
        [self.wholeCams setObject:hci forKey:hci.deviceId];
        graphic = [AGSGraphic graphicWithGeometry:graphicPoint symbol:graphicSymbol attributes:d];
        [self.highCamGraphicsLayer addGraphic:graphic];
    }];
//    [self.mapView addMapLayer:self.highCamGraphicsLayer withName:@"hc_graphlayer"];
}

- (void)createRoadCamGraphics {
    self.roadCamGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [APP_DELEGATE.tlMgr.roadCamInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TVRoadCamInfo *rci = obj;
        AGSGraphic *graphic = nil;
        AGSPoint *graphicPoint = nil;
        AGSPictureMarkerSymbol *graphicSymbol = nil;
        graphicPoint = [AGSPoint pointWithX:rci.pt.x y:rci.pt.y spatialReference:self.mapView.spatialReference];
        graphicSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:[rci getCamImagByStatus]];
        NSDictionary *d = @{kCam: rci.deviceId};
        [self.wholeCams setObject:rci forKey:rci.deviceId];
        graphic = [AGSGraphic graphicWithGeometry:graphicPoint symbol:graphicSymbol attributes:d];
        [self.roadCamGraphicsLayer addGraphic:graphic];
    }];
}

- (void)createEPGraphics {
    self.epGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [APP_DELEGATE.tlMgr.elecPoliceInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TVRoadCamInfo *epci = obj;
        AGSGraphic *graphic = nil;
        AGSPoint *graphicPoint = nil;
        AGSPictureMarkerSymbol *graphicSymbol = nil;
        graphicPoint = [AGSPoint pointWithX:epci.pt.x y:epci.pt.y spatialReference:self.mapView.spatialReference];
        graphicSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:[epci getCamImagByStatus]];
        NSDictionary *d = @{kCam: epci.deviceId};
        [self.wholeCams setObject:epci forKey:epci.deviceId];
        graphic = [AGSGraphic graphicWithGeometry:graphicPoint symbol:graphicSymbol attributes:d];
        [self.epGraphicsLayer addGraphic:graphic];
    }];
    
}


- (void)removeSelSignalCtrlerById:(NSString *)ctrlerId {
    __block NSInteger at = NSNotFound;
    [self.mutableSelSCArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *Id = obj;
        if ([Id isEqualToString:ctrlerId]) {
            at = idx;
            *stop = YES;
        }
    }];
    if (at != NSNotFound) {
        [self.mutableSelSCArray removeObjectAtIndex:at];
    }
}

- (BOOL)isSelectedSignalCtrler:(NSString *)ctrlerId {
    __block BOOL found = NO;
    [self.mutableSelSCArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *cId = obj;
        if ([cId isEqualToString:ctrlerId]) {
            found = YES;
            *stop = YES;
        }
        
    }];
    return found;
}

- (BOOL)isSelectedInCamArry:(AGSGraphic *) graphic {
    __block BOOL found = NO;
    [self.mutableSelCamArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AGSGraphic *g = obj;
        if ([g isEqual:graphic]) {
            found = YES;
            *stop = YES;
        }
    }];
    return found;
}

- (TVCamInfo *)getCamInfoByGraphic:(AGSGraphic *) graphic {
    NSString *deviceId = [graphic attributeForKey:kCam];
    TVCamInfo *ci = [self.wholeCams objectForKey:deviceId];;
    return ci;
}

#pragma mark - setup

- (void)setupSearch {
    RTTextField *searchTextField = [[RTTextField alloc] initWithFrame:CGRectZero];
    searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    searchTextField.font = [UIFont systemFontOfSize:14];
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.placeholder = @"点击查找";
    searchTextField.delegate = self;
    [self.view addSubview:searchTextField];
    [searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(24);
        make.width.equalTo(@210);
        make.height.equalTo(@30);
        make.right.equalTo(self.view).offset(-100);
    }];
}

- (void)setupConstraints {
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.shiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-18);
        make.top.equalTo(self.view).offset(12);
        make.width.equalTo(@64);
        make.height.equalTo(@64);
    }];
    
    [self.layerSelectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shiftBtn);
        make.top.equalTo(self.shiftBtn.mas_bottom).offset(8);
        make.width.equalTo(@105);
        make.height.equalTo(@110);
    }];
}

#pragma mark - getter
- (AGSMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[AGSMapView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_mapView];
    }
    return _mapView;
}


- (UIButton *)shiftBtn {
    if (_shiftBtn == nil) {
        _shiftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_shiftBtn setBackgroundImage:[UIImage imageNamed:@"map_shift"] forState:UIControlStateNormal];
        [_shiftBtn addTarget:self action:@selector(shiftBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_shiftBtn];
    }
    return _shiftBtn;
}

- (NSArray *)selectedSCArray {
    return self.mutableSelSCArray;
}

- (NSArray *)selectedCamArray {
    NSMutableArray *camArray = [[NSMutableArray alloc] initWithCapacity:4];
    [self.mutableSelCamArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AGSGraphic *graphic = obj;
        if ([graphic hasAttributeForKey:kCam]) {
            TVCamInfo *ci = [self getCamInfoByGraphic:graphic];
            if (ci) {
                [camArray addObject:ci];
            }
        }
    }];
    return camArray;
}

- (TCMapLayerSelectionView *)layerSelectionView {
    if (_layerSelectionView == nil) {
        _layerSelectionView = [[TCMapLayerSelectionView alloc] initWithFrame:CGRectZero];
        _layerSelectionView.delegate = self;
        [self.view addSubview:_layerSelectionView];
        
    }
    return _layerSelectionView;
}

#pragma mark - AGSLayerDelegate

- (void)layerDidLoad:(AGSLayer *)layer {
    APP_DELEGATE.tlMgr.delegate = self;
//    [APP_DELEGATE.tlMgr startRefresh];
}

- (void)layer:(AGSLayer *)layer didFailToLoadWithError:(NSError *)error {
    
}

-(void)layer:(AGSLayer *)layer didInitializeSpatialReferenceStatus:(BOOL)srStatusValid {
    
}

#pragma mark - private method
- (void)signalCtrller:(TLSignalCtrlerInfo *)scInfo graphic:(AGSGraphic *)graphic DidSelected:(BOOL)selected {
    if (selected) {
        [self.mutableSelSCArray addObject:[scInfo.ctrlerId copy]];
        AGSPictureMarkerSymbol *graphicSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"map_ctrller_sel"];
        graphic.symbol = graphicSymbol;
    } else {
        [self removeSelSignalCtrlerById:scInfo.ctrlerId];
        AGSPictureMarkerSymbol *graphicSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:[scInfo getSCImageByStatus]];
        graphic.symbol = graphicSymbol;
    }
    
    if ([self.delegate respondsToSelector:@selector(mapViewController:SignalCtrlerDidSelected:SignalCtrlerInfo:)]) {
        [self.delegate mapViewController:self SignalCtrlerDidSelected:selected SignalCtrlerInfo:scInfo];
    }
}

- (void)cam:(TVCamInfo *)camInfo graphic:(AGSGraphic *)graphic didSelected:(BOOL)selected {
    if (selected) {
        if (self.mutableSelCamArray.count >= 4) {
            AGSGraphic *g = [self.mutableSelCamArray firstObject];
//            NSString *ciId = [g attributeForKey:kCam];
            TVCamInfo *ci = [self getCamInfoByGraphic:g];
            g.symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:[ci getCamImagByStatus]];
            [self.mutableSelCamArray removeObjectAtIndex:0];
        }
        
        [self.mutableSelCamArray addObject:graphic];
        graphic.symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:camInfo.selectedImgName];
    } else {
        graphic.symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:[camInfo getCamImagByStatus]];
        [self.mutableSelCamArray removeObject:graphic];
    }
}

#pragma mark - AGSCalloutDelegate
-(BOOL)callout:(AGSCallout*)callout willShowForFeature:(id<AGSFeature>)feature layer:(AGSLayer<AGSHitTestable>*)layer mapPoint:(AGSPoint *)mapPoint {
    AGSGraphic* graphic = (AGSGraphic*)feature;
    if ([graphic hasAttributeForKey:kCtrlerId]) {
        NSString *ctrllerId = [graphic attributeForKey:kCtrlerId];
        TLSignalCtrlerInfo *scInfo = [APP_DELEGATE.tlMgr getSCInfoByCtrlerId:ctrllerId];
        if (scInfo != nil) {
            BOOL selected = [self isSelectedSignalCtrler:ctrllerId];
            if (selected) {
                [self signalCtrller:scInfo graphic:graphic DidSelected:NO];
            } else {
                if ([scInfo canSelected]) {
                    [self signalCtrller:scInfo graphic:graphic DidSelected:YES];
                } else {
                    DDLogInfo(@"点击了坏的信号机。");
                }
            }
        }
        return NO;
    }
    
    if ([graphic hasAttributeForKey:kCam]) {
        TVCamInfo *camInfo = [self getCamInfoByGraphic:graphic];
        
        if ([camInfo isKindOfClass: [TVElecPoliceInfo class]]) {
            TVElecPoliceInfo *epi = (TVElecPoliceInfo *)camInfo;
            self.epcCalloutVC = [[TCEPCCalloutViewController alloc] initWithGraphic:graphic videoSelected:epi.videoSelected tollgateSelected:epi.tollageSelected];
            self.epcCalloutVC.delegate = self;
            self.mapView.callout.customView = self.epcCalloutVC.view;
            return YES;
        }
        
        if (camInfo) {
            BOOL selected = [self isSelectedInCamArry:graphic];
            if (selected) {
                [self cam:camInfo graphic:graphic didSelected:NO];
            } else {
                if ([camInfo canSelect]) {
                    [self cam:camInfo graphic:graphic didSelected:YES];
                } else {
                    DDLogInfo(@"点击了坏的探头。");
                }
            }
        }
        

    }
    
    return NO;
}

#pragma mark - action

- (void)shiftBtnTapped:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(mapViewControllerShiftBtnPressed:)]) {
        [self.delegate mapViewControllerShiftBtnPressed:self];
    }
}

#pragma mark - delegate 
- (void)signalCtrllerCallOutViewController:(TCSignalCtrllerCallOutViewController *) signalCtrllerCallOutViewController DidSelected:(BOOL)selected SignalCtrler:(TLSignalCtrlerInfo *)scInfo {
    
    if (selected) {
        [self.mutableSelSCArray addObject:[scInfo.ctrlerId copy]];
        AGSPictureMarkerSymbol *graphicSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"map_ctrller_sel"];
        signalCtrllerCallOutViewController.graphic.symbol = graphicSymbol;
    } else {
        [self removeSelSignalCtrlerById:scInfo.ctrlerId];
        AGSPictureMarkerSymbol *graphicSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:[scInfo getSCImageByStatus]];
        signalCtrllerCallOutViewController.graphic.symbol = graphicSymbol;
    }
    
    if ([self.delegate respondsToSelector:@selector(mapViewController:SignalCtrlerDidSelected:SignalCtrlerInfo:)]) {
        [self.delegate mapViewController:self SignalCtrlerDidSelected:selected SignalCtrlerInfo:scInfo];
    }
    [self.mapView.callout dismiss];
}

#pragma mark - TCMapLayerSelectionViewDelegate
- (void)TCMapLayerSelectionView:(TCMapLayerSelectionView *)mapLayerSelectionView
             hcLayerDidSelected:(BOOL)selected {
    if (selected) {
         [self.mapView addMapLayer:self.highCamGraphicsLayer withName:@"hc_graphlayer"];
    } else {
        [self.mapView removeMapLayer:self.highCamGraphicsLayer];
    }
}

- (void)TCMapLayerSelectionView:(TCMapLayerSelectionView *)mapLayerSelectionView
             rcLayerDidSelected:(BOOL)selected {
    if (selected) {
        [self.mapView addMapLayer:self.roadCamGraphicsLayer withName:@"rc_graphlayer"];
    } else {
        [self.mapView removeMapLayer:self.roadCamGraphicsLayer];
    }
}

- (void)TCMapLayerSelectionView:(TCMapLayerSelectionView *)mapLayerSelectionView
             scLayerDidSelected:(BOOL)selected {
    if (selected) {
        [self.mapView addMapLayer:self.scGraphicsLayer withName:@"sc_graphicsLayer"];
    } else {
        [self.mapView removeMapLayer:self.scGraphicsLayer];
    }
    
}

- (void)TCMapLayerSelectionView:(TCMapLayerSelectionView *)mapLayerSelectionView
             epLayerDidSelected:(BOOL)selected {
    if (selected) {
        [self.mapView addMapLayer:self.epGraphicsLayer withName:@"ep_graphlayer"];
    } else {
        [self.mapView removeMapLayer:self.epGraphicsLayer];
    }
}

#pragma mark - RTextFieldDelegate

- (NSArray *)dataForPopoverInTextField:(RTTextField *)textField {
    return APP_DELEGATE.tlMgr.searchData;
}

- (void)textField:(RTTextField *)textField didEndEditingWithSelection:(NSDictionary *)result {
    id data = [result objectForKey:@"data"];
    if ([data isKindOfClass:[TVRoadCamInfo class]]) {
        TVRoadCamInfo *rc = data;
        [self.mapView centerAtPoint:[AGSPoint pointWithX:rc.pt.x y:rc.pt.y spatialReference:self.mapView.spatialReference] animated:YES];
    }
    
    if ([data isKindOfClass:[TVHighCamInfo class]]) {
        TVHighCamInfo *hc = data;
        [self.mapView centerAtPoint:[AGSPoint pointWithX:hc.pt.x y:hc.pt.y spatialReference:self.mapView.spatialReference] animated:YES];
    }
    
    if ([data isKindOfClass:[TVElecPoliceInfo class]]) {
        TVElecPoliceInfo *epc = data;
        [self.mapView centerAtPoint:[AGSPoint pointWithX:epc.pt.x y:epc.pt.y spatialReference:self.mapView.spatialReference] animated:YES];
    }
    
    if ([data isKindOfClass:[TLSignalCtrlerInfo class]]) {
        TLSignalCtrlerInfo *sci = data;
        [self.mapView centerAtPoint:[AGSPoint pointWithX:sci.tlPoint.x y:sci.tlPoint.y spatialReference:self.mapView.spatialReference] animated:YES];
    }
}

- (BOOL)textFieldShouldSelect:(RTTextField *)textField {
    return YES;
}

#pragma mark - TLMgrDelegate

- (void)TLMgr:(TLMgr *)tlMgr signnalInfoDidUpdate:(NSDictionary *)signaleCtrlerInfos {
    [self.scGraphicsLayer.graphics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AGSGraphic *g = obj;
        NSString *ctrllerId = [g attributeForKey:kCtrlerId];
        if ([self isSelectedSignalCtrler:ctrllerId]) {
            return;
        }
        TLSignalCtrlerInfo *scInfo = [signaleCtrlerInfos objectForKey:ctrllerId];
        if (scInfo) {
            g.symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:[scInfo getSCImageByStatus]];
        }
    }];
}

- (void)TLMgr:(TLMgr *)tlMgr highCamInfoDidUpdate:(NSDictionary *)highCamInfos {
    [self.scGraphicsLayer.graphics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AGSGraphic *g = obj;
        NSString *hcDeviceId = [g attributeForKey:kCam];
        if ([self isSelectedInCamArry:g]) {
            return;
        }
        TVHighCamInfo *hcInfo = [highCamInfos objectForKey:hcDeviceId];
        if (hcInfo) {
            g.symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:[hcInfo getCamImagByStatus]];
        }
    }];
}

- (void)TLMgr:(TLMgr *)tlMgr roadCamInfoDidUpdate:(NSDictionary *)roadCamInfos {
    [self.scGraphicsLayer.graphics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AGSGraphic *g = obj;
        if ([self isSelectedInCamArry:g]) {
            return;
        }
        NSString *rcDeviceId = [g attributeForKey:kCam];
        TVRoadCamInfo *rcInfo = [roadCamInfos objectForKey:rcDeviceId];
        if (rcInfo) {
            g.symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:[rcInfo getCamImagByStatus]];
        }
    }];
}

- (void)TLMgr:(TLMgr *)tlMgr epCamInfoDidUpdate:(NSDictionary *)epCamInfos {
    [self.scGraphicsLayer.graphics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AGSGraphic *g = obj;
        if ([self isSelectedInCamArry:g]) {
            return;
        }
        NSString *ecDeviceId = [g attributeForKey:kCam];
        TVElecPoliceInfo *epInfo = [epCamInfos objectForKey:ecDeviceId];
        if (epInfo) {
            g.symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:[epInfo getCamImagByStatus]];
        }
    }];
}

- (void)TCEPCCalloutViewController:(TCEPCCalloutViewController *)vc tollgateDidSelected:(BOOL)selected {
    TVCamInfo *camInfo = [self getCamInfoByGraphic:vc.graphic];
    TVElecPoliceInfo *epi = (TVElecPoliceInfo *)camInfo;
    epi.tollageSelected = selected;
    if (selected) {
        [APP_DELEGATE.tgMgr addDeviece:epi wsmgr:APP_DELEGATE.wsMgr completion:nil];
    } else {
        [APP_DELEGATE.tgMgr removeDevice:epi wsmgr:APP_DELEGATE.wsMgr completion:nil];
    }
    
}

- (void)TCEPCCalloutViewController:(TCEPCCalloutViewController *)vc videoDidSelected:(BOOL)selected {
    TVCamInfo *camInfo = [self getCamInfoByGraphic:vc.graphic];
    TVElecPoliceInfo *epi = (TVElecPoliceInfo *)camInfo;
    epi.videoSelected = selected;
    [self cam:camInfo graphic:vc.graphic didSelected:selected];
    DDLogInfo(@"video tapped");
}

@end
