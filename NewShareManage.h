//
//  NewShareManage.h
//  mall3658
//
//  Created by ygkj on 2017/12/5.
//  Copyright © 2017年 yangsu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger,umSocialShareType) {
    
    UMS_SHARE_TYPE_IMAGE = 0,//只分享图片
    UMS_SHARE_TYPE_ALL = 1,//图片文字链接
};

@interface NewShareManage : NSObject
+ (NewShareManage *)shareManage;

//分享类型对应的枚举
@property(nonatomic,assign) umSocialShareType shareType ;

/**
 *  弹出多个平台 选择分享至某一个
 *  sharePlatType 分享的类型 图片模式 还是图文链接模式
 *  shareTitle   分享的标题  图片模式时可传nil
 *  shareCotent  分享的内容  图片模式时可传nil
 *  shareImage   分享的图片 UIImage类对象，也可以是NSdata类对象，也可以是图片链接imageUrl NSString类对象
 *  shareWebUrl  分享点击对应的web页的URL  图片模式时可传nil
 *  @param block 回调block
 */
- (void)umSocial_ShareWithControll:(UIViewController *)PrsentControll withPlatShareType:(umSocialShareType)shareType withTitle:(NSString*)shareTitle withCotent:(NSString*)shareCotent withImage:(id)shareImage withWebUrl:(NSString*)shareWebUrl withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler;


/**
 *  分享到某一平台  不弹出框
 *  shareType 分享的类型  图片模式 还是图文链接模式
 *  type   直接送达的平台 UMSocialPlatformType内包含的平台
 *  shareTitle   分享的标题 图片模式时可传nil
 *  shareCotent  分享的内容 图片模式时可传nil
 *  shareImage   分享的图片 UIImage类对象，也可以是NSdata类对象，也可以是图片链接imageUrl NSString类对象
 *  shareWebUrl  分享点击对应的web页的URL 图片模式时可传nil
 *  @param block 回调block
 */
-(void)umSocial_ShareWithControll:(UIViewController *)PrsentControll withOutPlatShareType:(umSocialShareType)shareType withPostType:(UMSocialPlatformType)type withTitle:(NSString*)shareTitle withCotent:(NSString*)shareCotent withImage:(id)shareImage withWebUrl:(NSString*)shareWebUrl withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler;
@end
