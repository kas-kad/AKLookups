//
//  AKMeme.m
//  AKLookups
//
//  Created by Andrey Kadochnikov on 17.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import "AKMeme.h"

@implementation AKMeme
+(AKMeme*)memeWithTitle:(NSString*)title imageName:(NSString*)imageName
{
	AKMeme* carModel = [AKMeme new];
	carModel.lookupTitle = title;
	carModel.imageName = imageName;
	return carModel;
}
@end
