//
//  AKDropdownViewController.m
//  AKCalendarViewExample
//
//  Created by Andrey Kadochnikov on 03.06.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import "AKDropdownViewController.h"
#define MT_COLOR(R, G, B, A) \
[UIColor colorWithRed:(R)/(255.0) green:(G)/(255.0) blue:(B)/(255.0) alpha:(A)]

@interface AKDropdownViewController ()
{
	UIView *_dimmingOverlayView;
	UIView *_maskingView;
	UITapGestureRecognizer * _tap;
	UIViewController *_containerViewController;
}
@end

@implementation AKDropdownViewController

-(instancetype)initWithParentViewController:(UIViewController*)parentVC
{
	if (self = [super initWithNibName:nil bundle:nil]){
		_containerViewController = parentVC;
	}
	return self;
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	[self.view addSubview:self.maskingView];
	[self.maskingView addSubview:self.contentView];
	self.view.clipsToBounds = YES;
}

-(UIView*)contentView
{
	if (!_contentView){
		_contentView = [[UIView alloc] initWithFrame:self.maskingView.bounds];
		_contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_contentView.backgroundColor = [UIColor clearColor];
	}
	return _contentView;
}

-(UIView*)maskingView
{
	if (!_maskingView){
		_maskingView = [[UIView alloc] initWithFrame:self.view.bounds];
		_maskingView.clipsToBounds = YES;
		_maskingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
	}
	return _maskingView;
}

-(void)setupBackground
{
	
	if (!_dimmingOverlayView){
		_dimmingOverlayView = [[UIView alloc] initWithFrame: self.view.bounds ];
		_dimmingOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_dimmingOverlayView.backgroundColor = MT_COLOR(0, 0, 0, 0.3f);
		_dimmingOverlayView.alpha = 0;
		_dimmingOverlayView.userInteractionEnabled = YES;
		
		[self.view insertSubview:_dimmingOverlayView belowSubview:self.maskingView];
		
		_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(outsideZoneTapped:)];
		_tap.cancelsTouchesInView = NO;
		_tap.numberOfTapsRequired = 1;
		[_dimmingOverlayView addGestureRecognizer:_tap];
	}
}

-(void)showDropdownViewBelowView:(UIView*)view
{
	NSAssert(_containerViewController, @"containerViewController can not be nil. Use designated initializer `initWithParentViewController:` with correct parameter");
	self.view.alpha = 1;
	
	UIView *rootView = _containerViewController.view;
	self.view.frame = rootView.bounds;
	
	CGRect viewFrame = view.frame;
	
	CGRect onScreenContentViewFrame = CGRectZero;
	onScreenContentViewFrame.origin.x = CGRectGetMinX(viewFrame);
	onScreenContentViewFrame.origin.y = CGRectGetMaxY(viewFrame);
	onScreenContentViewFrame.size.width = view.frame.size.width;
	onScreenContentViewFrame.size.height = MIN([self contentHeight], [self spaceBelowPoint:onScreenContentViewFrame.origin]);

	self.maskingView.frame = onScreenContentViewFrame;
	
	CGRect offScreenContentViewFrame = CGRectOffset(self.maskingView.bounds, 0, -onScreenContentViewFrame.size.height);

	_contentView.frame = offScreenContentViewFrame;
	
	[_containerViewController addChildViewController:self];
	[self didMoveToParentViewController:_containerViewController];
	if ([_containerViewController shouldAutomaticallyForwardAppearanceMethods] == NO){
		[self viewWillAppear:YES];
	}
	if (view){
		[rootView insertSubview: self.view belowSubview:view];
	} else {
		[rootView addSubview: self.view];
	}
	[self setupBackground];
	
    if ([_delegate respondsToSelector:@selector(lookupsWillOpen:)]){
        [_delegate lookupsWillOpen:self];
    }
    
	[UIView animateWithDuration:0.3f animations:^{
		_dimmingOverlayView.alpha = 1.0f;
	}];
	
	[UIView animateWithDuration:0.4f
						  delay:0
		 usingSpringWithDamping:1
		  initialSpringVelocity:0
						options:UIViewAnimationOptionCurveEaseInOut animations:
	^{
		_contentView.frame = _maskingView.bounds;
		[self contentViewAppearingAction];
		
	} completion:^(BOOL finished) {
		
		[self contentViewAppearedAction];
		if ([_containerViewController shouldAutomaticallyForwardAppearanceMethods] == NO){
			[self viewDidAppear:YES];
		}
		if ([_delegate respondsToSelector:@selector(lookupsDidOpen:)]){
			[_delegate lookupsDidOpen:self];
		}
	}];
}

-(BOOL)isContentFits
{
	return [self spaceBelowPoint:_maskingView.frame.origin] > [self contentHeight];
}

-(CGFloat)contentHeight
{
	return 320;
}

-(void)contentViewAppearingAction
{
	
}

-(void)contentViewAppearedAction
{
	
}

-(CGFloat)spaceBelowPoint:(CGPoint)point
{
	UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
	UIView *rootView = rootVC.view;

	CGPoint adjustedPoint = [rootView convertPoint:point fromView:nil];
	CGFloat spaceBelow = (CGRectGetMaxY(rootView.bounds) -  adjustedPoint.y - _bottomMargin);
	return spaceBelow;
}

-(void)dismiss
{
	if ([_delegate respondsToSelector:@selector(lookupsWillClose:)]){
		[_delegate lookupsWillClose:self];
	}
	[UIView animateWithDuration:0.15f animations:^{
		self.view.alpha = 0;
		_dimmingOverlayView.alpha = 0;
	} completion:^(BOOL finished) {
		
		[_dimmingOverlayView removeGestureRecognizer:_tap];
		_tap = nil;
		
		[_dimmingOverlayView removeFromSuperview];
		_dimmingOverlayView = nil;
		
		[self.view removeFromSuperview];
		[self willMoveToParentViewController:nil];
		[self removeFromParentViewController];
		if ([_delegate respondsToSelector:@selector(lookupsDidClose:)]){
			[_delegate lookupsDidClose:self];
		}
	}];
}

- (void)closeCancel
{
	[self dismiss];
	if ([self.delegate respondsToSelector:@selector(lookupsDidCancel:)]){
		[self.delegate lookupsDidCancel:self];
	}
}

-(void)outsideZoneTapped:(UITapGestureRecognizer*)tapRecognizer
{
    CGPoint tapPoint = [tapRecognizer locationInView:_maskingView];
    UIView * clickedView = [_maskingView hitTest:tapPoint withEvent:nil];
    if(!clickedView)
    {
		[self closeCancel];
    }
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}
@end
