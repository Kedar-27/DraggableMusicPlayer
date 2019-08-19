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
    var animator: UIViewPropertyAnimator!
    
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

    }
    
    func setupUI(){
        
        
        animator = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) { [unowned self] in
            self.dragVC.view.alpha = 1
        }
        
        
        
        
        
    }
    
    // MARK: - Bottom Bar
    
    func presentBottomBar(){
        
//        let storyBoard = UIStoryboard(name: DraggableVC.storyboardName, bundle: nil)
//        let dragVC = storyBoard.instantiateViewController(withIdentifier: DraggableVC.storyboardIdentifier ) as! DraggableVC
//
//        dragVC.popupItem.title = "Hall of Fame"
//        dragVC.popupItem.subtitle = "Script"
//        dragVC.popupItem.image = UIImage()
//        dragVC.popupItem.progress = 0.5
//
//        self.popupContentView.popupCloseButtonStyle = .none
//        self.popupInteractionStyle = .drag
//        self.popupBar.marqueeScrollEnabled = true
       // DispatchQueue.main.async {
        
        
        
//        self.presentPopupBar(withContentViewController: dragVC, openPopup: true, animated: true) {
//            dragVC.view.alpha = self.transitionCoordinator?.percentComplete ?? 1
//        }
        
        
        
//                dragVC.popupItem.title = "Hall of Fame"
//                dragVC.popupItem.subtitle = "Script"
//                dragVC.popupItem.image = UIImage()
//                dragVC.popupItem.progress = 0.5

        
                let customBottomBarstoryBoard = UIStoryboard(name: CustomBottomBar.storyboardName, bundle: nil)
                let customBottomBarVC = customBottomBarstoryBoard.instantiateViewController(withIdentifier: CustomBottomBar.storyboardIdentifier ) as! CustomBottomBar
                self.popupBar.customBarViewController = customBottomBarVC
                self.popupContentView.popupCloseButtonStyle = .none
                self.popupInteractionStyle = .drag
        
        
                self.popupContentView.popupInteractionGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(gesture:)))
 
    
                self.presentPopupBar(withContentViewController: dragVC, animated: false, completion: nil)
        
        
       // }
    }
    
    
    
    
}

extension MainVC: UIGestureRecognizerDelegate{

    @objc func handlePanGesture(gesture: UIPanGestureRecognizer?){
    
        guard let _: CGPoint? = gesture?.translation(in: view) else { return }
        
            if gesture?.state == .changed || gesture?.state == .ended {

            
            let percent = ((UIScreen.main.bounds.size.height - popupContentView.frame.height) / UIScreen.main.bounds.size.height)
            
            self.popupContentView.alpha = 1.0 - percent
            self.popupBar.alpha = percent
            
        }
        
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









