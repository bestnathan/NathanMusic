//
//  MusicDataHandle.h
//  MusicPlay1102
//
//  Created by 李宁 on 15/11/3.
//  Copyright © 2015年 lining. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"
typedef void(^finishBlock) ();

@interface MusicDataHandle : NSObject

+(instancetype)shareMusicDataHandleWithFinishBlock:(finishBlock)finishblock;

-(NSInteger)musicDataCount;

-(MusicModel *)musicWithIndex:(NSInteger)index;

//记录上次播放的音乐

@property (nonatomic, copy) NSString *lastmp3Url;

@end
