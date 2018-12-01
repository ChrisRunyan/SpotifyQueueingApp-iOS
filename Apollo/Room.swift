//
//  Room.swift
//  Apollo
//
//  Created by Christopher Runyan on 12/1/18.
//  Copyright © 2018 Elon Rubin. All rights reserved.
//

import Foundation

class Room {
    var roomName: String
    var roomCode: String
    var roomOwner: String
    
    init() {
        roomName = "roomName"
        roomCode = "roomCode"
        roomOwner = "roomOwner"
    }
    
    init(roomName: String, roomCode: String, roomOwner: String) {
        self.roomName = roomName
        self.roomCode = roomCode
        self.roomOwner = roomOwner
    }
    
    public func getRoomName() -> String {
        return roomName
    }
    
    public func getRoomCode() -> String {
        return roomCode
    }
    
    public func getRoomOwner() -> String {
        return roomOwner
    }
}
