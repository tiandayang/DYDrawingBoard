//
//  DYDrawingBoard.h
//  DYDrawingBoard
//
//  Created by 田向阳 on 2017/12/21.
//  Copyright © 2017年 田向阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYDrawingBoard : UIView

@property (nonatomic, strong) UIImage *sourceImage;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;

- (void)clear;
- (void)goBack;
- (void)saveImageToAlbum;

@end
