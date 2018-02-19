//
//  Utilities.swift
//  EQTaxi
//
//  Created by Equator Technologies on 31/01/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import UIKit
var  alert = UIAlertController()
public class Utilities: NSObject
{
    
    
static func showToast(message : String,view:UIView) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2-150, y: view.frame.size.height-180, width: 300, height: 50))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.numberOfLines = 5
        toastLabel.font = UIFont(name: "Quicksand-Bold", size: 14.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 15;
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        }
    
static func showLoading(message : String,view:UIViewController) {
        
         alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 7, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
       view.present(alert, animated: true, completion: nil)
        }
  
    static func HideLoading(view:UIViewController) {
        alert.dismiss(animated: true, completion: nil)

    }
}
