//
//  LyricHandle.h
//  MusicPlay1102
//
//  Created by 李宁 on 15/11/5.
//  Copyright © 2015年 lining. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricHandle : NSObject
+(instancetype)shareLyricHandle;
- (void)changeLyricString:(NSString *)string;

- (NSInteger)lyricItemCount;

- (NSString *)lyricStringWithIndex:(NSInteger)index;

- (NSInteger)lyricItemWithTime:(float)time;
@end
