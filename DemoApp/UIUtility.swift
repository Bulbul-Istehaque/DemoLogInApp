//
//  UIUtility.swift
//  BIUtilityKit
//
//  Created by Bul on 9/1/23.
//

import Foundation
import UIKit

@objc public class UIUtility : NSObject {

    //MARK: - Alerts
    
    @objc public class func showAlert(WithTitle title : String?, ofMessage message : String?, style : UIAlertController.Style, withButtonActions buttonActions:[UIAlertAction], fromViewController vc : UIViewController, sourceView : UIView?, sourceRect : CGRect) {
        
        let alert = UIUtility.getAlert(WithTitle: title, ofMessage: message, style: style, withButtonActions: buttonActions, fromViewController: vc, sourceView: sourceView, sourceRect: sourceRect)
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    @objc public class func getAlert(WithTitle title : String?, ofMessage message : String?, style : UIAlertController.Style, withButtonActions buttonActions:[UIAlertAction], fromViewController vc : UIViewController, sourceView : UIView?, sourceRect : CGRect) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for action in buttonActions {
            alert.addAction(action)
        }
        
        let IS_IPAD = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad

        if IS_IPAD && style == .actionSheet {
            
            alert.modalPresentationStyle = .popover
            
            let popPresenter = alert.popoverPresentationController
            popPresenter?.sourceView = sourceView ?? vc.view
            popPresenter?.sourceRect = sourceView == nil ?  CGRectZero : sourceRect
        }
        
        return alert
    }
    
    @objc public class func getAlert(WithTitle title : String?, ofMessage message : String?, withButtonActions buttonActions:[UIAlertAction]) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in buttonActions {
            alert.addAction(action)
        }
        
        return alert
    }
    
    @objc public class func getCancelAction(WithTitle title : String) -> UIAlertAction {
        return UIAlertAction(title: title, style: .cancel) { action in
            
        }
    }
    
    @objc public class func showAlert(ForTitle title: String?, message: String?, cancelButtonTitle: String, fromViewController vc : UIViewController) {
        
        let alert = UIUtility.getAlert(ForError: title, message: message, cancelButtonTitle: cancelButtonTitle)
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    @objc public class func getAlert(ForError title: String?, message: String?, cancelButtonTitle: String) -> UIAlertController {
        
        return self.getAlert(WithTitle: title, ofMessage: message, withButtonActions: [UIUtility.getCancelAction(WithTitle: cancelButtonTitle)])
    }
    
    @objc public class func getSettingsAction(WithTitle title : String) -> UIAlertAction? {
        
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            debugPrint("Could not create Phone Settings URL")
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { action in
            
            UIApplication.shared.open(url, options: [:]) { finished in
                
            }
        }
    }
    
    
    //MARK: - Toolbar in Keyboards
    
    @objc public class func addDoneButtonOnKeyboard(_ target : Any, action : Selector, textView : UITextView) {
        
        let doneToolbar : UIToolbar = UIUtility.createToolbar()
        let flexSpace = UIUtility.getFlexibleSpaceBarButtonItem()
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: target, action: action)
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        textView.inputAccessoryView = doneToolbar
    }
    
    @objc public class func addDoneButtonOnKeyboard(_ target : Any, action : Selector, textField : UITextField) {
        
        let doneToolbar : UIToolbar = UIUtility.createToolbar()
        let flexSpace = UIUtility.getFlexibleSpaceBarButtonItem()
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: target, action: action)
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        textField.inputAccessoryView = doneToolbar
    }
    
    @objc public class func getFlexibleSpaceBarButtonItem () -> UIBarButtonItem {
        return  UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    @objc public class func createToolbar() -> UIToolbar {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        return doneToolbar
    }

}

