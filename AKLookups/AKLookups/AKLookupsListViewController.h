//
//  AKLookupsListViewController.h
//  AKLookups
//
//  Created by Andrey Kadochnikov on 17.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import "AKDropdownViewController.h"
#define PERFECT_CELL_HEIGHT 53.0f

@protocol AKLookupsDatasource <NSObject>
@required
-(NSArray*)lookupsItems;
-(id<AKLookupsCapableItem>)lookupsSelectedItem;
@end

@protocol AKLookupsListDelegate <AKLookupsDelegate>
-(void)lookups:(AKDropdownViewController*)lookups didSelectItem:(id<AKLookupsCapableItem>)item;
@end

@interface AKLookupsListViewController : AKDropdownViewController
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) id<AKLookupsListDelegate> delegate;
@property (nonatomic, weak) id<AKLookupsDatasource> dataSource;
@property (nonatomic, readonly) UITableView *tableView;

-(void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
@end
