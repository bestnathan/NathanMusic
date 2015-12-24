//
//  MusicListTableViewCell.h
//  MusicPlay1102
//
//  Created by 李宁 on 15/11/2.
//  Copyright © 2015年 lining. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicModel;
@interface MusicListTableViewCell : UITableViewCell

- (void)bindModel:(MusicModel *)model;
@end
