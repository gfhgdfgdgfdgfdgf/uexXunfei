//
//  uexXunFeiResponder.m
//  EUExXunfei
//
//  Created by 黄锦 on 15/12/31.
//  Copyright © 2015年 AppCan. All rights reserved.
//

#import "uexXunFeiResponder.h"


@implementation uexXunFeiResponder


+ (instancetype)sharedResponder{
    static uexXunFeiResponder *responder=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        responder=[[self alloc] init];
    });
    return responder;
}

@end