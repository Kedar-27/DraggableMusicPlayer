//
//  MainVC.swift
//  DragabbleViewController
//
//  Created by Kedar Sukerkar on 14/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    // MARK: - Constants
    static let storyboardIdentifier = "MainVC"
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
    
    func setupVC(){
        
        
        
        
    }
    
    func setupUI(){
        
        
        
        
        
        
        
        
    }
    
    // MARK: - IBActions



}

