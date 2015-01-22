//
//  HotelInvURLRequestManager.h
//  HotelInventory
//
//  Created by GIBSON BENJAMIN D on 12/3/13.
//  Copyright (c) 2013 KarashanCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelInvURLRequestManager : NSObject <NSURLConnectionDataDelegate>

-(HotelInvURLRequestManager*) initializeWithDebugSwitch:(bool)showDebug;
-(void) sendRequest:(NSString*)requestString forCaller:(id)caller withCallback:(SEL)selector toURL:(NSString*)URLasString withHTTPMethod:(NSString*)method;
    
@end
