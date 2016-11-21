//
//  TALNetWorkingReachability.h
//  TALNetWorking
//
//  Created by lmonster on 2016/11/21.
//  Copyright © 2016年 lmonster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TALNetWorkingReachability : NSObject

/**
 add network status listener
 */
+ (void)addNetStatusListener;

/**
 remove network status listener
 */
+ (void)removeNetStatusListener;

/**
 Check if we can reach the Internet currently

 @return returning YES represents we can reach the Internet, otherwise we cann't
 */
+ (BOOL)canReachToEntherNet;

@end
