//
//  PlaylistViewController.swift
//  Apollo
//
//  Created by Christopher Runyan on 11/20/18.
//  Copyright © 2018 Christopher Runyan. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {
    // if owner, allow playback through Spotify
    // if guest, just edit Firebase database
    // back button goes back to create/join, based off where it came from previously
    
    var roomType = String()
    var roomID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(roomType == "owner") {
            loadRoomForOwner()
        }
        else if(roomType == "guest") {
            loadRoomForGuest()
        }
    }
    
    private func loadRoomForOwner() {
        
    }
    
    private func loadRoomForGuest() {
        
    }
    
    public func setRoomType(roomType: String) {
        self.roomType = roomType
    }

}
