//
//  NetworkManager.swift
//  ApiVkEx
//
//  Created by Егор on 20.09.2020.
//  Copyright © 2020 Stroev Egor. All rights reserved.
//

import Foundation

let NetworkMgr = NetworkManager()

class NetworkManager {
    
    static let authURL = URL(string: "https://oauth.vk.com/authorize?client_id=7603385&display=page&response_type=token&redirect_uri=http://oauth.vk.com/blank.html" )
    
    fileprivate init() {}
    
    func getUser(_ token: String, completion: @escaping (UserDTO?) -> Void) {
        
        guard let url = self.getURLForUser(token) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
        
            guard let dataDict = (data?.jsonDictionary?["response"] as? [[String: Any]])?.first,
                let user = UserDTO( dataDict)
                else { completion(nil); return }
            
            completion(user)
        }.resume()
        
    }
    
    func getPosts(_ token: String, count: Int, offset: Int, completion: @escaping ([PostDTO]?) -> Void) {
        
        guard let url = self.getURLForPost(token, count: count, offset: offset) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
                   
               
            guard let data = data else {return}
                   
            guard let postsFromData = try? JSONDecoder().decode( PostResponse.self, from: data) else { return }
                   
            completion(postsFromData.response.posts)
        }.resume()
    }
    
    private func getURLForUser(_ token: String) -> URL? {
        return URL(string: "https://api.vk.com/method/users.get?fields=online,photo_100&access_token=\(token)&v=5.124")
    }
    
    private func getURLForPost(_ token: String, count: Int, offset: Int) -> URL? {
        return URL(string: "https://api.vk.com/method/wall.get?count=\(count)&offset=\(offset)&access_token=\(token)&v=5.103&extended=1")
    }
    
}
