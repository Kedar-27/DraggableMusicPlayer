//
//  DraggableVC.swift
//  DragabbleViewController
//
//  Created by Kedar Sukerkar on 14/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import UIKit
import LNPopupController
import FSPagerView

class DraggableVC: UIViewController {

    // MARK: - Constants
    static let storyboardIdentifier = "DraggableVC"
    static let storyboardName       = "Main"
    
    // MARK: - Outlets
    
    @IBOutlet weak var bgView: UIView!
    
    
    // MARK: - Properties
    
    
    
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
        
        
        
    
    }
    
    func setupUI(){
        
        
        
        
        
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        bgView.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        
        
    }
    
    
    
    
    // MARK: - IBActions

}










extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


