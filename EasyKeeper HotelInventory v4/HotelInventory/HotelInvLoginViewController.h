//
//  HotelInvViewController.h
//  HotelInventory
//
//  Created by GIBSON BENJAMIN D on 11/24/13.
//  Copyright (c) 2013 KarashanCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface HotelInvLoginViewController : UIViewController<AVAudioPlayerDelegate>
- (void)setupPlayer:(NSString *)str1 with:(NSString*) str2;
@property (nonatomic, strong) AVAudioPlayer *player;
@property(nonatomic,strong) NSURL *theSound;
@end
