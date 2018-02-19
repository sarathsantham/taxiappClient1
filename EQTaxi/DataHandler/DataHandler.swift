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

    func InputValues   (inputDic : NSDictionary,suburl : NSString,methodtype : NSString,classVc : Any , completion: @escaping (_ data:NSDictionary) -> Void) {
        guard let status = Network.reachability?.status else { return }
        if status.rawValue == "unreachable"{
            Utilities.showToast(message: "Network Error", view:classVc as! UIView)
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
                            
                        }
                        if Str_StatusCode == 500 {
                            
                        }
                        if Str_StatusCode == 200 {
                            
                            let str_status = json["status"] as! Bool
                            if str_status == true{
                                if (json["data"]  as? NSDictionary) != nil{
                                    dic_res = (json["data"]  as? NSDictionary)!
                                    completion(dic_res)
                                    print("Responce Data = ",dic_res)
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
                        
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)") // original server data as UTF8 string
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
                            
                        }
                        if Str_StatusCode == 500 {
                        }
                        if Str_StatusCode == 200 {

                        let str_status = json["status"] as! Bool
                        if str_status == true{
                            if (json["data"]  as? NSDictionary) != nil{
                                dic_res = (json["data"]  as? NSDictionary)!
                                completion(dic_res)
                                print("Responce Data = ",dic_res)
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
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)") // original server data as UTF8 string
                    }
                }
            }
        }
    
        
    }
    }
}
