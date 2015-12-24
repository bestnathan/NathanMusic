//
//  MusicPlayer.m
//  MusicPlay1102
//
//  Created by 李宁 on 15/11/3.
//  Copyright © 2015年 lining. All rights reserved.
//

#import "MusicPlayerHandle.h"
#import <AVFoundation/AVFoundation.h>
static MusicPlayerHandle *myMusicPlayer=nil;
@interface MusicPlayerHandle()

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation MusicPlayerHandle



+(instancetype)shareMusicPlayerHandle{
    if (myMusicPlayer==nil) {
        myMusicPlayer =[[MusicPlayerHandle alloc]init];
        myMusicPlayer.player =[AVPlayer new];
        
    }
    return myMusicPlayer;
}

//+(instancetype)shareMusicPlayerHandleWithFinishBlock:(finishBlock)finishblock{
//    if (myMusicPlayer==nil) {
//        myMusicPlayer =[[MusicPlayerHandle alloc]init];
//        myMusicPlayer.player =[AVPlayer new];
//        finishblock();
//    }
//    return myMusicPlayer;
//}



-(void)playWithURLString:(NSString*)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    //
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:item];
    
    [self play];
}
-(void)play{
    [self.player play];
    self.isPlaying = YES;
    
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        
        [self.timer fire];
    }
}
#pragma mark- timerAction

- (void)timerAction
{

    // 因为CMTime的结构体已经告诉了。 time.value / time.timescale 可以得到秒数，所以，我们这里通过这个方法计算出来当前播放到多少秒了。
            float progress = self.player.currentTime.value / self.player.currentTime.timescale;
    self.mptblock(progress);
}

-(void)pause{
    [self.player pause];
    self.isPlaying = NO;
    [self.timer invalidate];
    self.timer = nil;
}
-(void)stop{
    [self pause];

}
-(BOOL)isPlaying{
     return _isPlaying;
}

- (void)seekToTime:(float)time
{
    CMTime musicTime = CMTimeMakeWithSeconds(time, self.player.currentTime.timescale);
    
    [self pause];//先暂停
    
    [self.player seekToTime:musicTime completionHandler:^(BOOL finished)
    
    {if (finished) { [self play];}  }
     ];
}

@end
