//
//  RevanQRCodePhotoManager.h
//  RevanFunction
//
//  Created by RevanWang on 2018/8/25.
//

#import <Foundation/Foundation.h>

@class RevanQRCodePhotoManager;

@protocol RevanQRCodePhotoManagerDelegate <NSObject>

@required
/** 图片选择控制器取消按钮的点击回调方法 */
- (void)cancelQRCodePhotoManager:(RevanQRCodePhotoManager *)photoManager;
/** 图片选择控制器选取图片完成之后的回调方法 (result: 获取的二维码数据) */
- (void)qrCodePhotoManager:(RevanQRCodePhotoManager *)photoManager didFinishPickingMediaWithResult:(NSString *)result;

@end

@interface RevanQRCodePhotoManager : NSObject
/** 快速创建单利方法 */
+ (instancetype)sharedManager;
/** SGQRCodeAlbumManagerDelegate */
@property (nonatomic, weak) id<RevanQRCodePhotoManagerDelegate> delegate;
/** 判断相册访问权限是否授权 */
@property (nonatomic, assign) BOOL isPHAuthorization;
/** 是否开启 log 打印，默认为 YES */
@property (nonatomic, assign) BOOL isOpenLog;
/** 从相册中读取二维码方法，必须实现的方法 */
- (void)readQRCodeFromAlbumWithCurrentController:(UIViewController *)currentController;

@end
