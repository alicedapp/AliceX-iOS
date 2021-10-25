//
//  BroswerWKWebConfiguration.swift
//  AliceX
//
//  Created by lmcmz on 12/7/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import web3swift
import WebKit

struct ETHWeb3ScriptWKConfig {
    let address: String
    let chainId: Int
    let rpcUrl: String
    let privacyMode: Bool

    var providerJsBundleUrl: URL {
        let bundlePath = Bundle.main.path(forResource: "TrustWeb3Provider", ofType: "bundle")
        let bundle = Bundle(path: bundlePath!)!
        return bundle.url(forResource: "trust-min", withExtension: "js")!
    }

    var providerJsString: String {
        return Bundle.main.path(forResource: "web3-min", ofType: "js")!
    }

    var providerScript: WKUserScript {
        let source = try! String(contentsOfFile: providerJsString)
        let script = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        return script
    }

    var injectedScript: WKUserScript {
        let source: String
        if privacyMode {
            source = """
            (function() {
                var config = {
                    chainId: \(chainId),
                    rpcUrl: "\(rpcUrl)"
                };
                const provider = new window.Trust(config);
                window.ethereum = provider;

                window.chrome = {webstore: {}};
            })();
            """
        } else {
            source = """
            (function() {
                var config = {
                    address: "\(address)".toLowerCase(),
                    chainId: \(chainId),
                    rpcUrl: "\(rpcUrl)"
                };
                const provider = new window.Trust(config);
                window.ethereum = provider;
                window.web3 = new window.Web3(provider);
                window.web3.eth.defaultAccount = config.address;

                window.chrome = {webstore: {}};
            })();
            """
        }
        let script = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        return script
    }
}
