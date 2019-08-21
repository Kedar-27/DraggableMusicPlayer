//
//  DraggableVC.swift
//  DragabbleViewController
//
//  Created by Kedar Sukerkar on 14/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import UIKit
import LNPopupController


class DraggableVC: UIViewController {

    // MARK: - Constants
    static let storyboardIdentifier = "DraggableVC"
    static let storyboardName       = "Main"
    
    // MARK: - Outlets
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bannerView: UIView!
    
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
    
    // MARK: - IBActions

    @IBAction func prevButtonClicked(_ sender: Any) {
        let newIndex = self.pagerView.currentIndex - 1
        
        guard  newIndex >= 0 else {
            return
        }
        self.pagerView.scrollToItem(at: newIndex , animated: true)
        
        self.viewModel.currentMusicItem.value = self.musicData[newIndex]
        
        
        
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        let currentIndex = self.pagerView.currentIndex + 1
        
        
        guard  currentIndex < self.musicData.count else {
            return
        }
        self.pagerView.scrollToItem(at: currentIndex , animated: true)
        self.viewModel.currentMusicItem.value = self.musicData[currentIndex]
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
    
}







extension UIView {
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
