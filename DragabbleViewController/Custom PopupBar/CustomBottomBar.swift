//
//  CustomBottomBar.swift
//  DragabbleViewController
//
//  Created by Kedar Sukerkar on 16/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import UIKit
import AVFoundation
import LNPopupController


class CustomBottomBar: LNPopupCustomBarViewController {

    // MARK: - Constants
    static let storyboardIdentifier = "CustomBottomBar"
    static let storyboardName       = "Main"
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: MarqueeLabel!
    @IBOutlet weak var subtitleLabel: MarqueeLabel!
    @IBOutlet weak var trackImageView: UIImageView!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var durationProgressView: UIProgressView!
    
    
    
    
    // MARK: - Properties
    lazy var viewModel : MusicDataViewModel = {
        let viewModel = MusicDataViewModel.shared
        return viewModel
    }()
    
    var musicPlayer = MusicPlayer.shared
    
    
    
    
    // MARK: - Data Injections
    
    
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    
    override var wantsDefaultPanGestureRecognizer: Bool {
        get {
            return false
        }
    }
    
    
    
    func setupVC(){
        preferredContentSize = CGSize(width: -1, height: UIScreen.main.bounds.height * 0.1)
 
        titleLabel.tag = 201
        titleLabel.type = .continuous
        titleLabel.textAlignment = .left
        titleLabel.lineBreakMode = .byTruncatingHead
        titleLabel.speed = .duration(8.0)
        titleLabel.fadeLength = 15.0
        titleLabel.leadingBuffer = 10.0
        
        
        subtitleLabel.type = .continuous
        subtitleLabel.textAlignment = .left
        subtitleLabel.lineBreakMode = .byTruncatingHead
        subtitleLabel.speed = .duration(8.0)
        subtitleLabel.fadeLength = 15.0
        subtitleLabel.leadingBuffer = 10.0
        
        
        self.viewModel.currentMusicItem.addAndNotify(observer: self, completionHandler: { [weak self] (music) in
            self?.titleLabel.text = music.title
            self?.subtitleLabel.text = music.subtitle
            self?.trackImageView.image = UIImage(named: music.image)
        })
        
        
        self.musicPlayer.delegates.addDelegate(self)
        
        self.playButton.setImage(MusicPlayerImages.playImage, for: .normal)
        self.previousButton.setImage(MusicPlayerImages.prevImage, for: .normal)
        self.nextButton.setImage(MusicPlayerImages.nextImage, for: .normal)
        self.likeButton.setImage(MusicPlayerImages.likeImage, for: .normal)
        
        self.durationProgressView.progressTintColor = UIColor(red: 58/255, green: 208/255, blue: 194/255, alpha: 1)
        self.durationProgressView.progress = 0
    }
    
    func setupUI(){
     
        
        //
    }

    
    // MARK: - IBActions

    
    @IBAction func prevButtonClicked(_ sender: Any) {
        
        self.musicPlayer.playPrevious()
        
    }
    
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        
        self.musicPlayer.playNext()
        
        
        
    }
    
    
    
    @IBAction func playButtonClicked(_ sender: Any) {
        
        self.musicPlayer.play()
        
    }
    


}

extension CustomBottomBar: MusicPlayerDelegate{
    
    func playbackStateDidChange(player: AVPlayer, _ playbackState: MusicPlayerPlaybackState) {
        
        if playbackState == .paused{
            self.playButton.setImage(MusicPlayerImages.playImage, for: .normal)
            
        }else{
            self.playButton.setImage(MusicPlayerImages.pauseImage, for: .normal)
        }
    }
    
    func playerPlaybackDurationChanged(player: AVPlayer, currentTime: CMTime, totalTime: CMTime) {
        
        if !currentTime.seconds.isNaN , !totalTime.seconds.isNaN{
            self.durationProgressView.progress = Float(currentTime.seconds / totalTime.seconds)
        }
        
    }
    
    
    
    
    
}
