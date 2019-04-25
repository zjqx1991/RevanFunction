//
//  RevanQRCodeScanManager.h
//  AFNetworking
//
//  Created by RevanWang on 2018/8/25.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class RevanQRCodeScanManager;

@protocol RevanQRCodeScanManagerDelegate <NSObject>

@required
/** 二维码扫描获取数据的回调方法 (metadataObjects: 扫描二维码数据信息) */
- (void)revan_QRCodeScanManager:(RevanQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects;
@optional
/** 根据光线强弱值打开手电筒的方法 (brightnessValue: 光线强弱值) */
- (void)revan_QRCodeScanManager:(RevanQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue;
@end

@interface RevanQRCodeScanManager : NSObject

/** 快速创建单利方法 */
+ (instancetype)revan_sharedManager;
/**  RevanQRCodeScanManagerDelegate */
@property (nonatomic, weak) id<RevanQRCodeScanManagerDelegate> delegate;

/**
 *  创建扫描二维码会话对象以及会话采集数据类型和扫码支持的编码格式的设置，必须实现的方法
 *
 *  @param sessionPreset    会话采集数据类型
 *  @param metadataObjectTypes    扫码支持的编码格式
 *  @param currentController      SGQRCodeScanManager 所在控制器
 */
- (void)revan_setupSessionPreset:(NSString *)sessionPreset metadataObjectTypes:(NSArray *)metadataObjectTypes currentController:(UIViewController *)currentController;
/** 开启会话对象扫描 */
- (void)revan_startRunning;
/** 停止会话对象扫描 */
- (void)revan_stopRunning;
/** 移除 videoPreviewLayer 对象 */
- (void)revan_videoPreviewLayerRemoveFromSuperlayer;
/** 播放音效文件 */
- (void)revan_palySoundName:(NSString *)name;
/** 重置根据光线强弱值打开手电筒的 delegate 方法 */
- (void)revan_resetSampleBufferDelegate;
/** 取消根据光线强弱值打开手电筒的 delegate 方法 */
- (void)revan_cancelSampleBufferDelegate;


/** 打开手电筒 */
+ (void)revan_openFlashlight;
/** 关闭手电筒 */
+ (void)revan_CloseFlashlight;

@end
