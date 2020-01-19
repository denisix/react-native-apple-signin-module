//
//  RNAppleSignIn.m
//  AppleSignIn
//
//  Created by Den on 18.01.2020.
//  Copyright © 2020 Facebook. All rights reserved.
//
#import "RCTBridgeModule.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

@interface RCT_EXTERN_MODULE(RNAppleSignIn, NSObject)
RCT_EXTERN_METHOD(signIn:(NSString *)userIdentifier callback:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(supportedEvents)
@end
