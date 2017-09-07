//
//  XYActionSheet.m
//  XYActionSheet
//
//  Created by FireHsia on 2017/8/31.
//  Copyright © 2017年 FireHsia. All rights reserved.
//  Github: https://github.com/FireHsia
//

#define k_XYWidth [UIScreen mainScreen].bounds.size.width
#define k_XYHeight [UIScreen mainScreen].bounds.size.height
#define k_XYWindow [UIApplication sharedApplication].keyWindow

#import "XYActionSheet.h"

static NSString *const kXYActionSheetCell = @"kXYActionSheetCell";

static CGFloat const kSheetCellHeight = 50;
static CGFloat const kSheetFooterHeight = 5;

@interface XYActionSheet ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, copy) XYActionSheetBlock selectedBlock;

@end

@implementation XYActionSheet

static XYActionSheet *manager = nil;

+(instancetype)actionSheet
{
    if (manager == nil) {
        manager = [XYActionSheet new];
    }
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc{
}

#pragma mark --- 初始化 UI
- (void)setUpView
{
    [self.bgView addSubview:self.listView];
}

#pragma mark -- Show ActionSheet
- (void)showActionSheetWithTitles:(NSArray *)titles selectedIndexBlock:(XYActionSheetBlock)block
{
    _selectedBlock = block;
    _titles = titles;
    [self setUpView];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
        [k_XYWindow addSubview:self.bgView];
        self.listView.frame = CGRectMake(0, k_XYHeight - (((_titles.count + 1) * kSheetCellHeight) + kSheetFooterHeight), k_XYWidth, ((_titles.count + 1) * kSheetCellHeight) + kSheetFooterHeight);
    }];
}

#pragma mark --- Close ActionSheet
- (void)closeSheet:(UIGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.listView.frame = CGRectMake(0, k_XYHeight, k_XYWidth, ((self.titles.count + 1) * kSheetCellHeight) + kSheetFooterHeight);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        manager = nil;
    }];
}

#pragma mark --- Gesture Delegte
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *actionSheetView = touch.view;
    while ([actionSheetView.superview isKindOfClass:[UIView class]]) {
        if ([actionSheetView isKindOfClass:[UITableViewCell class]] || [actionSheetView isKindOfClass:[UITableView class]]) {
            return NO;
        }
        actionSheetView = actionSheetView.superview;
    }
    return YES;
}

#pragma mark --- TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.titles.count;
    }else {
        return 1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k_XYWidth, kSheetCellHeight)];
        view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return kSheetFooterHeight;
    }
    return 0;
}

#pragma mark ---- cell样式可自定义
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kXYActionSheetCell forIndexPath:indexPath];
    UIView *selectedBackView = [[UIView alloc] init];
    selectedBackView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    cell.selectedBackgroundView = selectedBackView;
    if (indexPath.section == 1) {
        [self setTableViewCell:cell text:@"取消"];
    }else {
        [self setTableViewCell:cell text:_titles[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedBlock) {
        
        [self closeSheet:nil];
        if (indexPath.section == 1) {
            _selectedBlock(_titles.count);
        }else {
            _selectedBlock(indexPath.row);
        }
    }
    
    
}

#pragma mark --- Set TableViewCell
- (void)setTableViewCell:(UITableViewCell *)cell text:(NSString *)text
{
    [cell.textLabel setValue:[UIColor whiteColor] forKey:@"backgroundColor"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = text;
    cell.textLabel.bounds = CGRectMake(0, 0, k_XYWidth, kSheetCellHeight);
}

#pragma mark --- LazyLoad Views
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.frame = CGRectMake(0, 0, k_XYWidth, k_XYHeight);
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSheet:)];
        tap.delegate = self;
        [_bgView addGestureRecognizer:tap];
        
    }
    return _bgView;
}

- (UITableView *)listView
{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, k_XYHeight, k_XYWidth, ((_titles.count + 1) * kSheetCellHeight) + kSheetFooterHeight) style:UITableViewStylePlain];
        _listView.scrollEnabled = NO;
        _listView.rowHeight = kSheetCellHeight;
        if ([_listView respondsToSelector:@selector(setSeparatorInset:)]){
            [_listView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_listView respondsToSelector:@selector(setLayoutMargins:)]){
            [_listView setLayoutMargins:UIEdgeInsetsZero];
        }
        _listView.backgroundColor = [UIColor whiteColor];
        [_listView registerClass:[UITableViewCell class] forCellReuseIdentifier:kXYActionSheetCell];
        _listView.delegate = self;
        _listView.dataSource = self;
    }
    return _listView;
}




@end
