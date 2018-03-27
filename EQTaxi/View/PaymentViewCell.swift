//
//  PaymentViewCell.swift
//  EQTaxi
//
//  Created by Equator Technologies on 18/03/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import UIKit
protocol PaymentListCellDelegate: class {
    func didclickDeletebutton(index : Int)
     func didclickSelectCardButton(index : Int)
}
class PaymentViewCell: UITableViewCell {
    
    weak var delegate: PaymentListCellDelegate?

    
    @IBOutlet var button_DefaultActions: UIButton!
    @IBOutlet var lbl_expiredate: UILabel!
    @IBOutlet var lbl_cardNo: UILabel!
    @IBOutlet var lbl_username: UILabel!
    @IBOutlet var view_contentview: UIView!
    var indexvalue = Int()
    override func awakeFromNib() {
        super.awakeFromNib()
  AddShadowTo(view_shadow: view_contentview)    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func GetIndex(index : Int) {
        indexvalue = index
    }
    // MARK: Draw Shadow to view ---------------------------->
    @IBAction func didclickDeletebutton(_ sender: Any) {
       self.delegate? .didclickDeletebutton(index: indexvalue)
    }
    @IBAction func didclickDefaultCardActions(_ sender: Any) {
//        let image = UIImage (named: "checkbox-marked")
//        button_DefaultActions.setImage(image , for: .normal)
         self.delegate? .didclickSelectCardButton(index: indexvalue)
        
    }
    
    func AddShadowTo (view_shadow:UIView) {
        view_shadow.layer.shadowOpacity = 0.8
        view_shadow.layer.shadowOffset = CGSize(width: 3, height: 3)
        view_shadow.layer.shadowRadius = 8.0
        view_shadow.layer.shadowColor = UIColor.darkGray.cgColor
    }
}
