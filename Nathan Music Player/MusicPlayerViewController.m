//
//  MusicPlayerViewController.m
//  MusicPlay1102
//
//  Created by 李宁 on 15/11/2.
//  Copyright © 2015年 lining. All rights reserved.
//

#import "Headers.h"

@interface MusicPlayerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong)MusicModel *model;//获取到的model
@property(nonatomic,strong)MusicPlayerHandle *mpHandle;
@property(nonatomic,strong)MusicDataHandle *dataHandle;
@property(nonatomic,strong)songPlayView *songV;

@end

@implementation MusicPlayerViewController



#pragma mark--viewDidLoad
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.mpHandle=[MusicPlayerHandle shareMusicPlayerHandle];
    
    self.songV = [[songPlayView alloc]initWithFrame:self.view.frame];
    self.view =self.songV;
    
    [self.songV.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.songV.tableview.delegate=self;
    self.songV.tableview.dataSource=self;
    
    self.songV.myImageView.layer.masksToBounds=YES;
    self.songV.myImageView.layer.cornerRadius =self.songV.myImageView.frame.size.width/2;
    
    
    self.dataHandle=[MusicDataHandle shareMusicDataHandleWithFinishBlock:nil] ;
    
    if (!self.direct) {
        self.model = [ self.dataHandle musicWithIndex:self.index];
        
NSLog(@"获取model=%@",self.model);
    }
    else{
        if(self.mpHandle.nowModel)
        self.model = self.mpHandle.nowModel;
        else self.model = [ self.dataHandle musicWithIndex:0];
        NSLog(@"直接获取model=%@",self.model);
    }
    self.direct=NO;
    self.songV.SongName.text = self.model.name;
    
    self.songV.SingerName.text = self.model.singer;
    self.songV.myImageView.layer.anchorPoint=CGPointMake(0.5, 0.5);

    
    
    switch (self.mpHandle.playStatus) {
            
        case 0:
            [self.songV.playMod setTitle:@"列表循环" forState:UIControlStateNormal];
            break;
        case 1:
            [self.songV.playMod setTitle:@"随机播放" forState:UIControlStateNormal];
            break;
        case 2:
            [self.songV.playMod setTitle:@"单曲循环" forState:UIControlStateNormal];
            break;
            
    }
    
    
    [self.songV.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.songV.playSong addTarget:self action:@selector(playSongAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.songV.mySlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.songV.playMod addTarget:self action:@selector(modButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.songV.nextSong addTarget:self action:@selector(nextSongClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.songV.lastSong addTarget:self action:@selector(lastSongClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self changeMusic:self.model];
}
#pragma mark 播放按钮

-(void)playSongAction:(UIButton*)sender{
    NSLog(@"点击播放按钮");
    UIButton *button = (UIButton *)sender;
    
    
    
    if ([self.mpHandle isPlaying]) {
        [self.mpHandle pause];
        [button setTitle:@"播放" forState:UIControlStateNormal];
        [self.myTimer invalidate];
        self.myTimer=nil;
    } else {
        [self.mpHandle play];
        [button setTitle:@"暂停" forState:UIControlStateNormal];
        
    }
    
    
    
}

#pragma mark--换歌曲
-(void)changeMusic:(MusicModel*)model{
    //修改歌曲名称、歌手、图片
    self.songV.SongName.text = model.name;
    self.songV.SingerName.text = model.singer;
    
    [self.songV.myImageViewblur sd_setImageWithURL:[NSURL URLWithString:model.blurpicfile_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.songV.myImageViewblur.image = image;
        });
    }];
    
    self.songV.myImageView.image=model.image;
    NSLog(@"model.name歌曲名称=%@", model.name);
    //设置进度条最大值
    [self setSliderMaxValue];
    
    
    [self.songV.playSong setTitle:@"暂停" forState:UIControlStateNormal];
    
    
    //获取上次播放的歌曲的网址
    
    __weak typeof(self) weakSelf=self;//第二种写法
    
    self.mpHandle=[MusicPlayerHandle shareMusicPlayerHandle];
    
    self.mpHandle.nowModel = model;
    
    self.mpHandle.mptblock=^void(float progress){
        
        
        //如果返回目录页，这个对象就不存在了，所以要判断一下
        if (weakSelf) {
            
            
            //这里实现图片旋转
            weakSelf.songV.myImageView.transform = CGAffineTransformRotate(weakSelf.songV.myImageView.transform, 0.01);
            
            
            weakSelf.songV.mySlider.value=progress;//进度条
            //歌词行数目
           // NSInteger coutOfstrs =[LyricHandle shareLyricHandle].lyricItemCount;
            
            
            NSInteger index = [[LyricHandle shareLyricHandle] lyricItemWithTime:progress];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            
            
            [weakSelf.songV.tableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            
            
            if (weakSelf.songV.mySlider.value==weakSelf.songV.mySlider.maximumValue)
            {
                
                
                
                
                NSLog(@"播放完毕");
                [weakSelf nextSongClick:nil];
                
            }
            
        }//if (weakSelf)
        
        
    };//^void(float progress)
    
    
    [[LyricHandle shareLyricHandle]changeLyricString:model.lyric];
    
    
    NSString *last_s=self.dataHandle.lastmp3Url;
    
    //歌曲地址不同，或者是单曲循环模式
    if (![last_s isEqualToString:model.MP3file_url]||self.mpHandle.playStatus==2) {
        
        
        self.dataHandle.lastmp3Url=model.MP3file_url;
        //播放音乐
        
        [self.mpHandle playWithURLString:model.MP3file_url];
        
    }
    
    
    //设置按钮文字为暂停
   // [self.songV.playSong setTitle:@"暂停" forState:UIControlStateNormal];
    [self.songV.tableview reloadData];
    
    
}



#pragma mark 返回按钮
-(void)backButtonAction:(UIButton*)sender{
    NSLog(@"点击返回按钮");
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger m = [[LyricHandle shareLyricHandle] lyricItemCount];
    return m;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[LyricHandle shareLyricHandle] lyricStringWithIndex:indexPath.row];
    
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;//居中显示
    
  //cell.textLabel.text=@"测试123";
    return  cell;
    
    
}


#pragma mark--进度条
//设置进度条最大值
-(void)setSliderMaxValue{
    self.songV.mySlider.value = 0;
    self.songV.mySlider.minimumValue = 0;
    
    int musicTime = [self.model.duration floatValue] / 1000;
    self.songV.mySlider.maximumValue = musicTime;
    NSLog(@"self.mySlider.maximumValue=%f",self.songV.mySlider.maximumValue);
}
#pragma mark--拖动进度条
- (void)sliderAction:(id)sender {
    
    UISlider * slider = (UISlider*) sender;
    //获取进度条当前的位置，然后将音乐前进到这个位置
    [self.mpHandle seekToTime:slider.value];
    
    
    
}


#pragma mark--拖动进度条播放模式控制按钮
- (void)modButtonClick:(id)sender {
    
    self.mpHandle.playStatus++;
    if (self.mpHandle.playStatus>2) {
        self.mpHandle.playStatus=0;
    }
    
    
    switch (self.mpHandle.playStatus) {
        case 0:
            [self.songV.playMod setTitle:@"列表循环" forState:UIControlStateNormal];
            break;
        case 1:
            [self.songV.playMod setTitle:@"随机播放" forState:UIControlStateNormal];
            break;
        case 2:
            [self.songV.playMod setTitle:@"单曲循环" forState:UIControlStateNormal];
            break;
            
    }
    
    NSLog(@"self.mpHandle.playStatus=%ld",(long)self.mpHandle.playStatus);
    
}



#pragma mark 下一首歌按钮
- (void)nextSongClick:(UIButton*)sender {
    
    
    switch (self.mpHandle.playStatus) {
        case 0://列表循环
            if (self.index == [[MusicDataHandle shareMusicDataHandleWithFinishBlock:nil] musicDataCount] - 1) {
                self.index = 0;
            } else {
                self.index += 1;
            }
            self.model = [[MusicDataHandle shareMusicDataHandleWithFinishBlock:nil] musicWithIndex:self.index];
            [self changeMusic:self.model];
            break;
        case 1://随机播放
            self.index = arc4random() % [[MusicDataHandle shareMusicDataHandleWithFinishBlock:nil] musicDataCount];
            self.model = [[MusicDataHandle shareMusicDataHandleWithFinishBlock:nil] musicWithIndex:self.index];
            [self changeMusic:self.model];
            break;
        case 2://单曲循环
            self.model = [[MusicDataHandle shareMusicDataHandleWithFinishBlock:nil] musicWithIndex:self.index];
            [self changeMusic:self.model];
            break;
        default:
            break;
    }
    
    
    
    
    
}


#pragma mark 上一首歌按钮
- (void)lastSongClick:(UIButton*)sender {
    
    
    
    if (self.index == 0) {
        self.index = [[MusicDataHandle shareMusicDataHandleWithFinishBlock:nil]musicDataCount] - 1;
    } else {
        self.index -= 1;
    }
    
    self.model = [[MusicDataHandle shareMusicDataHandleWithFinishBlock:nil] musicWithIndex:self.index];
    
    [self changeMusic:self.model];
}

@end
