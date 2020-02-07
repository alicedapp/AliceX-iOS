//
//  AddAccountFooter.swift
//  AliceX
//
//  Created by lmcmz on 5/1/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit

class AddAccountFooter: UITableViewHeaderFooterView {
    class func instanceFromNib() -> AddAccountFooter {
        let view = UINib(nibName: AddAccountFooter.nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AddAccountFooter
        return view
    }

    @IBAction func buttonClicked() {
        let vc = RPCCustomViewController()
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
