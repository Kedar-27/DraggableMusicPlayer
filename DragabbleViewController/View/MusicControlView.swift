//
//  MusicControlView.swift
//  DragabbleViewController
//
//  Created by Kedar Sukerkar on 21/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import UIKit

class MusicControlView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var suffleButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var disLikeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    // MARK: - Properties
    
    
    
    
    
    
    
    // MARK: - UIView
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    
    
    func setupView(){
        
        self.durationSlider.minimumValue = 0
        self.durationSlider.value = 0
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    

}
