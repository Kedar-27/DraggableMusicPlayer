//
//  MusicPlayer.swift
//  DragabbleViewController
//
//  Created by Kedar Sukerkar on 22/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import Foundation
import AVFoundation

@objc public protocol MusicPlayerDelegate: class{
    @objc optional func playerStateDidChange(player: AVPlayer , _ playerState: MusicPlayerState)
    @objc optional func playbackStateDidChange(player: AVPlayer, _ playbackState: MusicPlayerPlaybackState)
    @objc optional func playerPlaybackDurationChanged(player: AVPlayer, currentTime: CMTime , totalTime: CMTime)
    @objc optional func musicMetaData(title: String , artistName: String)
    @objc optional func musicPlayerItemChanged(player: AVPlayer , item: AVPlayerItem ,url: String)
}

// MARK: - MusicPlayingState

/**
 `MusicPlayingState` is the Player playing state enum
 */

@objc public enum MusicPlayerPlaybackState: Int {
    
    /// Player is playing
    case playing
    
    /// Player is paused
    case paused
    
    /// Player is stopped
    case stopped
    
    /// Return a readable description
    public var description: String {
        switch self {
        case .playing: return "Player is playing"
        case .paused: return "Player is paused"
        case .stopped: return "Player is stopped"
        }
    }
}

// MARK: - MusicPlayerState

/**
 `MusicPlayerState` is the Player status enum
 */

@objc public enum MusicPlayerState: Int {
    
    /// URL not set
    case urlNotSet
    
    /// Player is ready to play
    case readyToPlay
    
    /// Player is loading
    case loading
    
    /// The loading has finished
    case loadingFinished
    
    /// Error with playing
    case error
    
    /// Return a readable description
    public var description: String {
        switch self {
        case .urlNotSet: return "URL is not set"
        case .readyToPlay: return "Ready to play"
        case .loading: return "Loading"
        case .loadingFinished: return "Loading finished"
        case .error: return "Error"
        }
    }
}




class MusicPlayer: NSObject{
    
    // MARK: - Properties
    static let shared = MusicPlayer()
    
    private override init() {}
  
 
    var delegates = MulticastDelegate<MusicPlayerDelegate>()
    
    var player: AVPlayer?
    /// Player current state of type `MusicPlayerState`
    open private(set) var state = MusicPlayerState.urlNotSet {
        didSet {
            guard oldValue != state , let player = player else { return }
            
            delegates.invokeDelegates { (delegate) in
                
                
                delegate.playerStateDidChange?(player: player, state)
                

            }
            
            
            
        }
    }
    
    /// Playing state of type `MusicPlaybackState`
    open private(set) var playbackState = MusicPlayerPlaybackState.stopped {
        didSet {
            
            
            guard oldValue != playbackState , let player = player else { return }
           
            
            delegates.invokeDelegates { (delegate ) in
                delegate.playbackStateDidChange!(player: player, playbackState)
            }
            
            
            
            
            
        }
    }
    
    /// The player starts playing when the player gets set. (default == false)
    open var isAutoPlay = false

    /// Check for headphones, used to handle audio route change
    private var headphonesConnected: Bool = false
    
    /// Flag for resolving multiple call of durationchanged delegate 
    public var isDurationChanging: Bool = false
    

    /// Reachability for network interruption handling
    private let reachability = try? Reachability()
    /// Current network connectivity
    private var isConnected = false
    
    
    /// Check if the player is playing
    open var isPlaying: Bool {
        switch playbackState {
        case .playing:
            return true
        case .stopped, .paused:
            return false
        }
    }
    
    // Initial Items of AVPlayerQueue
    
    
    /// Last player item
    private var lastPlayerItem: AVPlayerItem?
    
    /// Default player item
    private var playerItem: AVPlayerItem? {
        willSet{
            
            removePeriodicTimeObserver()
            
        }
        
        
        didSet {
            // For observing time
            self.addTimeObserver()
            playerItemDidChange()
        }
    }
    
    // Current Index of song playing in playerItems
    public var currentIndex = 0
    
    
    var playerItems = [AVPlayerItem](){
        didSet{
            self.setupPlayer()
        }
    }
    
    /// Observing the Playback Time
    var timeObserverToken: Any?
    
    // MARK: - Methods
    
    func setupPlayer(){
        
        
        if self.player == nil{
            self.player = AVPlayer()
        }
        
        
        self.playerItem = self.playerItems.first
        
       
        // Enable bluetooth playback
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSession.Category.playback, options: [.defaultToSpeaker , .allowBluetooth])
        
        // Notifications
        setupNotifications()
        
        // Check for headphones
        checkHeadphonesConnection(outputs: AVAudioSession.sharedInstance().currentRoute.outputs)
        
        // Reachability config
        try? reachability?.startNotifier()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        isConnected = reachability?.connection != .none
        
        
        
        
    }
    
    
    deinit {
        resetPlayer()
        self.removePeriodicTimeObserver()
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Notifications
    
    private func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleRouteChange), name: AVAudioSession.routeChangeNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    
    
    
    // MARK: - Responding to Interruptions
    
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        
        switch type {
            case .began:
                DispatchQueue.main.async {
                    self.pause()
                    
            }
            case .ended:
                guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { break }
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                DispatchQueue.main.async { options.contains(.shouldResume) ? self.play() : self.pause() }
        @unknown default:
            break
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        guard let reachability = note.object as? Reachability else { return }
        
        // Check if the internet connection was lost
        if reachability.connection != .unavailable, !isConnected {
            checkNetworkInterruption()
        }
        
        isConnected = reachability.connection != .unavailable
    }
    
    // Check if the playback could keep up after a network interruption
    private func checkNetworkInterruption() {
        guard
            let item = playerItem,
            !item.isPlaybackLikelyToKeepUp,
            reachability?.connection != .unavailable else { return }
        
        player?.pause()
        
        // Wait 1 sec to recheck and make sure the reload is needed
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if !item.isPlaybackLikelyToKeepUp { self.reloadItem() }
            self.isPlaying ? self.playSong() : self.player?.pause()
        }
    }
    
    // MARK: - Control Methods
    
    /**
     Trigger the play function of the music player
     
     */
    open func play() {
        guard let player = player else { return }
        if player.currentItem == nil, playerItem != nil {
            player.replaceCurrentItem(with: playerItem)
        }
        
        //Check if player is playing song
        if playbackState == .playing , player.isPlaying{
            self.pause()
        }else{
            self.playSong()
            playbackState = .playing
        }
        
        
        
        
    }
    
    
    func playSong(){
        
       // currentIndex = self.playerItems.firstIndex(of: (self.player?.currentItem)!)!
        self.player?.play()
        
        
    }
    
    
    
    
    
    
    /**
     Trigger the pause function of the music player
     
     */
    open func pause() {
        guard let player = player else { return }
        player.pause()
        playbackState = .paused
    }
    
    /**
     Trigger the stop function of the music player
     
     */
    open func stop() {
        guard let player = player else { return }
        player.replaceCurrentItem(with: nil)
        playbackState = .stopped
    }
    
    
    /**
     Trigger the next function of the music player
     
     */
    open func playNext() {
        let nextIndex = self.currentIndex + 1
        
        if nextIndex < self.playerItems.count, let player = self.player{
            
            
            
            self.seekPlayer(to: .zero)
            
            
            let nextItem = self.playerItems[nextIndex]
            self.currentIndex = nextIndex
            lastPlayerItem = self.player?.currentItem
           
            
            
            
            playerItem = nextItem
            
            player.replaceCurrentItem(with: nil)
            player.replaceCurrentItem(with: nextItem)
            player.pause()
            
            
            
            
            if self.playbackState == .playing{
                self.playSong()
                self.playbackState = .playing
            }else{
                self.pause()
            }
            
            
            
            
            
        }
       
        
    }
    
    
    /**
     Trigger the previous function of the music player
     
     */
    open func playPrevious() {
        
        let prevIndex = self.currentIndex - 1
        
        if prevIndex >= 0, let player = self.player{
            let prevItem = self.playerItems[prevIndex]
        
           // lastPlayerItem = prevIndex == 0 ? nil : self.playerItems[prevIndex - 1 ]
           
             self.seekPlayer(to: .zero)
            
            playerItem = prevItem
            self.currentIndex = prevIndex
            player.replaceCurrentItem(with: nil)
            player.replaceCurrentItem(with: prevItem)
            
            player.pause()
            
            
           
            
            if self.playbackState == .playing{
                self.playSong()
                self.playbackState = .playing
            }else{
                self.pause()
            }
            
            
        }
        
        
    }
    
    
    /**
     Toggle isPlaying state
     
     */
    open func togglePlaying() {
        isPlaying ? pause() : play()
    }
    
    private func reloadItem() {
        player?.replaceCurrentItem(with: nil)
        player?.replaceCurrentItem(with: playerItem)
    }
    
    private func resetPlayer() {
        stop()
        playerItem = nil
        lastPlayerItem = nil
        player = nil
        
    }
    
    func shuffleSong(){
        
    }
    
    
    func repeatSong(){
//        if let playerItem = notification.object as? AVPlayerItem {
//            playerItem.seek(to: CMTime.zero, completionHandler: nil)
//        }
    }
    
    
    
    
    
    
    
    // Current Item finished playing , play next song if available
    @objc func playerDidFinishPlaying(){
        self.playNext()
    }
    
 
    private func playerItemDidChange() {
        
        guard lastPlayerItem != playerItem  , let mediaURL = (playerItem?.asset as? AVURLAsset)?.url.relativeString else { return }
        
        if let item = lastPlayerItem {
          //  pause()
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
            item.removeObserver(self, forKeyPath: "status")
            item.removeObserver(self, forKeyPath: "playbackBufferEmpty")
            item.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
            item.removeObserver(self, forKeyPath: "timedMetadata")
            
        }
        
        lastPlayerItem = playerItem
      //  timedMetadataDidChange(rawValue: nil)
        
        if let item = playerItem {
            
            item.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "timedMetadata", options: NSKeyValueObservingOptions.new, context: nil)
            player?.replaceCurrentItem(with: item)
            if isAutoPlay { play() }
        }
        
        
        
        self.delegates.invokeDelegates { (delegate) in
            delegate.musicPlayerItemChanged?(player: self.player!, item: playerItem!, url: mediaURL)
        }
        
        
        
        
    }
    
    /**
     Seeking AVPlayer instance to target Time and informing the same through delegate
 
     - parameter targetTime: CMTime
     */
    public func seekPlayer(to targetTime : CMTime){
        guard let player = self.player , let currentItem = player.currentItem else{return}
    
        print(targetTime.seconds)

        player.seek(to: targetTime)
      
     //   if !currentItem.duration.seconds.isNaN{
            
            self.delegates.invokeDelegates { (delegate) in
                delegate.playerPlaybackDurationChanged?(player: player, currentTime: targetTime, totalTime: currentItem.duration)
            }
            
            
         
       // }
        
        
        
    }
    
    public func playItem(index: Int){
        guard index != self.currentIndex , index < self.playerItems.count , let player = self.player else{return}
        
        self.currentIndex = index
        
        let newItem = self.playerItems[index]
    
        player.replaceCurrentItem(with: newItem)
        lastPlayerItem = playerItem
        playerItem = newItem
        
        
        self.seekPlayer(to: .zero)
        self.playSong()
        
    }
    
    
    
    
    
    
    
    // MARK: - Time Observer
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        self.timeObserverToken = player!.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard  let player = self?.player , let currentItem = player.currentItem
                //, !currentItem.duration.seconds.isNaN
                , let strongSelf = self else {return}
            
           
            
            if currentItem.status == .readyToPlay, !strongSelf.isDurationChanging{
                strongSelf.delegates.invokeDelegates { (delegate) in
                    delegate.playerPlaybackDurationChanged?(player: player, currentTime: currentItem.currentTime(), totalTime: currentItem.duration)
                }
            
            }
 
        })
    }

    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    // MARK: - KVO
    
    /// :nodoc:
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let item = object as? AVPlayerItem, let keyPath = keyPath, item == self.playerItem {
            
            switch keyPath {
                
                
                
            case "status":
                
                if player?.status == AVPlayer.Status.readyToPlay {
                    self.state = .readyToPlay
                } else if player?.status == AVPlayer.Status.failed {
                    self.state = .error
                }
                
            case "playbackBufferEmpty":
                
                if item.isPlaybackBufferEmpty {
                    self.state = .loading
                    self.checkNetworkInterruption()
                }
                
            case "playbackLikelyToKeepUp":
                
                self.state = item.isPlaybackLikelyToKeepUp ? .loadingFinished : .loading
                
            case "timedMetadata":
               // let rawValue = item.timedMetadata?.first?.value as? String
               // timedMetadataDidChange(rawValue: rawValue)
                break
            default:
                break
            }
        }
    }

    
    
    
    
    // MARK: - Responding to Route Changes
    
    private func checkHeadphonesConnection(outputs: [AVAudioSessionPortDescription]) {
        for output in outputs where convertFromAVAudioSessionPort(output.portType) == convertFromAVAudioSessionPort(AVAudioSession.Port.headphones) {
            headphonesConnected = true
            break
        }
        headphonesConnected = false
    }
    
    @objc private func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else { return }
        
        switch reason {
        case .newDeviceAvailable:
            checkHeadphonesConnection(outputs: AVAudioSession.sharedInstance().currentRoute.outputs)
        case .oldDeviceUnavailable:
            guard let previousRoute = userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription else { return }
            checkHeadphonesConnection(outputs: previousRoute.outputs);
            DispatchQueue.main.async { self.headphonesConnected ? () : self.pause() }
        default: break
        }
    }
    
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
        return input.rawValue
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromAVAudioSessionPort(_ input: AVAudioSession.Port) -> String {
        return input.rawValue
    }
    
    
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}



