//
//  Matt'sFilesItem.m
//  MobilAppProject
//
//  Created by Mac Powerhouse on 11/7/13.
//  Copyright (c) 2013 Mac Powerhouse. All rights reserved.
//

#import "Matt'sFilesItem.h"

@implementation Matt_sFilesItem

//init with nessary paramiters
-(id)initWithName: (NSString*) name anddefault: (int) num andprocess: (int) process androom: (int) room andstock: (int) stock andId: (int) itemID andItemType: (NSString*) itemType andItemTypeID: (int) itemTypeID {
    _itemName=name;
    _numberOfItems=num;
    _inProcess=process;
    _inRoom=room;
    _inStock=stock;
    _itemId=itemID;
    _itemType=itemType;
    _itemTypeId=itemTypeID;
    
    return self;
}

-(void)addToInRoom:(int)count {_inRoom += count;}
-(void)addToInProcess:(int)count {_inProcess += count;}
-(void)addToInStock:(int)count {_inStock += count;}

+(NSMutableArray*) jsonArrayToItemArray: (NSMutableArray*) tempArray{
    NSMutableArray* toBeRetured= [[NSMutableArray alloc]init];
    
    for (NSDictionary * tempDictionary in tempArray){
        NSString* name;
        NSString* itemType;
        int num;
        int process;
        int room;
        int stock;
        int itemID;
        int itemTypeId;
        
        name=[tempDictionary valueForKey:@"item_name"];
        num=[[tempDictionary valueForKey:@"total_amount"] intValue];
        process=[[tempDictionary valueForKey:@"in_process"] intValue];
        room= [[tempDictionary valueForKey:@"in_room"] intValue];
        stock= [[tempDictionary valueForKey:@"in_stock"] intValue];
        itemID= [[tempDictionary valueForKey:@"item_id"] intValue];
        itemType=[tempDictionary valueForKey:@"item_type"];
        itemTypeId= [[tempDictionary valueForKey:@"item_type_id"] intValue];
        
        
        Matt_sFilesItem* tempItem= [[Matt_sFilesItem alloc] initWithName:name anddefault:num andprocess:process androom:room andstock:stock andId:itemID andItemType: itemType andItemTypeID: itemTypeId];
        [toBeRetured addObject:tempItem];
    }
    
    return toBeRetured;
    
}
@end
