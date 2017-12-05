//
//  NewShareManage.m
//  mall3658
//
//  Created by ygkj on 2017/12/5.
//  Copyright © 2017年 yangsu. All rights reserved.
//

#import "NewShareManage.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

@implementation NewShareManage
{
    NSMutableArray *platFormArray;
}
static NewShareManage *shareManage;

+ (NewShareManage *)shareManage
{
    @synchronized(self)
    {
        if (shareManage == nil) {
            shareManage = [[self alloc] init];
            [shareManage shareConfig];

        }
        return shareManage;
    }
}
//弹出分享平台 默认实现 以下几种
- (void)shareConfig
{
    platFormArray =[NSMutableArray array];
    if ( [QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
        //安装QQ
        [platFormArray addObject:@(UMSocialPlatformType_QQ)];
        [platFormArray addObject:@(UMSocialPlatformType_Qzone)];
        
    }
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        //安装微信
        [platFormArray addObject:@(UMSocialPlatformType_WechatSession)];
        [platFormArray addObject:@(UMSocialPlatformType_WechatTimeLine)];
    }
    [platFormArray addObject:@(UMSocialPlatformType_Sina)];
    
}
/**
 *  弹出多个平台 选择分享至某一个
 *  sharePlatType 分享的类型 图片模式 还是图文链接模式
 *  @param block 回调block
 */
- (void)umSocial_ShareWithControll:(UIViewController *)PrsentControll withPlatShareType:(umSocialShareType)shareType withTitle:(NSString*)shareTitle withCotent:(NSString*)shareCotent withImage:(id)shareImage withWebUrl:(NSString*)shareWebUrl withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler{
    
    switch (shareType) {
        case UMS_SHARE_TYPE_IMAGE://只分享图片
        {
            [UMSocialUIManager setPreDefinePlatforms:platFormArray];
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                
                [self runShareImageWithType:platformType WithControll:PrsentControll withImage:shareImage withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler ];
            }];
        }
            break;
        case UMS_SHARE_TYPE_ALL://图片文字链接
        {
            
            [UMSocialUIManager setPreDefinePlatforms:platFormArray];
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                
                [self runShareAllWithType:platformType WithControll:PrsentControll withTitle:shareTitle withCotent:shareCotent withImage:shareImage withWebUrl:shareWebUrl withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler ];
            }];
        }
            break;
            
        default:
            break;
    }
}
/**
 *  分享到某一平台  不弹出框
 *  shareType 分享的类型  图片模式 还是图文链接模式
 *  @param block 回调block
 */
-(void)umSocial_ShareWithControll:(UIViewController *)PrsentControll withOutPlatShareType:(umSocialShareType)shareType withPostType:(UMSocialPlatformType)type withTitle:(NSString*)shareTitle withCotent:(NSString*)shareCotent withImage:(id)shareImage withWebUrl:(NSString*)shareWebUrl withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler{

    switch (shareType) {
            
        case UMS_SHARE_TYPE_IMAGE://只分享图片 不弹出平台
        {
            [self runShareImageWithType:type WithControll:PrsentControll withImage:shareImage withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler ];
        }
            break;
        case UMS_SHARE_TYPE_ALL://图片文字链接 不弹出平台
        {
            [self runShareAllWithType:type WithControll:PrsentControll withTitle:shareTitle withCotent:shareCotent withImage:shareImage withWebUrl:shareWebUrl withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler ];
        }
            break;
        default:
            break;
    }
    
    
}
//只分享图片
-(void)runShareImageWithType:(UMSocialPlatformType)type WithControll:(UIViewController *)PrsentControll withImage:(id)shareImage withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler{
    if (shareImage == nil || [NSString stringWithFormat:@"%@",shareImage].length <1) {
        [SVProgressHUD showInfoWithStatus:@"图片信息不能为空"];
        return;
    }
    UMSocialMessageObject *messageObj = [UMSocialMessageObject messageObject];
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    [shareObject setShareImage:shareImage];
    messageObj.shareObject = shareObject;
    [[UMSocialManager defaultManager]shareToPlatform:type messageObject:messageObj currentViewController:PrsentControll completion:^(id result, NSError *error) {
        
        if (error)
        {
            completionHandler(nil,error);
        }else{
            completionHandler(result,nil);
        }
    }];
}
//图片文字链接
-(void)runShareAllWithType:(UMSocialPlatformType)type WithControll:(UIViewController *)PrsentControll withTitle:(NSString*)shareTitle withCotent:(NSString*)shareCotent withImage:(id)shareImage withWebUrl:(NSString*)shareWebUrl withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler{
    
    UMSocialMessageObject *messageObj = [UMSocialMessageObject messageObject];
    if (type == UMSocialPlatformType_Sina) //如果是渣浪
    {
        if (shareImage == nil || [NSString stringWithFormat:@"%@",shareImage].length <1) {
            [SVProgressHUD showInfoWithStatus:@"图片信息不能为空"];
            return;
        }
        messageObj.text = [NSString stringWithFormat:@"%@%@%@",shareTitle,shareCotent,shareWebUrl];
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        [shareObject setShareImage:shareImage];
        messageObj.shareObject = shareObject;
        
    }else
    {
        if (shareTitle.length <1 || shareWebUrl.length <1) {
            [SVProgressHUD showInfoWithStatus:@"检查标题和网址不能为空"];
            return;
        }
        UMShareWebpageObject *shareObj =[UMShareWebpageObject shareObjectWithTitle:shareTitle descr:shareCotent thumImage:shareImage];
        shareObj.webpageUrl = shareWebUrl;
        messageObj.shareObject = shareObj;
    }
 
    [[UMSocialManager defaultManager]shareToPlatform:type messageObject:messageObj currentViewController:PrsentControll completion:^(id result, NSError *error) {
        
        if (error)
        {
            completionHandler(nil,error);
        }else{
            completionHandler(result,nil);
        }
    }];
}
@end
