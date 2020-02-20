//
//  MatrixManager.swift
//  AliceX
//
//  Created by lmcmz on 19/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import Foundation
import SwiftMatrixSDK
import PromiseKit

class MatrixManager {
    static let shared = MatrixManager()
    let serverURL = URL(string: "https://matrix.org")!
    
    var client: MXRestClient
    var fileStore: MXFileStore?
    var session: MXSession?
    var media: MXMediaManager
    
    init() {
        media = MXMediaManager.init(homeServer: serverURL.absoluteString)
        client = MXRestClient(homeServer: serverURL, unrecognizedCertificateHandler: nil)
//        fileStore = MXFileStore()
        login().done { _ in
            self.setStore()
        }
    }
    
    func login() -> Promise<MXCredentials> {
        return Promise<MXCredentials> { seal in
            client.login(type: .password, username: "testalice", password: "alice2020") { response in
                response.done(seal: seal) { credential in
                    self.client = MXRestClient(credentials: credential, unrecognizedCertificateHandler: nil)
                    self.fileStore = MXFileStore(credentials: credential)
                    self.session = MXSession(matrixRestClient: self.client)
                }
            }
        }
    }
    
    func setStore() -> Promise<Void> {
        return Promise<Void> { seal in
            guard let store = self.fileStore else {
                seal.reject(MyError.FoundNil("Matrix file store nil"))
                return
            }
            session?.setStore(store, completion: { response in
                response.done(seal: seal)
            })
        }
    }
    
    func fetchRooms() -> Promise<[MXRoom]> {
        if client.credentials == nil {
            return Promise<[MXRoom]> { seal in seal.reject(MyError.FoundNil("Chat not login yet")) }
        }
        
        return Promise<[MXRoom]> { seal in
            session?.start(completion: { response in
                switch response {
                case .success:
                    seal.fulfill(self.session!.rooms)
                case .failure(let error):
                    seal.reject(error)
                }
            })
        }
    }
    
    func test() {
        
//        firstly {
//            login()
//        }.then { _ in
//            self.setStore()
//        }.then {
//            self.fetchRooms()
//        }.done { rooms in
//            guard let rooms = self.session?.rooms, let room = rooms.last else {
//                return
//            }
//
//            room.liveTimeline { timeline in
//
//                timeline?.resetPagination()
//                timeline?.paginate(10, direction: .backwards, onlyFromStore: false, completion: { response in
//                    for event in room.enumeratorForStoredMessages.nextEventsBatch(room.storedMessagesCount) {
//                        print(event.content)
//                        print("CCCCC")
//                    }
//                })
//            }
//
////            self.client.sendTextMessage(toRoom: room.roomId, text: "TTTTEST") { reponse in
////                print("AAAAA")
////            }
//        }
        
//        client.login(username: "testalice", password: "alice2020") { response in
//            if response.isSuccess, let value = response.value {
//                print(value.accessToken)
//                print("AAAA")
//            }
//        }
        
        client.publicRooms(onServer: "https://matrix.org", limit: 10) { response in
            switch response {
            case .success(let rooms):

                // rooms is an array of MXPublicRoom objects containing information like room id
                print("The public rooms are: \(rooms)")

            case .failure:
                break
            }
        }
        

        
//        operation.
    }
}
