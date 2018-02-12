//
//  BottomSheetInitialSheetVc.swift
//  EQTaxi
//
//  Created by Equator Technologies on 07/02/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import UIKit

class BottomSheetInitialSheetVc: UIViewController {
       var frame = CGFloat ()
    var alphaforbackground12 = CGFloat ()
    var frameend = CGFloat ()
    @IBOutlet weak var headerView: UIView!
    
    var fullView: CGFloat = 0
    
    var partialView: CGFloat {
         alphaforbackground12 = UIScreen.main.bounds.height - 60
        return UIScreen.main.bounds.height - 60
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetInitialSheetVc.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            self?.frame = (self?.view.frame.width)!
            self?.frameend = (self?.view.frame.width)!-20
            let frame1 = self?.view.frame.height
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 10, y: yComponent!, width: (self?.frame)!-20, height: frame1!)
           
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didclickBackButton(_ sender: Any) {
        self.view.frame = CGRect(x: 10, y: self.partialView, width: self.frameend, height: self.view.frame.height)
        self.headerView.backgroundColor = UIColor .white
        
    }
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        let y = self.view.frame.minY
        
        if (y + translation.y >= fullView) && (y + translation.y <= partialView) {
            self.view.frame = CGRect(x: 0 , y: y + translation.y, width: frame, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
            let alphaforbackground : CGFloat = y / UIScreen.main.bounds.height
            headerView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: alphaforbackground )
        }
        
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 10, y: self.partialView, width: self.frameend, height: self.view.frame.height)
                        self.headerView.backgroundColor = UIColor .white
                                } else {
                    
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.frame, height: self.view.frame.height)
                        self.headerView.backgroundColor = UIColor .black
                }
                
            }, completion: { [weak self] _ in
                if ( velocity.y < 0 ) {
                    
                    
                }
            })
        }
    }
}
extension BottomSheetInitialSheetVc: UIGestureRecognizerDelegate {
    
  
    
}
