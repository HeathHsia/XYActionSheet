//
//  ViewController.m
//  XYActionSheetOCDemo
//
//  Created by FireHsia on 2017/9/7.
//  Copyright © 2017年 FireHsia. All rights reserved.
//

#import "ViewController.h"
#import "XYActionSheet.h"
#import "SubViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)XY_ActionSheet:(id)sender {
    NSArray *titles = @[@"拍摄", @"从手机相册选择"];
    [[XYActionSheet actionSheet] showActionSheetWithTitles:titles selectedIndexBlock:^(NSInteger index) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        SubViewController *subVC = [board instantiateViewControllerWithIdentifier:@"SubViewController"];
        subVC.view.backgroundColor = [UIColor whiteColor];
        NSLog(@"点击的index ---- %ld", index);
        if (titles.count > index) {
            subVC.title = titles[index];
            subVC.dismissButton.hidden = YES;
            [self.navigationController pushViewController:subVC animated:YES];
        }else {
            // index == title.count 为取消操作
            subVC.dismissButton.hidden = NO;
            [self presentViewController:subVC animated:YES completion:nil];
        }
    }];

}


@end
