//
//  PlaylistHelper.swift
//  DragabbleViewController
//
//  Created by Kedar Sukerkar on 22/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import UIKit
import AVFoundation


struct MusicPlayerImages {
    static let playImage = UIImage(named: "play") ?? UIImage()
    static let pauseImage = UIImage(named: "pause") ?? UIImage()
    static let prevImage = UIImage(named: "previous") ?? UIImage()
    static let nextImage = UIImage(named: "next") ?? UIImage()
    static let shuffleImage = UIImage(named: "shuffle") ?? UIImage()
    static let repeatImage = UIImage(named: "repeat") ?? UIImage()
    static let shareImage = UIImage(named: "share") ?? UIImage()
    static let likeImage = UIImage(named: "like") ?? UIImage()
    
}








class PlaylistHelper: NSObject{
    
    // MARK: - Properties
    static let shared = PlaylistHelper()
    
    var mediaURLs:[String] = []{
        didSet{
            self.playerItems = self.getAVPlayerItems()
        }
    }
    
    var playerItems = [AVPlayerItem]()
    
    
    
    // MARK: - Helper Methods
    func getAVPlayerItems() -> [AVPlayerItem]{
        var playerItems = [AVPlayerItem]()
        
        self.mediaURLs.forEach { (string) in
            if let url = URL(string: string){
                let asset = AVAsset(url: url)
                let playerItem = AVPlayerItem(asset: asset)
                playerItems.append(playerItem)
            }
        }
        return playerItems
    }
    
    
    ///Get AVQueuePlayer instance
    func getAVQueuePlayer() -> AVQueuePlayer{
        let queuePlayer = AVQueuePlayer(items: self.playerItems)
        return queuePlayer
    }
    
    
    ///Get AVQueuePlayer
    func initializeAVQueuePlayer(from url: String) -> AVQueuePlayer{
        guard let generatedURL = URL(string: url) else{
            return AVQueuePlayer(url: URL(string: "")!)
        }
        
        return AVQueuePlayer(playerItem: AVPlayerItem(url: generatedURL))
    }
    
    //Get Music player formatted time from CMTime
    func getTimeString(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        
        if totalSeconds.isNaN{
            return "00:00"
        }
        
        
        let hours = Int(totalSeconds/3600)
        let minutes = Int(totalSeconds/60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        }else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
    }
}





