//
//  LyricModel.h
//  MusicPlay1102
//
//  Created by 李宁 on 15/11/5.
//  Copyright © 2015年 lining. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject
@property(nonatomic,copy) NSString *lyricString;//歌词字符串
@property(nonatomic,assign)float time;//歌曲时间长度

+(instancetype)lyricWithString:(NSString*)lyricString andTime:(float)time;
@end
