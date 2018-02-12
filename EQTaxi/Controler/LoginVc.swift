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
    
// MARK: Reference outlet for TextField--------------->
    
    @IBOutlet var txt_otp4: UITextField!
    @IBOutlet var txt_otp3: UITextField!
    @IBOutlet var txt_otp2: UITextField!
    @IBOutlet var txt_Otp1: UITextField!
    @IBOutlet var txt_email: UITextField!
    @IBOutlet var txt_lastname: UITextField!
    @IBOutlet var txt_firstname: UITextField!
    @IBOutlet var txt_mobileno: UITextField!
    
// MARK: Reference outlet for Image--------------->
    
    @IBOutlet var img_country: UIImageView!
    
    var objDatahandler : DataHandler  = DataHandler()
    var objUtilities : Utilities = Utilities ()
    
// MARK: Reference outlet for Button--------------->
    
    @IBOutlet var button_socialLogin: UIButton!
    @IBOutlet var button_MobileNoValidate: UIButton!
    @IBOutlet var button_OTPNoValidate: UIButton!
    @IBOutlet var button_registerverify: UIButton!
    
    
// MARK: DidLoad--------------->
    
    var str_countryCode = String()
    var str_dialdCode = String()

    override func viewDidLoad() {
        super.viewDidLoad()

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
    let text = txt_Otp1.text! as NSString
    if (text.length == 1){
    }
    }
    if textField==txt_otp2 {
    let text = txt_otp2.text! as NSString
    if (text.length == 1){
    txt_Otp1 .becomeFirstResponder()
    txt_otp2.text=""
    return false
    }
    }
    if textField==txt_otp3 {
    let text = txt_otp3.text! as NSString
    if (text.length == 1){
    txt_otp2 .becomeFirstResponder()
    txt_otp3.text=""
    return false
    }
    }
    if textField==txt_otp4 {
        button_OTPNoValidate.setImage(UIImage(named: "right-arrow-50.png"), for: .normal)
    let text = txt_otp4.text! as NSString
    if (text.length == 1){
    txt_otp3 .becomeFirstResponder()
    txt_otp4.text=""
    return false
    }
    }
    }
    else{
    if textField==txt_Otp1 {
    let text = txt_Otp1.text! as NSString
    if (text.length == 0){
    
    }else{
    txt_otp2.becomeFirstResponder()
    }
    }
    if textField==txt_otp2 {
    let text = txt_otp2.text! as NSString
    if (text.length == 0){
    
    }else{
    txt_otp3.becomeFirstResponder()
    }
    }
    if textField==txt_otp3 {
    let text = txt_otp3.text! as NSString
    if (text.length == 0){
    
    }else{
    txt_otp4.becomeFirstResponder()
    }
    }
    if textField==txt_otp4 {
    let text = txt_otp4.text! as NSString
    if (text.length == 0){
        button_OTPNoValidate.setImage(UIImage(named: "right-arrow-b-50.png"), for: .normal)
        self .OTPVerfyButtonAction()
    }else{
       
    }
        }
    if textField==txt_mobileno {
        button_MobileNoValidate.setImage(UIImage(named: "right-arrow-b-50.png"), for: .normal)
        }
        
    }
    return true
    }
    

// MARK: Button Actions--------------->

    @IBAction func didclickLoginButton(_ sender: Any) {
        
        let homeVc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVcID") as! HomeVc
        self.present(homeVc, animated:false, completion:nil)
//        if  self.txt_mobileno.text==""{
//        }
//        else{
//         self .LoginButtonActionsServiceCall()
//
//
//        }
    
    }
    
   
   
    @IBAction func didclickRegistarSubmitButton(_ sender: Any) {
        let homeVc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVcID") as! HomeVc
        self.present(homeVc, animated:false, completion:nil)
        
    }
    
    @IBAction func didclickOTPResentButton(_ sender: Any) {
        
    }
    @IBAction func didclickOTPVerificationButton(_ sender: Any) {
       self .OTPVerfyButtonAction()
       
    }
    @IBAction func didclickResentOtpbutton(_ sender: Any) {
         self .LoginButtonActionsServiceCall()
        
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
        if  str_Back_Status == "NewRegistor"
        {
            self .dismissKeyboard()
            txt_Otp1.keyboardType = UIKeyboardType.phonePad
            txt_Otp1 .becomeFirstResponder()
            UIView .animate(withDuration: 0.3, animations: {
                if (kIphone_4s) {
                    self.view_newRegistor.frame=CGRect(x: 320, y: 0, width: 320, height: 330)
                }else if (kIphone_5){
                    self.view_newRegistor.frame=CGRect(x: 320, y: 0, width: 320, height: 390)
                }else if (kIphone_6){
                    self.view_newRegistor.frame=CGRect(x: 375, y: 0, width: 375, height: 458)
                }else{
                    self.view_newRegistor.frame=CGRect(x: 414, y: 0, width: 414, height: 505)
                }
            }, completion: nil)
            str_Back_Status = "OtpNo"
        }
    }
    
    @IBAction func didclickVerifyMobileNoSendOTPButton(_ sender: Any) {
        txt_Otp1 .becomeFirstResponder()
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
        str_Back_Status = "OtpNo"
    }
    
// MARK: OTP button Action method------------------------------------->

    func OTPVerfyButtonAction() {
        self .dismissKeyboard()
        txt_firstname.keyboardType = UIKeyboardType.default
       txt_firstname .becomeFirstResponder()
    UIView .animate(withDuration: 0.3, animations: {
    if (kIphone_4s) {
    self.view_newRegistor.frame=CGRect(x: 0, y: 0, width: 320, height: 330)
    }else if (kIphone_5){
    self.view_newRegistor.frame=CGRect(x: 0, y: 0, width: 320, height: 390)
    }else if (kIphone_6){
    self.view_newRegistor.frame=CGRect(x: 0, y: 0, width: 375, height: 458)
    }else{
    self.view_newRegistor.frame=CGRect(x: 0, y: 0, width: 414, height: 505)
    }
    }, completion: nil)
    str_Back_Status = "NewRegistor"
    }
    
// MARK: Send OTP Service Call------------------------------------->
    
    func LoginButtonActionsServiceCall()  {
        var dic_inputValues = [String : String]()
        dic_inputValues["mobile_no"] = txt_mobileno.text
        dic_inputValues["dial_code"] = self.str_dialdCode
        dic_inputValues["user_role"] = "3"
        dic_inputValues["country_code"] = self.str_countryCode
        let fCMtoken = Messaging.messaging().fcmToken
        dic_inputValues["fcm_id"] = fCMtoken ?? ""
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
        objDatahandler .InputValues(inputDic: dic_inputValues as NSDictionary, suburl: kLogin as NSString,methodtype:  "POST", classVc : self) { (  dic_data) in
           print("FinalValue---------------------------", dic_data)
            if dic_data.count==0 && dic_data == nil {
                
            }else{
                Toast("Send OTP Success") .show(self)
                
                self.view_newRegistor.isHidden=true
            }
        }
    }
    
    func VerifyOTPServiceCall()  {
        var dic_inputValues = [String : String]()
        let otp : String = txt_Otp1.text! + txt_otp2.text! + txt_otp3.text! + txt_otp4.text!
        dic_inputValues["user_otp"] = otp
        dic_inputValues["mobile_no"] = txt_mobileno.text
        dic_inputValues["dial_code"] = self.str_dialdCode
        dic_inputValues["user_role"] = "3"
        dic_inputValues["country_code"] = self.str_countryCode
        dic_inputValues["service"] = "login"
        objDatahandler .InputValues(inputDic: dic_inputValues as NSDictionary, suburl: kVerifyOTP as NSString,methodtype:  "POST", classVc : self) { (  dic_data) in
            print("FinalValue---------------------------", dic_data)
            if dic_data.count==0 && dic_data == nil {
                
            }else{
                let obj_data = dic_data .value(forKey: "data") as? Dictionary<String, Any>
                let token = obj_data!["auth_token"] as! String
                let isprofileVerified = obj_data!["is_profile_complete"] as! Bool
                UserDefaults.standard.set(token, forKey: "Token") //setObject
                UserDefaults.standard.set(obj_data, forKey: "ProfileInfo") //setObject
                if isprofileVerified == true{
                      let homeVc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVcID") as! HomeVc
                       self.present(homeVc, animated:true, completion:nil)
                }else{
                    self.view_OTP.isHidden=true
                    self.view_newRegistor.isHidden=false
                }
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
}
extension ViewController: MICountryPickerDelegate {
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        
        picker.navigationController?.popToRootViewController(animated: true)
    }
}

    





