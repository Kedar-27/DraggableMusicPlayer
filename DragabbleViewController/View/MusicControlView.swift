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
    @IBOutlet weak var durationSlider: ILAudioSlider!
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
        
        self.durationSlider.isContinuous = true
        
        
    }
    
    
    
    
    
    
    
    
    
    
    

}


class ILAudioSlider: UISlider {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.minimumTrackTintColor = #colorLiteral(red: 0.228225857, green: 0.8170934319, blue: 0.7601050735, alpha: 1)
        
        self.setThumbImage()
    }
    
    
    

    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let rect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        return CGRect(x: rect.origin.x, y: rect.origin.y + 2, width: rect.width, height: rect.height)
    }
    
    fileprivate func setThumbImage() {
        
        UIGraphicsBeginImageContext(CGSize(width: 15, height: 15))
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(#colorLiteral(red: 0.228225857, green: 0.8170934319, blue: 0.7601050735, alpha: 1))
        context?.addEllipse(in: CGRect(x: 0, y: 0, width: 13, height: 13))
        context!.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setThumbImage(image, for: .normal)
    }
    
    
}
