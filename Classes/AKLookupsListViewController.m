//
//  AKLookupsListViewController.m
//  AKLookups
//
//  Created by Andrey Kadochnikov on 17.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import "AKLookupsListViewController.h"
#define MT_COLOR(R, G, B, A) \
[UIColor colorWithRed:(R)/(255.0) green:(G)/(255.0) blue:(B)/(255.0) alpha:(A)]


@interface AKLookupsListViewController ()  <UITableViewDataSource,UITableViewDelegate>
{
	id<AKLookupsCapableItem> _selectedListItem;
}
@end

@implementation AKLookupsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
	_tableView.scrollEnabled = NO;
	_tableView.backgroundColor = [UIColor whiteColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:_tableView];
}

-(void)showDropdownViewBelowView:(UIView*)view
{
	if ([self.dataSource respondsToSelector:@selector(lookupsSelectedItem)]){
		_selectedListItem = [self.dataSource lookupsSelectedItem];
	}
	if ([self.dataSource respondsToSelector:@selector(lookupsItems)]){
		self.items = [self.dataSource lookupsItems];
	}
	[super showDropdownViewBelowView:view];
	[self.tableView reloadData];
}

#pragma mark - Table Datasource
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
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
	id<AKLookupsCapableItem> item = _items[indexPath.row];
	if([item isEqual:_selectedListItem]) {
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
	cell.textLabel.text = [item lookupTitle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f; // dirty workaround
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return PERFECT_CELL_HEIGHT;
}

#pragma mark - TableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	id<AKLookupsCapableItem> item = _items[indexPath.row];
	if ([self.delegate respondsToSelector:@selector(lookups:didSelectItem:)]){
		[self.delegate lookups:self didSelectItem:item];
	}
}

#pragma mark - Appearing
-(void)contentViewAppearingAction
{
	@try {
		[_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_items indexOfObject: _selectedListItem] inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
	}
	@catch (NSException *exception) {
	}
}

-(void)contentViewAppearedAction
{
	_tableView.scrollEnabled = ![self isContentFits];
	[_tableView flashScrollIndicators];
}

#pragma mark - Overridden
-(CGFloat)contentHeight
{
	return self.items.count * PERFECT_CELL_HEIGHT;
}
@end
