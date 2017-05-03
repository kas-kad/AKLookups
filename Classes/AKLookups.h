//
//  AKLookups.h
//  AKLookups
//
//  Created by Andrey Kadochnikov on 17.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AKDropdownViewController;
@class AKLookups;
@class AKLookupsListViewController;

typedef NS_ENUM(NSInteger, AKLookupsArrowPosition) {
    AKLookupsArrowPositionLeft,
    AKLookupsArrowPositionRight,
    AKLookupsArrowPositionAfterTitle
};

@protocol AKLookupsCapableItem <NSObject>
@required
@property (nonatomic, strong) NSString* lookupTitle;
@end

@protocol AKLookupsListControllerProvider <NSObject>
@required
- (AKLookupsListViewController *)controllerForLookup:(AKLookups *)lookup;
@end

@interface AKLookups : UIButton

// specify arrow position. default avlue is AKLookupsArrowPositionAfterTitle
@property (nonatomic, assign) AKLookupsArrowPosition arrowPosition;
@property (nonatomic, weak) IBOutlet id<AKLookupsListControllerProvider> listProvider;
@property (nonatomic, strong) id<AKLookupsCapableItem> selectedItem;


-(instancetype)initWithLookupViewController:(AKDropdownViewController*)viewController;
-(void)closeAnimation;
-(void)selectItem:(id<AKLookupsCapableItem>)item;
-(void)openLookup;
-(void)closeLookup;

@end
