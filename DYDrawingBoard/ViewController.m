//
//  ViewController.m
//  DYDrawingBoard
//
//  Created by 田向阳 on 2017/12/21.
//  Copyright © 2017年 田向阳. All rights reserved.
//

#import "ViewController.h"

#import "DYDrawingBoard.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"123"];
    
    DYDrawingBoard *board = [[DYDrawingBoard alloc] initWithFrame:[self scaleImageFrame:image]];
    board.tag = 100;
    board.sourceImage = image;
    board.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:board];
}

- (CGRect)scaleImageFrame:(UIImage *)image
{
    if(!image){
        return CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 400);
    }
    CGSize imageSize = image.size;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat x = 0.0,y = 0.0,width = 0.0,height = 0.0;
    CGFloat imageScale = imageSize.width/imageSize.height;
    CGFloat screenScale = screenSize.width/screenSize.height;
    if (imageScale > screenScale) {
        width = screenSize.width;
        height = width / imageScale;
        y = (screenSize.height - height) / 2;
    }else{
        height = screenSize.height;
        width = height * imageScale;
        x = (screenSize.width - width) / 2;
    }
    return CGRectMake(x, y, width, height);
}

- (IBAction)clear:(id)sender {
    DYDrawingBoard *board = [self.view viewWithTag:100];
    [board clear];
}

- (IBAction)save:(id)sender {
    DYDrawingBoard *board = [self.view viewWithTag:100];
    [board saveImageToAlbum];
}
- (IBAction)back:(id)sender {
    DYDrawingBoard *board = [self.view viewWithTag:100];
    [board goBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
