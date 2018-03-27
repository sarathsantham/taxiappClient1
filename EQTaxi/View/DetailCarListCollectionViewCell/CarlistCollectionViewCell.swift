//
//  CarlistCollectionViewCell.swift
//  EQTaxi
//
//  Created by Equator Technologies on 08/02/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import UIKit
protocol CarlistCollectionViewCellDelegate: class {
   // func DidSelectInfoButton(index : NSInteger)
}

class CarlistCollectionViewCell: UICollectionViewCell {
     weak var delegate: CarlistCollectionViewCellDelegate?
    var indexRef : NSInteger = NSInteger()
    @IBOutlet var img_Carimage: UIImageView!
    @IBOutlet var lbl_CarName: UILabel!
    @IBOutlet var ibi_CarPrice: UILabel!
    
    func DidSelectMethod(index : NSInteger) {
       indexRef = index
    }
    @IBAction func didclickInfoButton(_ sender: Any) {
        
       // self.delegate?.DidSelectInfoButton(index : indexRef)
    }
}
