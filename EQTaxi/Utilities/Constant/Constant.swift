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

//ServerURl
/*
 let kBaseUrl = "http://andrew.a2z4smb.com/service/"
 let kBaseUrl_image = "http://192.168.50.23/eqtaxi_service/"
 let kSocketUrl = "andrew.a2z4smb.com"
 */

//ServerURl
//  BaseURL

let kBaseUrl = "http://praitaxi.a2z4smb.com/service/mobile/"
let kBaseUrl_image = "http://praitaxi.a2z4smb.com/service/"
let kSocketUrl = "http://praitaxi.a2z4smb.com:3005/socketcluster/"
 let KCountryImage = "no"
 let KLabelCountry = "+47"
 let KStrDialCode = "+47"
 let KStrCountryCode = "NO"
 let KCurrencyCode = "kr "

//LocalURl
//let kBaseUrl = "http://192.168.50.23/eqtaxi_service/mobile/"
//let kBaseUrl_image = "http://192.168.50.23/eqtaxi_service/"
//let kSocketUrl = "ws://192.168.50.52:3000/socketcluster/"
//let KCurrencyCode = "kr "
//let KCountryImage = "in"
//let KLabelCountry = "+91"
//let KStrDialCode = "+91"
//let KStrCountryCode = "IN"

// Google APIKey

let kGoogleAPIKey = "AIzaSyAT6PAk4r4JpHcXbyR_Ginyx58-KB_cSvA"

//Suburls

let kLogin = "verifyCustomerMobileNumber"
let kVerifyOTP  = "verifyCustomerOTPCode"
let KSetNewPassword = "setCustomerPassword"
let KProfileRegUpdate = "customerProfileUpdate"
let KCheckOldUserPassword = "verifyCustomerPassword"
let KCustomerHistory = "getCustomerRideHistory"
let KLogout = "setLogout"
let KForgetPasswordsentOtp = "verifyCustomerForgoetPasswordMobile"
let KAddUserCardDetails = "addUserCardDetails"
let kGetAllCards = "getUserAllCardDetails"
let kDeleteUserCard = "visibleUserCardInformation/"
let kFinalpayment = "stripePaymentByRideId/"
let kSetCardAsDefault = "setUserDefaultCardByCardId/"




let KgetAvailableVehicleType = "getAvailableVehicleType"
let kImageurl = "uploadImage"
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
