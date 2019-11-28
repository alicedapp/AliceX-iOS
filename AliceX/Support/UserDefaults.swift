//
//  UserDefaults.swift
//  AliceX
//
//  Created by lmcmz on 2/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    var isFirstTimeOpen: DefaultsKey<Bool> { return .init("isFirstTimeOpen", defaultValue: true) }
    var MnemonicsBackup: DefaultsKey<Bool> { return .init("MnemonicsBackup", defaultValue: false) }
    var isHideAsset: DefaultsKey<Bool> { return .init("isHideAsset", defaultValue: false) }
    var lastTimeUpdateAsset: DefaultsKey<Date?> { return .init("lastTimeUpdateAsset") }
    var lastAssetBalance: DefaultsKey<Double> { return .init("lastAssetBalance", defaultValue: 0.0) }

    var homepage: DefaultsKey<URL> { return .init("homepage", defaultValue: URL(string: "https://duckduckgo.com")!) }
    var searchEngine: DefaultsKey<Int> { return .init("searchEngine", defaultValue: 0) }
}
