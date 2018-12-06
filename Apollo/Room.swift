//
//  Room.swift
//  Apollo
//
//  Created by Christopher Runyan on 12/1/18.
//  Copyright © 2018 Christopher Runyan. All rights reserved.
//

import Foundation

class Room {
    var roomName: String
    var roomCode: String
    var roomOwner: String
    var spotifyAccessToken: String
    var spotifyRefreshToken: String
    var songs = [Song]()
    
    init() {
        roomName = "roomName"
        roomCode = "roomCode"
        roomOwner = "roomOwner"
        spotifyAccessToken = "spotifyAccessToken"
        spotifyRefreshToken = "spotifyRefreshToken"
    }
    
    init(roomName: String, roomCode: String, roomOwner: String) {
        self.roomName = roomName
        self.roomCode = roomCode
        self.roomOwner = roomOwner
        spotifyAccessToken = ""
        spotifyRefreshToken = ""
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
    
    public func getSpotifyAccessToken() -> String {
        return spotifyAccessToken
    }
    
    public func getSongs() -> [Song] {
        return songs
    }
    
    public func setRoomCode(roomCode: String) {
        self.roomCode = roomCode
    }
    
    public func setSpotifyAccessRoken(accessToken: String) {
        self.spotifyAccessToken = accessToken
    }
    
    public func setSpotifyRefreshToken(refreshToken: String) {
        self.spotifyRefreshToken = refreshToken
    }
    
    public func setSongs(songs: [Song]) {
        self.songs = songs
    }
    
    public func removeAllSongs() {
        songs.removeAll()
    }
    
    public func printRoom() {
        print("Room Name: ", self.roomName)
        print("Room Code: ", self.roomCode)
        print("Room Owner: ", self.roomOwner)
        print("Spotify Access Token: ", self.spotifyAccessToken)
        print("Songs: ")
        for song in songs {
            print(song.printSong())
        }
     }
}
