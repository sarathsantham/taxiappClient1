//
//  LoginVc.swift
//  EQTaxiCustomer
//
//  Created by Equator Technologies on 20/01/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
class LoginVc: UIViewController,UITextFieldDelegate  {
    
    var str_Back_Status : String?
    
    
// MARK: Reference outlet for View--------------->
    
    @IBOutlet var view_password: UIView!
    @IBOutlet var view_BackGround: UIView!
    @IBOutlet var view_OTP: UIView!
    @IBOutlet var view_bottom: UIView!
    @IBOutlet var view_newRegistor: UIView!
    @IBOutlet var view_backarrow: UIView!
    
// MARK: Reference outlet for Label--------------->
    
    @IBOutlet var lbl_OTPView_MobileNo: UILabel!
    @IBOutlet var lbl_getMoveWithEqTaxi: UILabel!
    @IBOutlet var lbl_entermobileNo: UILabel!
    @IBOutlet var lbl_country: UILabel!
    @IBOutlet var lbl_CofirmPassword: UILabel!

    
// MARK: Reference outlet for TextField--------------->
    @IBOutlet var txt_Confirmpassword: DTTextField!
    @IBOutlet var txt_password: DTTextField!
    @IBOutlet var txt_otp4: DTTextField!
    @IBOutlet var txt_otp3: UITextField!
    @IBOutlet var txt_otp2: UITextField!
    @IBOutlet var txt_Otp1: UITextField!
    @IBOutlet var txt_email: UITextField!
    @IBOutlet var txt_lastname: DTTextField!
    @IBOutlet var txt_firstname: DTTextField!
    @IBOutlet var txt_mobileno: DTTextField!
    @IBOutlet var txt_commonOtpErrormessage: DTTextField!
    
    // MARK: Reference outlet for Image--------------->
    
    @IBOutlet var img_country: UIImageView!
    
    var objDatahandler : DataHandler  = DataHandler()
    var objUtilities : Utilities = Utilities ()
    
// MARK: Reference outlet for Button--------------->
    
    @IBOutlet var button_Password: UIButton!
    @IBOutlet var button_socialLogin: UIButton!
    @IBOutlet var button_MobileNoValidate: UIButton!
    @IBOutlet var button_OTPNoValidate: UIButton!
    @IBOutlet var button_registerverify: UIButton!
    
    
// MARK: DidLoad--------------->
    
    var str_countryCode = String()
    var str_dialdCode = String()
    var str_stoploader = String()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.removeObject(forKey: "Token")
         //Initial Country Setup
        
        let bundle = "assets.bundle/"
        self.img_country!.image = UIImage(named: bundle + "in" + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
        self.lbl_country.text = "+91"
        self.str_dialdCode="+91"
        self.str_countryCode="IN"
        
        //Initial View Operations
        
        view_backarrow.isHidden=true
        lbl_entermobileNo.isHidden=true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
    }
    
// MARK: TextField Delegates ------------------------->
   
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key
    {
        if textField==self.txt_mobileno{
            self.txt_mobileno .resignFirstResponder()
        }
        return true
    }
   
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == txt_mobileno{
        UIView .animate(withDuration: 0.3, animations: {
            if (kIphone_4s) {
                self.view_backarrow.frame=CGRect(x: 0, y: 0, width: 320, height: 42)
                self.view_bottom.frame=CGRect(x: 0, y: 42, width: 320, height: 330)
            }else if (kIphone_5){
                self.view_backarrow.frame=CGRect(x: 0, y: 0, width: 320, height: 50)
                self.view_bottom.frame=CGRect(x: 0, y: 50, width: 320, height: 390)
            }else if (kIphone_6){
                self.view_backarrow.frame=CGRect(x: 0, y: 0, width: 375, height: 59)
                self.view_bottom.frame=CGRect(x: 0, y: 59, width: 375, height: 458)
            }else{
                self.view_backarrow.frame=CGRect(x: 0, y: 0, width: 414, height: 64)
                self.view_bottom.frame=CGRect(x: 0, y: 64, width: 414, height: 505)
            }
        }, completion: nil)
        view_backarrow.isHidden=false
        lbl_entermobileNo.isHidden=false
        lbl_getMoveWithEqTaxi.isHidden=true
        button_socialLogin.isHidden=true
        str_Back_Status = "MobileNo"
        }
    }
    

    
func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
    if string.count == 0
    {
    if textField==txt_mobileno {
        let text = txt_mobileno.text! as NSString
        if (text.length == 1){
            button_MobileNoValidate.setImage(UIImage(named: "right-arrow-50.png"), for: .normal)
        }
    }
    if textField==txt_Otp1 {
        txt_commonOtpErrormessage.text=" "
    let text = txt_Otp1.text! as NSString
    if (text.length == 1){
    }
    }
    if textField==txt_otp2 {
         txt_commonOtpErrormessage.text=" "
    let text = txt_otp2.text! as NSString
    if (text.length == 1){
    txt_Otp1 .becomeFirstResponder()
    txt_otp2.text=""
    return false
    }
    }
    if textField==txt_otp3 {
         txt_commonOtpErrormessage.text=" "
    let text = txt_otp3.text! as NSString
    if (text.length == 1){
    txt_otp2 .becomeFirstResponder()
    txt_otp3.text=""
    return false
    }
    }
    if textField==txt_otp4 {
         txt_commonOtpErrormessage.text=" "
        button_OTPNoValidate.setImage(UIImage(named: "right-arrow-50.png"), for: .normal)
    let text = txt_otp4.text! as NSString
    if (text.length == 1){
    txt_otp3 .becomeFirstResponder()
    txt_otp4.text=""
    return false
    }
    }
        if textField==txt_Confirmpassword {
            let text = txt_Confirmpassword.text! as NSString
            if (text.length == 1){
                button_Password.setImage(UIImage(named: "right-arrow-50.png"), for: .normal)
            }
            
        }
        if textField==txt_lastname {
            let text = txt_lastname.text! as NSString
            if (text.length == 1){
                button_registerverify.setImage(UIImage(named: "right-arrow-50.png"), for: .normal)
            }
            
        }
    }
    else{
    if textField==txt_Otp1 {
         txt_commonOtpErrormessage.text=" "
    let text = txt_Otp1.text! as NSString
    if (text.length == 0){
    
    }else{
    txt_otp2.becomeFirstResponder()
    }
    }
    if textField==txt_otp2 {
         txt_commonOtpErrormessage.text=" "
    let text = txt_otp2.text! as NSString
    if (text.length == 0){
    
    }else{
    txt_otp3.becomeFirstResponder()
    }
    }
    if textField==txt_otp3 {
         txt_commonOtpErrormessage.text=" "
    let text = txt_otp3.text! as NSString
    if (text.length == 0){
    
    }else{
    txt_otp4.becomeFirstResponder()
        button_OTPNoValidate.setImage(UIImage(named: "right-arrow-b-50.png"), for: .normal)
    }
    }
    if textField==txt_otp4 {
         txt_commonOtpErrormessage.text=" "
    let text = txt_otp4.text! as NSString
    if (text.length == 0){
      
    }else{
        return false
    }
        }
    if textField==txt_mobileno {
        let count1 : String = txt_mobileno.text!
        let intCount : NSInteger = count1.count
        if intCount <= 9{
            button_MobileNoValidate.setImage(UIImage(named: "right-arrow-b-50.png"), for: .normal)
            return true
        }else{
          return false
        }
        }
        if textField==txt_Confirmpassword {
                button_Password.setImage(UIImage(named: "right-arrow-b-50.png"), for: .normal)
            
            }
        if textField==txt_lastname {
            button_registerverify.setImage(UIImage(named: "right-arrow-b-50.png"), for: .normal)
            
        }
        
    }
    return true
    }
    

// MARK: Button Actions--------------->

    @IBAction func didclickOpenpickerAction(_ sender: Any) {
        self .CountryPickerWhenClickingCountryPicker()
    }
    @IBAction func didclickRegistarSubmitButton(_ sender: Any) {
        
        if txt_firstname.text == "" || txt_lastname.text == "" {
            if txt_firstname.text == ""{
                txt_firstname.showError(message: "Enter first name")
            }else{
                txt_lastname.showError(message: "Enter last name")
            }
            

        }else{
                  CustomerProfileUpdate()
        }

    }
    @IBAction func didclickOTPResentButton(_ sender: Any) {
        
    }
    @IBAction func didclickPasswordVerifyButton(_ sender: Any) {
        if txt_password.text == "" || txt_Confirmpassword.text == ""
        {
            if txt_password.text == ""{
                txt_password.showError(message: "Enter password")

            }
            else{
                if str_Back_Status == "OldPassword"{
                    CheckOldCustomerPassword()
                }
            }
            
        }else{
            if  txt_password.text == txt_Confirmpassword.text{
               
                 SetPasswordServiceCall()
               
            }else{
                txt_Confirmpassword.showError(message: "password mismatched")
            }
        }
      
    }
    
   
    @IBAction func didclickOTPVerificationButton(_ sender: Any) {
    if txt_Otp1.text == "" || txt_otp2.text == "" || txt_otp3.text == "" || txt_otp4.text == "" {
       // txt_otp4.showError(message: "Enter OTP")
            
    }else{
       self .VerifyOTPServiceCall()
        }
    }
   
    @IBAction func didclickBackbutton(_ sender: Any) {
        if  str_Back_Status == "MobileNo"
        {
                UIView .animate(withDuration: 0.3, animations: {
                    if (kIphone_4s) {
                        self.view_backarrow.frame=CGRect(x: 0, y: 293, width: 320, height: 42)
                        self.view_bottom.frame=CGRect(x: 0, y: 333, width: 320, height: 330)
                    }else if (kIphone_5){
                        self.view_backarrow.frame=CGRect(x: 0, y: 347, width: 320, height: 50)
                        self.view_bottom.frame=CGRect(x: 0, y: 394, width: 320, height: 390)
                    }else if (kIphone_6){
                        self.view_backarrow.frame=CGRect(x: 0, y: 407, width: 375, height: 59)
                        self.view_bottom.frame=CGRect(x: 0, y: 463, width: 375, height: 458)
                    }else{
                        self.view_backarrow.frame=CGRect(x: 0, y: 450, width: 414, height: 64)
                        self.view_bottom.frame=CGRect(x: 0, y: 511, width: 414, height: 505)
                    }
                }, completion: nil)
            self .dismissKeyboard()
            view_backarrow.isHidden=true
            lbl_entermobileNo.isHidden=true
            lbl_getMoveWithEqTaxi.isHidden=false
            button_socialLogin.isHidden=false
            str_Back_Status = ""
        }
        if  str_Back_Status == "OtpNo"
        {
        UIView .animate(withDuration: 0.3, animations: {
            if (kIphone_4s) {
                self.view_OTP.frame=CGRect(x: 320, y: 0, width: 320, height: 330)
            }else if (kIphone_5){
                self.view_OTP.frame=CGRect(x: 320, y: 0, width: 320, height: 390)
            }else if (kIphone_6){
                self.view_OTP.frame=CGRect(x: 375, y: 0, width: 375, height: 458)
            }else{
                self.view_OTP.frame=CGRect(x: 414, y: 0, width: 414, height: 505)
            }
        }, completion: nil)
            str_Back_Status = "MobileNo"
        }
        if  str_Back_Status == "NewPassword"
        {
            self .dismissKeyboard()
            txt_Otp1.keyboardType = UIKeyboardType.phonePad
            txt_Otp1 .becomeFirstResponder()
            UIView .animate(withDuration: 0.3, animations: {
                if (kIphone_4s) {
                    self.view_password.frame=CGRect(x: 320, y: 0, width: 320, height: 424)
                }else if (kIphone_5){
                    self.view_password.frame=CGRect(x: 320, y: 0, width: 320, height: 502)
                }else if (kIphone_6){
                    self.view_password.frame=CGRect(x: 375, y: 0, width: 375, height: 589)
                }else{
                    self.view_password.frame=CGRect(x: 414, y: 0, width: 414, height: 650)
                }
            }, completion: nil)
            str_Back_Status = "OtpNo"
        }
        if  str_Back_Status == "NewRegistor"
        {
            txt_password .becomeFirstResponder()
            UIView .animate(withDuration: 0.3, animations: {
                if (kIphone_4s) {
                    self.view_newRegistor.frame=CGRect(x: 320, y: 0, width: 320, height: 424)
                }else if (kIphone_5){
                    self.view_newRegistor.frame=CGRect(x: 320, y: 0, width: 320, height: 502)
                }else if (kIphone_6){
                    self.view_newRegistor.frame=CGRect(x: 375, y: 0, width: 375, height: 589)
                }else{
                    self.view_newRegistor.frame=CGRect(x: 414, y: 0, width: 414, height: 650)
                }
            }, completion: nil)
            str_Back_Status = "NewPassword"
        }
        
        if  str_Back_Status == "OldPassword"
        {
            self .dismissKeyboard()
            txt_mobileno.keyboardType = UIKeyboardType.phonePad
            txt_mobileno .becomeFirstResponder()
            UIView .animate(withDuration: 0.3, animations: {
                if (kIphone_4s) {
                    self.view_password.frame=CGRect(x: 320, y: 0, width: 320, height: 424)
                }else if (kIphone_5){
                    self.view_password.frame=CGRect(x: 320, y: 0, width: 320, height: 502)
                }else if (kIphone_6){
                    self.view_password.frame=CGRect(x: 375, y: 0, width: 375, height: 589)
                }else{
                    self.view_password.frame=CGRect(x: 414, y: 0, width: 414, height: 650)
                }
            }, completion: nil)
            str_Back_Status = "MobileNo"
        }
        if  str_Back_Status == "OldRegistation"
        {
            self .dismissKeyboard()
            txt_password.keyboardType = UIKeyboardType.phonePad
            txt_password .becomeFirstResponder()
            UIView .animate(withDuration: 0.3, animations: {
                if (kIphone_4s) {
                    self.view_newRegistor.frame=CGRect(x: 320, y: 0, width: 320, height: 424)
                }else if (kIphone_5){
                    self.view_newRegistor.frame=CGRect(x: 320, y: 0, width: 320, height: 502)
                }else if (kIphone_6){
                    self.view_newRegistor.frame=CGRect(x: 375, y: 0, width: 375, height: 589)
                }else{
                    self.view_newRegistor.frame=CGRect(x: 414, y: 0, width: 414, height: 650)
                }
            }, completion: nil)
            str_Back_Status = "OldPassword"
        }
        
        
    }
    
    @IBAction func didclickVerifyMobileNoSendOTPButton(_ sender: Any) {
        if  self.txt_mobileno.text==""{
            txt_mobileno.showError(message: "Enter mobile number")

        }
        else{
            let mobile_count : String = txt_mobileno.text!
            if mobile_count.count == 10{
                self .MobileNoVerification()

            }else{
                 txt_mobileno.showError(message: "Enter valid mobile number")
            }
        }
    }
    

// MARK: Country Picker Delegate methods  ------------------------------------->
    
func CountryPickerWhenClickingCountryPicker()   {
    let picker = MICountryPicker { (name, code) -> () in
        print(code)
    }
    
    // Optional: To pick from custom countries list
    picker.customCountriesCode = ["IL","AF", "AL",  "DZ",  "AS","AD",  "AO",  "AI", "AG","AR",  "AM",  "AW",  "AU","AT", "AZ",  "BS", "BH","BD", "BB",  "BY",  "BE","BZ",  "BJ", "BM",  "BT","BA",  "BW",  "BR",  "IO","BG",  "BF",  "BI",  "KH","CM",  "CA",  "CV",  "KY","CF",  "TD",  "CL",  "CN","CX",  "CO",  "KM",  "CG","CK",  "CR",  "HR",  "CU","CY",  "CZ",  "DK",  "DJ","DM",  "DO",  "EC", "EG","SV",  "GQ",  "ER", "EE","ET",  "FO",  "FJ",  "FI","FR",  "GF", "PF",  "GA","GM",  "GE",  "DE", "GH","GI",  "GR",  "GL", "GD","GP",  "GU",  "GT", "GN","GW",  "GY",  "HT",  "HN","HU",  "IS",  "IN",  "ID","IQ",  "IE",  "IL",  "IT","JM",  "JP",  "JO", "KZ","KE",  "KI",  "KW",  "KG","LV",  "LB",  "LS",  "LR","LI",  "LT", "LU",  "MG","MW",  "MY", "MV",  "ML","MT",  "MH",  "MQ",  "MR","MU",  "YT",  "MX", "MC","MN",  "ME",  "MS",  "MA","MM", "NA",  "NR",  "NP","NL",  "AN",  "NC",  "NZ","NI", "NE",  "NG",  "NU","NF",  "MP",  "NO",  "OM","PK",  "PW",  "PA",  "PG","PY", "PE", "PH",  "PL","PT",  "PR",  "QA",  "RO","RW",  "WS",  "SM",  "SA","SN",  "RS",  "SC",  "SL","SG",  "SK",  "SI",  "SB","ZA",  "GS",  "ES",  "LK","SD",  "SR",  "SZ",  "SE","CH",  "TJ", "TH",  "TG","TK",  "TO",  "TT",  "TN","TR",  "TM",  "TC",  "TV","UG",  "UA",  "AE", "GB","US",  "UY",  "UZ",  "VU","WF",  "YE",  "ZM",  "ZW","BO",  "BN",  "CC", "CD","CI",  "FK",  "GG",  "VA","HK",  "IR",  "IM",  "JE","KP",  "KR",  "LA",  "LY","MO",  "MK",  "FM",  "MD","MZ", "PS",  "PN",  "RE","RU",  "BL", "SH", "KN","LC", "MF",  "PM", "VC","ST",  "SO",  "SJ",  "SY","TW",  "TZ",  "TL",  "VE","VN",  "VG",  "VI"]
    
    // delegate
    picker.delegate = self as? MICountryPickerDelegate
    
    // Display calling codes
    //        picker.showCallingCodes = true
    
    // or closure
    
    picker.didSelectCountryWithCallingCodeClosure = { name, code , dialCode in
        picker.navigationController?.popToRootViewController(animated: true)
        let bundle = "assets.bundle/"
        self.img_country!.image = UIImage(named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
        self.lbl_country.text = dialCode
        self.str_countryCode=code
        self.str_dialdCode=dialCode
        
        print(code)
    }
    
    navigationController?.pushViewController(picker, animated: true)
    }
    
// MARK: Login Service loader ------------------------------------------>
    
    func firstImageLoading(button : UIButton){
        if str_stoploader == "0" {
             button.setImage(UIImage(named: "right-arrow-b-50"), for: .normal)
        }else{
        button.setImage(UIImage(named: "5"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.secondImageLoading(button1: button )
        })
        }
    }
    func secondImageLoading(button1 : UIButton){
       if str_stoploader == "0" {
             button1.setImage(UIImage(named: "right-arrow-b-50"), for: .normal)
        }else{
        button1.setImage(UIImage(named: "1"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.thirdImageLoading(button2: button1)
        })
        }
    }
    func thirdImageLoading(button2 : UIButton){
        if str_stoploader == "0" {
            button2.setImage(UIImage(named: "right-arrow-b-50"), for: .normal)
        }else{
        button2.setImage(UIImage(named: "2"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.fourthImageLoading(button3: button2)
        })
        }
    }
    func fourthImageLoading(button3 : UIButton){
        if str_stoploader == "0" {
            button3.setImage(UIImage(named: "right-arrow-b-50"), for: .normal)
        }else{
        button3.setImage(UIImage(named: "3"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.FifthImageLoading(button4: button3)
        })
        }
    }
    func FifthImageLoading(button4 : UIButton){
        if str_stoploader == "0" {
             button4.setImage(UIImage(named: "right-arrow-b-50"), for: .normal)
        }else{
        button4.setImage(UIImage(named: "4"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.firstImageLoading(button: button4)
        })
        }
    }
// MARK: Service Call------------------------------------->
    
    func MobileNoVerification()  {
        self.str_stoploader = "1"
        firstImageLoading(button: button_MobileNoValidate)
        var dic_inputValues = [String : String]()
        dic_inputValues["user_mobile_no"] = txt_mobileno.text
        dic_inputValues["user_dial_code"] = self.str_dialdCode
        dic_inputValues["user_role"] = "3"
        dic_inputValues["user_country_code"] = self.str_countryCode
        let fCMtoken = Messaging.messaging().fcmToken
        dic_inputValues["user_fcm_id"] = fCMtoken ?? ""
        var modelName = UIDevice.current.model
        if modelName.isEqual("iPhone"){
            if kIphone_4s{
                modelName="iPhone4s"
            };
            if kIphone_5{
                modelName="iPhone5s/iPhone5/iphoneSe"
            };
            if kIphone_6{
                modelName="iPhone6s/iPhone6/iPhone7s/iPhone7/iPhone8"
            };
            if kIphone_6_Plus{
                modelName="iPhone6sPlus/iPhone6Plus/iPhone7Plus"
            }
        }
        dic_inputValues["device_name"] = modelName
        let osVersion = UIDevice.current.systemVersion
        dic_inputValues["device_os_version"] = osVersion
        dic_inputValues["ip_address"] = ""
        dic_inputValues["device_os"] = "IOS"
        dic_inputValues["service"] = "login"
        objDatahandler .InputValues(inputDic: dic_inputValues as NSDictionary, suburl: kLogin as NSString,methodtype:  "POST", classVc : self.view) { (  dic_data) in
            print("FinalValue---------------------------", dic_data)
            
            if (dic_data as AnyObject).count == 1 && dic_data["Message"] != nil
            {
                let message = dic_data["Message"] as! String
                self.txt_password.showError(message: message)
                self.str_stoploader = "0"
                
            }else{
                self.str_stoploader = "0"
                let isnew : Bool = (dic_data["is_new"] as? Bool)!
                if isnew == true{
                    self.txt_Confirmpassword.isHidden=false
                    self.lbl_CofirmPassword.isHidden=false
                     Utilities.showToast(message: "Send OTP Success" , view:self.view)
                    self.txt_Otp1 .becomeFirstResponder()
                    self.txt_Otp1.text=""
                    self.txt_otp2.text=""
                    self.txt_otp3.text=""
                    self.txt_otp4.text=""
                    self.lbl_OTPView_MobileNo.text=self.txt_mobileno.text
                    UIView .animate(withDuration: 0.3, animations: {
                        if (kIphone_4s) {
                            self.view_OTP.frame=CGRect(x: 0, y: 0, width: 320, height: 330)
                        }else if (kIphone_5){
                            self.view_OTP.frame=CGRect(x: 0, y: 0, width: 320, height: 390)
                        }else if (kIphone_6){
                            self.view_OTP.frame=CGRect(x: 0, y: 0, width: 375, height: 458)
                        }else{
                            self.view_OTP.frame=CGRect(x: 0, y: 0, width: 414, height: 505)
                        }
                    }, completion: nil)
                    self.str_Back_Status = "OtpNo"
                }else{
                    UIView .animate(withDuration: 0.3, animations: {
                        if (kIphone_4s) {
                            self.view_password.frame=CGRect(x: 0, y: 0, width: 320, height: 424)
                        }else if (kIphone_5){
                            self.view_password.frame=CGRect(x: 0, y: 0, width: 320, height: 502)
                        }else if (kIphone_6){
                            self.view_password.frame=CGRect(x: 0, y: 0, width: 375, height: 589)
                        }else{
                            self.view_password.frame=CGRect(x: 0, y: 0, width: 414, height: 650)
                        }
                    }, completion: nil)
                    self .dismissKeyboard()
                    self.txt_password.keyboardType = UIKeyboardType.default
                    self.str_Back_Status = "OldPassword"
                    self.txt_password.text=""
                    self.txt_password .becomeFirstResponder()
                    self.txt_Confirmpassword.isHidden=true
                    self.lbl_CofirmPassword.isHidden=true
                }
                
            }
        }
    }
    
    func VerifyOTPServiceCall()  {
        self.str_stoploader = "1"
        firstImageLoading(button: button_OTPNoValidate)
        var dic_inputValues = [String : String]()
        let otp : String = txt_Otp1.text! + txt_otp2.text! + txt_otp3.text! + txt_otp4.text!
        dic_inputValues["user_otp"] = otp
        dic_inputValues["user_mobile_no"] = txt_mobileno.text
        dic_inputValues["user_dial_code"] = self.str_dialdCode
        dic_inputValues["user_country_code"] = self.str_countryCode
        dic_inputValues["service"] = "login"
        objDatahandler .InputValues(inputDic: dic_inputValues as NSDictionary, suburl: kVerifyOTP as NSString,methodtype:  "POST", classVc : self.view) { (  dic_data) in
            print("FinalValue---------------------------", dic_data)
            if (dic_data as AnyObject).count == 1{
                  let message = dic_data["Message"] as! String
                if message == "OTP Verified!"{
                 self.str_stoploader = "0"
                self .dismissKeyboard()
                self.txt_password.keyboardType = UIKeyboardType.default
                self.txt_password .becomeFirstResponder()
                self.txt_password.text=""
                UIView .animate(withDuration: 0.3, animations: {
                    if (kIphone_4s) {
                        self.view_password.frame=CGRect(x: 0, y: 0, width: 320, height: 424)
                    }else if (kIphone_5){
                        self.view_password.frame=CGRect(x: 0, y: 0, width: 320, height: 502)
                    }else if (kIphone_6){
                        self.view_password.frame=CGRect(x: 0, y: 0, width: 375, height: 589)
                    }else{
                        self.view_password.frame=CGRect(x: 0, y: 0, width: 414, height: 650)
                    }
                }, completion: nil)
                self.str_Back_Status = "NewPassword"
            }
           else
            {
                let message = dic_data["Message"] as! String
            self.txt_commonOtpErrormessage.showError(message: message)
            self.str_stoploader = "0"
            }
        }
    }
    }
    
   
    func SetPasswordServiceCall()  {
        self.str_stoploader = "1"
        firstImageLoading(button: button_Password)
        var dic_inputValues = [String : String]()
        dic_inputValues["user_country_code"] = self.str_countryCode
        dic_inputValues["user_dial_code"] = self.str_dialdCode
        dic_inputValues["user_mobile_no"] = txt_mobileno.text
        dic_inputValues["user_password"] = txt_password.text

        objDatahandler .InputValues(inputDic: dic_inputValues as NSDictionary, suburl: KSetNewPassword as NSString,methodtype:  "PUT", classVc : self.view) {
            (  dic_data) in
            print("FinalValue---------------------------", dic_data)
            if (dic_data as AnyObject).count == 1 && dic_data["Message"] != nil{
                let message = dic_data["Message"] as! String
                self.txt_password.showError(message: message)
                self.str_stoploader = "0"
                
            }
            else{
                 self.str_stoploader = "0"
                let token = dic_data["user_auth_token"] as! String
                let userId = dic_data["pk_user_id"]
                UserDefaults.standard.set(userId, forKey: "UserId") //setObject
                UserDefaults.standard.set(token, forKey: "Token") //setObject
                                self.txt_firstname .becomeFirstResponder()
                                self.txt_firstname.text = ""
                                self.txt_lastname.text = ""
                
                                UIView .animate(withDuration: 0.3, animations: {
                                    if (kIphone_4s) {
                                        self.view_newRegistor.frame=CGRect(x: 0, y: 0, width: 320, height: 424)
                                    }else if (kIphone_5){
                                        self.view_newRegistor.frame=CGRect(x: 0, y: 0, width: 320, height: 502)
                                    }else if (kIphone_6){
                                        self.view_newRegistor.frame=CGRect(x: 0, y: 0, width: 375, height: 589)
                                    }else{
                                        self.view_newRegistor.frame=CGRect(x: 0, y: 0, width: 414, height: 650)
                                    }
                                }, completion: nil)
                                self.str_Back_Status = "NewRegistor"
            }
        }
    }
    
    
    func CustomerProfileUpdate()  {
        self.str_stoploader = "1"
        firstImageLoading(button: button_registerverify)
        var dic_inputValues = [String : String]()
        dic_inputValues["user_first_name"] = txt_firstname.text
        dic_inputValues["user_last_name"] = txt_lastname.text
        dic_inputValues["user_email"] = ""
        dic_inputValues["user_gender"] = "0"
        dic_inputValues["user_dob"] = ""
        dic_inputValues["user_image"] = ""

        objDatahandler .InputValues(inputDic: dic_inputValues as NSDictionary, suburl: KProfileRegUpdate as NSString,methodtype:  "PUT", classVc : self.view) {
            (  dic_data) in
            print("FinalValue---------------------------", dic_data)
            if (dic_data as AnyObject).count == 1 && dic_data["Message"] != nil{
                let message = dic_data["Message"] as! String
                self.txt_password.showError(message: message)
                self.str_stoploader = "0"
            }else{
                self.str_stoploader = "0"
                let homeVc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVcID") as! HomeVc
                self.present(homeVc, animated:false, completion:nil)
            }
        }
    }
   
    func CheckOldCustomerPassword()  {
        self.str_stoploader = "1"
        firstImageLoading(button: button_Password)
        var dic_inputValues = [String : String]()
        dic_inputValues["user_country_code"] = self.str_countryCode
        dic_inputValues["user_dial_code"] = self.str_dialdCode
        dic_inputValues["user_mobile_no"] = txt_mobileno.text
        dic_inputValues["user_password"] = txt_password.text
        objDatahandler .InputValues(inputDic: dic_inputValues as NSDictionary, suburl: KCheckOldUserPassword as NSString ,methodtype:  "POST", classVc : self.view) {
            (  dic_data) in
            print("FinalValue---------------------------", dic_data)
            if (dic_data as AnyObject).count == 1 && dic_data["Message"] != nil{
                let message = dic_data["Message"] as! String
                self.txt_password.showError(message: message)
                self.str_stoploader = "0"
            }else{
                self.str_stoploader = "0"
                let isProfilecompleted = dic_data["is_profile_complete"] as! Bool
                let token = dic_data["user_auth_token"] as! String
                let userId = dic_data["pk_user_id"]
                UserDefaults.standard.set(userId, forKey: "UserId") //setObject
                UserDefaults.standard.set(token, forKey: "Token")
                if isProfilecompleted == true{
                let homeVc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVcID") as! HomeVc
                self.present(homeVc, animated:false, completion:nil)
                }else{
                    self.txt_firstname .becomeFirstResponder()
                    self.txt_firstname.text = ""
                    self.txt_lastname.text = ""
                    
                    UIView .animate(withDuration: 0.3, animations: {
                        if (kIphone_4s) {
                            self.view_newRegistor.frame=CGRect(x: 0, y: 0, width: 320, height: 424)
                        }else if (kIphone_5){
                            self.view_newRegistor.frame=CGRect(x: 0, y: 0, width: 320, height: 502)
                        }else if (kIphone_6){
                            self.view_newRegistor.frame=CGRect(x: 0, y: 0, width: 375, height: 589)
                        }else{
                            self.view_newRegistor.frame=CGRect(x: 0, y: 0, width: 414, height: 650)
                        }
                    }, completion: nil)
                    self.str_Back_Status = "OldRegistation"
                    
                }
            }
        }
    }
}
extension ViewController: MICountryPickerDelegate {
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        
        picker.navigationController?.popToRootViewController(animated: true)
    }
}

    





