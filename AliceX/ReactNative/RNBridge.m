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

@interface RCT_EXTERN_MODULE(PaymentNativeModule, NSObject)

// Type 1: Calling a Swift function from JavaScript
RCT_EXTERN_METHOD(payment:(NSString *)to value:(NSString *)value callback:(RCTResponseSenderBlock *)successCallback)
//RCT_EXTERN_METHOD(payment:(NSString *)to value:(NSString *)value)

@end
