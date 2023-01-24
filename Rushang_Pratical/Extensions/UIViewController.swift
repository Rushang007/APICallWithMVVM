//  UIViewController.swift


import Foundation
import UIKit

extension UIViewController {
    func showAlertMessage(titleStr:String? = nil, messageStr:String) {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (alert) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           for (index, title) in actionTitles.enumerated() {
               let action = UIAlertAction(title: title, style: .default, handler: actions[index])
               alert.addAction(action)
           }
           self.present(alert, animated: true, completion: nil)
       }
}
