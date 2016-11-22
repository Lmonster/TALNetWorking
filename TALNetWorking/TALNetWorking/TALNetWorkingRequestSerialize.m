//
//  TALNetWorkingRequestSerialize.m
//  TALNetWorking
//
//  Created by lmonster on 2016/11/21.
//  Copyright © 2016年 lmonster. All rights reserved.
//

#import "TALNetWorkingRequestSerialize.h"

@interface TALNetWorkingRequestSerialize ()

typedef NS_ENUM(NSInteger, SerializeType) {
    SerializeJSONType,
    SerializePlainTextType,
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

+ (instancetype)TALPlainTextSerialize {
    
    TALNetWorkingRequestSerialize *serializer = [TALNetWorkingRequestSerialize new];
    serializer.type = SerializePlainTextType;
    return serializer;
}

+ (instancetype)TALDefaultSerialize {
    
    TALNetWorkingRequestSerialize *serializer = [TALNetWorkingRequestSerialize new];
    serializer.type = SerializeDefaultType;
    return serializer;
}

- (NSMutableURLRequest *)serializeRequest:(NSMutableURLRequest *)request parament:(id)parament {
    
    
    return request;
}

@end
