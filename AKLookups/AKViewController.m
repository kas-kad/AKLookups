//
//  AKViewController.m
//  AKLookups
//
//  Created by Andrey Kadochnikov on 17.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import "AKMeme.h"
#import "AKViewController.h"
#import "AKLookups.h"
#import "AKLookupsListViewController.h"
@interface AKViewController () <AKLookupsDatasource, AKLookupsListDelegate>
{
	NSArray *_items;
	UIImageView *_memeImageView;
	AKMeme *_selectedMeme;
	AKLookups *_memeLookupBtn;
	BOOL _menuPresented;
	AKLookupsListViewController *_listVC;
}
@end

@implementation AKViewController

-(id)init
{
	if (self = [super init]){
		_items = @[[AKMeme memeWithTitle:@"Forever Alone" imageName:@"fa.jpg"],
				   [AKMeme memeWithTitle:@"Trollface" imageName:@"tf.jpg"],
				   [AKMeme memeWithTitle:@"Me Gusta"  imageName:@"mg.jpg"],
				   [AKMeme memeWithTitle:@"Y U NO Guy" imageName:@"yu.jpg"],
				   [AKMeme memeWithTitle:@"Dolan" imageName:@"do.jpg"],
				   [AKMeme memeWithTitle:@"Yao Ming Face" imageName:@"ym.jpg"],
				   [AKMeme memeWithTitle:@"Okay Guy" imageName:@"og.jpg"]];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)];
	_memeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60.0f, 64.0f, 200.0f, 200.0f)];
	_memeImageView.backgroundColor = [UIColor lightGrayColor];
	[self.view addSubview: _memeImageView];
	

	_memeLookupBtn = [[AKLookups alloc] initWithLookupViewController:self.listVC];
	_memeLookupBtn.frame = CGRectMake(15.0f, CGRectGetMaxY( _memeImageView.frame ), 290.0f, 44.0f);
	[_memeLookupBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[_memeLookupBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	[_memeLookupBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_memeLookupBtn setArrowPosition:AKLookupsArrowPositionAfterTitle];
	[self.view addSubview:_memeLookupBtn];
}

#pragma mark - Lookup datasource
-(NSArray *)lookupsItems
{
	return _items;
}

-(id<AKLookupsCapableItem>)lookupsSelectedItem
{
	return _selectedMeme;
}

#pragma mark - Lookup delegate
-(void)lookups:(AKDropdownViewController *)lookups didSelectItem:(id<AKLookupsCapableItem>)item
{
	_selectedMeme = (AKMeme*)item;
	_memeImageView.image = [UIImage imageNamed:_selectedMeme.imageName];
	[_memeLookupBtn selectItem:item];
	[_memeLookupBtn closeLookup];
}
-(void)lookupsDidOpen:(AKDropdownViewController *)lookups
{
	_menuPresented = YES;
}
-(void)lookupsDidClose:(AKDropdownViewController *)lookups
{
	_menuPresented = NO;
}
-(void)lookupsDidCancel:(AKDropdownViewController *)lookups
{
	[_memeLookupBtn closeAnimation];
	_menuPresented = NO;
}

#pragma mark - Helpers
-(void)showMenu:(id)sender
{
	if (!_menuPresented){
		[self.listVC showDropdownViewBelowView:self.navigationController.navigationBar];
		_menuPresented = YES;
	}
}

-(AKLookupsListViewController*)listVC
{
	if (!_listVC){
		_listVC = [[AKLookupsListViewController alloc] initWithParentViewController:self.navigationController];
		_listVC.dataSource = self;
		_listVC.delegate = self;
		_listVC.bottomMargin = 15.0f;
	}
	return _listVC;
}
@end
