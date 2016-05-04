//
//  CMSwitchView.h
//
//  Created by Mycose on 31/03/2015.
//  Copyright (c) 2015 Mycose. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CMSwitchViewBlock)(UIView *switchView, UIView *dotView);

@protocol CMSwitchViewDelegate <NSObject>
/// Called when the switch view is clicked or when you move the dot after the middle with the pan gesture
- (void)switchValueChanged:(id)sender andNewValue:(BOOL)value;

@end

@interface CMSwitchView : UIControl<UIGestureRecognizerDelegate>

/// If you want to have rounded dots and switch view or not, YES by default
@property (nonatomic, assign) BOOL rounded;

/// Information about selection
@property (nonatomic, readwrite) BOOL on;

/// Width of the border, 1 by default
@property (nonatomic, assign) CGFloat borderWidth;

/// color of the border, white by default
@property (nonatomic, strong) UIColor* borderColor;

/// color of the background of the switch view, clearColor by default
@property (nonatomic, strong) UIColor* color;

/// width and height of the dot, frameHeight-2 by default
@property (nonatomic, assign) CGFloat dotWeight;

/// color of the dot, white by default
@property (nonatomic, strong) UIColor* dotColor;

/// Width of the dot's border, 0 by default
@property (nonatomic, assign) CGFloat dotBorderWidth;

/// Color of the dot's border, clear by default
@property (nonatomic, strong) UIColor* dotBorderColor;

/// duration of the animation, 0.6 by default
@property (nonatomic, assign) NSTimeInterval animDuration;

/// color of the background of the switch view when switched, clearColor by default
@property (nonatomic, strong) UIColor* tintColor;

/// color of the dot's background when switch is selected. Default is the same jak dotColor property
@property (nonatomic, strong) UIColor* selectedDotColor;

/// color of the dot's border color when switch is selected.Default is the same jak dotBorderColor property
@property (nonatomic, strong) UIColor* selectedDotBorderColor;

/// color of the border when switch is selected. Default is the same liek borderColor.
@property (nonatomic, strong) UIColor* selectedBorderColor;

/// color of the switch background when the switch is disabled. Default is [UIColor lightGrayColor]
@property (nonatomic, strong) UIColor* disabledBackgroundColor;

/// color of the dot's background when the switch is disabled. Default is [UIColor lightGrayColor]
@property (nonatomic, strong) UIColor* disabledDotColor;

/// color of the dot's border color when the switch is disabled. Default is [UIColor lightGrayColor]
@property (nonatomic, strong) UIColor* disabledDotBorderColor;

/// color of the border when the switch is disabled.  Default is [UIColor lightGrayColor]
@property (nonatomic, strong) UIColor* disabledBorderColor;


@property (strong, nonatomic) CMSwitchViewBlock willSelectBlock;
@property (strong, nonatomic) CMSwitchViewBlock willDeselectBlock;
@property (strong, nonatomic) CMSwitchViewBlock touchesBeganBlock;

/// delegate to be set
@property (nonatomic, weak) id <CMSwitchViewDelegate> delegate;

/// set the switch YES or NO, with animation or not
- (void)setOn:(BOOL)boolean animated:(BOOL)animated;

- (id)initWithFrame:(CGRect)frame;

@end
