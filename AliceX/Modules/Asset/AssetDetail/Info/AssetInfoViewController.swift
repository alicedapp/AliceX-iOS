//
//  AssetInfoViewController.swift
//  AliceX
//
//  Created by lmcmz on 6/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit
import PromiseKit

class AssetInfoViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var decimalLabel: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var ownerLabel: UILabel!
    
    @IBOutlet var transfersCountLabel: UILabel!
    @IBOutlet var holdersCountLabel: UILabel!
    @IBOutlet var issuancesCountLabel: UILabel!
    @IBOutlet var totalSupplyLabel: UILabel!
    
    @IBOutlet var descriptionView: UITextView!
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    var coin: Coin = .coin(chain: .Ethereum)
    
    var data: TokenInfo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestData()
    }
    
    func configure() {
        
        guard let model = data else {
            return
        }
        
        nameLabel.text = model.name
        decimalLabel.text = String(model.decimals)
        addressLabel.text = model.address
        
        symbolLabel.text = model.symbol
        descriptionView.text = model.description
        
        transfersCountLabel.text = String(model.transfersCount)
        holdersCountLabel.text = String(model.holdersCount)
        issuancesCountLabel.text = String(model.issuancesCount)
        
        totalSupplyLabel.text = String(model.totalSupply)
    }
    
    func requestData() {
        
//        if !coin.isERC20 {
//            return
//        }
        
        firstly { () -> Promise<TokenInfo> in
            API(Ethplorer.getTokenInfo(address: "0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2"))
        }.done { model in
            self.data = model
            self.configure()
       }.catch { error in
            
        }
        
    }
}

extension AssetInfoViewController: JXPagingViewListViewDelegate {
    public override func listView() -> UIView {
        return view
    }

    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> Void) {
        listViewDidScrollCallback = callback
    }

    public func listScrollView() -> UIScrollView {
        return scrollView
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
}
