//
//  PriceSectionView.m
//  UThing
//
//  Created by Apple on 15/1/15.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import "PriceSectionView.h"


@interface PriceSectionView ()

@property (nonatomic) NSInteger maxNum;  //最大价格
@property (nonatomic) NSInteger minNum;  //最小价格

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *preView; //可滑动变化view
@property (nonatomic, strong) UIView *oneSlider;
@property (nonatomic, strong) UIView *otherSlider;
@property (nonatomic, strong) UILabel *oneLabel;
@property (nonatomic, strong) UILabel *otherLabel;

@end

@implementation PriceSectionView


- (instancetype)initWithFrame:(CGRect)frame maxNum:(NSInteger)max minNum:(NSInteger)min
{
    if (self = [super initWithFrame:frame]) {
        
        _minNum = min;
        _maxNum = max;
        self.userInteractionEnabled = YES;
        self.layer.cornerRadius = self.height/2;
        
        [self initView];
    };
    return self;
};


- (void)initView
{
    
    _backView = [self viewWihtFrame:CGRectMake(10, 0, self.width-20, 10) conerRadius:5 bgColor:[UIColor lightGrayColor]];
    [self addSubview:_backView];
    
    
    _preView = [self viewWihtFrame:CGRectMake(10, 0, self.width-20, 10) conerRadius:5 bgColor:[UIColor colorFromHexRGB:@"FF9900"]];
    [self addSubview:_preView];
    
    
    _oneSlider = [self viewWihtFrame:CGRectMake(0, 0, 20, 20) conerRadius:10 bgColor:[UIColor colorFromHexRGB:@"FF9900"]];
    _oneSlider.center = CGPointMake(10, _preView.center.y);
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.minimumNumberOfTouches = 0.5;
    [_oneSlider addGestureRecognizer:pan];
    [self addSubview:_oneSlider];

    
    _oneLabel = [[UILabel alloc] init];
    _oneLabel.font = [UIFont boldSystemFontOfSize:12];
    _oneLabel.textColor = [UIColor lightGrayColor];
    _oneLabel.text = [@(_minNum) stringValue];
    [_oneLabel sizeToFit];
    _oneLabel.center = CGPointMake(10, _preView.center.y-30);
    [self addSubview:_oneLabel];
    
    _otherLabel = [[UILabel alloc] init];
    _otherLabel.font = [UIFont boldSystemFontOfSize:12];
    _otherLabel.textColor = [UIColor lightGrayColor];
    _otherLabel.text = [@(_maxNum) stringValue];
    [_otherLabel sizeToFit];
    _otherLabel.center = CGPointMake(self.width-10, _preView.center.y-30);
    [_otherLabel sizeToFit];
    [self addSubview:_otherLabel];
    
    
    _otherSlider = [self viewWihtFrame:CGRectMake(0, 0, 20, 20) conerRadius:10 bgColor:[UIColor colorFromHexRGB:@"FF9900"]];
    _otherSlider.center = CGPointMake(_backView.right, _preView.center.y);
    UIPanGestureRecognizer *pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [_otherSlider addGestureRecognizer:pan2];
    
    [self addSubview:_otherSlider];
    
}


#pragma mark -
#pragma mark -Action
/**
 *  拖动手势事件
 *
 *  @param pan
 */
- (void)panAction:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self];
    
    CGFloat pointPan = point.x+pan.view.center.x;
    
    if (pointPan < 10) {
        pointPan = 10;
    }
    if (pointPan > self.width-10) {
        pointPan = self.width-10;
    }
    
    pan.view.center = CGPointMake(pointPan, pan.view.center.y);
    
    CGRect frame = _preView.frame;
    
    if (_oneSlider == pan.view) {
        
        
        
        if (pan.view.center.x < _otherSlider.center.x) {
            frame.origin.x = pan.view.center.x;
            frame.size.width = _otherSlider.center.x - pan.view.center.x;
        } else {
            frame.origin.x = _otherSlider.center.x;
            frame.size.width = pan.view.center.x - _otherSlider.center.x;
        }
        
        _preView.frame = frame;
        
        
        _oneLabel.text = [@((int)(_minNum+((pointPan-10)/(self.width-20))*(_maxNum-_minNum))) stringValue];
        [_oneLabel sizeToFit];
        _oneLabel.center = CGPointMake(pointPan, _oneLabel.center.y);
        
        [pan setTranslation:CGPointZero inView:self];
    } else {
        
        
        if (pan.view.center.x < _oneSlider.center.x) {
            frame.origin.x = pan.view.center.x;
            frame.size.width = _oneSlider.center.x - pan.view.center.x;
        } else {
            frame.origin.x = _oneSlider.center.x;
            frame.size.width = pan.view.center.x - _oneSlider.center.x;
        }
        
        _preView.frame = frame;
        
        _otherLabel.text = [@((int)(_minNum+((pointPan-10)/(self.width-20))*(_maxNum-_minNum))) stringValue];
        [_otherLabel sizeToFit];
        _otherLabel.center = CGPointMake(pointPan, _otherLabel.center.y);
        
        [pan setTranslation:CGPointZero inView:self];
    }

    
    if ([_oneLabel.text intValue] > [_otherLabel.text intValue]) {
        self.currentMin = [_otherLabel.text intValue];
        self.currentMax = [_oneLabel.text intValue];
    } else {
        self.currentMin = [_oneLabel.text intValue];
        self.currentMax = [_otherLabel.text intValue];
    }
    
    
}



#pragma mark -
#pragma mark -private method

- (UIView *)viewWihtFrame:(CGRect)frame conerRadius:(CGFloat)radius bgColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    view.userInteractionEnabled = YES;
    view.layer.cornerRadius = radius;
    view.backgroundColor = color;
    return view;
}

@end
