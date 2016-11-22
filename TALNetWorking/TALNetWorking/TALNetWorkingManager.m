//
//  TALNetWorkingManager.m
//  TALNetWorking
//
//  Created by lmonster on 2016/11/21.
//  Copyright © 2016年 lmonster. All rights reserved.
//

#import "TALNetWorkingManager.h"
#import "TALNetWorkingSessionManager.h"
#import "TALNetWorkingReachability.h"
#import "TALNetWorkingRequestSerialize.h"
#import "TALNetWorkingResponseSerialize.h"

@implementation TALNetWorkingManager

+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    static TALNetWorkingManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [TALNetWorkingManager new];
    });
    return manager;
}

- (void)request:(NSString *)url requestMethod:(TALHTTPMethod)method parament:(id)parament result:(RequestResult)result {
    
    do {
        NSURL *aURL;
        NSString *scheme;
        BOOL matchProtocals;
        NSError *resultError;
        NSMutableURLRequest *request;
        
        aURL = [NSURL URLWithString:url];
        request = [NSMutableURLRequest requestWithURL:aURL];
        scheme = aURL.scheme.lowercaseString;
        matchProtocals = [self matchProtocals:scheme];
        
        // First check if the url's protocal is supported by the system
        // we now can only support http/https protocal and the we check if
        // the net is connected to the Internet if not we call the callback
        // otherwise we serialize the parament sent to server by requestSerialize
        // property if it's not assigned we will use TALSerializeDefault as
        // default.
        
        if ( ! matchProtocals ) {
            resultError = [self generateError:TALNetWorkingURLError];
            result(request, nil, resultError);
            break;
        }
        if ( ! [TALNetWorkingReachability canReachToEntherNet] ) {
            resultError = [self generateError:TALNetworkingNetError];
            result(request, nil, resultError);
            break;
        }
        
        // self.requestSerialize MUST NOT be nil
        
        NSAssert(self.requestSerialize != nil, @"You must assign a request serialize for your request");
        
        request = [self.requestSerialize serializeRequest:request parament:parament];
        [[TALNetWorkingSessionManager new] dataTask:request
                                             result:^(NSURLRequest *request, NSData *data, NSError *error) {
                                                 do {
                                                     if (error) {
                                                         
                                                         result(request, nil, error);
                                                         break;
                                                         
                                                         NSAssert(self.responseSerialize != nil, @"You must assign a response serialize for your request");
                                                         
                                                         id resultData = [self.responseSerialize serializeData:data];
                                                         result(request, resultData, nil);
                                                     }
                                                 } while (0);
                                             }];
    } while (0);
}

- (void)upload:(NSString *)url parament:(id)parament constructBlk:(void (^)(TALNetWorkingFormData *))blk progress:(UploadProgress)progress result:(RequestResult)result {
}


#pragma mark - Helper

- (BOOL)matchProtocals:(NSString *)scheme {
    
    if ( [scheme isEqualToString:@"http"] ||
         [scheme isEqualToString:@"https"]
        ) {
        return YES;
    }
    return NO;
}

- (NSError *)generateError:(TALNetWorkingError)errorCode {
    
    NSDictionary *errorInfo;
    switch (errorCode) {
        case TALNetWorkingURLError:
            errorInfo = @{@"info":@"The protocal you're requested is not support"};
            break;
        case TALNetworkingNetError:
            errorInfo = @{@"info":@""};
        case TALNetWorkingTimeoutError:
            errorInfo = @{@"info":@""};
        case TALNetWorkingNoError:
            errorInfo = @{@"info":@""};
        default:
            break;
    }
    NSError *error = [NSError errorWithDomain:@"" code:errorCode userInfo:errorInfo];
    return error;
}

@end
