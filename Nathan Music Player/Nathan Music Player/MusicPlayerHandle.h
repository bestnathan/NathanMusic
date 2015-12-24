//
//  MusicPlayer.h
//  MusicPlay1102
//
//  Created by 李宁 on 15/11/3.
//  Copyright © 2015年 lining. All rights reserved.
//
#import "Headers.h"
#import <Foundation/Foundation.h>
typedef void(^finishBlock) ();
//有参数无返回值，参数就是要传过去的实时的音乐播放位置
typedef void(^musicPlayTimeBlock) (float);
@protocol MusicPlayerHandleDelegate <NSObject>
// 这个代理方法的作用是告诉外界当前音乐播放的时间
- (void)musicPlayTime:(float)time;

// 当前音乐结束播放的代理方法
//- (void)currentMusicDidFinish;
@end


@interface MusicPlayerHandle : NSObject
//代理使用assign，防止父类对象作为子类对象代理人的时候造成循环引用
@property(nonatomic,assign) id<MusicPlayerHandleDelegate> delegate;

@property(nonatomic,assign) NSInteger playStatus;

@property(nonatomic,assign) NSInteger index;
//当前播放的歌曲

@property(nonatomic,strong) MusicModel *nowModel;

@property(nonatomic,copy) musicPlayTimeBlock mptblock;
+(instancetype)shareMusicPlayerHandle;
//+(instancetype)shareMusicPlayerHandleWithFinishBlock:(finishBlock)finishblock;

//开始播放
-(void)playWithURLString:(NSString*)urlString;

//播放
-(void)play;

//暂停
-(void)pause;

//停止
-(void)stop;

//是否在播放
-(BOOL)isPlaying;

//获取播放到的时间
- (void)seekToTime:(float)time;



@end
