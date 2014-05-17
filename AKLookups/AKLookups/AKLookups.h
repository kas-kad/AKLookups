//
//  AKLookups.h
//  AKLookups
//
//  Created by Andrey Kadochnikov on 17.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKLookups;

@protocol AKLookupsCapableItem <NSObject>
@required
@property (nonatomic, strong) NSString* lookupTitle;
@end

@protocol AKLookupsDelegate <NSObject>
@optional
-(void)lookupsWillOpen:(AKLookups*)lookups;
-(void)lookupsDidOpen:(AKLookups*)lookups;
-(void)lookupsWillClose:(AKLookups*)lookups;
-(void)lookupsDidClose:(AKLookups*)lookups;
-(void)lookups:(AKLookups*)lookups didSelectItemAtIndex:(NSUInteger)index;
@end

@protocol AKLookupsDatasource <NSObject>
@required
-(NSArray*)lookupsItems;
@end

@interface AKLookups : UIButton
@property (nonatomic, weak) id<AKLookupsDelegate> delegate;
@property (nonatomic, weak) id<AKLookupsDatasource> dataSource;
@property (nonatomic, assign) NSUInteger selectedItemIdx;
@property (nonatomic, assign) CGFloat bottomMargin;

-(instancetype)initWithDelegate:(id<AKLookupsDelegate>)delegate datasource:(id<AKLookupsDatasource>)datasource;
-(void)selectItemAtIndex:(NSUInteger)index;
-(void)openLookup;
-(void)closeLookup;
@end
