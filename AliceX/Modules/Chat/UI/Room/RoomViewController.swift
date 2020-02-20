//
//  RoomViewController.swift
//  AliceX
//
//  Created by lmcmz on 20/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit
import ESPullToRefresh
import SwiftMatrixSDK

class RoomViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    
    var rooms: [MXRoom] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(nibName: ChatRoomCell.nameOfClass)
        
        tableView.refreshIdentifier = RoomViewController.nameOfClass
        tableView.expiredTimeInterval = 10.0
        let animator = RoomRefreshAnimator(frame: CGRect.zero)
        tableView.es.addPullToRefresh(animator: animator) {
            self.requestData()
        }
    }
    
    func requestData() {
//        delay(3) {
//            self.tableView.es.stopPullToRefresh()
//        }
        
        titleLabel.text = "Loading.."
        
        MatrixManager.shared.fetchRooms().done { rooms in
            self.rooms = rooms
            self.tableView.reloadData()
        }.ensure {
            self.titleLabel.text = "Chat"
            self.tableView.es.stopPullToRefresh()
        }.catch { error in
            HUDManager.shared.showError(error: error)
        }
    }
    
}

extension RoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatRoomCell.nameOfClass, for: indexPath) as! ChatRoomCell
        let room = rooms[indexPath.row]
        cell.configure(room: room)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = rooms[indexPath.row]
        let vc = ChatViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
