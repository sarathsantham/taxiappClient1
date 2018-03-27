//
//  InVoiceVc.swift
//  EQTaxi
//
//  Created by Equator Technologies on 01/03/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import UIKit
protocol InVoiceDelegate: class {
    func DidSelectOkButton()
    
}

class InVoiceVc: UIViewController{
    
     var objDatahandler = DataHandler ()
    var cardId = String()
    var rideId = String()
    @IBOutlet var txt_cvvtxt: UITextField!
    @IBOutlet var view_cvv: UIView!
    @IBOutlet var view_selectcard: UIView!
    @IBOutlet var view_bler: UIView!
    @IBOutlet weak var tableView: UITableView!
     var restlt_Detailarray = NSMutableArray ()
     weak var delegate: InVoiceDelegate?
    @IBOutlet var lbl_waitingTime: UILabel!
    @IBOutlet var lbl_VAT: UILabel!
    @IBOutlet var lbl_durationFare: UILabel!
    @IBOutlet var lbl_distanceFare: UILabel!
    @IBOutlet var lbl_waitingFare: UILabel!
    @IBOutlet var lbl_totalduration: UILabel!
    @IBOutlet var lbl_totalDistance: UILabel!
    @IBOutlet var lbl_droplocation: UILabel!
    @IBOutlet var lbl_Pickuplocation: UILabel!
    @IBOutlet var lbl_totalFare: UILabel!
    @IBOutlet var lbl_baseFare: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       // view_bler.isHidden=true
// self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
       // GetuserCardDetails()
        // Do any additional setup after loading the view.
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            self?.view.frame = CGRect(x: 0, y: 0, width: (self?.view.frame.width)!, height: (self?.view.frame.height)!)
        })
    }
    public func setallValuesInView(dic_value : NSDictionary){
        rideId = ""
       // rideId = String(format: "%d",dic_value .value(forKey: "ride_id") as! Int )
        rideId = (String(format: "%@",dic_value.value(forKey: "ride_id")as! CVarArg)as NSString) as String
        lbl_totalFare.text = KCurrencyCode +  String(format: "%.2f", dic_value .value(forKey: "total_fare") as! Float)
        lbl_Pickuplocation.text = "\(dic_value .value(forKey: "pickup_location") ?? "")"
        lbl_droplocation.text = "\(dic_value .value(forKey: "drop_location") ?? "")"
        lbl_totalDistance.text = String(format: "%.2f", dic_value .value(forKey: "total_distance") as! Float) + " Km"
        let str_ridetime_cli : Int = Int(dic_value .value(forKey: "ride_time") as! String)!
        let seconds: Int = str_ridetime_cli % 60
        let minutes: Int = (str_ridetime_cli / 60) % 60
        let hours: Int = str_ridetime_cli / 3600
        lbl_totalduration.text =  String(format: "%02dhr %02dmin %02dsec",hours, minutes, seconds)
        lbl_waitingFare.text = KCurrencyCode +  String(format: "%.2f%@", dic_value .value(forKey: "waiting_fare") as! Float,"/Min")
         lbl_VAT.text = KCurrencyCode +  String(format: "%.2f", dic_value .value(forKey: "service_tax") as! Float)
        lbl_baseFare.text =  KCurrencyCode +  String(format: "%.2f", dic_value .value(forKey: "base_fare") as! Float)
        lbl_distanceFare.text = KCurrencyCode +  String(format: "%.2f%@", dic_value .value(forKey: "distance_fare") as! Float,"/Km")
        lbl_durationFare.text = KCurrencyCode +  String(format: "%.2f%@", dic_value .value(forKey: "duration_fare") as! Float,"/Min")
         let str_WaitingTime : Int = Int(dic_value .value(forKey: "waiting_time") as! String)!
        let seconds2: Int = str_WaitingTime % 60
        let minutes2: Int = (str_WaitingTime / 60) % 60
        let hours2: Int = str_WaitingTime / 3600
        lbl_waitingTime.text = String(format: "%02dh %02dm %02ds",hours2, minutes2, seconds2)
    }
    
    @IBAction func didclickdoneButton(_ sender: Any) {
         Utilities .showLoading(message: "Loading...", view: self)
        SubmitCvv()
       // view_bler.isHidden=false
       // view_cvv.isHidden=true
       // view_selectcard.isHidden=false
       
    }
    
//    @IBAction func didclickDoneButtonInCVV(_ sender: Any) {
//         dismissKeyboard()
//        Utilities .showLoading(message: "Loading...", view: self)
//        SubmitCvv()
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//          return restlt_Detailarray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell :UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
//        self.tableView.separatorStyle = .none
//        cell.selectionStyle = .none
//        let objdic: NSDictionary = restlt_Detailarray .object(at: indexPath.row) as! NSDictionary
//           cell.textLabel?.text = "\(objdic .value(forKey: "user_card_number") ?? "")"
//        let image : UIImage = UIImage(named: "radiobox-marked")!
//        cell.imageView?.image = image
//
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        view_selectcard.isHidden=true
//        let objdic: NSDictionary = restlt_Detailarray .object(at: indexPath.row) as! NSDictionary
//        cardId = String(format: "%d",objdic .value(forKey: "pk_user_card_id") as! Int )
//        view_cvv.isHidden=false
//        txt_cvvtxt.text=""
//
//    }
//
//
//    func GetuserCardDetails()  {
//        let dic_inputValues = [String : String]()
//        objDatahandler .InputValuesGetmethod(inputDic: dic_inputValues as NSDictionary, suburl: kGetAllCards as NSString,methodtype:  "GET", classVc : self) {
//            (  dic_data) in
//            if dic_data.count == 0  {
//
//            }else{
//                self.restlt_Detailarray .addObjects(from: dic_data as! [Any])
//                self.tableView.reloadData()
//
//            }
//        }
//    }
    func SubmitCvv()  {
        var dic_inputValues = [String : String]()
         let url = kFinalpayment + rideId
        dic_inputValues["user_card_id"] = ""
        dic_inputValues["user_card_cvv"] = ""
        dic_inputValues["currency"] = "nok"
         objDatahandler .InputValues(inputDic: dic_inputValues as NSDictionary, suburl: url as NSString,methodtype:  "POST", classVc : self) {
            (  dic_data) in
            if (dic_data as AnyObject).count == 1 && dic_data["Message"] != nil{
                Utilities .HideLoading(view: self)
                 let message = dic_data["Message"] as! String
                if message == "Payment Successful"{
                     self.delegate?.DidSelectOkButton()
                     Utilities .HideLoading(view: self)
                }else{
                    Utilities .showToast(message: message, view: self.view)
                     Utilities .HideLoading(view: self)
                }

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
