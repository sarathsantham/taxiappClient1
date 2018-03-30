//
//  MenuView.swift
//  SideMenu
//
//  Created by Equator Technologies on 23/02/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import UIKit
protocol MenuviewDelegate: class {
    func didclickRideHistoryButton()
     func didclickLogoutButton()
    func didclickPayments()
    func didclickRideNow()
    
}

class MenuView: UIViewController {
     weak var delegate: MenuviewDelegate?
    open var allowLeftSwipe : Bool = true
    /// A Boolean value indicating whether the right swipe is enabled.
    open var allowRightSwipe : Bool = true
    open var allowPanGesture : Bool = true
    fileprivate var panRecognizer : UIPanGestureRecognizer?
    
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var background_view: UIView!
    @IBOutlet weak var lbl_name: UILabel!
      @IBOutlet weak var lbl_mobileNo: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let userdefaults = UserDefaults.standard
         lbl_name.text = userdefaults.string(forKey: "UserName")
        lbl_mobileNo.text = userdefaults.string(forKey: "MobileNO")
        background_view.alpha = 0.3
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (closeSideMenu))
        background_view.addGestureRecognizer(gesture)
        let gesture_swipe = UITapGestureRecognizer(target: self, action:  #selector (closeSideMenu_swipe))
        bgview.addGestureRecognizer(gesture_swipe)
    }
    // ServiceCall------------------>
    
    func LogoutServiceCall()  {
        
        let dic_ProfileDetails = [String : String]()
        let objDatahandler = DataHandler()
        objDatahandler .InputValuesGetmethod(inputDic: dic_ProfileDetails as NSDictionary, suburl: KLogout as NSString,methodtype:  "GET", classVc : self.view)
        { (  dic_data) in
           
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didclickLogoutButton(_ sender: Any) {
        LogoutServiceCall()
         self .performMyAnimation()
         self.delegate?.didclickLogoutButton()
    }
    @IBAction func didclickRideHistory(_ sender: Any) {
         self .performMyAnimation()
   self.delegate? .didclickRideHistoryButton()
        
    }
    @IBAction func DidclickRideNow(_ sender: Any) {
        self .performMyAnimation()
        self.delegate? .didclickRideNow()
        
    }
    @IBAction func DidclickPayments(_ sender: Any) {
        self .performMyAnimation()
        self.delegate? .didclickPayments()
        
    }
    @objc func closeSideMenu()
    {
      
//        self.view.layer.removeAnimation(forKey: kCATransitionFromRight)
//        self.view.removeFromSuperview()
        
    
        self .performMyAnimation()
    }
    func performMyAnimation() {
        UIView.animate(withDuration: {0.5}(),
                       animations: {
                        let transition = CATransition()
                        let withDuration = 0.3
                        transition.duration = withDuration
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        transition.type = kCATransitionMoveIn
                        transition.subtype =  kCATransitionFromRight
                        self.view.layer.add(transition, forKey: kCATransition)
            self.view.removeFromSuperview()
        }
    )}
    @objc func closeSideMenu_swipe()
    {
        self.view.layer.removeAnimation(forKey: kCATransitionFromLeft)
        self.view.removeFromSuperview()
    }
}
