//
//  IdentitySettingViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/8/28.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "IdentitySettingViewController.h"
#import "UserInfoViewController.h"
#import "LoginButton.h"

@interface IdentitySettingViewController (){
    UIButton   *selectedButton;
    NSInteger   type; //1老师 2大学生
}

@property (nonatomic, strong) UILabel            *titleLabel;     //标题
@property (nonatomic, strong) LoginButton        *completeButton;       //确定

@end

@implementation IdentitySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenShaw = YES;
    type = 1;
    
    [self initIdentitySettingView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"身份设定"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"身份设定"];
}

#pragma mark -- Event response
-(void)chooseIdentityAction:(UIButton *)sender{
    selectedButton.selected=NO;
    sender.selected=YES;
    selectedButton=sender;
    type = sender.tag+1;
}

#pragma mark 确定身份选择
-(void)confirmIdentitySettingAction{
    NSString *body = [NSString stringWithFormat:@"token=%@&label=%ld",self.model.token,type];
    kSelfWeak;
    [TCHttpRequest postMethodWithURL:kSetUserInfoAPI body:body success:^(id json) {
        weakSelf.model.tch_label = [NSNumber numberWithInteger:type];
        dispatch_sync(dispatch_get_main_queue(), ^{
            UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
            userInfoVC.userModel = weakSelf.model;
            userInfoVC.isLoginIn = YES;
            [self.navigationController pushViewController:userInfoVC animated:YES];
        });
    }];
}

#pragma mark -- Private Methods
#pragma mark 初始化
-(void)initIdentitySettingView{
    [self.view addSubview:self.titleLabel];
    
    NSArray *titles = @[@"我是老师",@"我是大学生"];
    NSArray *images = IS_IPAD?@[@"identity_teacher_ipad",@"identity_undergraduate_ipad"]:@[@"identity_teacher",@"identity_undergraduate"];

    CGFloat btnCapWidth = IS_IPAD?132:24.0;
    CGFloat btnW = IS_IPAD?184:120;
    CGFloat imgCapWidth = (kScreenWidth-btnW*2-btnCapWidth)/2.0;
    for (NSInteger i=0; i<2; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake(imgCapWidth+(184+132)*i, self.titleLabel.bottom+71, 184, 205):CGRectMake(imgCapWidth+(btnW+btnCapWidth)*i,self.titleLabel.bottom+53, btnW, 136)];
        imgView.image = [UIImage imageNamed:images[i]];
        [self.view addSubview:imgView];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(imgCapWidth+20+(160+btnCapWidth)*i,imgView.bottom+21,160,36):CGRectMake(imgCapWidth+10+(110+btnCapWidth)*i, imgView.bottom+15, 110, 30)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:IS_IPAD?@"identity_choose_gray_ipad":@"identity_choose_gray"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:IS_IPAD?@"identity_choose_ipad":@"identity_choose"] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        btn.tag = i;
        [btn addTarget:self action:@selector(chooseIdentityAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.selected = YES;
            selectedButton = btn;
        }
        [self.view addSubview:btn];
    }
    
    [self.view addSubview:self.completeButton];
}

#pragma mark -- Getters
#pragma mark 标题
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(78, kNavHeight+24, 200, 42):CGRectMake(44, kNavHeight+15, 120, 28)];
        _titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?30:20];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _titleLabel.text = @"身份设定";
    }
    return _titleLabel;
}

#pragma mark 确定
-(LoginButton *)completeButton{
    if (!_completeButton) {
        CGRect btnFrame = IS_IPAD?CGRectMake((kScreenWidth-515)/2.0, self.titleLabel.bottom+435.0,515, 75):CGRectMake(48,self.titleLabel.bottom+273.0,kScreenWidth-96, 60);
        _completeButton = [[LoginButton alloc] initWithFrame:btnFrame title:@"确定"];
        [_completeButton addTarget:self action:@selector(confirmIdentitySettingAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}

@end
