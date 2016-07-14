//
//  MTADebugBar.m
//  Artist
//
//  Created by Jack on 16/7/8.
//  Copyright © 2016年 大众点评. All rights reserved.
//

#import "MTADebugBar.h"
#import "MTADebugModel.h"
#import "MTADebugpanel.h"
#import "MTADebugMethodBridge.h"
#import "UIImage+MTAColor.h"


#define kDebugBarItemHeight 35
#define kBottomButtonHeight 20
#define kDebugBarWidth  145
#define kMTADebugTableMaxHeight 400
#define kMTADebugSize [[UIScreen mainScreen] bounds].size

@interface MTADebugBar ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    CGRect _tableViewFrame;
    CGRect _originFrame;
    UIButton *_bottomButton;
    UIView *_urlWindow;
    UIView * _backColorView;
}

@property (nonatomic, copy)MTADebugDataSourceBlock block;
@property (nonatomic, strong,readwrite) NSArray * arrlist;
@property (nonatomic, strong) MTADebugMethodBridge *bridge;
@end

@implementation MTADebugBar


- (void)setConetenDateWithBlock:(MTADebugDataSourceBlock) block;
{
    if (block().count) {
        self.arrlist = [NSArray arrayWithArray:block()];
    }
    self.block = [block copy];
    [self performSelector:@selector(reloadTableListView) withObject:nil afterDelay:0];
}


- (void)reloadTableListView
{
    _tableView.scrollEnabled = NO;
    CGFloat tableheight =self.arrlist.count * (kDebugBarItemHeight + 5) - 5;
    if (kMTADebugTableMaxHeight < self.arrlist.count * (kDebugBarItemHeight + 5)) {
        tableheight = kMTADebugTableMaxHeight;
        _tableView.scrollEnabled = YES;
    }
    _tableViewFrame = CGRectMake(5, kDebugBarItemHeight + 2, kDebugBarWidth -10, tableheight);
    _tableView.frame = _tableViewFrame;
    [_tableView reloadData];
    
}

#pragma mark lifeCircle
- (id)init
{
    self = [super initWithFrame:CGRectMake((kMTADebugSize.width-kDebugBarWidth)/2, -kDebugBarItemHeight, kDebugBarWidth, kDebugBarItemHeight + kBottomButtonHeight)];
    if (self) {
        // Initialization code
        
        _originFrame = CGRectMake((kMTADebugSize.width-kDebugBarWidth)/2, -kDebugBarItemHeight, kDebugBarWidth, kDebugBarItemHeight +kBottomButtonHeight);
        _bridge = [[MTADebugMethodBridge alloc]init];
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        
        self.clipsToBounds = YES;
        
        _backColorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDebugBarWidth, 0)];
        _backColorView.backgroundColor = [UIColor whiteColor];
        _backColorView.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
        _backColorView.layer.borderWidth = 0.5;
        _backColorView.layer.cornerRadius = 6;
        [self addSubview:_backColorView];
    
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(5, kDebugBarItemHeight + 2, kDebugBarWidth, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
        _tableView.layer.borderWidth = 0.5;
        _tableView.layer.cornerRadius = 6;
        [self addSubview:_tableView];
        _tableView.alpha = 0;
        
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.backgroundColor = [UIColor clearColor];
        _bottomButton.frame = CGRectMake(kDebugBarWidth-60, kDebugBarItemHeight, 45, kBottomButtonHeight);
        [_bottomButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _bottomButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_bottomButton setTitle:@"🐞" forState:UIControlStateNormal];
        [_bottomButton addTarget:self action:@selector(taggleOpenClose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bottomButton];
        self.hidden = NO;
        [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBacomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [self performSelector:@selector(reloadTableListView) withObject:nil afterDelay:0];

    }
    return self;
}


- (void)taggleOpenClose {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(alphaBottomButton) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(taggleClose) object:nil];
    [self taggleOpen];
}

- (void)alphaBottomButton {
    [UIView animateWithDuration:0.3 animations:^{
        _bottomButton.alpha = 1;
    }];
}

- (void)taggleOpen {
    _bottomButton.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake((kMTADebugSize.width-kDebugBarWidth)/2, -kDebugBarItemHeight, kDebugBarWidth, _tableViewFrame.origin.y +_tableViewFrame.size.height + 2);
        _bottomButton.alpha = 0;
        _tableView.alpha = 1;
        _backColorView.frame = self.bounds;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(taggleClose) withObject:nil afterDelay:3];

    }];
}


- (void)taggleClose {
    
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.frame = _originFrame;
        _tableView.alpha = 0;
        _backColorView.frame = CGRectMake(0, 0, kDebugBarWidth, 0);
    } completion:^(BOOL finished) {
        _bottomButton.alpha = 1;
        _bottomButton.hidden = NO;
    }];
    
}



- (void)didBacomeActive:(NSNotification *)n {

    
}



- (void)setFrame:(CGRect)frame {
    /* 在iOS7中，当拍照时，系统会自动将Window的高度调整为20.
     * 为了避免这个问题，这里对"setFrame:"方法进行了Hack，不允许其高度低于40
     * （高度限制取40，是因为通话状态下状态栏的高度是40）
     */
    if (CGRectGetHeight(frame)<=40) {
        return;
    }
    [super setFrame:frame];
}




#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrlist.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 5;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDebugBarItemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MTAUITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MTAUITableViewCell"];
    }
    MTADebugModel *model;
    if (indexPath.section < self.arrlist.count) {
        model = self.arrlist[indexPath.section];
    }
    cell.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];;
    cell.textLabel.text = model.title&&model.selectorProperty?model.title:@"无效方法";
    cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self taggleClose];
    MTADebugModel *model;
    if (indexPath.section < self.arrlist.count) {
        model = self.arrlist[indexPath.section];
    }
    [_bridge handleSelectorProperty:model];
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
