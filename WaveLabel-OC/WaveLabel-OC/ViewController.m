//
//  ViewController.m
//  WaveLabel-OC
//
//  Created by 杜奎 on 2019/7/24.
//  Copyright © 2019 du. All rights reserved.
//

#import "ViewController.h"

static CGFloat kWaveWidth = 100;

@interface ViewController ()

@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) CAShapeLayer *waveLayer;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *upLabel;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.offset = 0;
    self.speed = 6;
    
    [self.view addSubview:self.bgView];
    
    [self.bgView addSubview:self.label];
    [self.bgView addSubview:self.upLabel];
    
    self.label.center = CGPointMake(self.bgView.frame.size.width * 0.5, self.bgView.frame.size.height * 0.5);
    self.upLabel.center = self.label.center;
    
    [self.bgView.layer insertSublayer:self.waveLayer below:self.label.layer];
    self.upLabel.layer.mask = self.shapeLayer;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(waveAction)];
    [self.displayLink addToRunLoop:NSRunLoop.currentRunLoop forMode:NSRunLoopCommonModes];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.displayLink != nil) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}


- (void)updateWaveWithWidth: (CGFloat)width height: (CGFloat)height {
    CGFloat degree = M_PI/180.0;
    
    CGMutablePathRef wavePath = CGPathCreateMutable();
    CGPathMoveToPoint(wavePath, NULL, 0, height);
    
    CGFloat offsetX = 0;
    while (offsetX < width) {
        CGFloat offsetY = height * 0.5 + 10 * sinf(offsetX * degree + self.offset * degree * self.speed);
        CGPathAddLineToPoint(wavePath, NULL, offsetX, offsetY);
        offsetX += 1.0;
    }
    
    CGPathAddLineToPoint(wavePath, NULL, width, height);
    CGPathAddLineToPoint(wavePath, NULL, 0, height);
    CGPathCloseSubpath(wavePath);
    
    self.waveLayer.path = wavePath;
    self.waveLayer.fillColor = [UIColor.blueColor CGColor];
    self.shapeLayer.path = wavePath;
    
}

- (void)waveAction {
    self.offset += 1;
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    [self updateWaveWithWidth:width height:height];
}

#pragma mark - setter & getter

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (CAShapeLayer *)waveLayer {
    if (!_waveLayer) {
        _waveLayer = [[CAShapeLayer alloc] init];
        _waveLayer.frame = CGRectMake(0, 0, kWaveWidth, kWaveWidth);
    }
    return _waveLayer;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont boldSystemFontOfSize:60];
        _label.textColor = [UIColor blueColor];
        _label.text = @"Wave Label";
        [_label sizeToFit];
    }
    return _label;
}

- (UILabel *)upLabel {
    if (!_upLabel) {
        _upLabel = [[UILabel alloc] init];
        _upLabel.font = [UIFont boldSystemFontOfSize:60];
        _upLabel.textColor = [UIColor whiteColor];
        _upLabel.text = @"Wave Label";
        [_upLabel sizeToFit];
    }
    return _upLabel;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.bounds = self.bgView.bounds;
        _shapeLayer.position = CGPointMake(self.label.bounds.size.width * 0.5, self.label.bounds.size.height * 0.5);
    }
    return _shapeLayer;
}

@end
