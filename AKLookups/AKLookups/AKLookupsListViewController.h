//
//  AKLookupsListViewController.h
//  AKLookups
//
//  Created by Andrey Kadochnikov on 17.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKLookups.h"

@interface AKLookupsListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSUInteger selectedItemIdx;
@property (nonatomic, assign) CGFloat bottomMargin;
-(void)showListFromLookupsButton:(AKLookups*)lookupsButton;
-(void)dismiss;
@end
