//
//  ProgressView.swift


import Foundation
import UIKit
extension UIViewController {
    func startActivityIndicator(_ labelText: String? = nil,_ detailText: String? = nil){
        DispatchQueue.main.async {
            ProgressView.shared.startAnimating()
        }
        
    }
    
    func stopActivityIndicator(){
        DispatchQueue.main.async {
            ProgressView.shared.stopAnimatimating()
        }
       
    }
}
class ProgressView {
    // MARK: - Variables
    private var containerView = UIView()
    private var progressView = UIView()
    private var activityIndicator = UIActivityIndicatorView()
    static var shared = ProgressView()
    
    // To close for instantiation
    private init() {}
    
    // MARK: - Functions
    func startAnimating(view: UIView = appDel.window!.rootViewController!.view) {
        containerView.center = view.center
        containerView.frame = view.frame
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        progressView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        progressView.center = containerView.center
        progressView.backgroundColor = .clear
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        activityIndicator.center = CGPoint(x: progressView.bounds.width/2, y: progressView.bounds.height/2)
        
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        }
        
        activityIndicator.color = .white
        view.addSubview(containerView)
        containerView.addSubview(progressView)
        progressView.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
  
    func stopAnimatimating() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.containerView.removeFromSuperview()
        }
    }
}
