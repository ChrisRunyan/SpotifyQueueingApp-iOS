//
//  Song.swift
//  Apollo
//
//  Created by Christopher Runyan on 12/5/18.
//  Copyright © 2018 Christopher Runyan. All rights reserved.
//

import Foundation

class Song {
    var artist: String
    var songName: String
    var songID: String
    var votes: NSInteger
    
    init() {
        artist = "artist"
        songName = "songName"
        songID = "songID"
        votes = 0
    }
    
    init(songID: String) {
        artist = "artist"
        songName = "songName"
        self.songID = songID
        votes = 0
    }
    
    init(artist: String, songName: String, songID: String, votes: NSInteger) {
        self.artist = artist
        self.songName = songName
        self.songID = songID
        self.votes = votes
    }
    
    public func getArtist() -> String {
        return artist
    }
    
    public func getSongName() -> String {
        return songName
    }
    
    public func getSongID() -> String {
        return songID
    }
    
    public func getVotes() -> NSInteger {
        return votes
    }
    
    public func setArtist(artist: String) {
        self.artist = artist
    }
    
    public func setSongName(songName: String) {
        self.songName = songName
    }
    
    public func setSongID(songID: String) {
        self.songID = songID
    }
    
    public func setVotes(votes: NSInteger) {
        self.votes = votes
    }
    
    public func printSong() {
        print("Name: ", self.songName)
        print("Artist: ", self.artist)
        print("ID: ", self.songID)
        print("Votes: ", self.votes)
    }
 }
