//
//  ChatRoomCell.swift
//  AliceX
//
//  Created by lmcmz on 20/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit
import SwiftMatrixSDK

class ChatRoomCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var avtarView: UIImageView!
    
    @IBOutlet var countView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(room: MXRoom) {
        guard let summary = room.summary else {
            return
        }
        nameLabel.text = summary.displayname
        let date = Date(timeIntervalSince1970: TimeInterval(summary.lastMessageOriginServerTs))
        timeLabel.text = date.formatToString()
        
        if let event = summary.lastMessageEvent, let body = event.content["body"] as? String {
            messageLabel.text = body
            
        }
        
        countView.isHidden = true
        if summary.notificationCount != 0 {
            countView.isHidden = false
            countLabel.text = String(summary.notificationCount)
        }
        
        if summary.avatar != nil {
            avtarView.setMXImage(mxString: summary.avatar)
        }
        
    }
}
