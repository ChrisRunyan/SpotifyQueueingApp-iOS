//
//  PlaylistViewController.swift
//  Apollo
//
//  Created by Christopher Runyan on 11/20/18.
//  Copyright © 2018 Christopher Runyan. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {
    var roomType = String()
    var roomID = String()
    var fHelper = FirebaseHelper()
    var sHelper = SpotifyHelper()
    var myRoom = Room()
    var wroteRoom = false
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var playPauseButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        print("inside of playlist view controller!!!!!")
        super.viewDidLoad()
        
        playPauseButton.title = "Play"
        
        print("room before: ")
        myRoom.printRoom()
        
        loadRoomInfo()
        
        print("room: ")
        myRoom.printRoom()
        
        if(roomType == "owner") {
            
            playPauseButton.isEnabled = true
        }
        else if(roomType == "guest") {
            playPauseButton.isEnabled = false
        }
    }
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        
        if(playPauseButton.title == "Play") {
            // try to play first song in song array in room
            self.playPauseButton.title = "Pause"
//            SpotifyLoginViewController.playSong(songID: myRoom.songs.first!.getSongID())
            // if this comment is stil here then we are good :)
            sHelper.playSong(songID: (myRoom.getSongs().first?.getSongID())!)
//            sHelper.playSong(songID: "2aibwv5hGXSgw7Yru8IYTO")
        }
        else if(playPauseButton.title == "Pause"){
            // try to pause first song in song array in room
            self.playPauseButton.title = "Play"
            sHelper.pauseSong()
        }
    }
    
    private func loadRoomInfo() {
        loadSongs()
        // load updated list of users?
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        print(roomType, " : ", wroteRoom)
        if(roomType == "owner" && wroteRoom == false) {
            print("set access token to: ", sHelper.getSpotifyAccessToken())
            myRoom.setSpotifyAccessRoken(accessToken: sHelper.getSpotifyAccessToken())
            fHelper.addRoomToDB(roomToAdd: myRoom)
            wroteRoom = true
        }
        
        myRoom.removeAllSongs()
        fHelper.loadSongsFromRoomCode(roomCode: myRoom.getRoomCode())
        
        let sv = UIViewController.displaySpinner(onView: self.view)
         DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIViewController.removeSpinner(spinner: sv)
            self.loadSongs()
            print(self.fHelper.getSongArray())
        }
        
    }
    
    private func loadSongs() {
        myRoom.removeAllSongs()
        print("$$$$$$$total songs: ", myRoom.getSongs().count)
        fHelper.removeSongs()
        // load songs given room code and place into Room object
        fHelper.loadSongsFromRoomCode(roomCode: myRoom.roomCode)
        
        print("fHelper songs array before: ", fHelper.getSongArray().count)
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIViewController.removeSpinner(spinner: sv)
            print("fHelper songs array after: ", self.fHelper.getSongArray().count)
            self.myRoom.setSongs(songs: self.fHelper.getSongArray())
            
//            self.myRoom.setSongs(songs: self.fHelper.getSortedSongArray(unsortedArray: self.myRoom.getSongs()))
            
            print("$$$$$$$total songs after: ", self.myRoom.getSongs().count)
            
            self.createSongButtons()
            // update list of songs in playlist view
            
            print("room after songs loaded: ")
            self.myRoom.printRoom()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if(roomType == "owner") {
            self.performSegue(withIdentifier: "backToCreateRoomSegue", sender: nil)
        }
        else if(roomType == "guest") {
            self.performSegue(withIdentifier: "backToJoinRoomSegue", sender: nil)
        }
    }
    
    public func setRoomType(roomType: String) {
        self.roomType = roomType
    }
    
    public func setFirebaseHelper(fHelper: FirebaseHelper) {
        self.fHelper = fHelper
    }

    public func setRoom(myRoom: Room) {
        self.myRoom = myRoom
    }
    
    public func setSpotifyHelper(helper: SpotifyHelper) {
        self.sHelper = helper
    }
    
    func createSongButtons() {
        var buttonY: CGFloat = 0
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
//        var scrollView: UIScrollView!
        let storyMultiplier: CGFloat = CGFloat(myRoom.getSongs().count)
        let contentSizeHeight: CGFloat = (30*storyMultiplier)+(10*storyMultiplier)
        let height = screenHeight-100
//        scrollView = UIScrollView(frame: CGRect(x: 0, y: 120, width: screenWidth, height: screenHeight-180))
        
        var count=0
        for song in myRoom.getSongs() {
            let songButton = UIButton(frame: CGRect(x: ((screenWidth/2)-182), y: buttonY, width: (screenWidth-11), height: 30))
            buttonY = buttonY + 40
            
            var songName = song.getSongName()
            var songArtist = song.getArtist()
            var songVotes = String(song.getVotes())
            var songInfoBeginning = songName + " - " + songArtist
            
            var titleText = songInfoBeginning + " (" + songVotes + ")"
            
            songButton.layer.cornerRadius = 6
            songButton.layer.borderWidth = 1
            songButton.backgroundColor = UIColor.white
            songButton.setTitleColor(UIColor.black, for: .normal)
            songButton.setTitle(titleText, for: UIControl.State.normal)
            songButton.addTarget(self, action: #selector(songButtonPressed), for: UIControl.Event.touchUpInside)
            
            scrollView.addSubview(songButton)
            count = count+1
        }
        
        if(buttonY<height) {
            scrollView.isScrollEnabled = false
            print("inside of basic, scrolling is disabled")
        }
        else{
            scrollView.isScrollEnabled = true
            print("inside of basic, scrolling is enabled")
        }
        
        scrollView.contentSize = CGSize(width: screenWidth, height: contentSizeHeight)
        view.addSubview(scrollView)
    }
    
    @objc func songButtonPressed(sender: UIButton!) {
        let label = sender.titleLabel?.text
        var title = label!.components(separatedBy: "-")
        var idToUpdate = ""
        var votesToUpdateTo = 0
        
        for song in myRoom.getSongs() {
            print("title at 0: ", title[0])
            if title[0] == song.getSongName() {
                print("match!")
                idToUpdate = song.getSongID()
                votesToUpdateTo = song.getVotes() + 1
            }
        }
    
        // add one to like and push to Firebase
        print("about to update likes for song in: ", myRoom.getRoomCode())
//        fHelper.updateLikeForSong(roomCode: myRoom.getRoomCode(), songID: "2RSVYvx9kGLbyyJ4bmRMbc", totalLikes: 5)
//        fHelper.updateLikeForSong(roomCode: myRoom.getRoomCode(), songID: idToUpdate, totalLikes: votesToUpdateTo)
        fHelper.updateLikeForSong(roomCode: myRoom.getRoomCode(), songID: (myRoom.getSongs().first?.getSongID())!, totalLikes: ((myRoom.getSongs().first?.getVotes())! + 1))
        print("song button pressed!")
    }
}
