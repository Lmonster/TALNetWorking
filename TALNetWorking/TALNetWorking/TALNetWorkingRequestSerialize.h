//
//  TALNetWorkingRequestSerialize.h
//  TALNetWorking
//
//  Created by lmonster on 2016/11/21.
//  Copyright © 2016年 lmonster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TALNetWorkingRequestSerialize :NSObject

/**
 json serialize
 
 @return serialize that handle data to json
 */
+ (instancetype)TALJSONSerialize;

/**
 text serialize
 
 @return serialize that handle data to plain text
 */
+ (instancetype)TALPlainTextSerialize;

/**
 default serialize
 
 @return serialize that handle data reference to content-type returned by server
 if no content-type is provided, we just return the raw data without serialize.
 */
+ (instancetype)TALDefaultSerialize;


/**
 Serialize request and data
 
 @param request the request
 @param parament data that is sent to server
 @return serilized request
 */
- (NSMutableURLRequest *)serializeRequest:(NSMutableURLRequest *)request parament:(id)parament;

@end
