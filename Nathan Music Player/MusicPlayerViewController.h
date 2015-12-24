//
//  MusicPlayerViewController.h
//  MusicPlay1102
//
//  Created by 李宁 on 15/11/2.
//  Copyright © 2015年 lining. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayerViewController : UIViewController


// 接受上一个界面点击过来的哪一首歌
@property (nonatomic, assign) NSInteger index;
@property(nonatomic,strong)NSTimer *myTimer;

@property(nonatomic,assign)BOOL direct;
@end
