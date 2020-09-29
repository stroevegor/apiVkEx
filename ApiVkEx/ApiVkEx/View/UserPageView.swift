//
//  UserPageView.swift
//  ApiVkEx
//
//  Created by Егор on 20.09.2020.
//  Copyright © 2020 Stroev Egor. All rights reserved.
//

import UIKit

class UserPageView: UITableView {
    
    static let postCellIdetifier = "PostCell"
    
    let headerView = UserInfoView()
    
    var isAllowLoadMore = true
        
    override init(frame: CGRect, style: UITableView.Style) {
        
        super.init(frame: frame, style: .grouped)
        
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        
        DataMgr.updatePosts(isCached: true) { [weak self] in
            DispatchQueue.main.async {
                self?.reloadData()
            }
        }
        
        self.delegate = self
        self.dataSource = self
        
        
        self.register(PostCell.self, forCellReuseIdentifier: Self.postCellIdetifier)
        
    }
}


extension UserPageView: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UserInfoView.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        DataMgr.getCurrentUser { user in
            DispatchQueue.main.async{
                guard let user = user else {return}
                self.headerView.configure(user)
            }
            
        }
        
        
        return self.headerView
    }
    
}


extension UserPageView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataMgr.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.postCellIdetifier) as! PostCell
        
        cell.configure(DataMgr.posts[indexPath.row])
        return cell
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard self.contentSize.height > self.frame.size.height, self.contentOffset.y - UserInfoView.height >= self.contentSize.height - self.frame.size.height, self.isAllowLoadMore else { return }
        
        self.isAllowLoadMore = false
        DataMgr.updatePosts(isCached: false) { [weak self] in
            DispatchQueue.main.async {
                self?.reloadData()
                self?.isAllowLoadMore = true
            }
        }
    }
}


extension UserPageView {
    
    class PostCell: UITableViewCell {
        
        static let cellHeight: CGFloat = 250
        
        static let avatarSize: CGFloat = 50
        
        let ownerAvatarImageView = UIImageView()
        let ownerName = UILabel()
        let textView = UITextView()
        let postImage = UIImageView()
        let likesCountLabel = UILabel()
        let commentsCountLabel = UILabel()
        let repostesCountLabel = UILabel()
        let createDateLabel = UILabel()
        
        override init(style: UITableViewCell.CellStyle,  reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            self.setUp()
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setUp() {
            
            
            self.selectionStyle = .none
            
            self.contentView.heightAnchor.constraint(equalToConstant: Self.cellHeight).isActive = true
            
            self.ownerAvatarImageView.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.ownerAvatarImageView)
            
            self.ownerAvatarImageView.layer.cornerRadius = Self.avatarSize / 2
            self.ownerAvatarImageView.clipsToBounds = true
            
            NSLayoutConstraint.activate([
                self.ownerAvatarImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
                self.ownerAvatarImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5),
                self.ownerAvatarImageView.heightAnchor.constraint(equalToConstant: Self.avatarSize),
                self.ownerAvatarImageView.widthAnchor.constraint(equalTo: self.ownerAvatarImageView.heightAnchor)
            ])
            
            self.ownerName.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.ownerName)
            
            NSLayoutConstraint.activate([
                self.ownerName.topAnchor.constraint(equalTo: self.ownerAvatarImageView.topAnchor),
                self.ownerName.leftAnchor.constraint(equalTo: self.ownerAvatarImageView.rightAnchor, constant: 5),
                
            ])
            
            self.textView.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.textView)
            
            NSLayoutConstraint.activate([
                self.textView.topAnchor.constraint(equalTo: self.ownerAvatarImageView.bottomAnchor, constant: 5),
                self.textView.heightAnchor.constraint(equalToConstant: 50),
                self.textView.leftAnchor.constraint(equalTo: self.ownerAvatarImageView.leftAnchor),
                self.textView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
                
            ])
            
            self.textView.isUserInteractionEnabled = false
            
            self.postImage.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.postImage)
            
            NSLayoutConstraint.activate([
                self.postImage.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
                self.postImage.topAnchor.constraint(equalTo: self.textView.bottomAnchor, constant: 10),
                self.postImage.heightAnchor.constraint(equalToConstant: 80),
                self.postImage.widthAnchor.constraint(equalTo: self.postImage.heightAnchor)
                
            ])
            
            self.createDateLabel.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.createDateLabel)
            
            NSLayoutConstraint.activate([
                self.createDateLabel.leftAnchor.constraint(equalTo: self.ownerAvatarImageView.leftAnchor),
                self.createDateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            ])
                       
            
            self.repostesCountLabel.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview( self.repostesCountLabel )
            
            NSLayoutConstraint.activate([
                self.repostesCountLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
                self.repostesCountLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            ])
            
            self.commentsCountLabel.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview( self.commentsCountLabel )
            
            NSLayoutConstraint.activate([
                self.commentsCountLabel.rightAnchor.constraint(equalTo: self.repostesCountLabel.leftAnchor, constant: -5),
                self.commentsCountLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            ])
            
            self.likesCountLabel.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview( self.likesCountLabel )
            
            NSLayoutConstraint.activate([
                self.likesCountLabel.rightAnchor.constraint(equalTo: self.commentsCountLabel.leftAnchor, constant: -5),
                self.likesCountLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            ])
        }
        
        func configure(_ post: PostDTO) {
            
            self.ownerAvatarImageView.image = post.ownerAvatarImage
            self.ownerName.text = post.owner
            self.textView.text = post.text
            self.postImage.image = post.postImage
            self.createDateLabel.text = post.createDateString
            self.likesCountLabel.text = "Likes: "  + String(post.likes)
            self.commentsCountLabel.text = "Comments: " + String(post.comments)
            self.repostesCountLabel.text = "Reposts: " + String(post.reposts)
            
            
        }
    }
}


