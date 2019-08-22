//
//  PlaylistHelper.swift
//  DragabbleViewController
//
//  Created by Kedar Sukerkar on 22/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import Foundation
import AVFoundation



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

}





