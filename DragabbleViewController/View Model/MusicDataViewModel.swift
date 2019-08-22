//
//  MusicDataViewModel.swift
//  DragabbleViewController
//
//  Created by Kedar Sukerkar on 20/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import Foundation


class MusicDataViewModel: NSObject{

    static let shared = MusicDataViewModel()
    private override init() {
        self.currentMusicItem = DynamicValue(MusicData.data.first!)
        super.init()
        
    }
    
    
    var currentMusicItem: DynamicValue<Music>
    var musicData: DynamicValue<[Music]> = DynamicValue(MusicData.data)
    
}






