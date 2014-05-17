//
//  AKAppDelegate.m
//  AKLookups
//
//  Created by Andrey Kadochnikov on 17.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import "AKAppDelegate.h"
#import "AKViewController.h"

@implementation AKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
	[self.window makeKeyAndVisible];
	self.window.rootViewController = [AKViewController new];
    return YES;
}
@end
