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

@protocol AKLookupsCapableItem <NSObject>
@required
@property (nonatomic, strong) NSString* lookupTitle;
@end

@interface AKLookups : UIButton
@property (nonatomic, strong) id<AKLookupsCapableItem> selectedItem;

-(instancetype)initWithLookupViewController:(AKDropdownViewController*)viewController;
-(void)closeAnimation;
-(void)selectItem:(id<AKLookupsCapableItem>)item;
-(void)openLookup;
-(void)closeLookup;
@end
