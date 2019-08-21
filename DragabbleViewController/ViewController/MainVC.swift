//
//  MainVC.swift
//  DragabbleViewController
//
//  Created by Kedar Sukerkar on 14/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import UIKit
import LNPopupController

class MainVC: UIViewController {

    // MARK: - Constants
    static let storyboardIdentifier = "MainVC"
    static let storyboardName       = "Main"
    
    // MARK: - Outlets
    
    
    
    // MARK: - Properties
    let storyBoard = UIStoryboard(name: DraggableVC.storyboardName, bundle: nil)
    var dragVC = DraggableVC()
    
    lazy var viewModel : MusicDataViewModel = {
        let viewModel = MusicDataViewModel.shared
        return viewModel
    }()
    
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
        self.presentBottomBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    func setupVC(){
        dragVC = storyBoard.instantiateViewController(withIdentifier: DraggableVC.storyboardIdentifier ) as! DraggableVC
        
        self.viewModel.currentMusicItem.addAndNotify(observer: self, completionHandler: {(music) in
          
      
        })
        
        
    }
    
    func setupUI(){
        
    
        
        
        
        
    }
    
    // MARK: - Bottom Bar
    
    func presentBottomBar(){
        
        let customBottomBarstoryBoard = UIStoryboard(name: CustomBottomBar.storyboardName, bundle: nil)
        let customBottomBarVC = customBottomBarstoryBoard.instantiateViewController(withIdentifier: CustomBottomBar.storyboardIdentifier ) as! CustomBottomBar
        self.navigationController?.popupBar.customBarViewController = customBottomBarVC
        self.navigationController?.popupContentView.popupCloseButtonStyle = .none
        self.navigationController?.popupInteractionStyle = .drag

    
        self.navigationController?.popupContentView.isTranslucent = false
        self.navigationController?.popupContentView.popupInteractionGestureRecognizer.delegate = self
        self.navigationController?.popupContentView.popupInteractionGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(gesture:)))
        self.navigationController?.popupBar.popupOpenGestureRecognizer.addTarget(self, action: #selector(handleTapGesture(recognizer:)))

        self.navigationController?.presentPopupBar(withContentViewController: self.dragVC, animated: false) {}
     
        
       // }
    }
    
    // MARK: - IBActions
    
    
    @IBAction func hidePopupButtonClicked(_ sender: Any) {
        
        self.navigationController?.popupBar.isHidden = true
        
        
    }
    
    @IBAction func showPopupButtonClicked(_ sender: Any) {
        
        
        self.navigationController?.popupBar.isHidden = false
        
        
        
        
    }

    
}

extension MainVC: UIGestureRecognizerDelegate{

    @objc func handlePanGesture(gesture: UIPanGestureRecognizer?){
    
        guard let _: CGPoint? = gesture?.translation(in: view) else { return }
            if gesture?.state == .changed || gesture?.state == .ended {
                let percent = ((UIScreen.main.bounds.size.height - (self.navigationController?.popupContentView.frame.height)!) / UIScreen.main.bounds.size.height)
            
                self.navigationController?.popupContentView.alpha = 1.0 - percent
                self.navigationController?.popupBar.alpha = percent
        }
        
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
   @objc func handleTapGesture(recognizer: UITapGestureRecognizer) {
    
        self.navigationController?.popupContentView.alpha = 1.0
    
    }
    
}




//extension MainVC: LNPopupBarPreviewingDelegate{
//    
//    func previewingViewController(for popupBar: LNPopupBar) -> UIViewController? {
//        let blur = UIBlurEffect(style: .extraLight)
//        
//        let vc = UIViewController()
//        vc.view = UIVisualEffectView(effect: blur)
//        vc.view.backgroundColor = UIColor.white.withAlphaComponent(0.0)
//        vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 2)
//        
//        let label = UILabel()
//        label.text = "Hello from\n3D Touch!"
//        label.numberOfLines = 0
//        label.textColor = UIColor.black
//        label.font = UIFont.systemFont(ofSize: 50, weight: .black)
//        label.sizeToFit()
//        label.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin]
//        
//        let vib = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blur))
//        vib.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        vib.contentView.addSubview(label)
//        
//        ((vc.view as? UIVisualEffectView)?.contentView)?.addSubview(vib)
//        
//        return vc
//        
//    }
//    
//    
//}









