//
//  AssetInfoViewController.swift
//  AliceX
//
//  Created by lmcmz on 6/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit
import PromiseKit
import SkeletonView

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
    
    @IBOutlet var descTextView: UITextView!
    
    @IBOutlet var textViewHeight: NSLayoutConstraint!
    
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
        ownerLabel.text = model.owner
        
        transfersCountLabel.text = String(model.transfersCount)
        holdersCountLabel.text = String(model.holdersCount)
        issuancesCountLabel.text = String(model.issuancesCount)
        
        totalSupplyLabel.text = String(model.totalSupply)
        
        descTextView.text = model.description ?? "(No Description)"
        descTextView.translatesAutoresizingMaskIntoConstraints = false
        descTextView.isScrollEnabled = false
        descTextView.sizeToFit()
        textViewHeight.constant = descTextView.contentSize.height
    }
    
    func requestData() {
        
        if !coin.isERC20 {
            return
        }
        
        view.showAnimatedGradientSkeleton()
        
        firstly { () -> Promise<TokenInfo> in
            API(Ethplorer.getTokenInfo(address: coin.id))
        }.done { model in
            self.data = model
            self.view.hideSkeleton()
            self.configure()
        }.catch { error in
            self.view.showSkeleton()
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
