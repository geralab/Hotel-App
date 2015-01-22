//
//  HotelInvItemsTableViewController.h
//  HotelInventory
//
//  Created by GIBSON BENJAMIN D on 11/24/13.
//  Copyright (c) 2013 KarashanCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Matt'sFilesStorageLocation.h"
#import <AVFoundation/AVFoundation.h>
#import "HotelInvURLRequestManager.h"

@interface HotelInvItemsTableViewController : UITableViewController<AVAudioPlayerDelegate>

@property (strong, nonatomic) HotelInvURLRequestManager *requestManager;
@property (strong, nonatomic) NSDictionary *userData;
@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) Matt_sFilesStorageLocation *storageData;
@property (nonatomic) bool showDebug;
- (void)setupPlayer:(NSString *)str1 with:(NSString*) str2;
@property (nonatomic, strong) AVAudioPlayer *player;
@property(nonatomic,strong) NSURL *theSound;
@end
