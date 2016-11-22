//
//  TALMappingTable.m
//  TALNetWorking
//
//  Created by lmonster on 2016/11/22.
//  Copyright © 2016年 lmonster. All rights reserved.
//

#import "TALMappingTable.h"

@implementation TALMappingTable

+ (NSDictionary *)metaData {
    
    static NSDictionary *metaData;
    if ( ! metaData ) {
        metaData = @{
                     // HTTP Method
                     
                     @(TALHTTPMethodGET):@"GET",
                     @(TALHTTPMethodPOST):@"POST",
                     @(TALHTTPMethodHEAD):@"HEAD",
                     @(TALHTTPMethodPUT):@"PUT",
                     @(TALHTTPMethodDELETE):@"DELETE",
                     
                     // Net Error Code
                     
                     @(TALNetWorkingNoError):@"There is no error",
                     @(TALNetworkingNetError):@"Ooops...Your network seems not working",
                     @(TALNetWorkingURLError):@"Protocal is Not support",
                     @(TALNetWorkingTimeoutError):@"Network request is timeout,it takes too much time",
                     };
    }
    return metaData;
}

+ (NSString *)map:(NSInteger)mapCode {
    
    return [self metaData][@(mapCode)];
}

@end
