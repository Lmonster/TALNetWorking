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
        NSString *httpMethod;
        
        aURL            = [NSURL URLWithString:url];
        request         = [NSMutableURLRequest requestWithURL:aURL];
        scheme          = aURL.scheme.lowercaseString;
        matchProtocals  = [self matchProtocals:scheme];
        httpMethod      = [TALMappingTable map:method];
        
        // First check if the url's protocal is supported by the system nor the url string is right
        // we now can only support http/https protocal and the we check if
        // the net is connected to the Internet if not we call the callback.
        // Then we check the http method,if method doesn't match any methods we support
        // return error info.
        // otherwise we serialize the parament sent to server by requestSerialize
        // property if it's not assigned we will use TALSerializeDefault as
        // default.
        
        if ( ! matchProtocals && ! aURL) {
            resultError = [self generateError:TALNetWorkingURLError];
            result(request, nil, resultError);
            break;
        }
//        if ( ! [TALNetWorkingReachability canReachToEntherNet] ) {
//            resultError = [self generateError:TALNetworkingNetError];
//            result(request, nil, resultError);
//            break;
//        }
        if ( ! httpMethod.length ) {
            resultError = [self generateError:TALNetWorkingMethodError];
            result(request, nil, resultError);
            break;
        }
        
        // self.requestSerialize MUST NOT be nil
        
        NSAssert(self.requestSerialize != nil, @"You must assign a request serialize for your request");
        
        request.HTTPMethod = httpMethod;
        request = [self.requestSerialize serializeRequest:request parament:parament];
        [[TALNetWorkingSessionManager new] dataTask:request
                                             result:^(NSURLRequest *request, NSData *data, NSError *error) {
                                                 do {
                                                     if (error) {
                                                         
                                                         result(request, nil, error);
                                                         break;
                                                     } else {
                                                         
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
    NSString *errorDesc;
    
    errorDesc = [TALMappingTable map:errorCode];
    errorInfo = @{@"info":errorDesc};
    NSError *error = [NSError errorWithDomain:@"" code:errorCode userInfo:errorInfo];
    return error;
}

- (NSString *)switchMethod: (TALHTTPMethod)methodCode {
    
    NSString *method;
    method = [TALMappingTable map:methodCode];
    return method;
}

@end
