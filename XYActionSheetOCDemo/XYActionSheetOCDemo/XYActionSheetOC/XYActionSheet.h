//
//  XYActionSheet.h
//  XYActionSheet
//
//  Created by FireHsia on 2017/8/31.
//  Copyright © 2017年 FireHsia. All rights reserved.
//  Github: https://github.com/FireHsia
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^XYActionSheetBlock)(NSInteger index);

@interface XYActionSheet : NSObject

+(instancetype)actionSheet;

- (void)showActionSheetWithTitles:(NSArray *)titles selectedIndexBlock:(XYActionSheetBlock)block;

@end
