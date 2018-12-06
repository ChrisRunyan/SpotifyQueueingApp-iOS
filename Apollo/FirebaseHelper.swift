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
//    var songs = [String]()
    var songArray = [Song]()
    var songsExist = false
    var roomCodeExists = false
    var indexOfDeletedSong = 0
    
    // get array of room id's
    public func buildRoomCodeArray() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        roomCodes.removeAll()
        
        ref.observeSingleEvent(of: .value) { snapshot in
            for object in snapshot.children.allObjects as! [DataSnapshot] {
                for child in object.children.allObjects as! [DataSnapshot] {
                    //                    print("*******room code: ", child.childSnapshot(forPath: "room_code").value!)
//                    print("key: ", child.key)
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
    
    public func updateLikeForSong(roomCode: String, songID: String, totalLikes: NSInteger) {
        print("inside of update like for song reference!")
//        let key = "votes"
        var ref: DatabaseReference!
        ref = Database.database().reference()
        var path = "rooms/"
        
        print("comparing song id: ", songID)
        
        ref.observeSingleEvent(of: .value) { snapshot in
            for object in snapshot.children.allObjects as! [DataSnapshot] {
                for child in object.children.allObjects as! [DataSnapshot] {
                    if(child.childSnapshot(forPath: "room_code").value! as! String == roomCode) {
                        path = path + child.key + "/songs/"
                        if(child.childSnapshot(forPath: "songs").exists()) {
                            print("songs exist")
                            for song in child.childSnapshot(forPath: "songs").children.allObjects as! [DataSnapshot] {
                                if(song.childSnapshot(forPath: "id").value! as! String == songID) {
                                    print("song id exists")
                                    path = path + song.key + "/votes"
//                                    song.childSnapshot(forPath: "votes").setValue(totalLikes, forKey: "votes")
//                                    song.setValue(totalLikes, forKey: "votes")
                                }
                            }
                        }
                    }
                }
            }
            
            print("updating path: ", path)
            ref.updateChildValues([path: totalLikes])
        }
    }
    
    // write new room data
    public func addRoomToDB(roomToAdd: Room) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let dict = ["room_code": roomToAdd.getRoomCode(), "room_name": roomToAdd.getRoomName(), "room_owner": roomToAdd.getRoomOwner(), "spotify_access_token": roomToAdd.getSpotifyAccessToken()]
        
        ref.child("rooms").childByAutoId().setValue(dict)
        
        // **TEMP FOR TESTING** add "Snow" to room
    }
    
    public func loadSongsFromRoomCode(roomCode: String) {
        songArray.removeAll()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        roomCodes.removeAll()
        
        ref.observeSingleEvent(of: .value) { snapshot in
            for object in snapshot.children.allObjects as! [DataSnapshot] {
                for child in object.children.allObjects as! [DataSnapshot] {
                    if(child.childSnapshot(forPath: "room_code").value! as! String == roomCode) {
                        if(child.childSnapshot(forPath: "songs").exists()) {
                            for song in child.childSnapshot(forPath: "songs").children.allObjects as! [DataSnapshot] {
//                                self.songs.append(song.childSnapshot(forPath: "id").value! as! String)
                                var duplicate = false
                                
                                for song2 in self.songArray {
                                    if song2.getSongID() == song.childSnapshot(forPath: "id").value as! String {
                                        duplicate = true
                                    }
                                }
                                
                                print("song child: ", song.key)
                                
                                if (duplicate == false ) {
                                    let songID = song.childSnapshot(forPath: "id").value! as! String
                                    let songVotes = song.childSnapshot(forPath: "votes").value! as! NSInteger
                                    let songName = song.childSnapshot(forPath: "name").value! as! String
                                    let artistName = song.childSnapshot(forPath: "artist").childSnapshot(forPath: "name").value! as! String
                                    //                                self.songArray.append(Song(songID: song.childSnapshot(forPath: "id").value! as! String))
                                    
                                    self.songArray.append(Song(artist: artistName, songName: songName, songID: songID, votes: songVotes))
                                    //                                print("**song firebase id: ", song.key)
                                    print("creted new song")
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        
        
        // order songs in array based off number of likes
    }
    
//    public func getSongs() -> [String] {
//        return self.songs
//    }
    
    public func getSortedSongArray(unsortedArray: [Song]) -> [Song] {
        var tempArray = unsortedArray
        var arrayToReturn = [Song]()
        var currentHighestVote = 0
        var songWithGreatestVotes = Song()
        var songWithGreatestVotesIndex = 0
        
        for song in tempArray {
            // find highest song
            songWithGreatestVotes = getSongWithMostVotes(myArray: tempArray)
            
            // add to array to return
            arrayToReturn.append(songWithGreatestVotes)
            
            // remove from tempArray
            tempArray.remove(at: indexOfDeletedSong)
        }
        
        print("sorted array: ")
        for song in arrayToReturn {
            song.printSong()
        }
        
        
        return arrayToReturn
    }
    
    public func removeSongs() {
        songArray.removeAll()
    }
    
    private func getSongWithMostVotes(myArray: [Song]) -> Song {
        var toReturn = myArray.first
        print("size of myArray: ", myArray.count)
        var index = 0
        indexOfDeletedSong = index
        
        
        for song in myArray {
            print("trying index ", index)
            if song.getVotes() > (toReturn?.getVotes())! {
                indexOfDeletedSong = index
                toReturn = song
            }
            
            index = index + 1
        }
        
        return toReturn!
    }
    
    public func getSongArray() -> [Song] {
        return self.songArray
    }
}
