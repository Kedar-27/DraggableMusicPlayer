//
//  MusicData.swift
//  DragabbleViewController
//
//  Created by Kedar Sukerkar on 20/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import Foundation


class MusicData: NSObject{
    
   static var data: [Music] = [Music(id: 1, image: "1.jpg", url: "https://download.mp3-zz.xyz/n/Queen-Bohemian-Rhapsody.mp3", title: "Queen", subtitle: "1 Subtitle of Song 1"),
                         Music(id: 2, image: "2.jpg", url: "https://download.mp3-zz.xyz/n/Zayn-feat-Sia-Dusk-Till-Dawn.mp3", title: "Dusk-Till-Dawn", subtitle: "2 Subtitle of Song 2"),
                         Music(id: 3, image: "3.jpg", url: "https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_5MG.mp3", title: "3 Song Title", subtitle: "3 Subtitle of Song 3"),
                         Music(id: 4, image: "4.jpg", url: "https://download.mp3-zz.xyz/n/Drake-Hotline-Bling.mp3", title: "Hotline-Bling", subtitle: "4 Subtitle of Song 4"),
                         Music(id: 5, image: "5.jpg", url: "http://latestmp3songs.in/siteuploads/files/sfd1/127/Shape%20of%20You%20-%20Ed%20Sheeran%20320Kbps(LatestMp3Songs.in).mp3", title: "Shape of You", subtitle: "5 Subtitle of Song 5")
                         ]
}

struct Music{
    var id: Int
    var image: String
    var url: String
    var title: String
    var subtitle: String
}

