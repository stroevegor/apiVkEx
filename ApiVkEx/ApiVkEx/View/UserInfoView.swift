//
//  UserInfoView.swift
//  ApiVkEx
//
//  Created by Егор on 21.09.2020.
//  Copyright © 2020 Stroev Egor. All rights reserved.
//

import UIKit


class UserInfoView: UIView {
    
    static let height: CGFloat = 80
    static let avatarSize: CGFloat = 60
    
    weak var userPageVCDelegate: UserPageVCDelegate?
    
    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let lastnameLabel = UILabel()
    let onlineLabel = UILabel()
    let logOutBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        
        self.avatarImageView.layer.cornerRadius = Self.avatarSize / 2
        self.avatarImageView.clipsToBounds = true
       
        self.avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.avatarImageView)
        
        NSLayoutConstraint.activate([
            self.avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.avatarImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.avatarImageView.heightAnchor.constraint(equalToConstant: Self.avatarSize),
            self.avatarImageView.widthAnchor.constraint(equalTo: self.avatarImageView.heightAnchor)
        ])
        
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.nameLabel)
        
        NSLayoutConstraint.activate([
            self.nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.nameLabel.leftAnchor.constraint(equalTo: self.avatarImageView.rightAnchor, constant: 10),
        ])
        
        self.lastnameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.lastnameLabel)
        
        NSLayoutConstraint.activate([
            self.lastnameLabel.centerYAnchor.constraint(equalTo: self.nameLabel.centerYAnchor),
            self.lastnameLabel.leftAnchor.constraint(equalTo: self.nameLabel.rightAnchor, constant: 5),
        ])
        
        self.onlineLabel.translatesAutoresizingMaskIntoConstraints = false
               self.addSubview(self.onlineLabel)
               
        NSLayoutConstraint.activate([
            self.onlineLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 5),
            self.onlineLabel.leftAnchor.constraint(equalTo: self.nameLabel.leftAnchor)
        ])
        
        self.onlineLabel.font = UIFont.systemFont(ofSize: 12)
        
        self.logOutBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.logOutBtn)
        
        NSLayoutConstraint.activate([
            self.logOutBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            self.logOutBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.logOutBtn.setTitle("LogOut", for: .normal)
        self.logOutBtn.setTitleColor(.red, for: .normal)
        self.logOutBtn.addTarget(self, action: #selector(self.logOut), for: .touchUpInside)
    }
    
    func configure(_ user: UserDTO) {
        
        self.avatarImageView.image = user.avatarImage
        self.nameLabel.text = user.lastName
        self.lastnameLabel.text = user.firstName
        self.onlineLabel.text = user.onlineDescription
        
    }
    
    @objc func logOut() {
        DispatchQueue.main.async {
            self.userPageVCDelegate?.logOut()
        }
    }
}
