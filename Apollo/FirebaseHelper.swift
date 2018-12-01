//
//  FirebaseHelper.swift
//  Apollo
//
//  Created by Christopher Runyan on 11/20/18.
//  Copyright © 2018 Christopher Runyan. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

class FirebaseHelper {
    var roomCodes = [String]()
    var roomCodeExists = false
    
    // get array of room id's
    public func buildRoomCodeArray() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        roomCodes.removeAll()
        
        ref.observeSingleEvent(of: .value) { snapshot in
            for object in snapshot.children.allObjects as! [DataSnapshot] {
                for child in object.children.allObjects as! [DataSnapshot] {
                    //                    print("*******room code: ", child.childSnapshot(forPath: "room_code").value!)
                        
                    // add each room code to the room codes array
                    self.roomCodes.append(child.childSnapshot(forPath: "room_code").value! as! String)
                }
            }
        }
    }
    
    // check if room code exists
    public func updateRoomCodeExists(roomCode: String) {
        buildRoomCodeArray()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.roomCodes.contains(roomCode) {
                self.roomCodeExists = true
            }
            
            print("array after delay: ", self.roomCodes)
        }
//        delayForFirebase()

//        return roomCodeExists
    }
    
    // write new room data
    public func addRoomToDB(roomToAdd: Room) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let dict = ["room_code": roomToAdd.getRoomCode(), "room_name": roomToAdd.getRoomName(), "room_owner": roomToAdd.getRoomOwner()]
        ref.child("rooms").childByAutoId().setValue(dict)
    }
    
    // get room id given room code
    
    
    
    // write delete room to existing room
    
    // write new song to existing room
    
    // wring delete song to existing room
    
    // write like song to existing room
    
    // write dislike song to existing room
    
    // load next song from existing room
}
