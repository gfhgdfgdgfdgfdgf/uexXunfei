//
//  EUExXunfei.h
//  EUExXunfei
//
//  Created by 黄锦 on 15/12/30.
//  Copyright © 2015年 AppCan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON/JSON.h"
#import "EUtility.h"
#import "EUExBase.h"
#import "iflyMSC/IFlyMSC.h"

@class IFlySpeechRecognizer;
@interface EUExXunfei : EUExBase<IFlySpeechSynthesizerDelegate,IFlySpeechRecognizerDelegate>
{
    IFlySpeechSynthesizer       * _iFlySpeechSynthesizer;
    IFlySpeechRecognizer      *_iFlySpeechRecognizer;
    
}

@end
