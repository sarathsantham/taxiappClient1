//
//  InternetConnectionVc.swift
//  EQTaxi
//
//  Created by Equator Technologies on 23/02/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import UIKit
protocol InternetVcDelegate: class {
    func DidSelectOkButton()
    
}

class InternetConnectionVc: UIViewController {
    
 weak var delegate: InternetVcDelegate?
   
    override func viewDidLoad() {
        super.viewDidLoad()
          view.endEditing(true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didclickOkButton(_ sender: Any) {
        self.delegate? .DidSelectOkButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            self?.view.frame = CGRect(x: 0, y: 0, width: (self?.view.frame.width)!, height: (self?.view.frame.height)!)
            
            
        })
    }

}
