//
//  AKDropdownViewController.h
//  AKCalendarViewExample
//
//  Created by Andrey Kadochnikov on 03.06.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKLookups.h"
@class AKDropdownViewController;
@protocol AKLookupsDelegate <NSObject>
@optional
-(void)lookupsWillOpen:(AKDropdownViewController*)lookups;
-(void)lookupsDidOpen:(AKDropdownViewController*)lookups;
-(void)lookupsWillClose:(AKDropdownViewController*)lookups;
-(void)lookupsDidClose:(AKDropdownViewController*)lookups;
-(void)lookupsDidCancel:(AKDropdownViewController*)lookups;
@end

@interface AKDropdownViewController : UIViewController
@property (nonatomic, weak) id<AKLookupsDelegate> delegate;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat bottomMargin;
-(instancetype)initWithParentViewController:(UIViewController*)parentVC;
-(void)showDropdownViewBelowView:(UIView*)view;
-(void)dismiss;
-(void)closeCancel;
-(CGFloat)contentHeight;
-(CGFloat)spaceBelowPoint:(CGPoint)point;
-(BOOL)isContentFits;
-(void)contentViewAppearingAction;
-(void)contentViewAppearedAction;
@end
