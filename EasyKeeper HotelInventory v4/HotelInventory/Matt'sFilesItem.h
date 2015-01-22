//
//  Matt'sFilesItem.h
//  MobilAppProject
//
//  Created by Mac Powerhouse on 11/7/13.
//  Copyright (c) 2013 Mac Powerhouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Matt_sFilesItem : NSObject

@property (nonatomic, strong, readonly )NSString* itemName;
@property (nonatomic, readonly )int numberOfItems;
@property (nonatomic, readonly )int inProcess;
@property (nonatomic, readonly )int inRoom;
@property (nonatomic, readonly )int inStock;
@property (nonatomic, readonly )int itemId;
@property (nonatomic, readonly )int itemTypeId;
@property (nonatomic, readonly, strong) NSString* itemType;

-(id)initWithName: (NSString*) name anddefault: (int) num andprocess: (int) process androom: (int) room andstock: (int) stock andId: (int) itemID andItemType: (NSString*) itemType andItemTypeID: (int) itemTypeID;
-(void)addToInProcess:(int)count;
-(void)addToInRoom:(int)count;
-(void)addToInStock:(int)count;
+(NSMutableArray*) jsonArrayToItemArray: (NSMutableArray*) tempArray;

@end
