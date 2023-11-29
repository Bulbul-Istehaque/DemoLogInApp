//
//  CustomResuableView.swift
//  SwiftTester
//
//  Created by Bulbul on 13/9/21.
//

import UIKit

open class CustomReusableView: UIView {

    var contentView : UIView?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup() {
        contentView = loadViewFromNib()
        contentView!.frame = bounds
        contentView!.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight/*,
            UIView.AutoresizingMask.flexibleLeftMargin,
            UIView.AutoresizingMask.flexibleRightMargin,
            UIView.AutoresizingMask.flexibleTopMargin,
            UIView.AutoresizingMask.flexibleBottomMargin*/]
        addSubview(contentView!)
    }

    public func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
