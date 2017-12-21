//
//  DYDrawingBoard.m
//  DYDrawingBoard
//
//  Created by 田向阳 on 2017/12/21.
//  Copyright © 2017年 田向阳. All rights reserved.
//

#import "DYDrawingBoard.h"

@interface DYDrawingBoard ()

@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, strong) UIBezierPath *drawingPath;
@property (nonatomic, strong) NSMutableArray *history;

@end

@implementation DYDrawingBoard

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.lineColor = [UIColor redColor];
        self.lineWidth = 5;
    }
    return self;
}

#pragma mark - Action
- (void)setSourceImage:(UIImage *)sourceImage
{
    if (sourceImage) {
        _sourceImage = sourceImage;
        [self.history addObject:sourceImage];
        [self setNeedsDisplay];
    }
}
- (void)clear
{
    [self.history removeAllObjects];
    if (self.sourceImage) {
        [self.history addObject:self.sourceImage];
    }
    [self setNeedsDisplay];
}

- (void)saveImageToAlbum
{
    UIImageWriteToSavedPhotosAlbum([self getImage], nil, nil, nil);
}

- (void)goBack
{
    if (self.history.count <= 1) {
        return;
    }
    [self.history removeLastObject];
    [self setNeedsDisplay];
}

#pragma mark - touchEvent
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint startPoint = [touch locationInView:self];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    self.drawingPath = path;
    self.drawingPath.lineWidth = self.lineWidth;
    self.drawingPath.lineCapStyle = kCGLineCapRound;
    self.drawingPath.lineJoinStyle = kCGLineJoinBevel;
    [self.history addObject:path];
    self.currentPoint = startPoint;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.drawingPath) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint midPoint = midpoint(self.currentPoint, currentPoint);
    [self.drawingPath addQuadCurveToPoint:midPoint controlPoint:self.currentPoint];
    [self setNeedsDisplay];
    self.currentPoint = currentPoint;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.drawingPath = nil;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.drawingPath = nil;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    for (id obj in self.history) {
        if ([obj isKindOfClass:[UIImage class]]) {
            [(UIImage *)obj drawInRect:rect];
        }else{
            UIBezierPath *path = (UIBezierPath *)obj;
            [self.lineColor set];
            [path stroke];
        }
    }
}

#pragma mark- Lazy
- (NSMutableArray *)history
{
    if (!_history) {
        _history = [NSMutableArray arrayWithCapacity:0];
    }
    return _history;
}

#pragma mark - Helper
- (UIImage *)getImage
{
        //UIGraphicsBeginImageContext(theView.bounds.size);
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, self.layer.contentsScale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

static CGPoint midpoint(CGPoint p0, CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}
@end
