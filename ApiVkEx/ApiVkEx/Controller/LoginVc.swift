//
//  LoginVc.swift
//  ApiVkEx
//
//  Created by Егор on 20.09.2020.
//  Copyright © 2020 Stroev Egor. All rights reserved.
//

import Foundation
import UIKit

protocol LoginVCDelegate: AnyObject{
    func nextVC()
}

class LoginVC: UIViewController {
    
    
    let loginView = LoginView()
    
    override func viewDidLoad() {
        self.setUp()
    }
    
    func setUp() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.loginView.delegate = self
        
        self.loginView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.loginView)
        
        NSLayoutConstraint.activate([
            self.loginView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.loginView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.loginView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.loginView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
        
}

extension LoginVC: LoginVCDelegate {
    func nextVC() {
        self.navigationController?.pushViewController(UserPageVC(), animated: true)
    }
    
}
