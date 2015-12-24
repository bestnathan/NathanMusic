//
//  LyricModel.m
//  MusicPlay1102
//
//  Created by 李宁 on 15/11/5.
//  Copyright © 2015年 lining. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel


-(instancetype)initWithString:(NSString*)lyricString andTime:(float)time{
    self = [super init];
    if (self) {
        _time=time;
        _lyricString =lyricString;
    }
    return self;
}

+(instancetype)lyricWithString:(NSString*)lyricString andTime:(float)time{
    LyricModel * m = [[LyricModel alloc]initWithString:lyricString andTime:time];
    return m;
}
@end
