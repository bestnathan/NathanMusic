//
//  MusicListTableViewCell.m
//  MusicPlay1102
//
//  Created by 李宁 on 15/11/2.
//  Copyright © 2015年 lining. All rights reserved.
//

#import "Headers.h"

@interface MusicListTableViewCell()

@property(nonatomic,strong) UILabel *PlayerNameLabel;
@property(nonatomic,strong) UILabel *MusicNameLabel;
@property(nonatomic,strong) UIImageView *MyMusicIMV;

@property(nonatomic,strong) UIImageView *MyMusicIMVblur;


@end

@implementation MusicListTableViewCell


-(void)p_setupViews{
   // self.imv=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)]autorelease];
   // self.imv.image=[UIImage imageNamed:@"1.jpg"];
   // [self.contentView addSubview:self.imv];
    
    self.MyMusicIMV = [[UIImageView alloc]init];
    
    self.MyMusicIMVblur = [[UIImageView alloc]init];
    
    self.PlayerNameLabel = [[UILabel alloc]init];
    self.MusicNameLabel = [[UILabel alloc]init];
    
    [self.contentView addSubview:self.MyMusicIMV];
    
    //[self.contentView addSubview:self.MyMusicIMVblur];
    
    [self.contentView addSubview:self.PlayerNameLabel];
    
    [self.contentView addSubview:self.MusicNameLabel];
    
    
}


//布局子视图,当视图的bounds发生改变的时候
-(void)layoutSubviews{
    //一定要调用父类方法
    [super layoutSubviews];
    //self.imv.frame=CGRectMake(20, 10, 80, 80);
    CGRect rect1 =CGRectMake(10, 10, 80, 80);
    
    
    CGRect rect2 =CGRectMake(CGRectGetMaxX(rect1)+10, CGRectGetMinY(rect1), CGRectGetWidth(self.contentView.frame)-CGRectGetWidth(rect1)-30, 30);
    
    
    CGRect rect3 =CGRectMake(CGRectGetMaxX(rect1)+10, CGRectGetMaxY(rect2)+20, CGRectGetWidth(self.contentView.frame)-CGRectGetWidth(rect1)-30, 30);

    self.MyMusicIMV.frame=rect1;
    self.PlayerNameLabel.frame=rect2;
    self.MusicNameLabel.frame =rect3;
    
    
    
    
    
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //如果自定义cell，原来的属性都不要再使用，他们会影响布局。（属性名不要再重复）
        [self p_setupViews];
    }
    return self;
}


//提供给外部绑定数据的方法
- (void)bindModel:(MusicModel *)model{
    self.MusicNameLabel.text = model.name;
    self.PlayerNameLabel.text = model.singer;
    //显示图片
    //[self.MyMusicIMV sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    
    //显示图片--同时获取到图像
    
    [self.MyMusicIMV sd_setImageWithURL:[NSURL URLWithString:model.picfile_url] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        model.image=image;
    }];
     
     
     
}

- (void)awakeFromNib {
    
    //拖控件出来的cell会走这个方法
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
