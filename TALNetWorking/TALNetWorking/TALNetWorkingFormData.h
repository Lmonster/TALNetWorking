//
//  TALNetWorkingFormData.h
//  TALNetWorking
//
//  Created by lmonster on 2016/11/21.
//  Copyright © 2016年 lmonster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TALNetWorkingFormData : NSObject

/**
 add file data to formed data

 @param data file data
 @param fileName file name if nil we assume it as date[yyyy-mm-dd-hh-mm-ss]-file
 @param fileKey file key
 @param mimeType the mime type of upload file
 */
- (void)appendData:(NSData *)data fileName:(NSString *)fileName fileKey:(NSString *)fileKey MIMEType:(NSString *)mimeType;

@end
