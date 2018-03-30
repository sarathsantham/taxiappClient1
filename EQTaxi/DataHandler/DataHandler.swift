//
//  DataHandler.swift
//  EQTaxiCustomer
//
//  Created by Equator Technologies on 23/01/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//
import Foundation
import UIKit
import Alamofire

class DataHandler: NSObject {
    
var bottomSheetInternetConnectionVc = InternetConnectionVc()
    func InputValues   (inputDic : NSDictionary,suburl : NSString,methodtype : NSString,classVc : Any , completion: @escaping (_ data:NSDictionary) -> Void) {
        guard let status = Network.reachability?.status else { return }
        if status.rawValue == "unreachable"{
            let message = "InternetError"
            let dic_message = NSMutableDictionary()
            dic_message .setValue(message, forKey: "InternetError")
            completion(dic_message)
        }else{
            var  token : String = NSString() as String
              let userdefaults = UserDefaults.standard
            if userdefaults.string(forKey: "Token") != nil{
                token = "Bearer " + userdefaults.string(forKey: "Token")!
            } else {
                token = ""
            }
        var dic_res: NSDictionary = NSDictionary()
        let baseurl = kBaseUrl + (suburl as String)
        print("Url = " + baseurl)
        print("Input Value = ",inputDic)
            if methodtype.isEqual(to: "POST"){
                Alamofire.request(baseurl, method: .post, parameters: (inputDic as! Dictionary), encoding: JSONEncoding.default, headers: ["Authorization":token ]  ).responseJSON { response in
                    if let json = response.result.value as? [String:Any] {
                        print("JSON: \(json)")
                       let Str_StatusCode = response.response?.statusCode
                        if Str_StatusCode == 401 ||  Str_StatusCode == 403{
                            let message = "InternetError"
                            let dic_message = NSMutableDictionary()
                            dic_message .setValue(message, forKey: "InternalServerError")
                            completion(dic_message)
                        }
                        if Str_StatusCode == 500 {
                            
                        }
                        if Str_StatusCode == 200 {
                            
                            let str_status = json["status"] as! Bool
                            if str_status == true{
                                if (json["data"]  as? NSDictionary) != nil{
                                    dic_res = (json["data"]  as? NSDictionary)!
                                    completion(dic_res)
                                }else{
                                    let message = json["message"] as! NSString
                                    let dic_message = NSMutableDictionary()
                                    dic_message .setValue(message, forKey: "Message")
                                    completion(dic_message)
                                }
                                
                            }else{
                                let message = json["message"] as! NSString
                                let dic_message = NSMutableDictionary()
                                dic_message .setValue(message, forKey: "Message")
                                completion(dic_message)
                            }
                        }
                    }
                }
            }
            if methodtype.isEqual(to: "PUT"){
                Alamofire.request(baseurl, method: .put, parameters: (inputDic as! Dictionary), encoding: JSONEncoding.default, headers: ["Authorization":token ]  ).responseJSON { response in
                    if let json = response.result.value as? [String:Any] {
                        print("JSON: \(json)")
                        let Str_StatusCode = response.response?.statusCode
                        if Str_StatusCode == 401 ||  Str_StatusCode == 403{
                            let message = "InternetError"
                            let dic_message = NSMutableDictionary()
                            dic_message .setValue(message, forKey: "InternalServerError")
                            completion(dic_message)
                        }
                        if Str_StatusCode == 500 {
                        }
                        if Str_StatusCode == 200 {

                        let str_status = json["status"] as! Bool
                        if str_status == true{
                            if (json["data"]  as? NSDictionary) != nil{
                                dic_res = (json["data"]  as? NSDictionary)!
                                completion(dic_res)
                            }else{
                                let message = json["message"] as! NSString
                                let dic_message = NSMutableDictionary()
                                dic_message .setValue(message, forKey: "Message")
                               completion(dic_message)
                            }
                           
                        }else{
                            let message = json["message"] as! NSString
                            let dic_message = NSMutableDictionary()
                            dic_message .setValue(message, forKey: "Message")
                            completion(dic_message)
                        }
                    }
                   
                }
            }
        }
    }
    }
    func InputValuesGetmethod   (inputDic : NSDictionary,suburl : NSString,methodtype : NSString,classVc : Any , completion: @escaping (_ data:NSArray) -> Void) {
        guard let status = Network.reachability?.status else { return }
        
       
        
        
        if status.rawValue == "unreachable"{
            (classVc as AnyObject).view.endEditing(true)
            (classVc as AnyObject).addChildViewController(bottomSheetInternetConnectionVc)
            (classVc as AnyObject).view.addSubview(bottomSheetInternetConnectionVc.view)
            bottomSheetInternetConnectionVc.didMove(toParentViewController: classVc as? UIViewController)
            let height = (classVc as AnyObject).view.frame.height
            let width  = (classVc as AnyObject).view.frame.width
            bottomSheetInternetConnectionVc.view.frame = CGRect(x:0, y: 0, width: width, height: height)
            bottomSheetInternetConnectionVc.delegate=(classVc as! InternetVcDelegate)
            
        }else{
            var  token : String = NSString() as String
            let userdefaults = UserDefaults.standard
            if userdefaults.string(forKey: "Token") != nil{
                token = "Bearer " + userdefaults.string(forKey: "Token")!
            } else {
                token = ""
            }
            var dic_res: NSArray = NSArray()
            let baseurl = kBaseUrl + (suburl as String)
            print("Url = " + baseurl)
            print("Input Value = ",inputDic)
            if methodtype.isEqual(to: "GET"){
                Alamofire.request(baseurl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization":token ]  ).responseJSON { response in
                    if let json = response.result.value as? [String:Any] {
                        print("JSON: \(json)")
                        
                        let Str_StatusCode = response.response?.statusCode
                        if Str_StatusCode == 401 ||  Str_StatusCode == 403{
                            let userdefaults = UserDefaults.standard
                            userdefaults .removeObject(forKey: "Token")
                            userdefaults .removeObject(forKey: "UserId")
                            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
                            let loginVc = storyboard1.instantiateViewController(withIdentifier: "LoginVcID") as! LoginVc
                            (classVc as AnyObject).present(loginVc, animated:false, completion:nil)
                        }
                        if Str_StatusCode == 500 {
                        }
                        if Str_StatusCode == 200 {
                            
                            let str_status = json["status"] as! Bool
                            if str_status == true{
                                if (json["data"]  as? NSArray) != nil{
                                    dic_res = (json["data"]  as? NSArray)!
                                    completion(dic_res)
                                }else{
                                    let dic_message = NSMutableArray()
                                   completion(dic_message)
                                }
                                
                            }else{
                                let dic_message = NSMutableArray()
                                completion(dic_message)
                            }
                        }
                    }
                }
            }
            
            
        }
    }
    
//func uploadImageData(inputUrl:String,parameters:[String:Any],imageName: String,imageFile : UIImage,completion:@escaping(_:Any)->Void) {
//        
//        let imageData = UIImageJPEGRepresentation(imageFile , 0.5)
//        
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            
//            multipartFormData.append(imageData!, withName: imageName, fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "image/jpeg")
//            
//            for key in parameters.keys{
//                let name = String(key)
//                if let val = parameters[name] as? String{
//                    multipartFormData.append(val.data(using: .utf8)!, withName: name)
//                }
//            }
//        }, to:inputUrl)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//                
//                upload.uploadProgress(closure: { (Progress) in
//                })
//                
//                upload.responseJSON { response in
//                    
//                    if let JSON = response.result.value {
//                        completion(JSON)
//                    }else{
//                        completion(nilValue)
//                    }
//                }
//                
//            case .failure(let encodingError):
//                completion(nilValue)
//            }
//        }
//        
//    }
    
    
    
}
