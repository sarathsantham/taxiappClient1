//
//  Constant.swift
//  EQTaxiCustomer
//
//  Created by Equator Technologies on 23/01/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import Foundation
import UIKit


//  Device IPHONE
 let kIphone_4s : Bool =  (UIScreen.main.bounds.size.height == 480)
let kIphone_5 : Bool =  (UIScreen.main.bounds.size.height == 568)
let kIphone_6 : Bool =  (UIScreen.main.bounds.size.height == 667)
let kIphone_6_Plus : Bool =  (UIScreen.main.bounds.size.height == 736)


//  BaseURL

//LocalURl
let kBaseUrl = "http://192.168.50.23/eqtaxi_service/api/"
let kSocketUrl = "192.168.50.25"

//ServerURl
/*
let kBaseUrl = "http://andrew.a2z4smb.com/service/"
let kSocketUrl = "andrew.a2z4smb.com"
 */


// Google APIKey

let kGoogleAPIKey = "AIzaSyAT6PAk4r4JpHcXbyR_Ginyx58-KB_cSvA"

//Suburls

let kLogin = "sendOTP"
let kVerifyOTP  = "verifyOTP"
let KgetAvailableVehicleType = "getAvailableVehicleType"
let kImageurl = "uploadImage"
let KProfileRegUpdate = "userProfileUpdate"
let KProfileAddressupdate = "addOrUpdatePersonalInfo"
let KDriverProfileReg = "addDriverInfo"
let KVehileInfoUpdate = "addOrUpdateVehicleInfo"
let KGetLocationID = "getLocation/1/0"
let KGetVehileTypeID = "getVehicleType/1/0"
let KGetVehileBrand = "getVehicleBrand/1/0"
let KGetVehicleModelByBrand = "getVehicleModelByBrand"
let KCalculateFair = "calculateRideFare"
let KOrderHistory = "getRideByUserId"
let KestimateRideFare = "estimateRideFare"
let KVerfyCupon = "verifyCoupon"
let KPayPalPayment = "http://192.168.50.16/taxi/paypalPayment"
let kNotifications = "getNotitcationInfo"
let krideRating = "addDriverRideRating"
