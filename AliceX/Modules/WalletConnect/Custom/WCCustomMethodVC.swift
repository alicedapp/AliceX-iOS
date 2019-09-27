//
//  WCCustomMethodVC.swift
//  AliceX
//
//  Created by lmcmz on 27/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import WalletConnectSwift

class WCCustomMethodVC: BaseViewController {

    var isServer: Bool = true
    @IBOutlet var textView: UITextView!
    @IBOutlet var methodLabel: UITextField!
    var placeholderLabel: UILabel!
    
    @IBOutlet var responseView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Parameter"
        placeholderLabel.font = UIFont.systemFont(ofSize: (textView.font?.pointSize)!, weight: .medium)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    @IBAction func send(){
        
        if methodLabel.text!.isEmptyAfterTrim() {
            HUDManager.shared.showError(text: "Method Name can't be empty")
            return
        }
        
        if isServer {
            WCServerHelper.shared.sendCustomRequest(method: methodLabel.text!, message: [textView.text])
            return
        }
        
        WCClientHelper.shared.sendCustomRequest(method: methodLabel.text!,
                                                message: [textView.text]) { (repsonse) in
                                                    self.handleReponse(response: repsonse)
        }
    }
    
    func handleReponse(response: Response) {
        onMainThread {
            do {
                let result = try response.result(as: String.self)
                self.responseView.text = result
            } catch {
                HUDManager.shared.showError(text: "Parse response failed")
            }
        }
    }
}


extension WCCustomMethodVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
