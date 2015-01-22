//
//  Matt'sFilesStorageLocation.h
//  MobilAppProject
//
//  Created by Mac Powerhouse on 11/7/13.
//  Copyright (c) 2013 Mac Powerhouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matt'sFilesItem.h"

@interface Matt_sFilesStorageLocation : NSObject
@property (nonatomic, strong, readonly ) NSString* locationName;
@property (nonatomic, strong, readonly ) NSMutableArray* itemsInLocation;
@property (nonatomic, strong, readonly ) NSString* floor;
@property (nonatomic, readonly ) int hotelId;
@property (nonatomic, readonly ) int locationId;

-(id)initWithName: (NSString*) name andstorageItems: (NSMutableArray*) items andFloor: (NSString*) floor andhotelID: (int) hotelID andId: (int) locationID;
-(void)addLocation: (Matt_sFilesStorageLocation *) item;
-(void) removeObjectFromStorageLocations:(Matt_sFilesStorageLocation*) item;
-(void) removeObjectFromItemsInLocationAtIndex:(NSUInteger)index;
-(void) setItemsList:(NSMutableArray*) tempArray;
+(NSMutableArray*) jsonObjctToArrayofLocations:(NSMutableArray*) tempArray;

@end
