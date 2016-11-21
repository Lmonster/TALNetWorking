//
//  TALNetWorkingManager.h
//  TALNetWorking
//
//  Created by lmonster on 2016/11/21.
//  Copyright © 2016年 lmonster. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TALNetWorkingFormData;
@interface TALNetWorkingManager : NSObject

/**
 请求返回的结果回调

 @param request 请求
 @param data 请求返回的数据
 @param error 请求返回的错误
 */
typedef void(^RequestResult)(NSURLRequest *request, NSData *data, NSError *error);

/**
 上传进度回调

 注：进度最大值为1!
 @param progress 进度
 */
typedef void(^UploadProgress)(double progress);

typedef NS_ENUM(NSUInteger, TALNetWorkingError) {
    TALNetWorkingURLError = -1000,
    TALNetworkingNetError,
    TALNetWorkingTimeoutError,
    TALNetWorkingNoError = 0,
};

/**
 请求的HTTP方法

 - TALHTTPMethodGET: GET方法
 - TALHTTPMethodPOST: POST方法
 - TALHTTPMethodHEAD: HEAD方法
 - TALHTTPMethodPUT: PUT方法
 - TALHTTPMethodDELETE: DELETE方法
 */
typedef NS_ENUM(NSUInteger, TALHTTPMethod) {
    TALHTTPMethodGET = 1,
    TALHTTPMethodPOST,
    TALHTTPMethodHEAD,
    TALHTTPMethodPUT,
    TALHTTPMethodDELETE,
};
/**
 单例

 @return 实例
 */
+ (instancetype)sharedManager;

/**
 向服务器请求

 method参数是设置请求方法的参数
  
 @param url 请求的url
 @param method 方法
 @param parament 请求参数
 @param result 返回的结果
 */
- (void)request:(NSString *)url
  requestMethod:(TALHTTPMethod)method
       parament:(id)parament
         result:(RequestResult)result;

/**
 上传文件

 @param url 上传的url
 @param parament 上传的非文件数据
 @param blk  将要传输的文件按照
 @param progress 上传进度
 @param result 上传结果
 */
- (void)upload:(NSString *)url
      parament:(id)parament
  constructBlk:(void(^)(TALNetWorkingFormData *formData))blk
      progress:(UploadProgress)progress
        result:(RequestResult)result;

@end
