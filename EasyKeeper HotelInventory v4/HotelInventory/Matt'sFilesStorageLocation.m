//
//  Matt'sFilesStorageLocation.m
//  MobilAppProject
//
//  Created by Mac Powerhouse on 11/7/13.
//  Copyright (c) 2013 Mac Powerhouse. All rights reserved.
//

#import "Matt'sFilesStorageLocation.h"

@implementation Matt_sFilesStorageLocation


-(id)initWithName: (NSString*) name andstorageItems: (NSMutableArray*) items andFloor: (NSString*) floor andhotelID: (int) hotelID andId: (int) locationID{
    _locationName=name;
    _itemsInLocation=items;
    _floor=floor;
    _hotelId=hotelID;
    _locationId=locationID;
    return self;
}


//adds an item to the array
-(void)addLocation: (Matt_sFilesStorageLocation *) item{
    [_itemsInLocation addObject:item];
    [self sortItems];
}

//removes an item from the list of locations based on the item object
-(void) removeObjectFromStorageLocations:(Matt_sFilesStorageLocation*) item{
    [_itemsInLocation  removeObject:item];
}

// removes an object by location in the array
-(void) removeObjectFromItemsInLocationAtIndex:(NSUInteger)index{
    [_itemsInLocation  removeObjectAtIndex:index];
}

// will sort our array of items based on how we want them displayed
// alphabeticaly
-(void) sortItems{
    for (int x=0; x<_itemsInLocation.count; x++) {
        for (int y=_itemsInLocation.count-1; y>x; y--) {
         
            Matt_sFilesItem* tempItemA =_itemsInLocation[y];
            Matt_sFilesItem* tempItemB=_itemsInLocation[y-1];
            NSComparisonResult result = [tempItemA.itemName compare:tempItemB.itemName];
            
            //switches item if out of order
            if (result==NSOrderedAscending) {
                _itemsInLocation[y]=tempItemB;
                _itemsInLocation [y-1]=tempItemA;
            }
        }
    }
}

-(void) setItemsList:(NSMutableArray*) tempArray{
    _itemsInLocation=tempArray;
    [self sortItems];
}


+(NSMutableArray*) jsonObjctToArrayofLocations:(NSMutableArray*) tempArray{
    NSMutableArray* toBeRetured= [[NSMutableArray alloc]init];
    
    for (NSDictionary * tempDictionary in tempArray){
        NSString* floor;
        NSString* name;
        int locID;
        int hotelID;
        
        floor=[tempDictionary valueForKey:@"floor"];
        hotelID=[[tempDictionary valueForKey:@"hotel_id"] intValue];
        locID=[[tempDictionary valueForKey:@"id"] intValue];
        name= [tempDictionary valueForKey:@"name"];
        
        Matt_sFilesStorageLocation* tempLocation= [[Matt_sFilesStorageLocation alloc]initWithName:name andstorageItems:nil andFloor:floor andhotelID:hotelID andId:locID];
        
        [toBeRetured addObject:tempLocation];
    }
    
    return toBeRetured  ;
}
@end
