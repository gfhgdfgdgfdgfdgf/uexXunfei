//
//  EUExXunfei.m
//  EUExXunfei
//
//  Created by 黄锦 on 15/12/30.
//  Copyright © 2015年 AppCan. All rights reserved.
//

#import "EUExXunfei.h"


@implementation EUExXunfei

-(id)initWithBrwView:(EBrowserView *)eInBrwView{
    if (self=[super initWithBrwView:eInBrwView]) {
        
    }
    return self;
}

-(void)init:(NSMutableArray *)inArguments{
    if(inArguments.count <1){
        return;
    }
    NSDictionary *info = [inArguments[0] JSONValue];
    NSString *appId=[info objectForKey:@"appID"];
    NSMutableDictionary *result=[NSMutableDictionary dictionary];
    if(appId){
        NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",appId];
        [IFlySpeechUtility createUtility:initString];
        [result setObject:[NSNumber numberWithBool:YES] forKey:@"result"];
    }
    else{
        [result setObject:[NSNumber numberWithBool:NO] forKey:@"result"];
    }
    [self cbInit:[result JSONFragment]];
}
- (void)cbInit:(NSString *)obj{
    NSString *result=nil;
    if([obj isKindOfClass:[NSString class]]){
        result=(NSString *)obj;
    }else{
        result=[obj JSONFragment];
    }
    NSString *cbStr=[NSString stringWithFormat:@"if(uexXunfei.cbInit != null){uexXunfei.cbInit('%@');}",result];
    [EUtility brwView:meBrwView evaluateScript:cbStr];
}
#pragma mark - 语音合成
-(void)initSpeaker:(NSMutableArray *)inArguments{
    NSString *speed=@"50";
    NSString *volume=@"80";
    NSString *voiceName=@"xiaoyan";
    if(inArguments.count >0){
        NSDictionary *info = [inArguments[0] JSONValue];
        if([info objectForKey:@"speed"]){
            speed=[info objectForKey:@"speed"];
        }
        if([info objectForKey:@"volume"]){
            volume=[info objectForKey:@"volume"];
        }
        if([info objectForKey:@"voiceName"]){
            voiceName=[info objectForKey:@"voiceName"];
        }
    }
    
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    _iFlySpeechSynthesizer.delegate = self;
    //设置语音合成的参数
    //语速,取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:speed forKey:[IFlySpeechConstant SPEED]];
    //音量;取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:volume forKey: [IFlySpeechConstant VOLUME]];
    //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表
    [_iFlySpeechSynthesizer setParameter:voiceName forKey: [IFlySpeechConstant VOICE_NAME]];

}
-(void)startSpeaking:(NSMutableArray *)inArguments{
    NSString *text=@"";
    if(inArguments.count >0){
        NSDictionary *info = [inArguments[0] JSONValue];
        if([info objectForKey:@"text"]){
            text=[info objectForKey:@"text"];
        }
    }
    [_iFlySpeechSynthesizer startSpeaking: text];
}

//合成结束
- (void) onCompleted:(IFlySpeechError *) error{
    NSString *cbStr=[NSString stringWithFormat:@"if(uexXunfei.onSpeakComplete != null){uexXunfei.onSpeakComplete();}"];
    [EUtility brwView:meBrwView evaluateScript:cbStr];
}
//合成开始
- (void) onSpeakBegin{
    NSString *cbStr=[NSString stringWithFormat:@"if(uexXunfei.onSpeakBegin != null){uexXunfei.onSpeakBegin();}"];
    [EUtility brwView:meBrwView evaluateScript:cbStr];
}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg{
}

//合成播放进度
- (void) onSpeakProgress:(int) progress{
    
}

//合成暂停回调
- (void)onSpeakPaused{
    NSString *cbStr=[NSString stringWithFormat:@"if(uexXunfei.onSpeakPaused != null){uexXunfei.onSpeakPaused();}"];
    [EUtility brwView:meBrwView evaluateScript:cbStr];
}

//恢复合成回调
- (void)onSpeakResumed{
    NSString *cbStr=[NSString stringWithFormat:@"if(uexXunfei.onSpeakResumed != null){uexXunfei.onSpeakResumed();}"];
    [EUtility brwView:meBrwView evaluateScript:cbStr];
}
//取消合成回调
- (void)onSpeakCancel{
    
}
#pragma mark - 语音识别
-(void)initRecognizer:(NSMutableArray *)inArguments{
    NSString *domain=@"iat";
    NSString *language=@"zh_cn";
    NSString *accent=@"mandarin";
    if(inArguments.count >0){
        NSDictionary *info = [inArguments[0] JSONValue];
        if([info objectForKey:@"domain"]){
            domain=[info objectForKey:@"domain"];
        }
        if([info objectForKey:@"language"]){
            language=[info objectForKey:@"language"];
        }
        if([info objectForKey:@"accent"]){
            accent=[info objectForKey:@"accent"];
        }
    }
    //初始化语音识别控件
    _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
    if(_iFlySpeechRecognizer.isListening){
        [_iFlySpeechRecognizer cancel];
    }
    _iFlySpeechRecognizer.delegate = self;
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    //听写模式
    [_iFlySpeechRecognizer setParameter: domain forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //语言
    [_iFlySpeechRecognizer setParameter: language forKey: [IFlySpeechConstant LANGUAGE]];
    //方言
    [_iFlySpeechRecognizer setParameter: accent forKey: [IFlySpeechConstant ACCENT]];
    //设置最长录音时间
    [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
    //设置后端点
    [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_EOS]];
    //设置前端点
    [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];
    //网络等待时间
    [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
    //设置采样率，推荐使用16K
    [_iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    //扩展参数
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
}
-(void)startListening:(NSMutableArray *)inArguments{
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer:nil];
    }
    if(_iFlySpeechRecognizer.isListening){
        [_iFlySpeechRecognizer cancel];
    }
    //启动识别服务
    [_iFlySpeechRecognizer startListening];
}
//开始语音识别
- (void) onBeginOfSpeech{
    NSString *cbStr=[NSString stringWithFormat:@"if(uexXunfei.onBeginOfSpeech != null){uexXunfei.onBeginOfSpeech();}"];
    [EUtility brwView:meBrwView evaluateScript:cbStr];
}
//停止识别回调
- (void) onEndOfSpeech{
    NSString *cbStr=[NSString stringWithFormat:@"if(uexXunfei.onEndOfSpeech != null){uexXunfei.onEndOfSpeech();}"];
    [EUtility brwView:meBrwView evaluateScript:cbStr];
}
/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResults: (NSArray *)resultArray isLast:(BOOL) isLast{
    NSMutableDictionary *result=[NSMutableDictionary dictionary];
    if(resultArray){
        [result setObject:resultArray forKey:@"text"];
    }
    else{
        [result setObject:@"" forKey:@"text"];
    }
    [result setObject:[NSNumber numberWithBool:isLast] forKey:@"isLast"];
    
    NSString * resultString=[result JSONFragment];
    NSString *cbStr=[NSString stringWithFormat:@"if(uexXunfei.onRecognizeResult != null){uexXunfei.onRecognizeResult('%@');}",resultString];
    [EUtility brwView:meBrwView evaluateScript:cbStr];
}
/*识别会话错误返回代理
 @ param  error 错误码
 */  
- (void)onError: (IFlySpeechError *) error {
    NSMutableDictionary * errDic=[NSMutableDictionary dictionary];
    [errDic setObject:@(error.errorCode) forKey:@"errorCode"];
    [errDic setObject:error.errorDesc forKey:@"errorDesc"];
    [errDic setObject:@(error.errorType) forKey:@"errorType"];
    
    NSMutableDictionary *resultDic=[NSMutableDictionary dictionary];
    [resultDic setObject:errDic forKey:@"error"];
    NSString *result =(NSString *)[resultDic JSONFragment];
    
    NSString *cbStr=[NSString stringWithFormat:@"if(uexXunfei.onRecognizeError != null){uexXunfei.onRecognizeError('%@');}",result];
    [EUtility brwView:meBrwView evaluateScript:cbStr];

}
@end
