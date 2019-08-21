//
//  MusicData.swift
//  DragabbleViewController
//
//  Created by Kedar Sukerkar on 20/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import Foundation


class MusicData: NSObject{
    
   static var data: [Music] = [Music(id: 1, image: "1.jpg", url: "", title: "1 Song Title", subtitle: "1 Subtitle of Song 1"),
                         Music(id: 1, image: "2.jpg", url: "", title: "2 Song Title", subtitle: "2 Subtitle of Song 2"),
                         Music(id: 1, image: "3.jpg", url: "", title: "3 Song Title", subtitle: "3 Subtitle of Song 3"),
                         Music(id: 1, image: "4.jpg", url: "", title: "4 Song Title", subtitle: "4 Subtitle of Song 4"),
                         Music(id: 1, image: "5.jpg", url: "", title: "5 Song Title", subtitle: "5 Subtitle of Song 5"),
                         Music(id: 1, image: "6.jpg", url: "", title: "6 Song Title", subtitle: "6 Subtitle of Song 6"),
                         Music(id: 1, image: "7.jpg", url: "", title: "7 Song Title", subtitle: "7 Subtitle of Song 7")
                         ]
}

struct Music{
    var id: Int
    var image: String
    var url: String
    var title: String
    var subtitle: String
}

