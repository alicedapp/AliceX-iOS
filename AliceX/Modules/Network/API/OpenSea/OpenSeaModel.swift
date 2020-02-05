//
//  OpenSeaModel.swift
//  AliceX
//
//  Created by lmcmz on 28/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import HandyJSON

struct OpenSeaContract: HandyJSON {
    var name: String!
    var address: String!
    var symbol: String?
    var description: String?
    var external_link: String?
    var nft_version: String?
    var asset_contract_type: String?
    var image_url: String!
    var large_image_url: String?
    var featured_image_url: String?

    init() {}
}

struct OpenSeaOwner: HandyJSON {
    var profile_img_url: String?
    var address: String?

    init() {}
}

struct OpenSeaPaymentToken: HandyJSON {
    var symbol: String?
    var address: String?
    var image_url: String?
    var decimals: Int?
    var name: String?
    var eth_price: String?
    var usd_price: String?

    init() {}
}

struct OpenSeaLastSell: HandyJSON {
    var event_type: String?
    var auction_type: String?
    var total_price: String?
    var payment_token: OpenSeaPaymentToken?

    init() {}
}

struct OpenSeaTrait: HandyJSON {
    var trait_type: String?
    var value: String?
    var display_type: String?
    var max_value: String?
    var order: String?
    var trait_count: Int32?

    init() {}
}

struct OpenSeaModel: HandyJSON {
    var token_id: String!
    var num_sales: Int!
    var background_color: String?
    var image_url: String?
    var image_preview_url: String?
    var image_thumbnail_url: String?
    var image_original_url: String?
    var animation_url: String?
    var animation_original_url: String?

    var permalink: String?

    var name: String?
    var description: String?
    var external_link: String?

    var asset_contract: OpenSeaContract?
    var owner: OpenSeaOwner?
    var last_sale: OpenSeaLastSell?

    var traits: [OpenSeaTrait]?

    var current_price: String?

    init() {}
}

struct OpenSeaReponse: HandyJSON {
    var assets: [OpenSeaModel]?
}
