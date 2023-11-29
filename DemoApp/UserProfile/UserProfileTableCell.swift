//
//  UserProfileTableCell.swift
//  DemoApp
//
//  Created by Bul on 25/11/23.
//

import UIKit

class UserProfileTableCell: UITableViewCell {
    
    @IBOutlet internal var titleLabel: UILabel!
    @IBOutlet internal var descriptionLabel: UILabel!

    deinit {
        debugPrint("UserProfileTableCell deinitialize")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpViews()
    }
    
    internal func setUpViews() {
        resetViews()
        
        let bgView = UIView()
        bgView.backgroundColor = .clear
        self.selectedBackgroundView = bgView
        
    }
    
    internal func resetViews() {
        self.titleLabel.text = nil
        self.descriptionLabel.text = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
