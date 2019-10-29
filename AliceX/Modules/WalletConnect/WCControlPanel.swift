//
//  WCControlPanel.swift
//  AliceX
//
//  Created by lmcmz on 26/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import BonMot
import UIKit

class WCControlPanel: BaseViewController {
    @IBOutlet var serverTime: UILabel!
    @IBOutlet var serverView: UIImageView!
    @IBOutlet var serverLabel: UILabel!
    @IBOutlet var serverDesc: UILabel!
    @IBOutlet var serverSwitch: UISwitch!
    var serverTimer: Timer!

    @IBOutlet var clientTime: UILabel!
    @IBOutlet var clientView: UIImageView!
    @IBOutlet var clientLabel: UILabel!
    @IBOutlet var clientDesc: UILabel!
    @IBOutlet var clientSwitch: UISwitch!
    var clientTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(clientConnect),
                                               name: .wallectConnectClientConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clientDisconnect),
                                               name: .wallectConnectClientDisconnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(serverConnect),
                                               name: .wallectConnectServerConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(serverDisconnect),
                                               name: .wallectConnectServerDisconnect, object: nil)

        serverUpdate()
        clientUpdate()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        if serverTimer != nil {
            serverTimer.invalidate()
            serverTimer = nil
        }
    }

    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    @IBAction func serverCustomClick() {
        let vc = WCCustomMethodVC()
        vc.isServer = true
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func clientCustomClick() {
        let vc = WCCustomMethodVC()
        vc.isServer = false
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WCControlPanel {
    func serverUpdate() {
        let blueStyle = StringStyle(
            .color(AliceColor.blue),
            .font(UIFont.systemFont(ofSize: 18, weight: .semibold))
        )

        let fishStyle = StringStyle(
            .font(UIFont.systemFont(ofSize: 18)),
            .lineHeightMultiple(1.2),
            .color(.darkGray),
            .xmlRules([
                .style("blue", blueStyle),
            ])
        )

        if let session = WCServerHelper.shared.session {
            let serverInfo = session.dAppInfo.peerMeta
            serverView.kf.setImage(with: serverInfo.icons.first, placeholder: Constant.placeholder)
            serverLabel.text = serverInfo.name
            serverDesc.text = (serverInfo.description?.isEmptyAfterTrim())! ? serverInfo.url.host! : serverInfo.description
            serverSwitch.isOn = true
        } else {
            serverView.image = Constant.placeholder
            serverLabel.text = "No connection"
            serverDesc.text = "No description"
            serverSwitch.isOn = false
        }

        if let date = WCServerHelper.shared.connectedDate {
            serverTimer = Timer(timeInterval: 1, repeats: true, block: { _ in
                let now = Date()
                let seconds = now.timeIntervalSince(date)
                let (h, m, s) = self.secondsToHoursMinutesSeconds(seconds: Int(seconds))
                let content = "<blue>DApp</blue> - \(h):\(m):\(s)"
                let attributedString = content.styled(with: fishStyle)
                self.serverTime.attributedText = attributedString
            })

            RunLoop.main.add(serverTimer, forMode: .common)
            serverTimer.fire()
        }
    }

    @IBAction func serverSwicther(sw: UISwitch) {
        if !sw.isOn {
            WCServerHelper.shared.disconnect()
            return
        }

        sw.setOn(false, animated: true)
        let vc = QRCodeReaderViewController()
        if let navi = self.navigationController {
            navi.pushViewController(vc, animated: true)
            return
        }
        vc.presentAsStork(vc)
    }

    @objc func serverConnect() {
        onMainThread {
            self.serverSwitch.setOn(true, animated: true)
            self.serverUpdate()
        }
    }

    @objc func serverDisconnect() {
        onMainThread {
            self.serverSwitch.setOn(false, animated: true)

            if self.serverTimer != nil {
                self.serverTimer.invalidate()
            }
            self.serverTimer = nil

            self.serverUpdate()
        }
    }
}

extension WCControlPanel {
    func clientUpdate() {
        let blueStyle = StringStyle(
            .color(AliceColor.blue),
            .font(UIFont.systemFont(ofSize: 18, weight: .semibold))
        )

        let fishStyle = StringStyle(
            .font(UIFont.systemFont(ofSize: 18)),
            .lineHeightMultiple(1.2),
            .color(.darkGray),
            .xmlRules([
                .style("blue", blueStyle),
            ])
        )

        guard let walletConnecnt = WCClientHelper.shared.walletConnect,
            let session = walletConnecnt.session,
            let clientInfo = session.walletInfo?.peerMeta else {
            clientView.image = Constant.placeholder
            clientLabel.text = "No connection"
            clientDesc.text = "No description"
            clientSwitch.isOn = false
            return
        }

        if let date = WCClientHelper.shared.connectedDate {
            clientTimer = Timer(timeInterval: 1, repeats: true, block: { _ in
                let now = Date()
                let seconds = now.timeIntervalSince(date)
                let (h, m, s) = self.secondsToHoursMinutesSeconds(seconds: Int(seconds))
                let content = "<blue>Wallet</blue> - \(h):\(m):\(s)"
                let attributedString = content.styled(with: fishStyle)
                self.clientTime.attributedText = attributedString
            })

            RunLoop.main.add(clientTimer, forMode: .common)
            clientTimer.fire()
        }

        clientView.kf.setImage(with: clientInfo.icons.first, placeholder: Constant.placeholder)
        clientLabel.text = clientInfo.name
        clientDesc.text = (clientInfo.description?.isEmptyAfterTrim())! ? clientInfo.url.host! : clientInfo.description
        clientSwitch.isOn = true
    }

    @IBAction func clientSwicther(sw: UISwitch) {
        if !sw.isOn {
            WCClientHelper.shared.disconnect()
        } else {
            WCClientHelper.shared.create()
            sw.setOn(false, animated: true)
        }
    }

    @objc func clientConnect() {
        onMainThread {
            self.clientSwitch.setOn(true, animated: true)
            self.clientUpdate()
        }
    }

    @objc func clientDisconnect() {
        onMainThread {
            self.clientSwitch.setOn(false, animated: true)
            if self.clientTimer != nil {
                self.clientTimer.invalidate()
            }
            self.clientTimer = nil
            self.clientUpdate()
        }
    }
}
