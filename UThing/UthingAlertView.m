//
//  ILSMLAlertView.m
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 谢凯伟. All rights reserved.
//

#import "UthingAlertView.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_FONT_SIZE     13
#define DEFAULT_ROW_HEIHGT    30
#define DEFAULT_MAX_HEIGHT    200


static NSMutableDictionary *_selDict;

@interface UthingAlertView ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL _leftLeave;
    UIView *backView;
}

@property (nonatomic, strong) UITableView *tableView;
// data
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation UthingAlertView

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
        });
        
        _selectedIndex = 0;
        
        
        
//        _selectedIndex = 0;
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
        //self.layer.cornerRadius = 8;
        self.layer.masksToBounds = NO;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_tableView];
        
        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(_tableView)]];
        [constraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(_tableView)]];
        [self addConstraints:constraints];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
   
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}


- (void)setSelectedHandle:(PopViewSelectedHandle)handle
{
    _selectedHandle = handle;
}


- (void)showFromView:(UIView *)view animated:(BOOL)animated
{
//    _selectedIndex = 0;
    
    _selectedIndex = [_selections indexOfObject:_currentString];
    
    
    backView = [[UIView alloc] initWithFrame:view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    
    NSLog(@"view = %@", view);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewClick)];
    [backView addGestureRecognizer:tap];
    
    
    [view addSubview:backView];
    
    if (self.visible) {
        [self removeFromSuperview];
    }
    [view addSubview:self];
    [self _setupConstraintsWithSuperView:view];
    [self _showFromView:view animated:animated];
}

- (void)backViewClick
{
    [self hide:YES];
}

- (void)hide:(BOOL)animated
{
    [backView removeFromSuperview];
    
    
    [self _hideWithAnimated:animated];
}

- (BOOL)visible
{
    
    if (self.superview) {
        

        return YES;
    }
    
    return NO;
}



- (void)setSelections:(NSArray *)selections
{
    _selections = selections;
    
    
    [_tableView reloadData];
}

#pragma mark - Private Methods

static CAAnimation* _showAnimation()
{
    CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    transform.values = values;
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacity setFromValue:@0.0];
    [opacity setToValue:@1.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.2;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setAnimations:@[transform, opacity]];
    return group;
}

static CAAnimation* _hideAnimation()
{
    CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    transform.values = values;
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacity setFromValue:@1.0];
    [opacity setToValue:@0.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.2;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setAnimations:@[transform, opacity]];
    return group;
}

- (void)_showFromView:(UIView *)view animated:(BOOL)animated
{

    if (animated) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self.tableView flashScrollIndicators];
        }];
        [self.layer addAnimation:_showAnimation() forKey:nil];
        [CATransaction commit];
    }
}

- (void)_hideWithAnimated:(BOOL)animated
{
    if (animated) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self.layer removeAnimationForKey:@"transform"];
            [self.layer removeAnimationForKey:@"opacity"];
            [self removeFromSuperview];
        }];
        [self.layer addAnimation:_hideAnimation() forKey:nil];
        [CATransaction commit];
    }else {
        [self removeFromSuperview];
    }
}

- (void)_setupConstraintsWithSuperView:(UIView *)view
{
    CGFloat totalHeight = _selections.count * DEFAULT_ROW_HEIHGT;
    CGFloat height = totalHeight > DEFAULT_MAX_HEIGHT ? DEFAULT_MAX_HEIGHT : totalHeight;
    CGFloat width = [[UIScreen mainScreen] bounds].size.width*.8;//[self _preferedWidth];
    //width = width > view.bounds.size.width * 0.9 ? view.bounds.size.width * 0.9 : width;
    CGFloat left = [[UIScreen mainScreen] bounds].size.width*.1; //(point.x + width) > view.bounds.size.width ? (view.bounds.size.width - width - 10) : point.x; //
    CGFloat top = ([[UIScreen mainScreen] bounds].size.height-height)/2;
    CGPoint point = CGPointMake(left, top);
    [self setFrame:CGRectMake(left, top, width, height)];
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[self(==width)]"
                                             options:0
                                             metrics:@{@"left": @(left), @"width": @(width)}
                                               views:NSDictionaryOfVariableBindings(self)]];
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=20-[self]->=10-|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(self)]];
    [constraints setValue:@(UILayoutPriorityRequired) forKeyPath:@"priority"];
    NSLayoutConstraint *hConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0
                                                                    constant:height];
    hConstraint.priority = UILayoutPriorityDefaultHigh;
    [constraints addObject:hConstraint];
    NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:view
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0
                                                                    constant:point.y];
    yConstraint.priority = UILayoutPriorityDefaultHigh;
    [constraints addObject:yConstraint];
    
    [view addConstraints:constraints];
}

- (CGFloat)_preferedWidth
{
    NSPredicate *maxLength = [NSPredicate predicateWithFormat:@"SELF.length == %@.@max.length", _selections];
    NSString *maxString = [_selections filteredArrayUsingPredicate:maxLength][0];
    CGFloat strWidth;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        strWidth = [maxString sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:DEFAULT_FONT_SIZE]}].width;
    }else {
        strWidth = [maxString sizeWithFont:[UIFont systemFontOfSize:DEFAULT_FONT_SIZE]].width;
    }
    return strWidth + 15 * 2 + 50;
}

#pragma mark - UITableview DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SelectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE];
        cell.textLabel.textColor = [UIColor darkTextColor];
        
        CGFloat cellHeight = [self.tableView rectForRowAtIndexPath:indexPath].size.height;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight-1, self.bounds.size.width, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lineView];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorFromHexRGB:@"f1f1f1"];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width-10, 0, 20, 30)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        imageView.center = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
        imageView.tag = 254;
        [view addSubview:imageView];
        cell.accessoryView = view;
        
        
        
        
    }

    if (_selectedIndex == indexPath.row) {
        
        
        UIImageView *cellImageView = (UIImageView *)[cell.accessoryView viewWithTag:254];
        if (DEVICE_IS_IPHONE6P) {
            cellImageView.image = LOADIMAGE(@"椭圆-off", @"png");
        } else {
            cellImageView.image = LOADIMAGE(@"椭圆-on", @"png");
        }
        
    }else {
        
        UIImageView *cellImageView = (UIImageView *)[cell.accessoryView viewWithTag:254];
        
        if (DEVICE_IS_IPHONE6P) {
            cellImageView.image = LOADIMAGE(@"椭圆-on", @"png");
        } else {
            cellImageView.image = LOADIMAGE(@"椭圆-off", @"png");
        }
        
        
    }
    cell.textLabel.text = _selections[indexPath.row];
    return cell;
}

#pragma mark - UITableview Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DEFAULT_ROW_HEIHGT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSLog(@"indexPath.row = %i", indexPath.row);
    
    _selectedIndex = indexPath.row;
    
    
    [UIView animateWithDuration:0.0 delay:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [tableView reloadData];
        
         	} completion:^(BOOL finished) {
                if (_selectedHandle) {
                    
                    _selectedHandle(indexPath.row);
                    
                    [self hide:YES];
                }
 	}];
    

        
    
        

    
    
}



@end


