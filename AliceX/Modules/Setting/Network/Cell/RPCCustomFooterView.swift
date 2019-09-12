//
//  NetworkCustomFooterView.swift
//  AliceX
//
//  Created by lmcmz on 11/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class RPCCustomFooterView: UITableViewHeaderFooterView {
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
         // Drawing code
     }
     */

    class func instanceFromNib() -> RPCCustomFooterView {
        let view = UINib(nibName: RPCCustomFooterView.nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RPCCustomFooterView
        return view
    }

    @IBAction func buttonClicked() {
        let vc = RPCCustomViewController()
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
