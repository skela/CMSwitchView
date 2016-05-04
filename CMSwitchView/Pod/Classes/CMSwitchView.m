//
//  CMSwitchView.m
//
//  Created by Mycose on 31/03/2015.
//  Copyright (c) 2015 Mycose. All rights reserved.
//

#import "CMSwitchView.h"


@interface UIView (CMSwitchView)
- (CGFloat)width;
- (CGFloat)semiWidth;
- (CGFloat)height;
- (CGFloat)semiHeight;
@end

@implementation UIView (CMSwitchView)
- (CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

- (CGFloat)semiWidth
{
    return floorf(CGRectGetWidth(self.frame)/2.0f);
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

- (CGFloat)semiHeight
{
    return floorf(CGRectGetHeight(self.frame)/2.0f);
}
@end

@interface CMSwitchView()
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIView* switchView;
@property (nonatomic, strong) UIView* dotView;
@end

@implementation CMSwitchView

#pragma mark - properties

- (void)setRounded:(BOOL)rounded
{
    _rounded = rounded;
    if (_rounded == YES) {
        [_dotView.layer setCornerRadius:_dotWeight/2];
        _switchView.layer.cornerRadius = [self semiHeight];
        
    } else {
        [_dotView.layer setCornerRadius:0.0f];
        _switchView.layer.cornerRadius = 0.0f;
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    _switchView.layer.borderWidth = _borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    _switchView.layer.borderColor = _borderColor.CGColor;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    _switchView.backgroundColor = _color;
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
}

- (void)setDotWeight:(CGFloat)dotWeight
{
    _dotWeight = dotWeight;
    [_dotView.layer setCornerRadius:_dotWeight/2];
    _switchView.layer.cornerRadius = [self semiHeight];
    [_dotView setFrame:CGRectMake(_dotView.frame.origin.x, _dotView.frame.origin.y, _dotWeight, _dotWeight)];
    [_dotView setFrame:CGRectMake([self semiHeight]-_dotWeight/2, [self semiHeight]-_dotWeight/2, _dotWeight, _dotWeight)];
}

- (void)setDotColor:(UIColor *)dotColor
{
    _dotColor = dotColor;
    _dotView.backgroundColor = _dotColor;
}

- (void)setDotBorderWidth:(CGFloat)dotBorderWidth
{
    _dotBorderWidth = dotBorderWidth;
    _dotView.layer.borderWidth = dotBorderWidth;
}

- (void)setDotBorderColor:(UIColor *)dotBorderColor
{
    _dotBorderColor = dotBorderColor;
    _dotView.layer.borderColor = dotBorderColor.CGColor;
}

- (BOOL)on
{
    return _isSelected;
}

- (void)setOn:(BOOL)on
{
    [self setOn:on animated:NO];
}

#pragma mark - LifeCycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _switchView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [self width], [self height])];
    [self addSubview:_switchView];
    
    _dotView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _dotWeight, _dotWeight)];
    [_dotView setBackgroundColor:self.dotColor];
    [_switchView addSubview:self.dotView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDetected:)];
    [_switchView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    pan.delegate = self;
    [_switchView addGestureRecognizer:pan];
    
    self.rounded                = YES;
    self.borderWidth            = 1.f;
    self.borderColor            = [UIColor whiteColor];
    self.color                  = [UIColor clearColor];
    self.tintColor              = [UIColor clearColor];
    self.dotWeight              = self.frame.size.height - 10.f;
    self.dotColor               = [UIColor whiteColor];
    self.dotBorderWidth         = .0f;
    self.dotBorderColor         = [UIColor clearColor];
    self.animDuration           = 0.6;
    self.selectedBorderColor    = self.borderColor;
    self.selectedDotColor       = self.dotColor;
    self.selectedDotBorderColor = self.dotBorderColor;
    
    UIColor *disabled = [UIColor lightGrayColor];
    self.disabledBackgroundColor = disabled;
    self.disabledBorderColor    = disabled;
    self.disabledDotColor       = disabled;
    self.disabledDotBorderColor = disabled;
    
    self.layer.masksToBounds    = NO;
}

- (void)changedValue
{
    if (self.delegate)
        [self.delegate switchValueChanged:self andNewValue:self.isSelected];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Gesture

- (void)panGestureDetected:(UIPanGestureRecognizer*)panGesture
{
    CGPoint translation = [panGesture translationInView:self.switchView];
    
    if (((CGRectGetMidX(self.dotView.frame) + translation.x) >= [self semiHeight]) &&
        ((CGRectGetMidX(self.dotView.frame) + translation.x) <= [self width] - [self semiHeight]))
        [self.dotView setFrame:CGRectMake(self.dotView.frame.origin.x + translation.x, self.dotView.frame.origin.y, self.dotView.frame.size.width, [self.dotView height])];
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        
        if ((self.isSelected == NO && (CGRectGetMidX(self.dotView.frame) > [self semiWidth])) ||
            (self.isSelected == YES && (CGRectGetMidX(self.dotView.frame) < [self semiWidth]))) {
            self.isSelected = !self.isSelected;
            [self changedValue];
        }
        
        if (self.isSelected == NO && (CGRectGetMidX(self.dotView.frame) > [self semiWidth])) {
            [self switchClicked];
        } else if (self.isSelected == NO && (CGRectGetMidX(self.dotView.frame) < [self semiWidth])) {
            [self reloadColors:NO animated:YES];
        } else if (self.isSelected == YES && (CGRectGetMidX(self.dotView.frame) < [self semiWidth])) {
            [self switchClicked];
        } else if (self.isSelected == YES && (CGRectGetMidX(self.dotView.frame) > [self semiWidth])) {
            [self reloadColors:YES animated:YES];
        }
    }
    
    [panGesture setTranslation:CGPointZero inView:self.switchView];
}

- (void)tapGestureDetected:(UITapGestureRecognizer *)tapGesture {
    BOOL prev = self.isSelected;
    [self switchClicked];
    if (prev != self.isSelected)
        [self changedValue];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.touchesBeganBlock) {
        self.touchesBeganBlock(self.switchView, self.dotView);
    }
}

#pragma mark - Action

- (void)switchClicked
{
    if (self.isSelected == YES)
    {
        self.isSelected = NO;
        [self reloadColors:NO animated:YES];
    }
    else if(self.isSelected == NO)
    {
        self.isSelected = YES;
        [self reloadColors:YES animated:YES];
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    [self reloadColors:self.selected animated:NO];
}

- (void)reloadColors:(BOOL)selected animated:(BOOL)animated
{
    if (!selected)
    {
        if (self.willDeselectBlock)
        {
            self.willDeselectBlock(self.switchView, self.dotView);
        }
        [UIView animateWithDuration:animated?self.animDuration:0 animations:^
        {
            [self.dotView setFrame:CGRectMake([self semiHeight]-[self.dotView semiWidth], self.dotView.frame.origin.y, self.dotView.frame.size.width, [self.dotView height])];
            self.switchView.backgroundColor   = self.color;
            self.switchView.layer.borderColor = self.enabled ? self.borderColor.CGColor : self.disabledBorderColor.CGColor;
            self.dotView.backgroundColor      = self.enabled ? self.dotColor : self.disabledDotColor;
            self.dotView.layer.borderColor    = self.enabled ? self.dotBorderColor.CGColor : self.disabledDotBorderColor.CGColor;
        }];
    }
    else
    {
        if (self.willSelectBlock)
        {
            self.willSelectBlock(self.switchView, self.dotView);
        }
        [UIView animateWithDuration:animated?self.animDuration:0 animations:^
        {
            [self.dotView setFrame:CGRectMake([self width]-[self semiHeight]-[self.dotView semiWidth], self.dotView.frame.origin.y, self.dotView.frame.size.width, [self.dotView height])];
            self.switchView.backgroundColor   = self.enabled ? self.tintColor : self.disabledBackgroundColor;
            self.switchView.layer.borderColor = self.enabled ? self.selectedBorderColor.CGColor : self.disabledBorderColor.CGColor;
            self.dotView.backgroundColor      = self.selectedDotColor;
            self.dotView.layer.borderColor    = self.selectedDotBorderColor.CGColor;
        }];
    }
}

- (void)setOn:(BOOL)boolean animated:(BOOL)animated
{
    if (boolean != self.isSelected)
    {
        self.isSelected = boolean;
        [self reloadColors:boolean animated:animated];
    }
}

@end
