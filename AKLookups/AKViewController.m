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
@interface AKViewController () <AKLookupsDatasource, AKLookupsListDelegate, AKLookupsListControllerProvider>
{
	NSArray *_items;
	AKMeme *_selectedMeme;
    AKLookups *_memeLookupBtn2;
	BOOL _menuPresented;
	AKLookupsListViewController *_listVC;
}
@property (weak, nonatomic) IBOutlet UIImageView *memeImageView;
@property (weak, nonatomic) IBOutlet AKLookups *memeLookupBtn;
@end

@implementation AKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.memeLookupBtn setArrowPosition:AKLookupsArrowPositionAfterTitle];
    
    _memeLookupBtn2 = [[AKLookups alloc] initWithLookupViewController:self.listVC];
    _memeLookupBtn2.frame = CGRectZero;
    [_memeLookupBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_memeLookupBtn2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_memeLookupBtn2 setBackgroundColor:[UIColor lightGrayColor]];
    [_memeLookupBtn2 setArrowPosition:AKLookupsArrowPositionAfterTitle];
    [self.view addSubview:_memeLookupBtn2];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect topFrame = self.memeLookupBtn.frame;
    topFrame.origin.y += 50;
    _memeLookupBtn2.frame = topFrame;
}

#pragma mark - Lookup datasource
-(NSArray *)lookupsItems
{
	return self.items;
}

-(id<AKLookupsCapableItem>)lookupsSelectedItem
{
	return _selectedMeme;
}

#pragma mark - Lookup delegate
-(void)lookups:(AKDropdownViewController *)lookups didSelectItem:(id<AKLookupsCapableItem>)item
{
	_selectedMeme = (AKMeme*)item;
	self.memeImageView.image = [UIImage imageNamed:_selectedMeme.imageName];
	[_memeLookupBtn selectItem:item];
	[_memeLookupBtn closeLookup];
    [_memeLookupBtn2 selectItem:item];
    [_memeLookupBtn2 closeLookup];
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

- (AKLookupsListViewController *)controllerForLookup:(AKLookups *)lookup {
    if ([lookup isEqual:self.memeLookupBtn]) {
        return self.listVC;
    }
    return nil;
}

#pragma mark - Helpers
- (IBAction)showMenu:(id)sender {
    if (!_menuPresented){
        [self.listVC showDropdownViewBelowView:self.navigationController.navigationBar];
        _menuPresented = YES;
    }
}

- (AKLookupsListViewController*)listVC
{
	if (!_listVC){
		_listVC = [[AKLookupsListViewController alloc] initWithParentViewController:self.navigationController];
		_listVC.dataSource = self;
		_listVC.delegate = self;
		_listVC.bottomMargin = 15.0f;
	}
	return _listVC;
}
- (NSArray *)items {
    if (_items == nil) {
        _items = @[[AKMeme memeWithTitle:@"Forever Alone" imageName:@"fa.jpg"],
                   [AKMeme memeWithTitle:@"Trollface" imageName:@"tf.jpg"],
                   [AKMeme memeWithTitle:@"Me Gusta"  imageName:@"mg.jpg"],
                   [AKMeme memeWithTitle:@"Y U NO Guy" imageName:@"yu.jpg"],
                   [AKMeme memeWithTitle:@"Dolan" imageName:@"do.jpg"],
                   [AKMeme memeWithTitle:@"Yao Ming Face" imageName:@"ym.jpg"],
                   [AKMeme memeWithTitle:@"Okay Guy" imageName:@"og.jpg"]];
    }
    return _items;
}
@end
