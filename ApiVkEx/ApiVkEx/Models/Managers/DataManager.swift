//
//  DataManager.swift
//  ApiVkEx
//
//  Created by Егор on 20.09.2020.
//  Copyright © 2020 Stroev Egor. All rights reserved.
//

import Foundation
import CoreData
import WebKit

let DataMgr = DataManager()

class DataManager {
    
    var posts = [PostDTO]()
    
    private var count = 4
    private var offset = 0
    
    var token: String? {
        
        get {
            return UserDefaults.standard.string(forKey: "token")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
    
    fileprivate init() {}
    
    func getCurrentUser(completion: @escaping (UserDTO?) -> Void) {
        
        guard let token = self.token else {return}
        
        NetworkMgr.getUser(token, completion: completion)
        
    }
    
    
  func updatePosts(isCached: Bool = false, completion: @escaping () -> Void) {
      
      guard isCached else {
          self.downloadPosts(completion: completion)
          return
      }
      
      self.getCachedPosts { cachedPosts in
          
          if cachedPosts.isEmpty {
              self.downloadPosts(isCached: isCached, completion: completion)
              return
          }
          
          self.posts += cachedPosts
          self.offset += 5
          completion()
      }
  }
  
  func downloadPosts(isCached: Bool = false, completion: @escaping () -> Void) {
      
      guard let token = self.token else { return }
      
      NetworkMgr.getPosts( token, count: self.count, offset: self.offset) { newPosts in
          
          guard let newPosts = newPosts else { return }
          
          self.posts += newPosts
          self.offset += 5
          
          if isCached { self.cachePosts( newPosts ) }
          
          completion()
      }
  }
    

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "ApiVkEx")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getCachedPosts(completion: @escaping ([PostDTO]) -> Void) {
            
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            
            guard let posts = try? self?.persistentContainer.viewContext.fetch(fetchRequest), !posts.isEmpty else {
                completion([])
                return
            }
            
            completion(posts.map({ $0.dto }))
        }
    }
    
    func cachePosts(_ posts: [PostDTO]) {
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
                
            guard let self = self else { return }
            
            for post in posts {
                
                let postModel = Post(context: self.persistentContainer.viewContext)
                
                postModel.text = post.text
                postModel.likes = Int16(post.likes)
                postModel.comments = Int16(post.comments)
                postModel.reposts = Int16(post.reposts)
                postModel.date = post.date
                postModel.imageLink = post.imageLink
                postModel.owner = post.owner
                postModel.ownerImageLink = post.ownerImageLink
            }
            
            self.saveContext()
        }
    }
    
    func clearCachedPosts(completion: @escaping () -> Void) {
        
        self.token = nil
        
        self.posts = []
        self.count = 4
        self.offset = 0
        
        let dataStore = WKWebsiteDataStore.default()
               
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records,
                completionHandler: completion)
               }
       
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            guard let self = self else { return }
                
            let postsDeleteRequest = NSBatchDeleteRequest(fetchRequest: Post.fetchRequest())
            
            do {
                try self.persistentContainer.viewContext.execute(postsDeleteRequest)
                
                self.saveContext()

                completion()
            }
            catch {
                
                print("Failed to clear cache")
                completion()
            }
        }
    }
}
