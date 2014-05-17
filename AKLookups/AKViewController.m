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
@interface AKViewController () <AKLookupsDatasource, AKLookupsDelegate>
{
	NSArray *_items;
	UIImageView *_carLogoView;
}
@end

@implementation AKViewController

-(id)init{
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
	_carLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(60.0f, 20.0f, 200.0f, 200.0f)];
	_carLogoView.backgroundColor = [UIColor lightGrayColor];
	[self.view addSubview: _carLogoView];
	
	AKLookups *carModelLookup = [[AKLookups alloc] initWithDelegate:self datasource:self];
	carModelLookup.frame = CGRectMake(15.0f, 220.0f, 290.0f, 44.0f);
	carModelLookup.bottomMargin = 15.0f;
	[carModelLookup setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[carModelLookup setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	[carModelLookup setBackgroundColor:[UIColor lightGrayColor]];
	[self.view addSubview:carModelLookup];
}

-(NSArray *)lookupsItems{
	return _items;
}

-(void)lookups:(AKLookups *)lookups didSelectItemAtIndex:(NSUInteger)index{
	AKMeme *ameme = _items[index];
	_carLogoView.image = [UIImage imageNamed:ameme.imageName];
}
@end
