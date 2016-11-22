//
//  TALNetWorkingSessionManager.m
//  TALNetWorking
//
//  Created by lmonster on 2016/11/21.
//  Copyright © 2016年 lmonster. All rights reserved.
//

#import "TALNetWorkingSessionManager.h"

@interface TALNetWorkingSessionManager () <NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

/**
 Default session for the data operation
 */
@property (strong, nonatomic) NSURLSession *defaultDataSession;

/**
 Default session for the upload operation
 */
@property (strong, nonatomic) NSURLSession *defaultUploadSession;

/**
 default queue that finish network operation
 */
@property (strong, nonatomic) NSOperationQueue *defaultQueue;

/**
 progress callback for upload operation
 */
@property (strong, nonatomic) progressCallBack progressBlk;

/**
 finish callback for upload operation
 */
@property (strong, nonatomic) taskCallBack uploadTaskCallback;

/**
 upload data
 */
@property (strong, nonatomic) NSMutableData *uploadResponseData;

@end

@implementation TALNetWorkingSessionManager

+ (instancetype)sharedManager {
    TALNetWorkingSessionManager *manager = [[TALNetWorkingSessionManager alloc] init];
    return manager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *uploadConfig, *dataConfig;
        
        dataConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        uploadConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        uploadConfig.timeoutIntervalForResource = 300.;
        dataConfig.timeoutIntervalForResource = 15.;
        
        self.defaultQueue = [NSOperationQueue new];
        self.uploadResponseData = [NSMutableData data];
    }
    return self;
}

- (void)dataTask:(NSURLRequest *)request result:(taskCallBack)blk {
    
    [[self.defaultDataSession dataTaskWithRequest:request
                           completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                               blk(request, data, error);
                           }] resume];
}

- (void)uploadTask:(NSURLRequest *)request progress:(progressCallBack)progress result:(taskCallBack)blk {
    
    NSAssert(self.uploadResponseData == nil &&
             self.uploadResponseData == nil &&
             self.progressBlk == nil
             , @"one manager can only handle one upload task! Details See the document");
    
    self.progressBlk = progress;
    self.uploadTaskCallback = blk;
    [[self.defaultUploadSession dataTaskWithRequest:request] resume];
}

#pragma mark - NSURLSession delegate

// Record upload progress
// this method only happend when uploading which is a data task

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
    double fSent, fExpected;
    fSent = (double)totalBytesSent;
    fExpected = (double)totalBytesExpectedToSend;
    if (self.progressBlk) self.progressBlk(fSent / fExpected);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (self.uploadTaskCallback) {
        self.uploadTaskCallback(task.originalRequest, self.uploadResponseData, error);
        self.uploadTaskCallback = nil;
        self.uploadResponseData = nil;
        self.progressBlk        = nil;
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    [self.uploadResponseData appendData:data];
}



@end
