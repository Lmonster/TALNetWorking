//
//  TALNetWorkingManager.h
//  TALNetWorking
//
//  Created by lmonster on 2016/11/21.
//  Copyright © 2016年 lmonster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TALMappingTable.h"
@class TALNetWorkingFormData;
@class TALNetWorkingRequestSerialize;
@class TALNetWorkingResponseSerialize;

/**
 This is class is the only interface of the network request.
 It can handle data task and upload task
 */
@interface TALNetWorkingManager : NSObject

/**
 Request result

 @param request 请求
 @param data data from server
 @param error error created when requesting
 */
typedef void(^RequestResult)(NSURLRequest *request, id data, NSError *error);

/**
 Upload progress callback

 PS:total progress is 1
 @param progress upload progress
 */
typedef void(^UploadProgress)(double progress);

/**
 Serialize for the request
 */
@property (strong, nonatomic) TALNetWorkingRequestSerialize *requestSerialize;

/**
 Serializer for the response
 */
@property (strong, nonatomic) TALNetWorkingResponseSerialize *responseSerialize;

/**
 Singleton

 @return instance of TALNetWorkingManager
 */
+ (instancetype)sharedManager;

/**
 Request to server

 parament 'method' is HTTP method
  
 @param url server url
 @param method HTTP method
 @param parament data send to server
 @param result request result
 */
- (void)request:(NSString *)url
  requestMethod:(TALHTTPMethod)method
       parament:(id)parament
         result:(RequestResult)result;

/**
 upload files

 @param url server url
 @param parament non-file datas
 @param blk  file data call back
 @param progress upload progress
 @param result upload result
 */
- (void)upload:(NSString *)url
      parament:(id)parament
  constructBlk:(void(^)(TALNetWorkingFormData *formData))blk
      progress:(UploadProgress)progress
        result:(RequestResult)result;

@end
