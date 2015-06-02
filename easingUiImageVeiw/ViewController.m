//
//  ViewController.m
//  easingUiImageVeiw
//
//  Created by 藤賀 雄太 on 6/2/15.
//  Copyright (c) 2015 藤賀 雄太. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // UIButtion for easing feature
    easing = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    easing.frame = CGRectMake(0, 0, 100, 100);
    [easing setTitle:@"easing" forState:UIControlStateNormal];
    [easing addTarget:self action:@selector(easing) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:easing];
    
    // UIImageView to ease
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat.jpg"]];
    _imageView.center = self.view.center;
    [self.view addSubview:_imageView];
    
    // debug
    // drawLine
    [self drawLine:CGPointMake(_imageView.layer.position.x, _imageView.layer.position.y) toPoint:CGPointMake(_imageView.layer.position.x, _imageView.frame.origin.y+_imageView.layer.frame.size.height)];
    // draw circle
    [self drawCircle:_imageView.center verticalSize:5 horizontalSize:5];
    [self drawCircle:CGPointMake(100, 100) verticalSize:5 horizontalSize:5];
}

-(void)drawCircle:(CGPoint)centerPoint verticalSize:(float)verticalSize horizontalSize:(float)horizontalSize{
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(centerPoint.x-horizontalSize, centerPoint.y-horizontalSize, verticalSize*2, horizontalSize*2)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.fillColor = [[UIColor redColor] CGColor];
    [self.view.layer addSublayer:shapeLayer];
}


- (void)drawLine:(CGPoint)fromPoint toPoint:(CGPoint)toPoint{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:fromPoint];
    [path addLineToPoint:toPoint];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
    shapeLayer.lineWidth = 1.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.view.layer addSublayer:shapeLayer];
}

- (void)easing{
    NSLog(@"easing: from(%f, %f)", _imageView.frame.origin.x, _imageView.frame.origin.y);
    NSLog(@"easing: from(%f, %f)", _imageView.layer.position.x, _imageView.layer.position.y);
    [self easingImageViewFromOrigin:_imageView movePoint:CGPointMake(100, 100)];
}

- (void)easingImageViewFromOrigin:(UIImageView*)imageView movePoint:(CGPoint)movePoint{
    [self easingImageView:imageView fromPoint:imageView.layer.position toPoint:CGPointMake(movePoint.x, movePoint.y)];
}

- (void)easingImageView:(UIImageView*)imageView fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint{
    CAAnimation *chase = [CAKeyframeAnimation animationWithKeyPath:@"position"
                                                          function:SineEaseIn
                                                         fromPoint:fromPoint
                                                           toPoint:toPoint];
    
    [chase setDelegate:self];
    chase.removedOnCompletion = NO;
    chase.fillMode = kCAFillModeForwards;
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.750] forKey:kCATransactionAnimationDuration];
    [imageView.layer addAnimation:chase forKey:@"easing"];
    [CATransaction commit];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (anim == [_imageView.layer animationForKey:@"easing"]) {
        NSLog(@"easing stopped");
    }
}

static double remap(double value, double inputMin, double inputMax, double outputMin, double outputMax){
    value = constrain(value, inputMin, inputMax);
    return (value - inputMin) * ((outputMax - outputMin) / (inputMax - inputMin)) + outputMin;
}

static double constrain(double value, double inputMin, double inputMax){
    if (value < inputMin) {
        return inputMin;
    }else if (value > inputMax) {
        return inputMax;
    }
    return value;
}

static double remapWidthConstrain(double value, double inputMin, double inputMax, double outputMin, double outputMax){
    value = constrain(value, inputMin, inputMax);
    value = remap(value, inputMin, inputMax, outputMin, outputMax);
    return value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
