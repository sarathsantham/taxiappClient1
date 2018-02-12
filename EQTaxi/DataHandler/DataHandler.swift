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

    func InputValues   (inputDic : NSDictionary,suburl : NSString,methodtype : NSString,classVc :Any , completion: @escaping (_ data:NSDictionary) -> Void) {
        guard let status = Network.reachability?.status else { return }
        if status.rawValue == "unreachable"{
            Toast("Network Error") .show(classVc as! UIViewController)
        }else{
/*
            let  token : String =  (UserDefaults.standard.string(forKey: "Token"))!
        //let  token : String = ""
        var dic_res: NSDictionary = NSDictionary()
        let baseurl = kBaseUrl + (suburl as String)
        print(baseurl)
        if methodtype.isEqual(to: "POST"){.
        Alamofire.request(baseurl, method: .post, parameters: (inputDic as! Dictionary), encoding: JSONEncoding.default, headers: ["Authorization":token ]  ).responseJSON { response in
            if let json = response.result.value as? [String:Any] {
                print("JSON: \(json)")
                let str_status = json["status"] as! Bool
                if str_status == true{
                    dic_res = (json["data"]  as? NSDictionary)!
                    completion(dic_res)
                }
            }

            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
        }

        
     */
        
    }
    }
}
