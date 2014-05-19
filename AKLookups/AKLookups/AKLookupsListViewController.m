//
//  AKLookupsListViewController.m
//  AKLookups
//
//  Created by Andrey Kadochnikov on 17.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import "AKLookupsListViewController.h"
#define PERFECT_CELL_HEIGHT 44.0f
#define MT_COLOR(R, G, B, A) \
[UIColor colorWithRed:(R)/(255.0) green:(G)/(255.0) blue:(B)/(255.0) alpha:(A)]


@interface AKLookupsListViewController ()
{
	UITableView *_tableView;
	UIView *_dimmingOverlayView;
	UITapGestureRecognizer * _tap;
	__weak AKLookups *_lookupsButton;
}
@end

@implementation AKLookupsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
	_tableView.scrollEnabled = NO;
	_tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_tableView];
	self.view.clipsToBounds = YES;
}

-(void)setupBackground
{
	if (!_dimmingOverlayView){
		UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
		_dimmingOverlayView = [[UIView alloc] initWithFrame: rootVC.view.bounds ];
		_dimmingOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_dimmingOverlayView.backgroundColor = MT_COLOR(0, 0, 0, 0.5f);
		_dimmingOverlayView.alpha = 0;
		_dimmingOverlayView.userInteractionEnabled = YES;
		
		_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(outsideZoneTapped:)];
		_tap.cancelsTouchesInView = NO;
		_tap.numberOfTapsRequired = 1;
		
		UIView *rootView = rootVC.view;
		[rootView insertSubview:_dimmingOverlayView belowSubview:_lookupsButton];
		
		[_dimmingOverlayView addGestureRecognizer:_tap];
	}
}

-(void)showListFromLookupsButton:(AKLookups*)lookupsButton
{
	_items = [lookupsButton.dataSource lookupsItems];
	_selectedItemIdx = lookupsButton.selectedItemIdx;
	_lookupsButton = lookupsButton;
	[self setupBackground];
	
	UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
	[rootVC addChildViewController:self];
	[self didMoveToParentViewController:rootVC];
	
	UIView *rootView = rootVC.view;
	CGRect buttonFrame = lookupsButton.frame;
	CGRect adjustedRect = [rootView convertRect:buttonFrame fromView:lookupsButton.superview];
	CGRect onScreenFrame;
	
	onScreenFrame = ({CGRect newFrame = self.view.frame; newFrame.origin.x = CGRectGetMinX(adjustedRect); newFrame.origin.y = CGRectGetMaxY(adjustedRect); newFrame.size.width = CGRectGetWidth(buttonFrame); newFrame;});
	onScreenFrame = [self adjustFrameToContent:onScreenFrame];
	self.view.frame = onScreenFrame;
	CGRect offScreenTableViewFrame = CGRectOffset(self.view.bounds, 0, -onScreenFrame.size.height);
	_tableView.frame = offScreenTableViewFrame;
	
	[rootView addSubview:self.view];
	
	[UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		_tableView.frame = self.view.bounds;
		_dimmingOverlayView.alpha = 1;
		[_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedItemIdx inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
	} completion:^(BOOL finished) {
		_tableView.scrollEnabled = ![self isContentFits];
		[_tableView flashScrollIndicators];
	}];
}

-(BOOL)isContentFits
{
	return [self spaceBelow] > [self lookupsListHeight];
	
}

-(CGRect)adjustFrameToContent:(CGRect)frame
{
	frame.size.height = MIN([self lookupsListHeight], [self spaceBelow]);
	return frame;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"lookupslistcell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if(indexPath.row == _selectedItemIdx) {
        _selectedItemIdx = indexPath.row;
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
	cell.textLabel.text = [_items[indexPath.row]  lookupTitle];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f; // dirty workaround
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[_lookupsButton selectItemAtIndex:indexPath.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return PERFECT_CELL_HEIGHT;
}

-(CGFloat)spaceBelow
{
	CGRect buttonFrame = _lookupsButton.frame;
	UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
	UIView *rootView = rootVC.view;
	CGRect adjustedRect = [rootView convertRect:buttonFrame fromView:_lookupsButton.superview];
	return (CGRectGetMaxY(rootView.bounds) -  CGRectGetMaxY(adjustedRect) - _bottomMargin);
}

-(CGFloat)lookupsListHeight
{
	return self.items.count * PERFECT_CELL_HEIGHT;
}

-(void)outsideZoneTapped:(UITapGestureRecognizer*)tapRecognizer
{
    CGPoint tapPoint = [tapRecognizer locationInView:self.view];
    UIView * clickedView = [self.view hitTest:tapPoint withEvent:nil];
    if(!clickedView)
    {
        [_lookupsButton closeLookup];
    }
}

-(void)dismiss
{
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
	}];
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
