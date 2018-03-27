//
//  CustomerHistoryVc.swift
//  EQTaxi
//
//  Created by Equator Technologies on 01/03/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import UIKit
protocol CustomerHistoryDelegate: class {
    func didclickBackCustomerHistoryButton()
    
}
class CustomerHistoryVc: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
 weak var delegate: CustomerHistoryDelegate?
    @IBOutlet var view_tableview: UITableView!
    @IBOutlet var img_alert :UIImageView!
@IBOutlet var lbl_alert
    :UILabel!
    public var arr_Listofcars = NSMutableArray ()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view_tableview.isHidden=true
            getcustomerHistory()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            self?.view.frame = CGRect(x: 0, y: 0, width: (self?.view.frame.width)!, height: (self?.view.frame.height)!)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_Listofcars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "RideHistoryViewCellTableViewCellID"
        var cell:RideHistoryViewCellTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? RideHistoryViewCellTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "SelectVechileTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? RideHistoryViewCellTableViewCell
        }
        //let vehical_type = vehicle["fk_vehicle_type"] as! NSDictionary
        let objdic: NSDictionary = arr_Listofcars .object(at: indexPath.row) as! NSDictionary
        print(objdic)
        // cell.lbl_ = "\(dic_value .value(forKey: "total_fare") ?? "")"
        cell.lbl_time.text = "\(objdic .value(forKey: "ride_start_time") ?? "")"
        cell.lbl_ridefare.text  = KCurrencyCode + "\(objdic .value(forKey: "ride_total_amount") ?? "")"
        cell.lbl_drop.text = "\(objdic .value(forKey: "ride_drop_location") ?? "")"
        cell.lbl_pickup.text  = "\(objdic .value(forKey: "ride_pickup_location") ?? "")"
        cell.ibi_date.text  = "\(objdic .value(forKey: "ride_date") ?? "")"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    // Button Actions ---------------------->
    
    @IBAction func didcliclbackButtonActions(_ sender: Any) {
        self.delegate? .didclickBackCustomerHistoryButton()
    }
    
    // Service Call ---------------------->
    
    func getcustomerHistory()  {
        let dic_inputValues = [String : String]()
        let objDatahandler = DataHandler ()
        objDatahandler .InputValuesGetmethod(inputDic: dic_inputValues as NSDictionary, suburl: KCustomerHistory as NSString,methodtype:  "GET", classVc : self) {
            (  dic_data) in
                self.view_tableview.isHidden=false
                self.arr_Listofcars .addObjects(from: dic_data as! [Any])
                print(self.arr_Listofcars)
               self.view_tableview.reloadData()
            
        }
        
    }
    }
    

