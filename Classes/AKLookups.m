//
//  AKLookups.m
//  AKLookups
//
//  Created by Andrey Kadochnikov on 17.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import "AKLookups.h"
#import "NSString+StringSizeWithFont.h"
#import "AKLookupsListViewController.h"

@interface AKLookups ()
{
	NSArray*						_items;
	UIImageView* 					_arrowIndicator; //TODO easy color customization and highlighted state needed
	BOOL 							_isOpened;
	AKDropdownViewController*		_lookupVC;
}
@end

@implementation AKLookups

-(instancetype)initWithLookupViewController:(AKDropdownViewController*)viewController
{
	NSAssert(viewController, @"viewController is mandatory");
	NSAssert([viewController isKindOfClass:[AKDropdownViewController class]], @"viewController must be a subclass of AKDropdownViewController");
	self = [super init];
	if (self){
		_lookupVC = viewController;
		_selectedItem = nil;
		[self addTarget:self action:@selector(pressed) forControlEvents:UIControlEventTouchUpInside];
		
		_arrowIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selector_btn_arrow"]];
		_arrowIndicator.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		_arrowIndicator.contentMode = UIViewContentModeCenter;
		[self addSubview:_arrowIndicator];
		[self selectItem:_selectedItem];
	}
	return self;
}


-(void)pressed
{
	if (!_isOpened){
		[self openLookup];
	} else {
		[self closeLookup];
	}
}

-(void)selectItem:(id<AKLookupsCapableItem>)item
{
	_selectedItem = item;
	[self setTitle:[(id<AKLookupsCapableItem>)item lookupTitle] forState:UIControlStateNormal];
}

-(void)layoutSubviews
{
	[super layoutSubviews];
    
    NSString *title;
    title = [_selectedItem lookupTitle];
    
    CGFloat x = 0;
    static int margin = 25;
    switch (self.arrowPosition) {
        case AKLookupsArrowPositionAfterTitle:
            x = CGRectGetMidX(self.bounds) + [title sizeWithMyFont:self.titleLabel.font].width/2 + 10 + self.titleEdgeInsets.left - self.titleEdgeInsets.right;
            break;
        case AKLookupsArrowPositionRight:
            x = CGRectGetWidth(self.frame) - CGRectGetWidth(_arrowIndicator.frame) - margin;
            break;
        case AKLookupsArrowPositionLeft:
            x = margin;
            break;
        default:
            NSLog(@"unsupported arrow position used");
            break;
    }

    _arrowIndicator.frame = CGRectMake(x,
                                       CGRectGetMidY(self.bounds) - 4 + self.titleEdgeInsets.top/2 - self.titleEdgeInsets.bottom/2,
                                       10,
                                       10);

}

-(void)openLookup
{
	[_lookupVC showDropdownViewBelowView:self];
	[self openAnimation];
}

-(void)openAnimation
{
	CABasicAnimation *openRotationAnimation;
	openRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	openRotationAnimation.fromValue = 0;
	openRotationAnimation.toValue = [NSNumber numberWithFloat:M_PI];
	openRotationAnimation.duration = 0.15f;
	openRotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[openRotationAnimation setRemovedOnCompletion:NO];
	[openRotationAnimation setFillMode:kCAFillModeForwards];
	[_arrowIndicator.layer addAnimation:openRotationAnimation forKey:@"openRotationAnimation"];
	
	_isOpened = !_isOpened;
}

-(void)closeLookup
{
	[_lookupVC dismiss];
	[self closeAnimation];
}

-(void)closeAnimation
{
	CABasicAnimation *closeRotationAnimation;
	closeRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	closeRotationAnimation.fromValue = [NSNumber numberWithFloat:M_PI];
	closeRotationAnimation.toValue = 0;
	closeRotationAnimation.duration = 0.15f;
	closeRotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[closeRotationAnimation setRemovedOnCompletion:NO];
	[closeRotationAnimation setFillMode:kCAFillModeForwards];
	[_arrowIndicator.layer addAnimation:closeRotationAnimation forKey:@"closeRotationAnimation"];
	
	_isOpened = !_isOpened;
}
@end
