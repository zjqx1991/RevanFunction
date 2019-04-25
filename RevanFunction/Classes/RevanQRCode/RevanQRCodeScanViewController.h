//
//  RevanQRCodeScanViewController.h
//  RevanFunction
//
//  Created by RevanWang on 2018/8/25.
//

#import <UIKit/UIKit.h>

typedef void(^RevanQRCodeScanCompleteBlock)(NSString *urlstr);

@interface RevanQRCodeScanViewController : UIViewController

/** 二维码内容 */
@property (nonatomic, copy) RevanQRCodeScanCompleteBlock completeBlock;

@end
