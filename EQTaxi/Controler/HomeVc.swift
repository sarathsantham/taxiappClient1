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
import SocketCluster_ios_client
class HomeVc: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate{
    var str_isStart_End_Picker = NSString()
    var dub_LatitudeStart = Double()
    var dub_LongitudeStart = Double()
    var dub_LongitudeEnd = Double()
    var dub_LatitudeEnd = Double()
    var mArr_Car_MarkerList = NSMutableArray()
    let bottomSheetMessageVC =  BottomSheetInitialSheetVc()
    let bottomSheetLocationVC =  ScrollableBottomSheetViewController()
    var CarlistbottomSheetVC =  AvailableCarListVc()

// MARK: Reference outlet for View--------------->
    
    @IBOutlet var view_TopStart_EndLocation: UIView!
    @IBOutlet var view_map: GMSMapView!
    @IBOutlet var view_Top_End: UIView!

    
    @IBOutlet var view_RippleEffect: UIView!
    
// MARK: Reference outlet for Label--------------->
    

// MARK: Reference outlet for TextField--------------->
    
    @IBOutlet var txt_endlocation: UITextField!
    @IBOutlet var txt_startLocation: UITextField!
// MARK: Reference outlet for Image--------------->
    
    @IBOutlet var img_centerpin: UIImageView!
    
// MARK: Reference outlet for Pickers--------------->
    
   
    
// MARK: Button Reference--------------->
    @IBOutlet var button_CurrentLocation: UIButton!
    @IBOutlet var button_doneFordrawPolyLine: UIButton!
    @IBOutlet var button_menu: UIButton!
    
    
// MARK: MapReferences--------------->
    var locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    
// MARK: DidLoad--------------->

    override func viewDidLoad() {
        super.viewDidLoad()
        
            // initialy Hiden Views.
      
       self.view_RippleEffect.isHidden=true
        self.view_TopStart_EndLocation.isHidden=true
        img_centerpin.isHidden=true
        button_doneFordrawPolyLine.isHidden=true
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
        
     // GetCurrent Place Name In Map
        
       self .GetCurrentPlaceNameWithLatLong(cameraPosition: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addBottomSheetViewMessage(view2: bottomSheetMessageVC)
    }
    
// MARK: TextField Delegates ------------------------->
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == txt_startLocation{
            str_isStart_End_Picker = "StartLocation"
            self .dismissKeyboard()
        }
        if textField == txt_endlocation{
            str_isStart_End_Picker = "EndLocation"
            self .dismissKeyboard()


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
        let position = CLLocationCoordinate2D(latitude:(carlist .value(forKey: "latitude") as! Double) , longitude: (carlist .value(forKey: "longitude") as! Double))
        let marker = GMSMarker(position: position)
        marker.icon = UIImage(named: "carIcon")
        marker.map = self.view_map
        mArr_Car_MarkerList .add(marker)
    }
    
// MARK: Check Driver already exist Or Not in mapView ---------------------------->
    
    func CheckDriverAvailableInMapView()  {
//       let marker = GMSMarker()
//        let defaults = UserDefaults.standard
//        let arr_livetracking = defaults.stringArray(forKey: "LivetrackCarId") ?? [String]()
//        
//        if arr_livetracking == nil || arr_livetracking.count == 0{
//            
//        }else{
//            var dic_singleValueOfLivetrack: [String: String] = [:]
//            
//            for dic_singleValueOfLivetrack in arr_livetracking{
//                
//                if self.mArr_Car_MarkerList.count == 0{
//                    
//                    self .AddCarlistToAnimate(carlist: dic_singleValueOfLivetrack as! NSDictionary)
//                    
//                }else{
//                    var f : Float = 0
//                    var h : Float = 0
//                    var obj_MyAnnotation : NSDictionary = [String :String]() as NSDictionary
//                    for obj_MyAnnotation in self.mArr_Car_MarkerList{
//                        h += 1
//                        let annotationId : String = (obj_MyAnnotation as AnyObject).title as String
//                        
//                        
//                        
//                    }
//                }
//            }
//            
//        }

    }

//    - (void)updateLocation {
//    MapAnnotation *myAnnotation;
//    NSData *data1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"LivetrackCarId"];
//    NSArray *arr_livetrack = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
//    if (arr_livetrack==nil || arr_livetrack.count==0) {
//    }else{
//
//    for (NSDictionary *objdic in arr_livetrack) {
//
//    if (_arr.count==0) {
//    [self loadMapView:objdic];
//    }else{
//    int f=0;
//    int h=0;
//    for ( MapAnnotation *obj_MyAnnotation in _arr) {
//    h++;
//    NSString *annotationId=[NSString stringWithFormat:@"%@",obj_MyAnnotation.title];
//    NSString *driverId=[NSString stringWithFormat:@"%@%@",@"CarId",[objdic valueForKey:@"fk_user_id"]];
//    NSString *oflineDriver = [[NSUserDefaults standardUserDefaults]
//    stringForKey:@"OfflineUserId"];
//    NSString *offlinecar=[NSString stringWithFormat:@"%@%@",@"CarId",oflineDriver];
//    if ([oflineDriver isEqualToString:@""] || oflineDriver==nil) {
//
//    }else{
//    if ([annotationId isEqualToString:offlinecar]) {
//    id userAnnotation = obj_MyAnnotation;
//    [_mapview removeAnnotation:userAnnotation];
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"OfflineUserId"];
//    NSMutableArray *obj_RemoveOffline_Driver=[[NSMutableArray alloc]init];
//    [obj_RemoveOffline_Driver addObjectsFromArray:arr_livetrack];
//    [obj_RemoveOffline_Driver removeObjectAtIndex: h-1];
//    NSData *data12 = [NSKeyedArchiver archivedDataWithRootObject:obj_RemoveOffline_Driver ];
//    [_arr removeObject:obj_MyAnnotation];
//    [[NSUserDefaults standardUserDefaults] setObject:data12 forKey:@"LivetrackCarId"];
//    f=1;
//    break;
//    }
//    }
//
//    if ([annotationId isEqualToString:driverId]) {
//    myAnnotation = obj_MyAnnotation;
//    oldLocation.latitude =myAnnotation.coordinate.latitude;
//    oldLocation.longitude = myAnnotation.coordinate.longitude;
//
//    newLocation.latitude =[[objdic valueForKey:@"latitude"] doubleValue];
//    newLocation.longitude =[[objdic valueForKey:@"longitude"] doubleValue];
//    float getAngle = [self angleFromCoordinate:oldLocation toCoordinate:newLocation];
//    [UIView animateWithDuration:2.0
//    animations:^{
//    myAnnotation.coordinate = newLocation;
//    AnnotationView *annotationView = (AnnotationView *)[self.mapview viewForAnnotation:myAnnotation];
//    annotationView.transform = CGAffineTransformMakeRotation(getAngle);
//    }];
//    f++;
//    }
//
//    }if(f==0){
//    [self loadMapView:objdic];
//    }
//    }
//
//    }
//    }
//
//    }
    
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
                    self.txt_startLocation.text = "    " + (place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n"))!
                    self.dub_LatitudeStart=place.coordinate.latitude
                    self.dub_LongitudeStart=place.coordinate.longitude
                    if cameraPosition == true{
                       self .DrawPoliLineInMap()
                    }
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
    
    func DrawPoliLineInMap(){
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
                                    let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(170, 30, 30, 30))
                                    self.view_map!.moveCamera(update)
                                    // Move the camera 100 points down, and 200 points to the right.
                                    let downwards = GMSCameraUpdate.scrollBy(x: 0, y: 200)
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
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        button_CurrentLocation.isHidden=false

    }

    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(cameraPosition.target) { (response, error) in
            guard error == nil else {
                return
            }
            
            if let result = response?.firstResult() {
                if self.str_isStart_End_Picker == ""{
                }
                else{
                    self .addBottomSheetViewRemove(view1:self.bottomSheetLocationVC )
                    if self.str_isStart_End_Picker == "StartLocation"{
                        self.dub_LatitudeStart=result.coordinate.latitude
                        self.dub_LongitudeStart=result.coordinate.longitude
                        let camera = GMSCameraPosition.camera(withLatitude: (self.dub_LatitudeStart), longitude: (self.dub_LongitudeStart), zoom: 15)
                        self.view_map?.animate(to: camera)
                        let address : String = result.lines![0] + "," + result.lines![1]
                         self.txt_startLocation.text = "   " + address
                    }
                    if self.str_isStart_End_Picker == "EndLocation"{
                        self.dub_LatitudeEnd=result.coordinate.latitude
                        self.dub_LongitudeEnd=result.coordinate.longitude
                        let camera = GMSCameraPosition.camera(withLatitude: (self.dub_LatitudeEnd), longitude: (self.dub_LongitudeEnd), zoom: 15)
                            self.view_map?.animate(to: camera)
                        let address : String = result.lines![0] + "," + result.lines![1]
                         self.txt_endlocation.text = "   " + address
                    }
               
                }
            }
        }
    }


// MARK: Button Actions ---------------------------->

    @IBAction func didclickDonbuttonToDisplayPoliLine(_ sender: Any) {
        if txt_startLocation.text == ""  && txt_endlocation.text == ""
        {
        }
        else{
            button_doneFordrawPolyLine.isHidden=true
            img_centerpin.isHidden=true
            view_TopStart_EndLocation.isHidden=true
            str_isStart_End_Picker = ""
            button_menu.setImage(UIImage(named: "backArrow(Black).png"), for: .normal)
            view_Top_End.isHidden=true
             self .DrawPoliLineInMap()
           
            self.CarlistbottomSheetVC = (self.storyboard?.instantiateViewController(withIdentifier: "AvailableCarListVcID"))! as! AvailableCarListVc
            self.addBottomSheetViewMessage(view2: self.CarlistbottomSheetVC)

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

        
        //remove bottom sheet message
        self .addBottomSheetViewRemove(view1: bottomSheetMessageVC)

        //add bottom sheet Location
         self .addBottomSheetViewLocation()
        
        //get location through pin in map
        str_isStart_End_Picker = "EndLocation"
       
    }
    @IBAction func didclickCancelRideRequestButton(_ sender: Any) {
    }
    @IBAction func didclickPromocodeSubmitButton(_ sender: Any) {
    }
    @IBAction func didclickRideInfoGotItButton(_ sender: Any) {
    }
    @IBAction func didclickNotificationButton(_ sender: Any) {
    }
    @IBAction func didclickMenuButton(_ sender: Any) {
        if (button_menu.currentImage?.isEqual(UIImage(named: "backArrow(Black)")))! {
              button_menu.setImage(UIImage(named: "menu.png"), for: .normal)
            BackButtonCallForMenuStartEndLOcation()
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
    
// MARK: Button Actions Methods Call ---------------------------->
    
 // For BackButton In start & End Location view and Menu Back Button Calll
    
    func BackButtonCallForMenuStartEndLOcation() {
        view_Top_End.isHidden=false
        view_TopStart_EndLocation.isHidden=true
        img_centerpin.isHidden=true
        button_doneFordrawPolyLine.isHidden=true
        self .dismissKeyboard()
        //add bottom sheet message
        addBottomSheetViewMessage(view2: bottomSheetMessageVC)

        //remove bottom sheet message
        self .addBottomSheetViewRemove(view1: bottomSheetLocationVC)
        
        //remove bottom sheet message
        self .addBottomSheetViewRemove(view1: CarlistbottomSheetVC)
        
        //get location through pin in map
        str_isStart_End_Picker = ""
         self.view_map .clear()
         CurrentLocation()

    }
    
  // update Current Location in map
    
    func CurrentLocation()  {
         self.locationManager.startUpdatingLocation()
    }

}
