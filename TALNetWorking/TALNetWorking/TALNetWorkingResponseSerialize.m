//
//  TALNetWorkingResponseSerialize.m
//  TALNetWorking
//
//  Created by lmonster on 2016/11/21.
//  Copyright © 2016年 lmonster. All rights reserved.
//

#import "TALNetWorkingResponseSerialize.h"

@interface TALNetWorkingResponseSerialize ()

typedef NS_ENUM(NSInteger, SerializeType) {
    SerializeJSONType,
    SerializePlainTextType,
    SerializeDefaultType,
};

@property (assign, nonatomic) SerializeType type;

@end

@implementation TALNetWorkingResponseSerialize

+ (instancetype)TALJSONSerialize {
    TALNetWorkingResponseSerialize *serializer = [TALNetWorkingResponseSerialize new];
    serializer.type = SerializeJSONType;
    return serializer;
}

+ (instancetype)TALPlainTextSerialize {
    TALNetWorkingResponseSerialize *serializer = [TALNetWorkingResponseSerialize new];
    serializer.type = SerializePlainTextType;
    return serializer;
}

+ (instancetype)TALDefaultSerialize {
    TALNetWorkingResponseSerialize *serializer = [TALNetWorkingResponseSerialize new];
    serializer.type = SerializeDefaultType;
    return serializer;
}

- (id)serializeData:(id)inData {
    
    if ( ! inData ) return nil;
    switch (self.type) {
        case SerializeJSONType: {
            NSError *error;
            id jsonObjc = [NSJSONSerialization JSONObjectWithData:inData options:NSJSONReadingMutableLeaves error:&error];
            return jsonObjc;
        }
            break;
        case SerializePlainTextType: {
            NSString *string = [[NSString alloc] initWithData:inData encoding:NSUTF16StringEncoding];
            return string;
        }
        case SerializeDefaultType: {
            return inData;
        }
            
        default: {
            NSAssert(NO , @"Your serializer is not matched to anyone");
        }
            break;
    }
    
    return nil;
}

@end
