//
//  NetworkCnnectionDisplayView.swift
//  DemoApp
//
//  Created by Bul on 25/11/23.
//

import UIKit
import Foundation

class NetworkCnnectionDisplayView: CustomReusableView {

    //MARK: - Properties
    
    var isConnectedToNetwork = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                                
                guard let weakSelf = self else { return }
                
                if weakSelf.isConnectedToNetwork {
                    weakSelf.titleLabel.textColor = .black
                    
                    weakSelf.titleLabel.text = "Connected"
                } else {
                    weakSelf.titleLabel.textColor = .red
                    
                    weakSelf.titleLabel.text = "No Internet"
                }
                weakSelf.isHidden = false
                
                if weakSelf.isConnectedToNetwork == false {
                    return
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    weakSelf.isHidden = weakSelf.isConnectedToNetwork
                }
            }
        }
    }

    var networkType: NetworkType = .NOT_CONNECTED {
        didSet {
            /*
            DispatchQueue.main.async { [weak self] in
                
                guard let weakSelf = self else { return }
                
                weakSelf.titleLabel.textColor = weakSelf.networkType == .NOT_CONNECTED ? .red : .black
                
                weakSelf.titleLabel.text = weakSelf.networkType == .NOT_CONNECTED ? "No Internet" : "Connected"
                
                weakSelf.isHidden = false
                
                if weakSelf.networkType == .NOT_CONNECTED {
                    return
                }
                                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    weakSelf.isHidden = weakSelf.networkType != .NOT_CONNECTED
                }
            }
             */
        }
    }
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    deinit {
        debugPrint("NetworkCnnectionDisplayView deinitialize")
    }
    
    private func setUpViews() {
        
        self.networkType = NetworkRechability.shared.getNetworkType()
        
        self.isConnectedToNetwork = NetworkRechability.shared.isConnectedToNetwork
        
        self.outerView.layer.cornerRadius = self.outerView.bounds.size.height / 2
                
//        NotificationCenter.default.addObserver(self, selector: #selector(self.networkChanged), name: NSNotification.Name("NETWORK_INTERFACE_CHANGED"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkChanged), name: NSNotification.Name("NETWORK_CONNECTION_CHANGED"), object: nil)
    }
    
    
    @objc internal func networkChanged() {
        self.networkType = NetworkRechability.shared.getNetworkType()
        self.isConnectedToNetwork = NetworkRechability.shared.isConnectedToNetwork
    }
    

}
