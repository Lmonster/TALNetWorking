//
//  TALMappingTable.h
//  TALNetWorking
//
//  Created by lmonster on 2016/11/22.
//  Copyright © 2016年 lmonster. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class is the project public code mapping.And the code rule is as following:
 1. Net Error 2000 ...
 2. HTTP Method 1000 ...
 */
@interface TALMappingTable : NSObject

/**
 Network Request Error Code
 
 - TALNetWorkingURLError: URL error
 - TALNetworkingNetError: NO network error
 - TALNetWorkingTimeoutError: timeout error
 - TALNetWorkingNoError: no error
 */
typedef NS_ENUM(NSUInteger, TALNetWorkingError) {
    TALNetWorkingURLError = 2000,
    TALNetworkingNetError,
    TALNetWorkingTimeoutError,
    TALNetWorkingMethodError,
    TALNetWorkingNoError = 0,
};

/**
 HTTP Method Enumer
 
 - TALHTTPMethodGET: GET
 - TALHTTPMethodPOST: POST
 - TALHTTPMethodHEAD: HEAD
 - TALHTTPMethodPUT: PUT
 - TALHTTPMethodDELETE: DELETE
 */
typedef NS_ENUM(NSUInteger, TALHTTPMethod) {
    TALHTTPMethodGET = 1000,
    TALHTTPMethodPOST,
    TALHTTPMethodHEAD,
    TALHTTPMethodPUT,
    TALHTTPMethodDELETE,
};

/**
 Map the code given by user and retuen it's infomation

 @param mapCode the code that needs to be mapped
 */
+ (NSString *)map:(NSInteger)mapCode;

@end
