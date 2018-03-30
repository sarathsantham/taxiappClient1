//
//  AddCardVc.swift
//  EQTaxi
//
//  Created by Equator Technologies on 18/03/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import UIKit
protocol AddcardVcDelegate: class {
    func didclickBackAddCartVcButton()
}

class AddCardVc: UIViewController,UITextFieldDelegate {

    weak var delegate: AddcardVcDelegate?
 var objDatahandler = DataHandler()
    
    @IBOutlet var txt_Cvv: UITextField!
    @IBOutlet var txt_expiremonth: UITextField!
    @IBOutlet var txt_expireYear: UITextField!
    @IBOutlet var txt_name: UITextField!
    @IBOutlet var txt_cardNo: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Language change------->
        let userdefaults = UserDefaults.standard
        let lanuage =  userdefaults.string(forKey: "Lanuage")
        if lanuage == ".nb"{
            txt_name.placeholder = "John(eksempel)"
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            self?.view.frame = CGRect(x: 0, y: 0, width: (self?.view.frame.width)!, height: (self?.view.frame.height)!)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       dismissKeyboard()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key
    {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if string.count == 0
        {
        }
        else{
            let month : String = txt_expiremonth.text!
            let year : String = txt_expireYear.text!
            let cvv : String = txt_Cvv.text!
            let cardNo : String = txt_cardNo.text!

            
            if textField == txt_expiremonth{
                if month.count <= 1{
                    return true
                }else{
                    return false
                }
            }
           else if textField == txt_expireYear{
                if year.count <= 3{
                    return true
                }else{
                    return false
                }
            }
            else if textField == txt_Cvv{
                if cvv.count <= 2{
                    return true
                }else{
                    return false
                }
            }
            else if textField == txt_cardNo{
                if cardNo.count <= 15{
                  return true
                }else{
                    return false
                }
            }
            
            
        }
        return true
        
    }

    @IBAction func didclickBackButton(_ sender: Any) {
         self.delegate? .didclickBackAddCartVcButton()
    }
    @IBAction func DidClickAddbutton(_ sender: Any) {
         AddcustomerCarddetails()
    }
    
    // MARK: service call----------------------
   
    func AddcustomerCarddetails()  {
        Utilities .showLoading(message: "Loading...", view: self)
        var dic_inputValues = [String : String]()
        dic_inputValues["user_card_number"] = txt_cardNo.text
        dic_inputValues["user_card_cvv"] = txt_Cvv.text
        dic_inputValues["user_exp_month"] = txt_expiremonth.text
        dic_inputValues["user_exp_year"] = txt_expireYear.text
        dic_inputValues["is_default"] = txt_Cvv.text
        dic_inputValues["user_card_holder_name"] = txt_name.text
       
        objDatahandler .InputValues(inputDic: dic_inputValues as NSDictionary, suburl: KAddUserCardDetails as NSString,methodtype:  "POST", classVc : self) {
            (  dic_data) in
            if (dic_data as AnyObject).count == 1 && dic_data["Message"] != nil{
                let message = dic_data["Message"] as! String
                if message == "User Card Expired"{
                     Utilities .showToast(message: message, view: self.view)
                }else if message == "New Card Added"{
                       self.delegate? .didclickBackAddCartVcButton()
                }
                 Utilities .showToast(message: message, view: self.view)
                Utilities .HideLoading(view: self)
              
            }
            else if (dic_data["InternetError"] != nil){
                Utilities .HideLoading(view: self)
            }
            else if (dic_data["InternalServerError"] != nil){
                Utilities .HideLoading(view: self)
            }
            else{
                Utilities .HideLoading(view: self)
               
            }
        }
    }
    
}
