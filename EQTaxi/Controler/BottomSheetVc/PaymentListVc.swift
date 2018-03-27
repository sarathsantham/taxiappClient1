//
//  PaymentListVc.swift
//  EQTaxi
//
//  Created by Equator Technologies on 18/03/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import UIKit
protocol PaymentListVcDelegate: class {
    func didclickBackPaymentVcButton()
    func didclickAddcardButtonAction()
}

class PaymentListVc: UIViewController,UITableViewDataSource,UITableViewDelegate,PaymentListCellDelegate{
   
    weak var delegate: PaymentListVcDelegate?
    
    var objDatahandler = DataHandler ()

    @IBOutlet var view_tableview: UITableView!
     public var arr_Listofcards = NSMutableArray ()

    override func viewDidLoad() {
        super.viewDidLoad()
       GetuserCardDetails()
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
        return arr_Listofcards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "PaymentViewCellID"
        var cell:PaymentViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? PaymentViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "SelectVechileTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PaymentViewCell
        }
        cell.delegate=self
        self.view_tableview.separatorStyle = .none
        cell.selectionStyle = .none
        cell.GetIndex(index: indexPath.row)
        let objdic: NSDictionary = arr_Listofcards .object(at: indexPath.row) as! NSDictionary
        print(objdic)
        cell.lbl_username.text = "\(objdic .value(forKey: "user_card_holder_name") ?? "")"
        cell.lbl_expiredate.text  = "\(objdic .value(forKey: "user_exp_month") ?? "")" + "/" + "\(objdic .value(forKey: "user_exp_year") ?? "")"
        cell.lbl_cardNo.text = "\(objdic .value(forKey: "user_card_number") ?? "")"
        let selected = objdic .value(forKey: "is_default") as! Bool
        if selected == true{
        let image = UIImage (named: "checkbox-marked")
       cell.button_DefaultActions.setImage(image , for: .normal)
        }else{
            let image = UIImage (named: "checkbox-blank")
            cell.button_DefaultActions.setImage(image , for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
     // Delegate delete Button Actions ---------------------->
    func didclickDeletebutton(index : Int){
        let objdic: NSDictionary = arr_Listofcards .object(at: index) as! NSDictionary
        let card = String(format: "%d",objdic .value(forKey: "pk_user_card_id") as! Int )
        DeleteButtonServicecall(CardId: card )
    }
    // Button Actions ---------------------->
    
    @IBAction func didcliclbackButtonActions(_ sender: Any) {
        self.delegate? .didclickBackPaymentVcButton()
    }
    @IBAction func didclickAddcardButton(_ sender: Any) {
         UserDefaults.standard.set("FromPaymentVc", forKey: "AddCard")//setObject
        self.delegate? .didclickAddcardButtonAction()
    }
    func didclickSelectCardButton(index: Int) {
        let objdic: NSDictionary = arr_Listofcards .object(at: index) as! NSDictionary
        let card = String(format: "%d",objdic .value(forKey: "pk_user_card_id") as! Int )
     AddDefaultCardButtonServicecall(CardId: card )
    }
    
    func GetuserCardDetails()  {
       // Utilities .showLoading(message: "Loading...", view: self)
        let dic_inputValues = [String : String]()
        objDatahandler .InputValuesGetmethod(inputDic: dic_inputValues as NSDictionary, suburl: kGetAllCards as NSString,methodtype:  "GET", classVc : self) {
            (  dic_data) in
            if dic_data.count == 0{
                self.view_tableview.isHidden=true
                Utilities .HideLoading(view: self)
            }else{
                self.arr_Listofcards .removeAllObjects()
                self.view_tableview.isHidden=false
                self.arr_Listofcards .addObjects(from: dic_data as! [Any])
                print(self.arr_Listofcards)
                self.view_tableview.reloadData()
               // Utilities .HideLoading(view: self)
            }
        }
    }
     // Service call ---------------------->
    func DeleteButtonServicecall( CardId : String)  {
         Utilities .showLoading(message: "Loading...", view: self)
                let url = kDeleteUserCard + CardId
        var dic_inputValues = [String : String]()
         dic_inputValues["is_visible"] = "0"
         objDatahandler .InputValues(inputDic: dic_inputValues as NSDictionary, suburl: url as NSString,methodtype:  "PUT", classVc : self) {
            (  dic_data) in
            if (dic_data as AnyObject).count == 1 && dic_data["Message"] != nil
            {
                let message = dic_data["Message"]
                Utilities .showToast(message: message as! String, view: self.view)
                // Utilities .HideLoading(view: self)
                self.GetuserCardDetails()
                  Utilities .HideLoading(view: self)
            }else{
                Utilities .HideLoading(view: self)
            }
           
            
        }
        
    }
    func AddDefaultCardButtonServicecall( CardId : String)  {
        Utilities .showLoading(message: "Loading...", view: self)
        let url = kSetCardAsDefault + CardId
        let dic_inputValues = [String : String]()
        objDatahandler .InputValuesGetmethod(inputDic: dic_inputValues as NSDictionary, suburl: url as NSString,methodtype:  "GET", classVc : self) {
            (  dic_data) in
            if dic_data.count == 0{
                self.arr_Listofcards .removeAllObjects()
                self.view_tableview.isHidden=false
                 self.GetuserCardDetails()
                print(self.arr_Listofcards)
                 Utilities .HideLoading(view: self)
            }
            
            
        }
        
    }
    
}
