//
//  DraggableVC.swift
//  DragabbleViewController
//
//  Created by Kedar Sukerkar on 14/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import UIKit
import LNPopupController
import  AVFoundation

class DraggableVC: UIViewController {

    // MARK: - Constants
    static let storyboardIdentifier = "DraggableVC"
    static let storyboardName       = "Main"
    
    // MARK: - Outlets
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var playerControlView: UIView!
    
    // MARK: - Properties
    var pagerView: FSPagerView!{
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.transformer = CustomFSPagerViewTransformer(type: .linear)
            self.pagerView.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.width * 0.6)
            self.pagerView.decelerationDistance = 1
        }
    }
    
    var viewModel : MusicDataViewModel{
        let viewModel = MusicDataViewModel.shared
        return viewModel
    }
    
    var musicData = [Music](){
        didSet{
            self.pagerView.reloadData()
        }
    }
    
    
    var avPlayer: AVPlayer!
    
    var musicPlayer = MusicPlayer.shared
    
    var musicControlView = MusicControlView()
    
    
    // MARK: - Data Injections
    
    
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupVC()
        self.showMusicControlView()
        self.setupMusicPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        
        
        
    }
    
    func setupVC(){
        self.pagerView = FSPagerView()
        self.pagerView.translatesAutoresizingMaskIntoConstraints = false
        self.bannerView.addSubview(pagerView)
        
        [self.pagerView!.centerXAnchor.constraint(equalToSystemSpacingAfter: self.view.centerXAnchor, multiplier: 1), self.bannerView.centerYAnchor.constraint(equalToSystemSpacingBelow: self.bannerView.centerYAnchor, multiplier: 1), self.pagerView!.widthAnchor.constraint(equalTo: bannerView!.widthAnchor, multiplier: 1) , self.pagerView!.heightAnchor.constraint(equalTo: bannerView!.heightAnchor, multiplier: 1)].forEach({$0.isActive = true})
     
        
        self.pagerView.delegate = self
        self.pagerView.dataSource = self
        self.pagerView.interitemSpacing = 20

        self.pagerView.removeGestureRecognizer(self.pagerView.panGestureRecognizer)
        
        
        self.viewModel.musicData.addAndNotify(observer: self) { (musics) in
            self.musicData = musics
        }
        
    
       
        
        
        
        
        
        
    }
    
    func setupUI(){
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.bgView.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        
        
    }
    
    func showMusicControlView(){
      
        guard let musicView =  Bundle.main.loadNibNamed(MusicControlView.identifier, owner: self, options: nil)?.first as? MusicControlView else{ return}
        
        DispatchQueue.main.async { [unowned self] in
            self.musicControlView = musicView
            self.playerControlView.addSubview(musicView)
            musicView.translatesAutoresizingMaskIntoConstraints = false
            musicView.centerXAnchor.constraint(equalTo: self.playerControlView.centerXAnchor).isActive = true
            musicView.centerYAnchor.constraint(equalTo: self.playerControlView.centerYAnchor, constant: 0).isActive = true
            musicView.widthAnchor.constraint(equalTo: self.playerControlView.widthAnchor).isActive = true
            musicView.heightAnchor.constraint(equalTo: self.playerControlView.heightAnchor, multiplier: 1, constant: 0).isActive = true
        }
        
        self.viewModel.currentMusicItem.addAndNotify(observer: self, completionHandler: {(music) in
                musicView.songTitleLabel.text = music.title
                musicView.artistNameLabel.text = music.subtitle
        })
        
        musicView.durationSlider.addTarget(self, action: #selector(sliderValueChanged(_:)) , for: .valueChanged)
        
        
        
        musicView.previousButton.addTarget(self, action: #selector(prevButtonClicked(_:)), for: .touchUpInside)
        musicView.nextButton.addTarget(self, action: #selector(nextButtonClicked(_:)), for: .touchUpInside)
        
        musicView.playButton.addTarget(self, action: #selector(playButtonCLicked), for: .touchUpInside)
        
        
    }
    
    func setupMusicPlayer(){
        self.musicPlayer.delegate = self
        let helper = PlaylistHelper.shared
        helper.mediaURLs = musicData.compactMap({$0.url})
        
        musicPlayer.playerItems = helper.getAVPlayerItems()
        
        
    }
    
    
    
    
    
    
    
    
    // MARK: - IBActions

    @objc func prevButtonClicked(_ sender: Any) {
        let newIndex = self.pagerView.currentIndex - 1
        
        guard  newIndex >= 0 else {
            return
        }
        self.pagerView.scrollToItem(at: newIndex , animated: true)
        
        self.viewModel.currentMusicItem.value = self.musicData[newIndex]
        
         musicPlayer.playPrevious()
        
    }
    
    @objc func nextButtonClicked(_ sender: Any) {
        
        let currentIndex = self.pagerView.currentIndex + 1
        
        
        guard  currentIndex < self.musicData.count else {
            return
        }
        self.pagerView.scrollToItem(at: currentIndex , animated: true)
        self.viewModel.currentMusicItem.value = self.musicData[currentIndex]
    
        musicPlayer.playNext()
    
    }
    
    
    @objc func playButtonCLicked(){
        
        
       
        
      //  let videoURL = NSURL(string: "http://strm112.1.fm/acountry_mobile_mp3")
        //avPlayer = AVPlayer(url: videoURL! as URL)
        //avPlayer.play()
        
        
        
        
        
       musicPlayer.play()
        
        
    }
    
    @objc func sliderValueChanged(_ playbackSlider: UISlider){
        
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        musicPlayer.seekPlayer(to: targetTime)
    }
    
    
    
}



extension DraggableVC: FSPagerViewDataSource, FSPagerViewDelegate{
    

    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return musicData.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: self.musicData[index].image)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = pagerView.collectionView.contentOffset
        visibleRect.size = pagerView.collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = pagerView.collectionView.indexPathForItem(at: visiblePoint) else { return }
    
        self.musicPlayer.playItem(index: indexPath.row)
        
        self.viewModel.currentMusicItem.value = self.musicData[indexPath.row]
        
        
    }
    
    
    
    
    
}










extension DraggableVC: MusicPlayerDelegate{
    func playerStateDidChange(player: AVPlayer, _ playerState: MusicPlayerState) {
        
        print(player)
        print(playerState)
        
        
    }
    
    func playbackStateDidChange(player: AVPlayer, _ playbackState: MusicPlayerPlaybackState) {
        print(player)
        print(playbackState)
    }
    
    func playerPlaybackDurationChanged(player: AVPlayer, currentTime: CMTime, totalTime: CMTime) {
//        print(player)
//        print(currentTime)
//        print(totalTime)
 
        if currentTime.seconds > 80{
            
            
            
            
            
            
            
        }
        
        
        
        print(currentTime.seconds)
        
        
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else{return}
            
            strongSelf.musicControlView.currentTimeLabel.text  = PlaylistHelper.shared.getTimeString(from: currentTime)
            strongSelf.musicControlView.durationSlider.value = Float(currentTime.seconds)
            strongSelf.musicControlView.durationLabel.text = PlaylistHelper.shared.getTimeString(from: totalTime)
            strongSelf.musicControlView.durationSlider.maximumValue = Float(totalTime.seconds)
        }
        
        
    
        
    
    
    }
    
}



























extension UIView {
    
    /// Returns String Represention of the class
    class var identifier: String{
        return String(describing: self)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


class CustomFSPagerViewTransformer: FSPagerViewTransformer{
    
    override func proposedInteritemSpacing() -> CGFloat {
        return UIScreen.main.bounds.width * 0.01
    }
    
    
    
}



typealias UIButtonTargetClosure = (UIButton) -> ()

class ClosureWrapper: NSObject {
    let closure: UIButtonTargetClosure
    init(_ closure: @escaping UIButtonTargetClosure) {
        self.closure = closure
    }
}

extension UIButton {
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTargetClosure(closure: @escaping UIButtonTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(UIButton.closureAction), for: .touchUpInside)
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
    
    func alignTextUnderImage(spacing: CGFloat = 6.0){
        if let image = self.imageView?.image , let font = self.titleLabel!.font{
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
    
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.isExclusiveTouch = true
    }
    
}
