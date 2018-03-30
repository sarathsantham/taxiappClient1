   //
//  HomeVc.swift
//  EQTaxi
//
//  Created by Equator Technologies on 27/01/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import CoreLocation
import Alamofire
import SwiftyJSON
import ScClient
   class HomeVc: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate,BottomSheetLocationDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CarlistCollectionViewCellDelegate,InVoiceDelegate,RatingDelegate,CustomerHistoryDelegate,MenuviewDelegate,PaymentListVcDelegate,AddcardVcDelegate{
   
    
    
    // For swipe to cancel--->
    var objDatahandler = DataHandler ()
    var velocity1:CGPoint!
    var selectedIndex = Int ()
    var str_rideId = Int ()
    var dic_BookingValues = NSMutableDictionary ()
    var arr_Carlist = NSMutableArray ()
      var rippleView: SMRippleView?
    var  dic_BookingInfoDetails = NSMutableDictionary()
    var  resultsArray_Lat_long = NSMutableArray()
    var  resultsArray_Detail = NSMutableArray()
    var  resultsArray = NSMutableArray()
    var str_isStart_End_Picker = NSString()
    var dub_LatitudeStart = Double()
    var dub_LongitudeStart = Double()
    var dub_LongitudeEnd = Double()
    var dub_LatitudeEnd = Double()
    var dub_PickupLatitude = Double()
    var dub_PickupLongitude = Double()
    var str_StartLocation = NSString()
     var str_EndLocation = NSString()
    var driver_MobileNo = NSString()

    var mArr_Car_MarkerList = NSMutableArray()
   // var mArr_Car_DriverList = NSMutableArray()

    let bottomSheetMessageVC =  BottomSheetInitialSheetVc()
    let bottomSheetLocationVC =  ScrollableBottomSheetViewController()
    var bottomsheetInVoiceVc =  InVoiceVc()
    var bottomsheetRatingVc =  RatingVc()
     var bottomsheetCustomerHistoryVc =  CustomerHistoryVc()
     var bottomsheetPaymentListVc =  PaymentListVc()
    var bottomsheetAddCardVc =  AddCardVc()
    

// MARK: socketConnection SetUp ------------------------------------>
    var client = ScClient(url: kSocketUrl)
    var onConnect = {
        (client :ScClient) in
        print("Connnected to server")
    }
    
    var onDisconnect = {
        (client :ScClient, error : Error?) in
        print("Disconnected from server due to ", error?.localizedDescription as Any)
    }
    
    var onAuthentication = {
        (client :ScClient, isAuthenticated : Bool?) in
        print("Authenticated is ", isAuthenticated as Any)
       
    }
    
    var onSetAuthentication = {
        (client : ScClient, token1 : String?) in
        print("Token is ", token1 as Any)
        
    }
    
    

// MARK: Reference outlet for View--------------->
    @IBOutlet var view_availableCarList: UIView!
    @IBOutlet var view_driverDetails: UIView!
    @IBOutlet var view_confirmPickUp: UIView!
    @IBOutlet var view_TopStart_EndLocation: UIView!
    @IBOutlet var view_map: GMSMapView!
    @IBOutlet var view_Top_End: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var view_RippleEffect: UIView!
    @IBOutlet var view_DetailCollectionView: UIView!
    @IBOutlet var view_WhiteBoxONrippleView: UIView!
    @IBOutlet var view_swipetoarrived_cancel: UIView!
    @IBOutlet var view_swipetoArrived: UIView!
    @IBOutlet var view_CarListCollectionView: UICollectionView!
    @IBOutlet var view_ShimmerForCarcollection: UIView!



// MARK: Reference outlet for Label--------------->
    
    @IBOutlet var ibi_driverName: UILabel!
    @IBOutlet var lbl_driverNo: UILabel!
    
// MARK: Reference outlet for TextField--------------->
    
    @IBOutlet var txt_ConfirmPickupLocation: UITextField!
    @IBOutlet var txt_endlocation: UITextField!
    @IBOutlet var txt_startLocation: UITextField!
// MARK: Reference outlet for Image--------------->
    
    @IBOutlet var img_driverProfile: UIImageView!
    @IBOutlet var img_centerpin: UIImageView!
    
// MARK: Reference outlet for Pickers--------------->
    
   
    
// MARK: Button Reference--------------->
    @IBOutlet var button_CurrentLocation: UIButton!
    @IBOutlet var button_doneFordrawPolyLine: UIButton!
    @IBOutlet var button_menu: UIButton!
    
    @IBOutlet var button_ConfirmBookingin_AvaiilableCars: UIButton!
    @IBOutlet var button_ConfirmPickupLocation: UIButton!
    
// MARK: MapReferences--------------->
    var locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    
// MARK: DidLoad--------------->

    override func viewDidLoad() {
        super.viewDidLoad()
        //change Language------->
        let userdefaults = UserDefaults.standard
        let lanuage =  userdefaults.string(forKey: "Lanuage")
        UserDefaults.standard.set("Home", forKey: "statusBack")//setObject
        if lanuage == ".nb"{
            txt_endlocation.placeholder = "Ankomstpunkt"
            txt_startLocation.placeholder = "Hentested"
            txt_ConfirmPickupLocation.placeholder = "bekreft hentestedet"
        }
        
        
        // forcollection view------------->
    
        
          selectedIndex = 0
        // Swipe to Arrived Button Setup------------->
        view_swipetoarrived_cancel.layer.cornerRadius = 30
        view_swipetoArrived.layer.cornerRadius = 25
        let gestureRecognizer2 = UIPanGestureRecognizer(target: self, action: #selector(handlePanSwipeToArrived))
        self.view_swipetoArrived.addGestureRecognizer(gestureRecognizer2)
        
        // Socket Connections -------------------------
        client.setBasicListener(onConnect: onConnect, onConnectError: nil, onDisconnect: onDisconnect)
        client.setAuthenticationListener(onSetAuthentication: onSetAuthentication, onAuthentication: onAuthentication)
        let status = client.isConnected()
        if status == true{
            
        }else{
            client.connect()
        }
        
        // CarDetailView CollectionView Cell Configure.
         viewConfigrations()
        
        // initialy Hiden Views.
        view_driverDetails.isHidden=true
      view_confirmPickUp.isHidden=true
        button_ConfirmPickupLocation.isHidden=true
       self.view_RippleEffect.isHidden=true
        self.view_TopStart_EndLocation.isHidden=true
        img_centerpin.isHidden=true
        button_doneFordrawPolyLine.isHidden=true
        view_DetailCollectionView.isHidden=true
       self .AddShadowTo(view_shadow: view_TopStart_EndLocation)
        self .AddShadowTo(view_shadow: view_Top_End)

        
     //Location Manager code to fetch current location  11.0265 77.1313
        
        view_map.delegate = self
        self.view_map?.isMyLocationEnabled = true
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
     // Google Place-----
         placesClient = GMSPlacesClient.shared()

     // Change Google MapStyle ------------
       self .AddGoogleMapColour()
        
         // textfield clear button ------------
        txt_startLocation.clearButtonMode = UITextFieldViewMode.whileEditing
        txt_endlocation.clearButtonMode = UITextFieldViewMode.whileEditing

    }
    func startCode(client :ScClient) {
        // start writing your code from here
        // All emit, receive and publish events
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //addBottomSheetViewMessage(view2: bottomSheetMessageVC)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            /// connect channel -------------------------
            self.ConnectChannel()
           
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
        let data = NSMutableDictionary ()
        self.client.emit(eventName: "checkIsOnRide", data: data )
        }
        
    }
    
// MARK: TextField Delegates ------------------------->
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string.count == 0
        {
            if textField==txt_endlocation  || textField==txt_startLocation {
                var text = NSString ()
                if str_isStart_End_Picker == "StartLocation"{
                 text = txt_startLocation.text! as NSString
                }
                if str_isStart_End_Picker == "EndLocation"{
                     text = txt_endlocation.text! as NSString
                }
                if (text.length == 1){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                        self.resultsArray.removeAllObjects()
                        self.resultsArray_Lat_long.removeAllObjects()
                        self.resultsArray_Detail.removeAllObjects()
                        self.bottomSheetLocationVC.GetResult(array: self.resultsArray, detailarray: self.resultsArray_Detail )
                        self.bottomSheetLocationVC.HideTableView()
                    }

                }else{
                    let placesClient = GMSPlacesClient()
                    placesClient.autocompleteQuery(text as String, bounds: nil, filter: nil, callback: { (result, error) -> Void in
                        self.resultsArray.removeAllObjects()
                        self.resultsArray_Lat_long.removeAllObjects()
                        self.resultsArray_Detail.removeAllObjects()

                        if result == nil {
                            return
                        }else{
                            for value in result!{
                                if let value = value as? GMSAutocompletePrediction{
                                    self.resultsArray .add(value.attributedPrimaryText.string)
                                    self.resultsArray_Detail.add(value.attributedSecondaryText?.string as Any)
                                     self.resultsArray_Lat_long .add(value.placeID!)
                                       print(self.resultsArray_Detail)                                }
                                
//                                self.resultsArray .add(value.attributedFullText.string)
//                                self.resultsArray_Lat_long .add(value.placeID!)
                               
                            }
                            self.bottomSheetLocationVC.GetResult(array: self.resultsArray, detailarray: self.resultsArray_Detail )
                        }
                    })
                }
                }
            }
        
        if ( textField ==  txt_endlocation  || textField==txt_startLocation){
            self.bottomSheetLocationVC.ShowTableView()
              let placesClient = GMSPlacesClient()
            var text = NSString ()
            if str_isStart_End_Picker == "StartLocation"{
                text = txt_startLocation.text! as NSString
            }
            if str_isStart_End_Picker == "EndLocation"{
                text = txt_endlocation.text! as NSString
            }
            placesClient.autocompleteQuery(text as String, bounds: nil, filter: nil, callback: { (result, error) -> Void in
                self.resultsArray.removeAllObjects()
                self.resultsArray_Lat_long.removeAllObjects()
                self.resultsArray_Detail.removeAllObjects()

                if result == nil {
                    return
                }else{
                    for value in result!{
                        if let value = value as? GMSAutocompletePrediction{
                            self.resultsArray .add(value.attributedPrimaryText.string)
                            self.resultsArray_Detail.add(value.attributedSecondaryText?.string as Any)
                            self.resultsArray_Lat_long .add(value.placeID!)
                            print(self.resultsArray_Detail)
                        }
                    }
                    self.bottomSheetLocationVC.GetResult(array: self.resultsArray, detailarray: self.resultsArray_Detail )
                }
            })
        }
        return true
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        addBottomSheetViewRemove(view1: bottomSheetLocationVC)
        addBottomSheetViewLocation(scrollable: true)
        if textField == txt_startLocation{
            str_isStart_End_Picker = "StartLocation"
            self.resultsArray.removeAllObjects()
            self.resultsArray_Lat_long.removeAllObjects()
           // self .dismissKeyboard()
        }
        if textField == txt_endlocation{
            str_isStart_End_Picker = "EndLocation"
            self.resultsArray.removeAllObjects()
            self.resultsArray_Lat_long.removeAllObjects()
          //  self .dismissKeyboard()

        }
    }
    
    
// MARK: BottomSheet ADD  ---------------------------->

    func addBottomSheetViewMessage(view2:UIViewController) {
        self.addChildViewController(view2)
        self.view.addSubview(view2.view)
        view2.didMove(toParentViewController: self)
        let height = view.frame.height
        let width  = view.frame.width
        view2.view.frame = CGRect(x:0, y: self.view.frame.maxY, width: width, height: height)
    }
    func addBottomSheetViewLocation(scrollable: Bool? = true) {
        self.addChildViewController(bottomSheetLocationVC)
        self.view.addSubview(bottomSheetLocationVC.view)
        bottomSheetLocationVC.didMove(toParentViewController: self)
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetLocationVC.view.frame = CGRect(x:0, y: self.view.frame.maxY, width: width, height: height)
        bottomSheetLocationVC.delegate = self
    }
    
    // MARK: BottomSheet Remove  ---------------------------->
    
    func addBottomSheetViewRemove(view1 : UIViewController) {
        view1.willMove(toParentViewController: nil)
        view1.view.removeFromSuperview()
        view1.removeFromParentViewController()
        view1.removeFromParentViewController()
    }
   

// MARK: Draw Shadow to view ---------------------------->

    func AddShadowTo (view_shadow:UIView) {
        view_shadow.layer.shadowOpacity = 0.8
        view_shadow.layer.shadowOffset = CGSize(width: 3, height: 3)
        view_shadow.layer.shadowRadius = 8.0
        view_shadow.layer.shadowColor = UIColor.darkGray.cgColor
    }
    

// MARK: Add Google MapColour  ---------------------------->

    func AddGoogleMapColour() {
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "map_style", withExtension: "json") {
                self.view_map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
 // MARK: Add NewDrivers To mapView after checking from socket ---------------------------->
    
    func AddCarlistToAnimate(carlist:NSDictionary)  {
        let lat   =  Double(carlist .value(forKey: "latitude") as! String)
        let long =  Double(carlist .value(forKey: "longitude")as! String)
        let position = CLLocationCoordinate2D(latitude:lat! , longitude: long! )
        let marker = GMSMarker(position: position)
        marker.icon = UIImage(named: "carIcon")
        let str_onlineDriverId : String = String(carlist["pk_user_id"] as! Int)
        marker.title = str_onlineDriverId
        marker.map = self.view_map
        mArr_Car_MarkerList .add(marker)
    }
    
    // MARK: LikeTracking for drivers --------------------------------------->
    
    func scChannelLivetracking()
    {
        client.subscribeAck(channelName: "liveTracking", ack : {
            (channelName : String, error : AnyObject?, data : AnyObject?) in
            if (error is NSNull) {
                print("Successfully subscribed to channel ", channelName)
            } else {
                print("Got error while subscribing ", error as Any)
            }
        })
        
        client.onChannel(channelName: "liveTracking" as String, ack: {
            (channelName : String , data : AnyObject?) in
            print ("Got data for channel", channelName, " object data is ", data as Any)
            let Dic_driverInfoFromSocker : NSDictionary = (data  as? NSDictionary)!
               var myannotation : GMSMarker = GMSMarker()
            if self.mArr_Car_MarkerList.count == 0 {
                self .AddCarlistToAnimate(carlist: Dic_driverInfoFromSocker)
            }
            else{
                var k: Int = 0
                
                for item in self.mArr_Car_MarkerList {
                     myannotation = item  as! GMSMarker
                    let str_onlineDriverId : Int = Dic_driverInfoFromSocker["pk_user_id"] as! Int
                    let str_DriverFromList : Int = Int(myannotation.title!)!
                    if (str_onlineDriverId == str_DriverFromList) {
                        
                        let oldlat = Double(myannotation.position.latitude)
                        let oldlong = Double(myannotation.position.longitude)
                        let old = CLLocationCoordinate2D(latitude: oldlat , longitude: oldlong )
                        let newlat : Double = Double(Dic_driverInfoFromSocker .value(forKey: "latitude") as! String)!
                        let newlong : Double = Double(Dic_driverInfoFromSocker .value(forKey: "longitude") as! String)!
                        let new = CLLocationCoordinate2D(latitude:newlat , longitude: newlong )
                        
                        let calBearing: Float = self.getHeadingForDirection(fromCoordinate: old, toCoordinate: new)
                        myannotation.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
                        myannotation.rotation = CLLocationDegrees(calBearing); //found bearing value by calculation when marker add
                        myannotation.position = old; //this can be old position to make car movement to new position
                        
                        //marker movement animation
                        CATransaction.begin()
                        CATransaction.setValue(2.0, forKey: kCATransactionAnimationDuration)
                        CATransaction.setCompletionBlock({() -> Void in
                            myannotation.rotation = (Int(0.0) != 0) ? CLLocationDegrees(0.0) : CLLocationDegrees(calBearing)
                        })
                        
                        myannotation.position = new; //this can be new position after car moved from old position to new position with animation
                        myannotation.map = self.view_map;
                        myannotation.rotation = CLLocationDegrees(calBearing);
                        CATransaction.commit()
                        
                        k=1
                        break
                    }
                }
                if k == 0 {
                    self .AddCarlistToAnimate(carlist: Dic_driverInfoFromSocker)
                    
                }
            }
        })
    }
    
    
    
// MARK: Car wrotate radius calculation method ---------------------------->

    private func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        
        let fLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let tLat: Float = Float((toLoc.latitude).degreesToRadians)
        let tLng: Float = Float((toLoc.longitude).degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        return (degree >= 0) ? degree : (360 + degree)
    }
    
    
// MARK: Get Current Location With Name And Lat Long ---------------------------->
    
    func GetCurrentPlaceNameWithLatLong(cameraPosition:Bool)  {
        
        placesClient = GMSPlacesClient.shared()
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            self.txt_startLocation.text = ""
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.txt_startLocation.text = (place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n"))!
                    self.dub_LatitudeStart=place.coordinate.latitude
                    self.dub_LongitudeStart=place.coordinate.longitude
                    self.str_StartLocation=(place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: ","))! as NSString
                    print(self.str_StartLocation)
                    if cameraPosition == true{
                       self .DrawPoliLineInMap()
                    }
                }
            }
        })
    }
    
    
// MARK: Get Latitude and Longitude by Sending Place Id ---------------------------->

    func GetplaceByPlaceId(placeId : NSString)  {
        
        placesClient.lookUpPlaceID(placeId as String, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(placeId)")
                return
            }
            
            if self.str_isStart_End_Picker == "StartLocation"{
                self.dub_LatitudeStart=place.coordinate.latitude
                self.dub_LongitudeStart=place.coordinate.longitude
                self.str_StartLocation=place.formattedAddress! as NSString
                self.txt_startLocation.text = place.formattedAddress
                if self.txt_endlocation.text != ""{
                    //remove bottom sheet location
                    self.addBottomSheetViewRemove(view1: self.bottomSheetLocationVC)
                    self.DoneButtonMethodCall()
                }else{
                    self.addBottomSheetViewRemove(view1: self.bottomSheetLocationVC)
                    self.addBottomSheetViewLocation(scrollable: true)
                }
            }
            if self.str_isStart_End_Picker == "EndLocation"{
                self.dub_LatitudeEnd=place.coordinate.latitude
                self.dub_LongitudeEnd=place.coordinate.longitude
                self.str_EndLocation=place.formattedAddress! as NSString
                self.txt_endlocation.text = place.formattedAddress
                if self.txt_startLocation.text != ""{
                    
                    //remove bottom sheet location
                    self.addBottomSheetViewRemove(view1: self.bottomSheetLocationVC)
                    self.DoneButtonMethodCall()
                }else{
                    self.addBottomSheetViewRemove(view1: self.bottomSheetLocationVC)
                    self.addBottomSheetViewLocation(scrollable: true)
                }

            }
           
        })
    }
    
// MARK: GetCurrent Location Marker And camera Zoom to It (Delegate Method Default) ---------------------------->
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 13.9)
        
        self.view_map?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func ChangeCameraPositionToCurrentLocation()  {
        
    }
    // 11.024429 77.112882  

// MARK: Poli line Roat In map (Overlay)( --------------------------------->
    func carlistShow() {
        // emit Socket To get List of Cars -------------------------------
        let data = NSMutableDictionary ()
        data ["pickup_latitude"]=self.dub_LatitudeStart
        data ["pickup_longitude"]=self.dub_LongitudeStart
        data ["drop_latitude"]=self.dub_LatitudeEnd
        data ["drop_longitude"]=self.dub_LongitudeEnd
        self.client.emit(eventName: "getEstimatedPrice", data: data )
        arr_Carlist.removeAllObjects()
        client.on(eventName: "availableCars", ack: {
            (eventName : String, data : AnyObject?) in
            print("Got data for eventName ", eventName, " data is ", data as Any)
            self.arr_Carlist .addObjects(from: data as! [Any])
            self.view_CarListCollectionView .reloadData()
            self.view_ShimmerForCarcollection.isHidden=true
            self.view_ShimmerForCarcollection.hideLoader()
            self.button_ConfirmBookingin_AvaiilableCars.isUserInteractionEnabled=true
        })
        CarcollectionviewUp()
    }
    
    func DrawPoliLineInMap(){
       
        view_ShimmerForCarcollection.isHidden=false
        let userdefaults = UserDefaults.standard
            let lanuage = userdefaults.string(forKey: "Lanuage")
        if lanuage == ".en"{
         button_ConfirmBookingin_AvaiilableCars.setTitle("No available cars", for: UIControlState.normal)
        }
        else{
              button_ConfirmBookingin_AvaiilableCars.setTitle("Ingen tilgjengelige biler", for: UIControlState.normal)
        }
        button_ConfirmBookingin_AvaiilableCars.isUserInteractionEnabled=false
       view_ShimmerForCarcollection.showLoader()
          self.view_map .clear()
        self .AddMarker(lat: dub_LatitudeStart, lon: dub_LongitudeStart,type: "pickup")
        print(dub_LatitudeStart,dub_LongitudeStart)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(dub_LatitudeStart),\(dub_LongitudeStart)&destination=\(dub_LatitudeEnd),\(dub_LongitudeEnd)&sensor=true&mode=driving&key=AIzaSyAT6PAk4r4JpHcXbyR_Ginyx58-KB_cSvA")!
            
            let task = session.dataTask(with: url, completionHandler: {
                (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                else {
                    do {
                        if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                            
                            guard let routes = json["routes"] as? NSArray else {
                                return
                            }
                            
                            if (routes.count > 0) {
                                let overview_polyline = routes[0] as? NSDictionary
                                print(overview_polyline ?? "")
                                
                                let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                                let points = dictPolyline?.object(forKey: "points") as? String
                                self.showPath(polyStr: points!)
                                DispatchQueue.main.async {
                                    let myLocation = CLLocationCoordinate2D(latitude:self.dub_LatitudeStart, longitude: self.dub_LongitudeStart)
                                    let distination = CLLocationCoordinate2D(latitude:self.dub_LatitudeEnd, longitude: self.dub_LongitudeEnd)
                                    let bounds = GMSCoordinateBounds(coordinate: myLocation, coordinate: distination)
                                    let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(150, 30, 50, 50))
                                   // let update = GMSCameraUpdate.fit(bounds)
                                    self.view_map!.moveCamera(update)
                                    // Move the camera 100 points down, and 200 points to the right.
                                    let downwards = GMSCameraUpdate.scrollBy(x: 0, y: 160)
                                    self.view_map.animate(with: downwards)
                                    self .AddMarker(lat: self.dub_LatitudeEnd, lon: self.dub_LongitudeEnd,type: "drop")
                                }
                               
                            }
                            else {
                                DispatchQueue.main.async {
                                }
                            }
                        }
                    }
                    catch {
                        print("error in JSONSerialization")
                        DispatchQueue.main.async {
                        }
                    }
                }
            })
        let status = client.isConnected()
        if status == true{
              self.carlistShow()
        }else{
             client.connect()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                 self.carlistShow()
 }
        }
        
            task.resume()
        }
  
        func showPath(polyStr :String){
 
           let path = GMSPath(fromEncodedPath: polyStr)!
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 2.5
            polyline.strokeColor = UIColor.black
                polyline.map = self.view_map // Your map vie
            // add bottom sheet  AvailableCarListVc-----------
           

        }
    
    
   
    
// MARK: Add Marker In MapView ---------------------------->
    
    func AddMarker(lat : Double,lon : Double,type:String )  {
    let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    let marker = GMSMarker(position: position)
        if type == "pickup" {
             marker.icon = UIImage(named: "pickup_pin")
        }else if type == "drop"{
             marker.icon = UIImage(named: "drop_pin")
        }
    marker.map = self.view_map
     }
    
// MARK: update location through pin in the map ---------------------------->
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        button_CurrentLocation.isHidden=false
    }
   
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(cameraPosition.target) { (response, error) in
            guard error == nil else {
                return
            }
            
            if let result = response?.firstResult() {
                if self.str_isStart_End_Picker == "" {
                }
                else{
                    self .addBottomSheetViewRemove(view1:self.bottomSheetLocationVC )
                    if self.str_isStart_End_Picker == "StartLocation"{
                        self.dub_LatitudeStart=result.coordinate.latitude
                        self.dub_LongitudeStart=result.coordinate.longitude
                        let camera = GMSCameraPosition.camera(withLatitude: (self.dub_LatitudeStart), longitude: (self.dub_LongitudeStart), zoom: 15)
                        self.view_map?.animate(to: camera)
                        let address : String = result.lines![0] + "," + result.lines![1]
                         self.txt_startLocation.text =  address
                        self.str_StartLocation=address as NSString
                    }
                    if self.str_isStart_End_Picker == "EndLocation"{
                        self.dub_LatitudeEnd=result.coordinate.latitude
                        self.dub_LongitudeEnd=result.coordinate.longitude
                        let camera = GMSCameraPosition.camera(withLatitude: (self.dub_LatitudeEnd), longitude: (self.dub_LongitudeEnd), zoom: 15)
                            self.view_map?.animate(to: camera)
                        let address : String = result.lines![0] + "," + result.lines![1]
                         self.txt_endlocation.text =  address
                        self.str_EndLocation=address as NSString
                    }
                    if self.str_isStart_End_Picker == "PickUpLocation"{
                        self.dub_PickupLatitude=result.coordinate.latitude
                        self.dub_PickupLongitude=result.coordinate.longitude
                        let address : String = result.lines![0] + "," + result.lines![1]
                        self.txt_ConfirmPickupLocation.text =  address
                    }
               
                }
            }
        }
    }


// MARK: Button Actions ---------------------------->
    @IBAction func handlePanSwipeToArrived(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self.view_swipetoarrived_cancel)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view_swipetoArrived)
            velocity1 = gestureRecognizer.velocity(in: view_swipetoArrived)
            print(velocity1)
        }
        else if gestureRecognizer.state == .failed
        {
            SetoriginalPositionInSwipeButton()
        }
        else if gestureRecognizer.state == .ended
        {
            if velocity1.x > 380.168 {
                  DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {self.RemoveRipple() })
                view_RippleEffect.isHidden=true
                rippleView?.stopAnimation()
//                let data = NSMutableDictionary ()
//                data ["ride_id"]=self.str_rideId
//                self.client.emit(eventName: "cancelRide", data: data )
                 DoneButtonMethodCall()
            } else {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.SetoriginalPositionInSwipeButton()
                })
            }
            
        }
    }
    @IBAction func didclickConfirmPickupLocationButton(_ sender: Any) {
        let data = NSMutableDictionary ()
        data ["ride_date"]=""
        data ["fk_vehicle_type_id"]=dic_BookingInfoDetails .value(forKey: "fk_vehicle_type_id")
        data ["ride_pickup_longitude"]=dub_PickupLongitude
        data ["ride_pickup_location"]=str_StartLocation
        data ["ride_pickup_latitude"]=dub_PickupLatitude
        data ["ride_drop_latitude"]=dub_LatitudeEnd
        data ["ride_pickup_time"]=""
        data ["ride_drop_location"]=str_EndLocation
        data ["ride_drop_longitude"]=dub_LongitudeEnd
        data ["ride_coupon_code"]=""
        data ["ride_payment_type"]="Cash"
        data ["fk_city_id"]=dic_BookingInfoDetails .value(forKey: "fk_city_id")
        data ["ride_type"]="Now"
        self.client.emit(eventName: "bookRide", data: data )
        view_confirmPickUp.isHidden=true
        img_centerpin.isHidden=true
        button_ConfirmPickupLocation.isHidden=true
        SetoriginalPositionInSwipeButton()
     view_RippleEffect.isHidden=false
        let fillColor: UIColor? = UIColor.clear
        rippleView = SMRippleView(frame: view_WhiteBoxONrippleView.bounds, rippleColor: UIColor.white, rippleThickness: 0.3, rippleTimer: 0.8, fillColor: fillColor, animationDuration: 1, parentFrame: self.view.frame)
        self.view_WhiteBoxONrippleView.addSubview(rippleView!)
        let camera = GMSCameraPosition.camera(withLatitude: dub_PickupLatitude, longitude: dub_PickupLongitude, zoom: 12.0)
        self.view_map?.animate(to: camera)
    }
    @IBAction func didclickDonbuttonToDisplayPoliLine(_ sender: Any) {
        if txt_startLocation.text == ""  || txt_endlocation.text == ""
        {
            if txt_startLocation.text == ""{
                txt_startLocation .becomeFirstResponder()
            }else{
                 txt_endlocation .becomeFirstResponder()
            }
        }
        else{
            DoneButtonMethodCall()
        }
    }
    
    @IBAction func didclickBackButtonInTopStartEndLocationView(_ sender: Any) {
        BackButtonCallForMenuStartEndLOcation()
    }
    @IBAction func didclickWhereToGoTopviewButton(_ sender: Any) {
        
        self .dismissKeyboard()
        view_TopStart_EndLocation.isHidden=false
        img_centerpin.isHidden=false
        button_doneFordrawPolyLine.isHidden=false
         txt_endlocation .text = ""
        
        // GetCurrent Place Name In Map
        
        self .GetCurrentPlaceNameWithLatLong(cameraPosition: false)
        
        //remove bottom sheet message
        self .addBottomSheetViewRemove(view1: bottomSheetMessageVC)

        //add bottom sheet Location
         self .addBottomSheetViewLocation()
        
        //get location through pin in map
        str_isStart_End_Picker = "EndLocation"
        
        
       
    }
    @IBAction func didclickCancelRideRequestButton(_ sender: Any) {
    }
    @IBAction func didclickMenuButton(_ sender: Any) {
         let userdefaults = UserDefaults.standard
        let  status = userdefaults.string(forKey: "statusBack")
        if (status == "Home") {
           
            if  str_isStart_End_Picker == "PickUpLocation"{
                str_isStart_End_Picker = ""
                view_confirmPickUp.isHidden=true
                button_ConfirmPickupLocation.isHidden=true
                img_centerpin.isHidden=true
                  DoneButtonMethodCall()
            }else{
                
                BackButtonCallForMenuStartEndLOcation()
            }
             UserDefaults.standard.set("Back", forKey: "statusBack")
        }else{
            UserDefaults.standard.set("Home", forKey: "statusBack")
            let sideMenuVC = UIStoryboard(name:"Main",bundle:nil).instantiateViewController(withIdentifier: "MenuViewID")as!MenuView
            sideMenuVC.delegate=self
            let vc = self
            vc.addChildViewController(sideMenuVC)
            vc.view.addSubview(sideMenuVC.view)
            sideMenuVC.didMove(toParentViewController: vc)
            let transition = CATransition()
            let withDuration = 0.3
            transition.duration = withDuration
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush
            transition.subtype =  kCATransitionFromLeft
            sideMenuVC.view.layer.add(transition, forKey: kCATransition)
            

        }
    }
    @IBAction func didclickRidenowButton(_ sender: Any) {
    }
   
    @IBAction func didclickRideLaterButton(_ sender: Any) {
    }
    @IBAction func didclickGetCurrentLocation(_ sender: Any) {
        button_CurrentLocation.isHidden=true
        CurrentLocation()
    }
    @IBAction func didclickBookNowButton(_ sender: Any) {
    }
    @IBAction func didclickApplyPromocodeViewButton(_ sender: Any) {
    }
    @IBAction func didclickRideFairInfoButton(_ sender: Any) {
    }
    @IBAction func didclickPaymentTypePayPalButton(_ sender: Any) {
    }
    @IBAction func didclickCash_PayPalButton(_ sender: Any) {
    }
    @IBAction func didclickPaymentTypeCashButton(_ sender: Any) {
    }
    @IBAction func didclickRideDate_TimeButton(_ sender: Any) {
    }
    @IBAction func didclickCancelDriverRideButton(_ sender: Any) {
    }
    @IBAction func didclickDetailCloseCollectionView(_ sender: Any) {
        //add bottom sheet message
       
        view_DetailCollectionView.isHidden=true
    }
    @IBAction func didclickShareDriverLocation(_ sender: Any) {
    }
    @IBAction func didclickCallDriverButton(_ sender: Any) {
    }
    @IBAction func didclickDatePickerOkButton(_ sender: Any) {
    }
    @IBAction func didclickDatepickerValueChangeButton(_ sender: Any) {
    }
    @IBAction func didclickTimeValueChangeButton(_ sender: Any) {
    }
    @IBAction func didclickTimeOkButton(_ sender: Any) {
    }
    @IBAction func didBookselectedCarListButton(_ sender: Any) {
        GetuserCardDetails()
    }
    
// MARK: Button Actions For Driver view ---------------------------->
    
    @IBAction func didclickRideCancel(_ sender: Any) {
        let data = NSMutableDictionary ()
        data ["ride_id"]=self.str_rideId
self.client.emit(eventName: "cancelRide", data: data )
    }
    @IBAction func didclickcallDriver(_ sender: Any) {
        let url = URL(string: "tel://" + (driver_MobileNo as String))
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!)
        } else {
            // Fallback on earlier versions
        }
    }
    @IBAction func didclickShareLocation(_ sender: Any) {
    }
    // MARK: Button Actions Methods Call ---------------------------->
    
 // carcollectionview Up --------------------------->
    func CarcollectionviewUp()  {
        UIView.animate(withDuration: 0.6, animations: {
        if (kIphone_4s) {
                        self.view_availableCarList.frame = CGRect(x: 0, y: 180.0, width: 320.0, height: 300.0)
                    }
                    if (kIphone_5) {
                        self.view_availableCarList.frame = CGRect(x: 0, y: 268.0, width: 320.0, height: 300.0)
                    }
                    if (kIphone_6) {
                        self.view_availableCarList.frame = CGRect(x: 0, y: 367, width: 375.0, height: 300.0)
                    }
                    if (kIphone_6_Plus) {
                        self.view_availableCarList.frame = CGRect(x: 0, y: 436, width: 414.0, height: 300.0)
                    }
             })

    }
    
  // carcollectionview down --------------------------->
    func CarcollectionviewDown()  {
         UIView.animate(withDuration: 0.6, animations: {
        if (kIphone_4s) {
            self.view_availableCarList.frame = CGRect(x: 0, y: 480.0, width: 320.0, height: 300.0)
        }
        if (kIphone_5) {
            self.view_availableCarList.frame = CGRect(x: 0, y: 568.0, width: 320.0, height: 300.0)
        }
        if (kIphone_6) {
            self.view_availableCarList.frame = CGRect(x: 0, y: 668, width: 375.0, height: 300.0)
        }
        if (kIphone_6_Plus) {
            self.view_availableCarList.frame = CGRect(x: 0, y: 736, width: 414.0, height: 300.0)
        }
        })
    }
    
    func SetoriginalPositionInSwipeButton()
    {
    if (kIphone_4s){
    self.view_swipetoArrived.frame = CGRect (x: 5, y: 4, width: 56, height: 34)
    self.view_swipetoarrived_cancel.frame = CGRect (x: 20, y: 423, width: 280, height: 42)
    }
    else if (kIphone_5){
    self.view_swipetoArrived.frame = CGRect (x: 5, y: 5, width: 56, height: 40)
    self.view_swipetoarrived_cancel.frame = CGRect (x: 20, y: 500, width: 280, height: 50)
    
    }
    else if (kIphone_6){
    self.view_swipetoArrived.frame = CGRect (x: 6, y: 6, width: 66, height: 47)
    self.view_swipetoarrived_cancel.frame = CGRect (x: 23, y: 587, width: 329, height: 59)
    }
    else if (kIphone_6_Plus){
    self.view_swipetoArrived.frame = CGRect (x: 6, y: 7, width: 73, height: 52)
    self.view_swipetoarrived_cancel.frame = CGRect (x: 26, y: 648, width: 362, height: 65)
    }
    }
    // For Removing Repple effect from View -------------------------

    func RemoveRipple(){
        self.rippleView?.stopAnimation()
    }
   
 // For BackButton In start & End Location view and Menu Back Button Calll
    
    func BackButtonCallForMenuStartEndLOcation() {
        button_menu.setImage(UIImage(named: "menu.png"), for: .normal)
        view_Top_End.isHidden=false
        view_TopStart_EndLocation.isHidden=true
        img_centerpin.isHidden=true
        button_doneFordrawPolyLine.isHidden=true
        self .dismissKeyboard()
        
        //add bottom sheet message
       // addBottomSheetViewMessage(view2: bottomSheetMessageVC)

        //remove bottom sheet message
        self .addBottomSheetViewRemove(view1: bottomSheetLocationVC)
        
        //remove bottom sheet message
        CarcollectionviewDown()
        
        //get location through pin in map
        str_isStart_End_Picker = ""
         self.view_map .clear()
         CurrentLocation()

    }
    // For Done button Method call For Optimization ----------------

    func DoneButtonMethodCall() {
        button_doneFordrawPolyLine.isHidden=true
        img_centerpin.isHidden=true
        view_TopStart_EndLocation.isHidden=true
        str_isStart_End_Picker = ""
        button_menu.setImage(UIImage(named: "backArrow(Black).png"), for: .normal)
        view_Top_End.isHidden=true
        self .DrawPoliLineInMap()
       
    }
    
    
  // update Current Location in map
    
    func CurrentLocation()  {
         self.locationManager.startUpdatingLocation()
    }
    
    
// MARK: connect channel -------------------->
    
    func ConnectChannel()  {
         userStatusChannel()
        scChannelLivetracking()
        let userdefaults = UserDefaults.standard
        let userid = userdefaults.string(forKey: "UserId")! as NSString
        let channelname123 = "user#" + (userid as String) as NSString
        
        client.subscribeAck(channelName: channelname123 as String, ack : {
            (channelName : String, error : AnyObject?, data : AnyObject?) in
            if (error is NSNull) {
                print("Successfully subscribed to channel ", channelName)
            } else {
                print("Got error while subscribing ", error as Any)
            }
        })
        
        client.onChannel(channelName: channelname123 as String, ack: {
            (channelName : String , data : AnyObject?) in
            print ("Got data for channel", channelName, " object data is ", data as Any)
           let  dic_res = (data  as? NSDictionary)!
            let actionname : NSString = dic_res.value(forKey: "action") as! NSString
            if actionname ==  "booking_success" {
                let dic_ride_confirmed_responce : NSDictionary = dic_res.value(forKey: "data") as! NSDictionary
                self.str_rideId = (dic_ride_confirmed_responce .value(forKey: "pk_ride_id") as! Int)
            }
            else if actionname ==  "booking_failed" {
                self.view_RippleEffect.isHidden=true
                self.rippleView?.stopAnimation()
                self.DoneButtonMethodCall()
            }
            
             else if actionname ==  "driver_not_available" {
                self.view_RippleEffect.isHidden=true
                self.rippleView?.stopAnimation()
                 Utilities .showToast(message: "Driver not available", view: self.view)
                self.DoneButtonMethodCall()
            }
            else if actionname ==  "userStatus" {
                self.view_RippleEffect.isHidden=true
                self.rippleView?.stopAnimation()
                Utilities .showToast(message: "Driver not available", view: self.view)
                self.DoneButtonMethodCall()
            }
             else if actionname ==  "ride_confirmed" {
               
                self.view_Top_End.isHidden=true
                self.view_RippleEffect.isHidden=true
                self.rippleView?.stopAnimation()
                self.view_driverDetails.isHidden=false
                  let dic_ride_confirmed_responce : NSDictionary = dic_res.value(forKey: "data") as! NSDictionary
                self.str_rideId = (dic_ride_confirmed_responce .value(forKey: "ride_id") as! Int)
                self.driver_MobileNo = (dic_ride_confirmed_responce .value(forKey: "mobile_no") as! NSString)
                self.lbl_driverNo.text = ("\(dic_ride_confirmed_responce .value(forKey: "vehicle_no") as? String ?? "") ")
                 self.ibi_driverName.text = (dic_ride_confirmed_responce .value(forKey: "driver_name") as! String)
                let img_str = (dic_ride_confirmed_responce .value(forKey: "driver_image") as! String)
                let str_fullpath = kBaseUrl_image + img_str
                let url = URL(string: str_fullpath)
                let data = try? Data(contentsOf: url!)
                var image1 = UIImage ()
                if let imageData = data {
                    image1 = UIImage(data: imageData)!
                }
                self.img_driverProfile.image = image1
                self.BackButtonCallForMenuStartEndLOcation()
                self.view_Top_End.isHidden=true
            }
             else if actionname ==  "ride_not_confirmed" {
                 self.view_RippleEffect.isHidden=true
                self.rippleView?.stopAnimation()
               Utilities .showToast(message: "Ride not confirmed", view: self.view)
                 self.DoneButtonMethodCall()
            }
            else if actionname ==  "driver_arrived" {
                 self.view_RippleEffect.isHidden=true
                self.rippleView?.stopAnimation()
                 Utilities .showToast(message: "Driver arrived", view: self.view)
            }
            else if actionname ==  "ride_started" {
                 self.view_RippleEffect.isHidden=true
                self.rippleView?.stopAnimation()
               Utilities .showToast(message: "Ride started", view: self.view)
            }
            else if actionname ==  "ride_invoice" {
                 self.view_driverDetails.isHidden=true
                 let dic_ride_confirmed_responce : NSDictionary = dic_res.value(forKey: "data") as! NSDictionary
                self.addBottomSheetViewMessage(view2: self.bottomsheetInVoiceVc)
                self.bottomsheetInVoiceVc.delegate=self
                self.bottomsheetInVoiceVc .setallValuesInView(dic_value: dic_ride_confirmed_responce)
            }else if actionname ==  "ride_cancelled" {
                self.view_driverDetails.isHidden=true
                self.BackButtonCallForMenuStartEndLOcation()
            }
            else if actionname ==  "alert_message" {
                 let message : NSString = dic_res.value(forKey: "message") as! NSString
                Utilities .showToast(message: message as String, view: self.view)
            }
            
        })
    }
    func  userStatusChannel()  {
        client.subscribeAck(channelName: "userStatus", ack : {
            (channelName : String, error : AnyObject?, data : AnyObject?) in
            if (error is NSNull) {
                print("Successfully subscribed to channel ", channelName)
            } else {
                print("Got error while subscribing ", error as Any)
            }
        })
        
        client.onChannel(channelName: "userStatus" as String, ack: {
            (channelName : String , data : AnyObject?) in
            print ("Got data for channel", channelName, " object data is ", data as Any)
            let  dic_res = (data  as? NSDictionary)!
            let actionname : Int = dic_res.value(forKey: "status") as! Int
            let emptyDic = NSDictionary ()
            let Dic_driverInfoFromSocker : NSDictionary = dic_res.value(forKey: "data") as? NSDictionary ?? emptyDic
            if actionname ==  0 {
                if Dic_driverInfoFromSocker.count != 0{
                var myannotation : GMSMarker = GMSMarker()
                var f: Int = 0
                for item in self.mArr_Car_MarkerList {
                    myannotation = item  as! GMSMarker
                    let str_onlineDriverId : Int = Dic_driverInfoFromSocker["pk_user_id"] as! Int
                    let str_DriverFromList : Int = Int(myannotation.title!)!
                    if (str_onlineDriverId == str_DriverFromList) {
                        myannotation.map = nil
                         self.mArr_Car_MarkerList.remove(f)
                        break
                    }
                     f = f + 1
            }
                }
            }
            else if  actionname ==  1 {
        

            }
        }
        
        )
    }
    
 //  MARK:  ServiceCall ---------------------------------------
    func GetuserCardDetails()  {
         Utilities .showLoading(message: "Loading...", view: self)
        let dic_inputValues = [String : String]()
        objDatahandler .InputValuesGetmethod(inputDic: dic_inputValues as NSDictionary, suburl: kGetAllCards as NSString,methodtype:  "GET", classVc : self) {
            (  dic_data) in
            if dic_data.count == 0 {
                  UserDefaults.standard.set("FromHome", forKey: "AddCard")
                Utilities .HideLoading(view: self)
                self.bottomsheetAddCardVc = (self.storyboard?.instantiateViewController(withIdentifier: "AddCardVcID"))! as! AddCardVc
                self.bottomsheetAddCardVc.delegate=self
                self.addBottomSheetViewMessage(view2: self.bottomsheetAddCardVc)
            }else{
                 UserDefaults.standard.set("FromHome", forKey: "AddCard")
                 Utilities .HideLoading(view: self)
                self.dic_BookingInfoDetails .setDictionary(self.dic_BookingValues as! [AnyHashable : Any])
                self.button_ConfirmPickupLocation.isHidden=false
                self.view_confirmPickUp.isHidden=false
                self.view_map .clear()
                self.img_centerpin.isHidden=false
                self.str_isStart_End_Picker = "PickUpLocation"
                self.button_doneFordrawPolyLine.isHidden=true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    let camera = GMSCameraPosition.camera(withLatitude:self.dub_LatitudeStart, longitude:self.dub_LongitudeStart, zoom: 16)
                    self.view_map?.animate(to: camera)
                }
                self.CarcollectionviewDown()
                
            }
            
            
        }
        
    }
    
    
    
//  MARK:  Delegate Methods (OverAll) ---------------------------------------
    
     //MenuVc Delegate Methods -------------------------->
    func didclickBackPaymentVcButton(){
        addBottomSheetViewRemove(view1: bottomsheetPaymentListVc)
    }

    //MenuVc Delegate Methods -------------------------->
    func didclickLogoutButton(){
        let userdefaults = UserDefaults.standard
        userdefaults .removeObject(forKey: "Token")
        userdefaults .removeObject(forKey: "UserId")
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let loginVc = storyboard1.instantiateViewController(withIdentifier: "LoginVcID") as! LoginVc
        self.present(loginVc, animated:false, completion:nil)
    }
    func didclickRideHistoryButton(){
    self.bottomsheetCustomerHistoryVc = (self.storyboard?.instantiateViewController(withIdentifier: "bottomsheetCustomerHistoryVcID"))! as! CustomerHistoryVc
         bottomsheetCustomerHistoryVc.delegate=self
        addBottomSheetViewMessage(view2: bottomsheetCustomerHistoryVc)
        
    }
    func didclickPayments(){
        self.bottomsheetPaymentListVc = (self.storyboard?.instantiateViewController(withIdentifier: "PaymentListVcID"))! as! PaymentListVc
        bottomsheetPaymentListVc.delegate=self
        addBottomSheetViewMessage(view2: bottomsheetPaymentListVc)
        
    }
    func didclickRideNow(){
        
    }
    //PaymentVc method Delegate Methods -------------------------->

    func didclickAddcardButtonAction(){
          addBottomSheetViewRemove(view1: bottomsheetPaymentListVc)
        self.bottomsheetAddCardVc = (self.storyboard?.instantiateViewController(withIdentifier: "AddCardVcID"))! as! AddCardVc
        bottomsheetAddCardVc.delegate=self
        addBottomSheetViewMessage(view2: bottomsheetAddCardVc)
    }
     //Addcardvc method Delegate Methods -------------------------->
    func didclickBackAddCartVcButton() {
        addBottomSheetViewRemove(view1: bottomsheetAddCardVc)
        let userdefaults = UserDefaults.standard
        let  type = userdefaults.string(forKey: "AddCard")!
        if type == "FromHome"{
            
        }else{
        self.bottomsheetPaymentListVc = (self.storyboard?.instantiateViewController(withIdentifier: "PaymentListVcID"))! as! PaymentListVc
        bottomsheetPaymentListVc.delegate=self
           addBottomSheetViewMessage(view2: bottomsheetPaymentListVc)
        }
    }
    //Customer method Delegate Methods -------------------------->
    
    func didclickBackCustomerHistoryButton() {
    addBottomSheetViewRemove(view1: bottomsheetCustomerHistoryVc)
    }
     //RatingVc method Delegate Methods -------------------------->
    func didclickRatingButton(dic_valuesRating:NSMutableDictionary) {
        let data = NSMutableDictionary ()
        data ["ride_id"]=self.str_rideId
        data ["driver_rating"] = dic_valuesRating .value(forKey: "driver")
        data ["car_rating"] = dic_valuesRating .value(forKey: "car")
        data ["service_rating"] = dic_valuesRating .value(forKey: "experience")
        data ["ride_comments"] = dic_valuesRating .value(forKey: "comment")
        
        self.client.emit(eventName: "addDriverRating", data: data )
         addBottomSheetViewRemove(view1: bottomsheetRatingVc)
        self.BackButtonCallForMenuStartEndLOcation()
    }
    //Invoice method Delegate Methods -------------------------->

    func DidSelectOkButton() {
        addBottomSheetViewRemove(view1: bottomsheetInVoiceVc)
        addBottomSheetViewMessage(view2: bottomsheetRatingVc)
        bottomsheetRatingVc.delegate=self
    }
    
    //locationBottomSheet Delegate Methods -------------------------->
    func DidSelectLocation(index : NSInteger) {
        dismissKeyboard()
        self .GetplaceByPlaceId(placeId: resultsArray_Lat_long .object(at: index) as! NSString)
      
    }
    func DismisskeyboardFromHomeVc(){
        dismissKeyboard()
    }
    
// MARK:  CollectionView Animation In detailCarlist  Delegates Methods ---------------------------->
    
   
    
    
    private func viewConfigrations() {
        
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        collectionView.contentInset = UIEdgeInsetsMake(0, 30, 0, 30)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    func updateCellsLayout()  {
        
        let centerX = collectionView.contentOffset.x + (collectionView.frame.size.width)/2
        for cell in collectionView.visibleCells {
            var offsetX = centerX - cell.center.x
            if offsetX < 0 {
                offsetX *= -1
            }
            cell.transform = CGAffineTransform.identity
            let offsetPercentage = offsetX / (view.bounds.width * 2.7)
            let scaleX = 1-offsetPercentage
            cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
        }
    }
    
 
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(arr_Carlist)
        return arr_Carlist.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! CarlistCollectionViewCell
        cell.delegate = self 
        let index : NSInteger = indexPath.row
        cell .DidSelectMethod(index: index)
        let objdic: NSDictionary = arr_Carlist .object(at: indexPath.row) as! NSDictionary
        cell.lbl_CarName.text =  objdic .value(forKey: "vehicle_type") as? String
        let fare : Float = objdic .value(forKey: "estimated_fare") as!  Float
        cell.ibi_CarPrice.text = "\(KCurrencyCode)\(String(format: "%.2f",fare))"
        //cell.ibi_CarPrice.text = "\(KCurrencyCode)\(String(fare))"
        if selectedIndex == indexPath.row
        {
            dic_BookingValues .setDictionary(objdic as! [AnyHashable : Any])
            let str_img =    objdic .value(forKey: "vehicle_type_image_active") as? String
            let str_vehiclename =  "Confirm " +  "\(objdic .value(forKey: "vehicle_type") as? String ?? "")"
            button_ConfirmBookingin_AvaiilableCars.setTitle(str_vehiclename, for: UIControlState.normal)
            let str_fullpath = kBaseUrl_image + str_img!
            let url = URL(string: str_fullpath)
            let data = try? Data(contentsOf: url!)
            var image = UIImage ()
            if let imageData = data {
                image = UIImage(data: imageData)!
            }
            let expandTransform:CGAffineTransform = CGAffineTransform(scaleX: 1.04, y: 1.04);
            UIView.transition(with: cell.img_Carimage,
                              duration:0.2,
                              options: UIViewAnimationOptions.transitionCrossDissolve,
                              animations: {
                                cell.img_Carimage.image = image
                                cell.img_Carimage.transform = expandTransform
            },
                              completion: {(finished: Bool) in
                                UIView.animate(withDuration: 0.2,
                                               delay:0.0,
                                               usingSpringWithDamping:0.40,
                                               initialSpringVelocity:0.2,
                                               options:UIViewAnimationOptions.curveEaseOut,
                                               animations: {
                                                cell.img_Carimage.transform = expandTransform.inverted()
                                }, completion:nil)
            })
        }
        else
        {
            let str_img =    objdic .value(forKey: "vehicle_type_image") as? String
            let str_fullpath = kBaseUrl_image + str_img!
            let url = URL(string: str_fullpath)
            let data = try? Data(contentsOf: url!)
            var image = UIImage ()
            if let imageData = data {
                image = UIImage(data: imageData)!
            }
            cell.img_Carimage.image = image
        }
        
        //  let yourImage: UIImage = UIImage(named: "taxi_default_inactive")!
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        selectedIndex = indexPath.row
        view_CarListCollectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if arr_Carlist.count == 1 &&  arr_Carlist.count == 1{
        let totalCellWidth = 114 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)
        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
        }else{
            
        }
      return UIEdgeInsetsFromString("0")
    }
}

//// MARK:  CollectionView Animation In detailCarlist   View ---------------------------->
//
//extension HomeVc: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
//        print(index)
//       // cell.wallpaperImageView.image = UIImage(named: "\(indexPath.item)")
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        var cellSize: CGSize = collectionView.bounds.size
//
//        cellSize.width -= collectionView.contentInset.left * 2
//        cellSize.width -= collectionView.contentInset.right * 2
//        cellSize.height = cellSize.width
//
//        return cellSize
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        updateCellsLayout()
//    }
//
//
//}



