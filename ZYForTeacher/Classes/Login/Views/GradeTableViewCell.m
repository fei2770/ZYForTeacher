//
//  GradeTableViewCell.m
//  ZYForTeacher
//
//  Created by vision on 2018/8/29.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "GradeTableViewCell.h"

@interface GradeTableViewCell ()

@property (nonatomic ,strong) UILabel     *gradeLabel;
@property (nonatomic ,strong) UIButton    *selectButton;    //选择

@end

@implementation GradeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, 12, 20, 20)];
        [self.selectButton setImage:[UIImage imageNamed:@"payment_method_choose_gray"] forState:UIControlStateNormal];
        [self.selectButton setImage:[UIImage imageNamed:@"payment_method_choose"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.selectButton];
        
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    self.selectButton.selected = isSelected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end