//
//  RNBridge.m
//  AliceX
//
//  Created by lmcmz on 11/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(WalletModule, NSObject)

// Type 1: Calling a Swift function from JavaScript
RCT_EXTERN_METHOD(sendTransaction:(NSString *)to value:(NSString *)value callback:(RCTResponseSenderBlock *)successCallback)

RCT_EXTERN_METHOD(smartContract:(NSString *)contractAddress method:(NSString *)method ABI:(NSString *)ABI parameter:(NSArray *)parameter callback:(RCTResponseSenderBlock *)successCallback)

RCT_EXTERN_METHOD(getAddress:(RCTResponseSenderBlock *)successCallback)

@end
