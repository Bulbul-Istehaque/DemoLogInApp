//
//  CustomNetworkRechability.swift
//  DemoApp
//
//  Created by Bul on 29/11/23.
//

import Foundation

import Reachability

enum ReachabilityChange {
    case available
    case unavailable
}

protocol NetworkReachable: AnyObject {
    func startReachability()
    var reachabilityChangeHandler: ((ReachabilityChange) -> Void)? { get set }
    var reachability: Reachability? { get set }
}

extension NetworkReachable {
    func emitReachability(_ change: ReachabilityChange) {
        reachabilityChangeHandler?(change)
    }
    
    func startReachability() {
        startHost()
    }
    
    func startHost() {
        stopNotifier()
        setupReachability("https://www.google.com")
        startNotifier()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.startHost()
        }
    }
    
    func setupReachability(_ hostName: String) {
        var reachability: Reachability?
        reachability = try? Reachability(hostname: hostName)
        self.reachability = reachability
        
        if reachability?.connection == .unavailable {
            self.emitReachability(.unavailable)
        } else {
            self.verifyURL(urlPath: hostName, completion: { (isUrlAccessible) in
                if isUrlAccessible {
                    self.emitReachability(.available)
                } else {
                    self.emitReachability(.unavailable)
                }
            })
        }
    }
    
    func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            return
        }
    }
    
    func stopNotifier() {
        reachability?.stopNotifier()
        reachability = nil
    }
    
    func verifyURL(urlPath: String, completion: @escaping (_ isUrlAccessible: Bool) -> Void) {
        if let url = URL(string: urlPath) {
            var request = URLRequest(url: url)
            request.timeoutInterval = 5
            let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            config.urlCache = nil
            let task = URLSession(configuration: config).dataTask(with: request) { _, response, _ in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
            task.resume()
        } else {
            completion(false)
        }
    }
}
