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

RCT_EXTERN_METHOD(sendTransaction:(NSString *)to value:(NSString *)value callback:(RCTResponseSenderBlock *)successCallback)

RCT_EXTERN_METHOD(getAddress:(RCTResponseSenderBlock *)successCallback)

RCT_EXTERN_METHOD(signMessage:(NSString *)message callback:(RCTResponseSenderBlock *)successCallback)

@end

# pragma - Smart Contract

@interface RCT_EXTERN_MODULE(ContractModule, NSObject)

RCT_EXTERN_METHOD(write:(NSString *)contractAddress
                  abi:(NSString *)abi
                  functionName:(NSString *)functionName
                  parameters:(NSArray *)parameters
                  value:(NSString *)value
                  data:(NSString *)data
                  callback:(RCTResponseSenderBlock *)successCallback)


RCT_EXTERN_METHOD(read:(NSString *)contractAddress
                  abi:(NSString *)abi
                  functionName:(NSString *)functionName
                  parameters:(NSArray *)parameters
                  callback:(RCTResponseSenderBlock *)successCallback)

@end
