//
//  TALNetWorkingRequestSerialize.m
//  TALNetWorking
//
//  Created by lmonster on 2016/11/21.
//  Copyright © 2016年 lmonster. All rights reserved.
//

#import "TALNetWorkingRequestSerialize.h"
#import "TALMappingTable.h"

@interface TALNetWorkingRequestSerialize ()

typedef NS_ENUM(NSInteger, SerializeType) {
    SerializeJSONType,
    SerializeHTTPRequestType,
    SerializeDefaultType,
};

@property (assign, nonatomic) SerializeType type;

@end

@implementation TALNetWorkingRequestSerialize

+ (instancetype)TALJSONSerialize {
    
    TALNetWorkingRequestSerialize *serializer = [TALNetWorkingRequestSerialize new];
    serializer.type = SerializeJSONType;
    return serializer;
}

+ (instancetype)TALHTTPRequestSerialize {
    
    TALNetWorkingRequestSerialize *serializer = [TALNetWorkingRequestSerialize new];
    serializer.type = SerializeHTTPRequestType;
    return serializer;
}

+ (instancetype)TALDefaultSerialize {
    
    TALNetWorkingRequestSerialize *serializer = [TALNetWorkingRequestSerialize new];
    serializer.type = SerializeDefaultType;
    return serializer;
}

- (NSMutableURLRequest *)serializeRequest:(NSMutableURLRequest *)request parament:(id)parament {
    
    // First convert parament according to serializer type.
    // And then set HTTP header
    // for the last,place the parament data to it's place according to HTTP method.
    
    // *
    
    NSData *bodyData;
    bodyData = nil;
    if ([request.HTTPMethod isEqualToString:@""]) {
    }
    switch (self.type) {
        case SerializeDefaultType: {
        }
            break;
        case SerializeHTTPRequestType: {
            bodyData = [self convertToHTMLSerialize:parament];
        }
            break;
        case SerializeJSONType: {
            bodyData = [self convertToJSON:parament];
        }
            break;
            
        default:
            break;
    }
    
    // **
    
    NSMutableString *acceptLanguage  = [NSMutableString string];
    NSInteger count;
    float unit;
    int index;
    
    count = [[NSLocale preferredLanguages] count];
    unit= 1. / count;
    index = 0;
    for (NSString *languageType in [NSLocale preferredLanguages]) {
        float value = unit * (count - index);
        NSString *component = [NSString stringWithFormat:@"%@;q=%f",languageType,value];
        ++index;
        [acceptLanguage appendString:component];
    }
    
    [request setValue:request.URL.host forHTTPHeaderField:@"Host"];
    [request setValue:acceptLanguage forHTTPHeaderField:@"Accept-Language"];
    
    // ***
    
    if ([request.HTTPMethod isEqualToString:[TALMappingTable map:TALHTTPMethodGET]] ||
        [request.HTTPMethod isEqualToString:[TALMappingTable map:TALHTTPMethodHEAD]]) {
    } else if ([request.HTTPMethod isEqualToString:[TALMappingTable map:TALHTTPMethodPOST]]) {
    }
    request.HTTPBody = bodyData;
    return request;
}

#pragma mark - Serialize parament for GET method

- (NSString *)convertURLQuery:(id)parament {
    NSMutableString *queryString;
    
    queryString = [NSMutableString stringWithString:@"?"];
    if ([parament isKindOfClass:[NSString class]]) {
        
        [queryString appendString:parament];
        
    } else if ([parament isKindOfClass:[NSDictionary class]]) {
        
        [parament enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[NSString class]] ||
                [obj isKindOfClass:[NSNumber class]]
                ) {
                [queryString appendFormat:@"%@=%@&",key,obj];
            } else if ([obj isKindOfClass:[NSArray class]]) {
                
                // Here we don't allow an array as an object.
                // But it's not appropriate.We need to make sure
                // an array can work fine as well later
                
                NSAssert(NO, @"value cann't be an array");
            } else {
                
                NSAssert(NO, @"value cann't be non-dictionary");
            }
        }];
    }
    return queryString;
}

#pragma mark - Serialize parament for POST/PUT method

- (id)convertToJSON:(id)parament {
    
    id result = nil;
    if ( ! parament ) return nil;
    
    if ([NSJSONSerialization isValidJSONObject:parament]) {
        NSError *error;
        result = [NSJSONSerialization dataWithJSONObject:parament options:NSJSONWritingPrettyPrinted error:&error];
        if (error) return nil;
    }
    return result;
}

- (id)convertToHTMLSerialize: (id)parament {
    
    id result = nil;
    if ( ! parament ) return nil;
    
    if ([parament isKindOfClass:[NSArray class]] ||
        [parament isKindOfClass:[NSDictionary class]]) {
        NSError *error;
        result = [NSJSONSerialization dataWithJSONObject:parament options:NSJSONWritingPrettyPrinted error:&error];
        if (error) return nil;
    }
    if ([parament isKindOfClass:[NSString class]]) {
        result = [parament dataUsingEncoding:NSUTF16StringEncoding allowLossyConversion:NO];
    }
    return result;
}


@end
