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
                  data:(NSString *)data
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

//RCT_EXTERN_METHOD(getAddress:(RCTResponseSenderBlock *)successCallback)
RCT_EXTERN_METHOD(getAddress:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getNetwork:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getBalance:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(signMessage:(NSString *)message
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(signTransaction:(NSString *)to
                  value:(NSString *)value
                  data:(NSString *)data
                  detailObject:(BOOL *)detailObject
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(sendTransactionWithDapplet:(NSString *)to
                  value:(NSString *)value
                  data:(NSString *)data
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(sendToken:(NSString *)tokenAddress
                  to:(NSString *)to
                  value:(NSString *)value
                  data:(NSString *)data
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(transfer:(NSString *)to
                  value:(NSString *)value
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(fetchTXStatus:(NSString *)txHash
                  rpcURL:(NSString *)rpcURL
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

RCT_EXTERN_METHOD(writeWithGasLimit:(NSString *)contractAddress
                  abi:(NSString *)abi
                  functionName:(NSString *)functionName
                  parameters:(NSArray *)parameters
                  value:(NSString *)value
                  data:(NSString *)data
                  gasLimit:(NSString *)gasLimit
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
RCT_EXTERN_METHOD(browser:(NSString *)url)
RCT_EXTERN_METHOD(qrScanner:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(getOrientation:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(isDarkMode:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(popToRootVC)
RCT_EXTERN_METHOD(popBack)
RCT_EXTERN_METHOD(minimizeApp)

@end


# pragma - Broadcasting to RN

@interface RCT_EXTERN_MODULE(CallRNModule, RCTEventEmitter)

@end

# pragma - WalletConnect

@interface RCT_EXTERN_MODULE(WallectConnectModule, NSObject)

RCT_EXTERN_METHOD(create)
RCT_EXTERN_METHOD(message:(NSString *)message
                  isServer: (BOOL *)isServer)
@end
