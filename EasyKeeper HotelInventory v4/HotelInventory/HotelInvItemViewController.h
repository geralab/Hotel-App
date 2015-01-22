//
//  HotelInvItemViewController.h
//  HotelInventory
//
//  Created by GIBSON BENJAMIN D on 11/24/13.
//  Copyright (c) 2013 KarashanCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Matt'sFilesItem.h"
#import <AVFoundation/AVFoundation.h>
#import "HotelInvURLRequestManager.h"

@interface HotelInvItemViewController : UIViewController<AVAudioPlayerDelegate>

@property (strong, nonatomic) HotelInvURLRequestManager *requestManager;
@property (strong, nonatomic) NSDictionary *userData;
@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) Matt_sFilesItem *item;
@property (nonatomic) int storageId;
@property (nonatomic) bool showDebug;
@property (nonatomic, strong) AVAudioPlayer *player;
@property(nonatomic,strong) NSURL *theSound;
- (void)setupPlayer:(NSString *)str1 with:(NSString*) str2;
@end
