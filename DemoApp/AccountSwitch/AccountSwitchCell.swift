//
//  AccountSwitchCell.swift
//  DemoApp
//
//  Created by Bul on 25/11/23.
//

import UIKit

class AccountSwitchCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet internal var outerView: UIView!
    @IBOutlet internal var profileImageView: UIImageView!
    @IBOutlet internal var profileEmailLabel: UILabel!
    
    @IBOutlet internal var logOutButton: UIButton!
    
    var logOutPressed: (() -> Void)?
    
    //MARK: - Properties
    var imagePath: String?
    
    deinit {
        debugPrint("AccountSwitchCell deinitialize")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpViews()
    }

    
    internal func setUpViews() {
        resetViews()
    }
    
    internal func resetViews() {
        self.profileImageView.image = DefaultIcons.PERSON
        self.profileEmailLabel.text = nil
        self.imagePath = nil
        self.logOutPressed = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction private func logOutAction(_ sender: UIButton) {
        guard let block = logOutPressed else {
            return
        }
        block()
    }
    
}
