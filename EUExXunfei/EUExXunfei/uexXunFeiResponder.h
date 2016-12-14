//
//  uexXunFeiResponder.h
//  EUExXunfei
//
//  Created by 黄锦 on 15/12/31.
//  Copyright © 2015年 AppCan. All rights reserved.
//
#import <Foundation/Foundation.h>
@class EBrowserView;

@interface uexXunFeiResponder : NSObject
@property (nonatomic, weak) id<AppCanWebViewEngineObject> specifiedReceiver;

+ (instancetype)sharedResponder;


@end
