#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "RevanGCDTimer.h"
#import "RevanProxy.h"
#import "RevanTimer.h"
#import "RevanDB.h"
#import "RevanDBProtocol.h"
#import "RevanModelTool.h"
#import "RevanSqliteTableTool.h"
#import "RevanSqliteTool.h"
#import "NSString+MD5.h"
#import "RevanDownLoader.h"
#import "RevanDownLoaderManager.h"
#import "RevanDownLoadFileTool.h"
#import "NSString+RevanTimeFormat.h"
#import "NSURL+Revan.h"
#import "RevanFileManager.h"
#import "RevanPlayer.h"
#import "RevanPlayerDownLoader.h"
#import "RevanResourceLoaderDelegate.h"
#import "RevanQRCode.h"
#import "RevanQRCodeManager.h"
#import "RevanQRCodePhotoManager.h"
#import "RevanQRCodeScanManager.h"
#import "RevanQRCodeScanView.h"
#import "RevanQRCodeScanViewController.h"
#import "RevanSegmentConfig.h"
#import "RevanSegmentedView.h"
#import "RevanSegmentViewController.h"
#import "UIView+RevanSegmented.h"
#import "RevanSnapshot.h"
#import "RevanIndicatorUtil.h"
#import "RevanTipsView.h"
#import "RevanTipsViewHeader.h"
#import "RevanVerifyButton.h"

FOUNDATION_EXPORT double RevanFunctionVersionNumber;
FOUNDATION_EXPORT const unsigned char RevanFunctionVersionString[];

