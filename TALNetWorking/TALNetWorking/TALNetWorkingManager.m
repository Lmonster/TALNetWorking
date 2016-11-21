//
//  TALNetWorkingManager.m
//  TALNetWorking
//
//  Created by lmonster on 2016/11/21.
//  Copyright © 2016年 lmonster. All rights reserved.
//

#import "TALNetWorkingManager.h"

@implementation TALNetWorkingManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static TALNetWorkingManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [TALNetWorkingManager new];
    });
    return manager;
}

@end
