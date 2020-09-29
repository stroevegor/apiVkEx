//
//  UserPageVC.swift
//  ApiVkEx
//
//  Created by Егор on 20.09.2020.
//  Copyright © 2020 Stroev Egor. All rights reserved.
//

import Foundation
import UIKit

protocol UserPageVCDelegate: AnyObject{
    func logOut()
}

class UserPageVC: UIViewController {
    
    let userPageView = UserPageView()
    
    override func viewDidLoad() {
        
        self.setUp()
        
    }
    
    func setUp() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.userPageView.headerView.userPageVCDelegate = self
        
        self.userPageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.userPageView)
        
        NSLayoutConstraint.activate([
            self.userPageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.userPageView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.userPageView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.userPageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension UserPageVC: UserPageVCDelegate {
    func logOut() {
        DataMgr.clearCachedPosts { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(LoginVC(), animated: true)
            }
        }
    }
}
