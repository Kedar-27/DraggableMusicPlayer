//
//  CustomBottomBar.swift
//  DragabbleViewController
//
//  Created by Kedar Sukerkar on 16/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import UIKit
import LNPopupController

class CustomBottomBar: LNPopupCustomBarViewController {

    

    
    
    // MARK: - Constants
    static let storyboardIdentifier = "CustomBottomBar"
    static let storyboardName       = "Main"
    
    // MARK: - Outlets
    
    
    
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
    
    
    override var wantsDefaultPanGestureRecognizer: Bool {
        get {
            return false
        }
    }
    
    
    
    func setupVC(){
        preferredContentSize = CGSize(width: -1, height: 65)
 
    }
    
    func setupUI(){
        
        
        
    }
    
    
    
    
    
  
    
    
    
    // MARK: - IBActions

    
    


}

