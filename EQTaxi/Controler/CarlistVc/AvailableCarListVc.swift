//
//  AvailableCarListVc.swift
//  EQTaxi
//
//  Created by Equator Technologies on 09/02/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import UIKit

class AvailableCarListVc: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
 {
    var leftInset = CGFloat()
     var rightInset = CGFloat()
    var selectedIndex = Int ()


    @IBOutlet var view_collectionView: UICollectionView!
    
    let identifier = "Cell"
    var frame = CGFloat ()
    @IBOutlet weak var headerView: UIView!
    
    
    var partialView: CGFloat {
    return UIScreen.main.bounds.height - 300
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
       selectedIndex = 0

    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    UIView.animate(withDuration: 0.6, animations: { [weak self] in
    let frame = self?.view.frame
    let yComponent = self?.partialView
    self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: 300)
    
    })
    }
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath) as! CarlistCollectionViewCell
        if selectedIndex == indexPath.row
        {
            let yourImage: UIImage = UIImage(named: "taxi_default_active")!
            let expandTransform:CGAffineTransform = CGAffineTransform(scaleX: 1.04, y: 1.04);
            UIView.transition(with: cell.img_Carimage,
                                      duration:0.2,
                                      options: UIViewAnimationOptions.transitionCrossDissolve,
                                      animations: {
                                        cell.img_Carimage.image = yourImage
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
            let yourImage: UIImage = UIImage(named: "taxi_default_inactive")!
                              cell.img_Carimage.image = yourImage
        }

        
        
    return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // handle tap events
        selectedIndex = indexPath.row
        self.view_collectionView.reloadData()

       
    }
   
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalCellWidth = 114 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)
        
        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
        
    }
    
    
    // MARK: - Button Action
    
    @IBAction func didclickCashButton(_ sender: Any) {
    }
    
    
}

