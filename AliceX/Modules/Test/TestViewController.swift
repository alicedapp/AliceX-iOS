//
//  TestViewController.swift
//  AliceX
//
//  Created by lmcmz on 24/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BigInt
import UIKit

class TestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func click() {
        TransactionManager.showRNCustomPaymentView(toAddress: "test", amount: BigUInt(0), data: Data()) { _ in
        }
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
