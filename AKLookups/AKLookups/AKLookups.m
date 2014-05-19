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
	AKLookupsListViewController* 	_list;
}
@end

@implementation AKLookups

-(instancetype)initWithDelegate:(id<AKLookupsDelegate>)delegate datasource:(id<AKLookupsDatasource>)datasource{
	NSAssert(delegate && datasource, @"delegate and datasource are mandatory");
	self = [super init];
	if (self){
		_delegate = delegate;
		_dataSource = datasource;
		_items = [datasource lookupsItems];
		_selectedItemIdx = 0;
		[self addTarget:self action:@selector(pressed) forControlEvents:UIControlEventTouchUpInside];

		_arrowIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selector_btn_arrow"]];
		_arrowIndicator.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		_arrowIndicator.contentMode = UIViewContentModeCenter;
		[self addSubview:_arrowIndicator];
		[self selectItemAtIndex:_selectedItemIdx];
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

-(void)selectItemAtIndex:(NSUInteger)index
{
	_selectedItemIdx = index;
	[self setTitle:[(id<AKLookupsCapableItem>)_items[index] lookupTitle] forState:UIControlStateNormal];
	if ([self.delegate respondsToSelector:@selector(lookups:didSelectItemAtIndex:)]){
		[self.delegate lookups:self didSelectItemAtIndex:index];
	}
	
	if (_isOpened){
		[self closeLookup];
	}
	
	[self setNeedsLayout];
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	NSString *title = [(id<AKLookupsCapableItem>)_items[_selectedItemIdx] lookupTitle];
	CGFloat x = CGRectGetMidX(self.bounds) + [title sizeWithMyFont:self.titleLabel.font].width/2;
	_arrowIndicator.frame = CGRectMake(x + 10 + self.titleEdgeInsets.left - self.titleEdgeInsets.right,
									   CGRectGetMidY(self.bounds) - 3 + self.titleEdgeInsets.top/2 - self.titleEdgeInsets.bottom/2,
									   10,
									   10);

}

-(void)openLookup
{
	if ([_delegate respondsToSelector:@selector(lookupsWillOpen:)]){
		[_delegate lookupsWillOpen:self];
	}
	
	_list = [AKLookupsListViewController new];
	_list.bottomMargin = _bottomMargin;
	[_list showListFromLookupsButton:self];
	
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
	
	if ([_delegate respondsToSelector:@selector(lookupsDidOpen:)]){ // TODO this should be placed into list animation completion block
		[_delegate lookupsDidOpen:self];
	}
}

-(void)closeLookup
{
	if ([_delegate respondsToSelector:@selector(lookupsWillClose:)]){
		[_delegate lookupsWillClose:self];
	}
	
	[_list dismiss];
    _list = nil;
	
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
	
	if ([_delegate respondsToSelector:@selector(lookupsDidClose:)]){ // TODO this should be placed into list animation completion block
		[_delegate lookupsDidClose:self];
	}
}
@end
