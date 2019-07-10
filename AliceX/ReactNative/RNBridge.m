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

# pragma - Wallet

@interface RCT_EXTERN_MODULE(WalletModule, NSObject)

RCT_EXTERN_METHOD(sendTransaction:(NSString *)to
                  value:(NSString *)value
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

//RCT_EXTERN_METHOD(getAddress:(RCTResponseSenderBlock *)successCallback)
RCT_EXTERN_METHOD(getAddress:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(signMessage:(NSString *)message
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(signTransaction:(NSString *)to
                  value:(NSString *)value
                  data:(NSString *)data
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

@end

# pragma - Smart Contract

@interface RCT_EXTERN_MODULE(ContractModule, NSObject)

RCT_EXTERN_METHOD(write:(NSString *)contractAddress
                  abi:(NSString *)abi
                  functionName:(NSString *)functionName
                  parameters:(NSArray *)parameters
                  value:(NSString *)value
                  data:(NSString *)data
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)


RCT_EXTERN_METHOD(read:(NSString *)contractAddress
                  abi:(NSString *)abi
                  functionName:(NSString *)functionName
                  parameters:(NSArray *)parameters
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

@end

# pragma - Native View Controller

@interface RCT_EXTERN_MODULE(NativeVCModule, NSObject)

RCT_EXTERN_METHOD(setting)

@end


# pragma - Broadcasting to RN

@interface RCT_EXTERN_MODULE(CallRNModule, RCTEventEmitter)

@end
