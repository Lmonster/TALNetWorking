//
//  TALNetWorkingSessionManager.h
//  TALNetWorking
//
//  Created by lmonster on 2016/11/21.
//  Copyright © 2016年 lmonster. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This is the Class of net session
 */
@interface TALNetWorkingSessionManager : NSObject

typedef void(^taskCallBack)(NSURLRequest *request, NSData *data, NSError* error);
typedef void(^progressCallBack)(double progress);

/**
 Singleton

 @return instance of TALNetWorkingSessionManager
 */
+ (instancetype)sharedManager;

/**
 Begin a data task

 @param request net request
 @param blk callback of the result
 */
- (void)dataTask:(NSURLRequest *)request result:(taskCallBack)blk;

/**
 Begin a upload task

 @param request net request
 @param progress upload progress
 @param blk upload result callback
 */
- (void)uploadTask:(NSURLRequest *)request progress:(progressCallBack)progress result:(taskCallBack)blk;

@end
