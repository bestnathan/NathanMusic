//
//  songPlayView.h
//  Nathan Music Player
//
//  Created by 李宁 on 15/12/23.
//  Copyright © 2015年 Nthan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface songPlayView : UIView<UIScrollViewDelegate>

//左边是图片旋转，右边是歌词tableview
@property(nonatomic,strong)UIScrollView *myScrollView;

//显示北京
@property (strong, nonatomic)  UIImageView *myImageViewblur;

//显示旋转图片
@property (strong, nonatomic)  UIImageView *myImageView;
//显示歌词
@property (strong, nonatomic)  UITableView *tableview;

//播放模式控制按钮
@property (strong, nonatomic)  UIButton *playMod;

@property (strong, nonatomic)  UIButton *lastSong;
@property (strong, nonatomic)  UIButton *playSong;
@property (strong, nonatomic)  UIButton *nextSong;

@property (strong, nonatomic)  UIButton *backButton;

@property (strong, nonatomic)  UILabel *SongName;
@property (strong, nonatomic)  UILabel *SingerName;
@property (strong, nonatomic)  UISlider *mySlider;

@end
