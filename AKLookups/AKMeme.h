//
//  AKMeme.h
//  AKLookups
//
//  Created by Andrey Kadochnikov on 17.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKLookups.h"

@interface AKMeme : NSObject <AKLookupsCapableItem>
@property (nonatomic, strong) NSString* lookupTitle;
@property (nonatomic, strong) NSString* imageName;
+(AKMeme*)memeWithTitle:(NSString*)title imageName:(NSString*)imageName;
@end
