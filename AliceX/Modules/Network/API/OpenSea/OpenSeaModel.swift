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
    var symbol: String!
    var image_url: String!
    var large_image_url: String!
    var featured_image_url: String!
}

struct OpenSeaOwner: HandyJSON {
    var profile_img_url: String!
    var address: String!
}

struct OpenSeaModel: HandyJSON {
    var token_id: String!
    var num_sales: Int!
    var background_color: String!
    var image_url: String!
    var image_preview_url: String!
    var image_thumbnail_url: String!
    var image_original_url: String!
    var animation_url: String!
    var animation_original_url: String!

    var name: String!
    var description: String!
    var external_link: String!

    var asset_contract: OpenSeaContract!
    var owner: OpenSeaOwner!
}

struct OpenSeaReponse: HandyJSON {
    var assets: [OpenSeaModel]?
}
