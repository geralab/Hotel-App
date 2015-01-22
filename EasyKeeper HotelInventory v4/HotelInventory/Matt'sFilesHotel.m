//
//  Matt'sFilesHotel.m
//  MobilAppProject
//
//  Created by Mac Powerhouse on 11/7/13.
//  Copyright (c) 2013 Mac Powerhouse. All rights reserved.
//

#import "Matt'sFilesHotel.h"


// The Hotel object is to be initalized after all of the locations
//This can be changed if we want it too

@implementation Matt_sFilesHotel
-(id)initWithName: (NSString*) name andstorageLocations: (NSMutableArray*) locations{
    _HotelTitle=name;
    _storageLocations=[Matt_sFilesStorageLocation jsonObjctToArrayofLocations:locations];
    [self sortLocations];
    return self;
}

//adds a storage location to the array
-(void)addLocation: (Matt_sFilesStorageLocation *) location{
    [_storageLocations addObject:location];
    [self sortLocations];
}

//removes a location from the list of locations based on the location object
-(void) removeObjectFromStorageLocations:(Matt_sFilesStorageLocation*) location{
    [_storageLocations removeObject:location];
}

// removes an object by location in the array
-(void) removeObjectFromStorageLocationsAtIndex:(NSUInteger)index{
    [_storageLocations removeObjectAtIndex:index];
}

// will sort our array of locations based on how we want them displayed
// alphabeticaly
-(void) sortLocations{
    for (int x=0; x<_storageLocations.count; x++) {
        for (int y=_storageLocations.count-1; y>x; y--) {
            
            Matt_sFilesStorageLocation* tempLocationA =_storageLocations[y];
            Matt_sFilesStorageLocation* tempLocationB=_storageLocations[y-1];
            
            //switches item if out of order
            if (tempLocationA.locationId < tempLocationB.locationId) {
                _storageLocations[y]=tempLocationB;
                _storageLocations [y-1]=tempLocationA;
            }
        }
    }
}
@end