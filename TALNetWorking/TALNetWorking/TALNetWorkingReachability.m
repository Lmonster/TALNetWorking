//
//  TALNetWorkingReachability.m
//  TALNetWorking
//
//  Created by lmonster on 2016/11/21.
//  Copyright © 2016年 lmonster. All rights reserved.
//

#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import "TALNetWorkingReachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation TALNetWorkingReachability

static SCNetworkReachabilityRef reachabilityRef;
static TALNetWorkingReachability *reachability;
static BOOL hasAddListener;

+ (BOOL)canReachToEntherNet {

    if ( ! reachability ) {
        createReability();
    }
    SCNetworkReachabilityFlags flag = SCNetworkReachabilityGetFlags(reachabilityRef, &flag);
    
    return flag & kSCNetworkReachabilityFlagsReachable;
}

+ (void)addNetStatusListener {
    
    if ( ! reachability ) {
        reachability = [[self alloc] init];
    }
    if ( ! hasAddListener ) {
        hasAddListener = YES;
        if ( ! reachability ) createReability();
        SCNetworkReachabilitySetCallback(reachabilityRef, reachabilityCallback, NULL);
        SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetMain(), kCFRunLoopCommonModes);
        [[NSNotificationCenter defaultCenter] addObserver:reachability
                                                 selector:@selector(nickname)
                                                     name:@""
                                                   object:nil];
    }
}

+ (void)removeNetStatusListener {
    SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef, CFRunLoopGetMain(), kCFRunLoopCommonModes);
}

void createReability() {
    struct sockaddr_in addr;
    bzero(&addr, sizeof(addr));
    addr.sin_len    = sizeof(addr);
    addr.sin_family = AF_INET;
    reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *) &addr);
}

void reachabilityCallback (
     SCNetworkReachabilityRef			target,
     SCNetworkReachabilityFlags			flags,
     void			     *	__nullable	info
     ) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:reachability userInfo:@{}];
    }

@end
