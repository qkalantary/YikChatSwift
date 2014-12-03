//
//  global.swift
//  YikChatSwift
//
//  Created by Q Kalantary on 12/2/14.
//  Copyright (c) 2014 Q Kalantary. All rights reserved.
//

import Foundation
import MultipeerConnectivity
class Global {
    var peerID:MCPeerID
    init(name:MCPeerID) {
        self.peerID = name
    }
    func setName(set:String){
        self.peerID = MCPeerID(displayName: set)
    }
}
var global = Global(name: MCPeerID(displayName: UIDevice.currentDevice().name))