//
//  LoginView.swift
//  ApiVkEx
//
//  Created by Егор on 20.09.2020.
//  Copyright © 2020 Stroev Egor. All rights reserved.
//

import Foundation
import WebKit

class LoginView: WKWebView{
    
    weak var delegate: LoginVCDelegate?
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        self.setUp()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        
    
        self.navigationDelegate = self
        
        guard let url = NetworkManager.authURL else {return}
        
        self.load(URLRequest(url: url))
        
        
    }
    
}

extension LoginView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard let urlString = webView.url?.absoluteString.replacingOccurrences(of: "#", with: "?"),
            let urlParams = URLComponents(string: urlString)?.queryItems,
            let token = urlParams.first(where: {$0.name == "access_token"})?.value
        else {return}
        
        DataMgr.token = token
        
        self.delegate?.nextVC() 
    }
}
