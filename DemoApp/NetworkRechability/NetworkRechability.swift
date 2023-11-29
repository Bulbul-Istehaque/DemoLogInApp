//
//  NetworkRechability.swift
//  SingleBase
//
//  Created by Bul on 16/11/23.
//

import Foundation
import Network
import Alamofire
import Reachability


@objc public protocol NetworkRechabilityDelegateProtocol {
    func networkTypeChanged(_ networkType: NetworkType)
    func networkConnectionChanged(_ isConnected: Bool)
}

@objc public enum NetworkType: NSInteger {
    case NOT_CONNECTED
    case WIFI
    case CELLULAR
    case OTHER_MEDIUM
}

public class NetworkRechability: NetworkReachable {
    
    static public let shared = NetworkRechability()
    
    public var isConnectedToNetwork = false {
        didSet {
            self.delegate?.networkConnectionChanged(isConnectedToNetwork)
        }
    }
    
    var reachability: Reachability?
    var reachabilityChangeHandler: ((ReachabilityChange) -> Void)?
    
    @objc public var delegate: NetworkRechabilityDelegateProtocol?
    
    internal var networkType: NetworkType = .NOT_CONNECTED {
        didSet {
            switch networkType {
            case .NOT_CONNECTED:
                debugPrint("NetworkRechability -> networkType = NOT_CONNECTED")
                break
            case .WIFI:
                debugPrint("NetworkRechability -> networkType = WIFI")
                break
            case .CELLULAR:
                debugPrint("NetworkRechability -> networkType = CELLULAR")
                break
            case .OTHER_MEDIUM:
                debugPrint("NetworkRechability -> networkType = OTHER_MEDIUM")
                break
            }
            self.delegate?.networkTypeChanged(networkType)
        }
    }
    
    
    let monitor = NWPathMonitor()
    
    let monitorQueue = DispatchQueue(label: "Monitor")
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    
    private init() {
        
        self.startReachability()
        
        setUpQueue()
//        startNetworkReachabilityObserver()
        
        self.reachabilityChangeHandler = { [weak self] change in
            guard let weakSelf = self else { return }
            switch change {
            case .available:
                debugPrint("NetworkRechability: Available")
                if weakSelf.isConnectedToNetwork == false {
                    weakSelf.isConnectedToNetwork = true
                }
            case .unavailable:
                debugPrint("NetworkRechability: Unavailable")
                if weakSelf.isConnectedToNetwork {
                    weakSelf.isConnectedToNetwork = false
                }
            }
        }
    }
    
    
    
    
    
    internal func setUpQueue() {
        
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
//                print("NetworkRechability -> Network connected!")
                let usesWifi = path.usesInterfaceType(.wifi)
                let usesCellular = path.usesInterfaceType(.cellular)
                
                self.networkType = usesWifi ? .WIFI : usesCellular ? .CELLULAR : .OTHER_MEDIUM
            } else {
//                print("NetworkRechability -> No Network connection.")
                self.networkType = .NOT_CONNECTED
            }
            
        }
        
        monitor.start(queue: monitorQueue)
    }

    
    @objc public func getNetworkType() -> NetworkType {
        return self.networkType
    }
    
    
    // MARK: - Alamofire

    func startNetworkReachabilityObserver() {
        
        reachabilityManager?.startListening(onQueue: .main, onUpdatePerforming: { status in
            switch status {
                
            case .notReachable:
                self.networkType = .NOT_CONNECTED
                break
            case .unknown :
                self.networkType = .NOT_CONNECTED
                break
                
            case.reachable(let type):
                switch type {
                case .cellular:
                    self.networkType = .CELLULAR
                    break
                case .ethernetOrWiFi:
                    self.networkType = .WIFI
                    break
                }
                break
                
            }
        })
        
    }
    
    
}
