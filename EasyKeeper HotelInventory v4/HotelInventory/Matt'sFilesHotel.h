//
//  Matt'sFilesHotel.h
//  MobilAppProject
//
//  Created by Mac Powerhouse on 11/7/13.
//  Copyright (c) 2013 Mac Powerhouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matt'sFilesStorageLocation.h"
#import "Matt'sFilesItem.h"

@interface Matt_sFilesHotel : NSObject
@property (nonatomic, strong, readonly ) NSString* HotelTitle;
@property (nonatomic, strong, readonly ) NSMutableArray* storageLocations;
-(id)initWithName: (NSString*) name andstorageLocations: (NSMutableArray*) locations;
-(void)addLocation: (Matt_sFilesStorageLocation *) location;
-(void) removeObjectFromStorageLocations:(Matt_sFilesStorageLocation*) location;
-(void) removeObjectFromStorageLocationsAtIndex:(NSUInteger)index;
@end
