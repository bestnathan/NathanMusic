//
//  LyricHandle.m
//  MusicPlay1102
//
//  Created by 李宁 on 15/11/5.
//  Copyright © 2015年 lining. All rights reserved.
//

#import "LyricHandle.h"
#import "LyricModel.h"

static LyricHandle *myHandle=nil;


@interface LyricHandle()
@property (nonatomic, strong) NSMutableArray *lyricItemArray;

@property (nonatomic, assign) NSInteger index;

@end



@implementation LyricHandle
+(instancetype)shareLyricHandle{
    if (myHandle==nil) {
        myHandle = [[LyricHandle alloc]init];
    }
    return myHandle;
}

-(NSMutableArray *)lyricItemArray{
    
    if (_lyricItemArray==nil) {
        self.lyricItemArray= [NSMutableArray array];
    }
    
    return _lyricItemArray;
}

- (void)changeLyricString:(NSString *)string{
    [self.lyricItemArray removeAllObjects];
    NSArray *arr1 = [string componentsSeparatedByString:@"\n"];
    
    for (NSString *str  in arr1)
    {
       
        if (str.length==0)
        {
            //没有歌词？
            LyricModel * m =[LyricModel lyricWithString:@"" andTime:1000];
            [self.lyricItemArray addObject:m];
            
        }//if (str.length==0)
        else
        {
            NSArray *arr2 = [str componentsSeparatedByString:@"]"];
            
            if (arr2.count>1) {
                
                NSString *timeStr = arr2[0];
                NSString *lyricStr = arr2[1];
                
                NSString * timeStr2 = [timeStr substringFromIndex:1];//去掉第一个"["
                NSArray * timeArr = [timeStr2 componentsSeparatedByString:@":"];
                if (timeArr.count>1) {
                    float minute =[timeArr[0] floatValue];
                    float second = [timeArr[1] floatValue];
                    
                    float time = minute*60 + second;
                    
                    LyricModel *m2 = [LyricModel lyricWithString:lyricStr andTime:time];
                    [self.lyricItemArray addObject:m2];
                }
                
                
                
                
            }
            
            
        }// else
        
        
        
        
    }//for (NSString *str  in arr)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

- (NSInteger)lyricItemCount{
       return self.lyricItemArray.count;
}

- (NSString *)lyricStringWithIndex:(NSInteger)index{
    LyricModel *m = self.lyricItemArray[index];
    return m.lyricString;
}

- (NSInteger)lyricItemWithTime:(float)time{
    
    //根据歌曲播放时间，获取到当前的歌词
    
    
    for (int i=0; i<self.lyricItemArray.count; i++) {
        
        
        
        LyricModel *m = self.lyricItemArray[i];
        
        if (time<m.time) {
            
            
            
            _index = i-1>0?i-1:0;
            
            break;
            
            
        }
        
        
        
    }
    
    
    
    return _index;
    
    
    
}
@end
