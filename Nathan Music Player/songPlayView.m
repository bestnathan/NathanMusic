//
//  songPlayView.m
//  Nathan Music Player
//
//  Created by 李宁 on 15/12/23.
//  Copyright © 2015年 Nthan. All rights reserved.
//

#import "songPlayView.h"
#define kWidth self.bounds.size.width
#define kHeight self.bounds.size.height

@implementation songPlayView
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x <= 0)
    {
        CGPoint offset = scrollView.contentOffset;
        offset.y = 0;
        scrollView.contentOffset = offset;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
   
    
    self.myScrollView.bounces = NO;
    
    self.myScrollView.pagingEnabled=YES;
    
    self.myScrollView.backgroundColor = [UIColor redColor];
    self.myScrollView.frame = CGRectMake(0, 0.2*kHeight, kWidth, 0.4*kHeight);
    self.myScrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    self.myScrollView.contentSize =CGSizeMake(2*kWidth, 0);
    //隐藏指示条
    self.myScrollView.showsHorizontalScrollIndicator=NO;
    self.myScrollView.showsVerticalScrollIndicator=NO;
    self.myScrollView.alwaysBounceHorizontal = NO;
    self.myScrollView.alwaysBounceVertical   = NO;
    [self.myScrollView setContentOffset:CGPointMake(0, 0)];
    
    self.myImageViewblur.frame = CGRectMake(0, 0, kWidth, self.myScrollView.frame.size.height);
    self.myImageView.backgroundColor = [UIColor yellowColor];
    self.myImageView.frame = CGRectMake(kWidth/2-120, 0.2*kHeight-120, 240, 240);
    
    self.tableview.backgroundColor=[UIColor blueColor];
    self.tableview.frame=CGRectMake(kWidth, 0, kWidth, 0.4*kHeight);
    
    
    [self.myScrollView  addSubview:self.myImageViewblur];
    [self.myScrollView  addSubview:self.myImageView];
    [self.myScrollView addSubview:self.tableview];
    
    
    
    self.myImageView.layer.masksToBounds=YES;
    self.myImageView.layer.cornerRadius =120;
    self.myImageView.layer.anchorPoint=CGPointMake(0.5, 0.5);

    
    //歌曲名字 歌手名字
    
    self.mySlider.frame = CGRectMake(30, CGRectGetMaxY(self.myScrollView.frame)+10, kWidth-60, 40);
    
    //播放模式按钮
    self.playMod.frame = CGRectMake(20, CGRectGetMaxY(self.myScrollView.frame)+100, 80, 30);
    [self.playMod setTitle:@"播放模式" forState:UIControlStateNormal];
    
    //上一首按钮
    self.lastSong.frame = CGRectMake(CGRectGetMaxX(self.playMod.frame)+10, CGRectGetMaxY(self.myScrollView.frame)+100, 80, 30);
    [self.lastSong setTitle:@"上一首" forState:UIControlStateNormal];
    
    
    //播放按钮
self.playSong.frame = CGRectMake(CGRectGetMaxX(self.lastSong.frame)+10, CGRectGetMaxY(self.myScrollView.frame)+100, 60, 30);
    [self.playSong setTitle:@"暂停" forState:UIControlStateNormal];
    //下一首按钮
    self.nextSong.frame = CGRectMake(CGRectGetMaxX(self.playSong.frame)+10, CGRectGetMaxY(self.myScrollView.frame)+100, 80, 30);
    [self.nextSong setTitle:@"下一首" forState:UIControlStateNormal];
    
    
    
    //返回按钮
    self.backButton.frame = CGRectMake(20,30, 40, 30);
    
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    
    self.SongName.frame = CGRectMake(kWidth/2-80, CGRectGetMinY(self.backButton.frame), 160, 15);
    self.SongName.textAlignment = NSTextAlignmentCenter;
    self.SongName.font = [UIFont systemFontOfSize:15];
    
     self.SingerName.frame = CGRectMake(kWidth/2-80, CGRectGetMaxY(self.SongName.frame)+5, 160, 15);
    
    
    self.SingerName.textAlignment = NSTextAlignmentCenter;
    
    
    self.SingerName.font = [UIFont systemFontOfSize:10];
    
    
    
    
    
    
}
-(void)p_setupViews{
    
    
    self.myScrollView = [[UIScrollView alloc]init];
    self.myImageView =[[UIImageView alloc]init];
    
    self.myImageViewblur =[[UIImageView alloc]init];
    
    self.tableview = [[UITableView alloc]init];
    
    
    self.lastSong = [UIButton buttonWithType:UIButtonTypeSystem];
      self.nextSong = [UIButton buttonWithType:UIButtonTypeSystem];
    self.playSong = [UIButton buttonWithType:UIButtonTypeSystem];
     self.playMod = [UIButton buttonWithType:UIButtonTypeSystem];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    self.SongName =[[UILabel alloc]init];
    self.SingerName =[[UILabel alloc]init];
    
    self.mySlider = [[UISlider alloc]init];
    
    
    [self addSubview:self.myScrollView];
    //[self addSubview:self.myImageView];
   // [self addSubview:self.tableview];
    
    [self addSubview:self.lastSong];
    [self addSubview:self.nextSong];
    [self addSubview:self.playSong];
    
    [self addSubview:self.playMod];
    [self addSubview:self.backButton];
    
    
    
    [self addSubview:self.SongName];
    
    [self addSubview:self.SingerName];
    [self addSubview:self.mySlider];
    
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupViews];
    }
    return self;
}


@end
