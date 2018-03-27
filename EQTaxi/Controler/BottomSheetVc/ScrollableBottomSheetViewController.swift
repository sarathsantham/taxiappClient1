//
//  ScrollableBottomSheetViewController.swift
//  BottomSheet
//
//  Created by Ahmed Elassuty on 10/15/16.
//  Copyright © 2016 Ahmed Elassuty. All rights reserved.
//

import UIKit
protocol BottomSheetLocationDelegate: class {
    func DidSelectLocation(index : NSInteger)
    func DismisskeyboardFromHomeVc()
}
class ScrollableBottomSheetViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countryview: UIView!
    
    weak var delegate: BottomSheetLocationDelegate?

    var alphaforbackground = CGFloat ()
    var frame = CGFloat ()
    var frameend = CGFloat ()
   var restlt_array = NSMutableArray ()
    var restlt_Detailarray = NSMutableArray ()

    var fullView: CGFloat = 150

    var partialView: CGFloat {
        alphaforbackground = UIScreen.main.bounds.height - 90
            return UIScreen.main.bounds.height - 90
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
               let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(ScrollableBottomSheetViewController.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         tableView.isHidden=true
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            self?.frame = (self?.view.frame.width)!
            self?.frameend = (self?.view.frame.width)!-20
            let frame1 = self?.view.frame.height
          //  let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: (self?.fullView)!, width: (self?.frame)!, height: frame1! - 100)
            
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
       
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)

        let y = self.view.frame.minY
        if (y + translation.y >= fullView) && (y + translation.y <= partialView) {
            self.view.frame = CGRect(x: 0 , y: y + translation.y, width: frame, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        if alphaforbackground == y{
            
        }
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 10, y: self.partialView, width: self.frameend, height: self.view.frame.height)
                self .delegate?.DismisskeyboardFromHomeVc()
                    
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.frame, height: self.view.frame.height)
                }
                
                }, completion: { [weak self] _ in
                    if ( velocity.y < 0 ) {
                        self?.tableView.isScrollEnabled = true
                    }
            })
        }
    }
    // Mark: UITableview Delegates methods --------------------------->
    
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restlt_array.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell :UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")

       // let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = restlt_array .object(at: indexPath.row) as? String
        cell.detailTextLabel?.text = restlt_Detailarray.object(at: indexPath.row) as? String
        let image : UIImage = UIImage(named: "placeholder")!
        cell.imageView?.image = image
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.DidSelectLocation(index: indexPath.row)
    }
    
    
// MARK: Home viewController Delegate method --------------------------------------->
    public func GetResult(array : NSMutableArray,detailarray : NSMutableArray){
        self.restlt_array = array
        self.restlt_Detailarray = detailarray
        tableView.reloadData()
        
    }
   
    public func ShowTableView(){
       tableView.isHidden=false
        
    }
    public func HideTableView(){
        tableView.isHidden=true
        
    }
}




extension ScrollableBottomSheetViewController: UIGestureRecognizerDelegate {

    // Solution
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y

        let y = view.frame.minY
        if (y == fullView && tableView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
        
        return false
    }
    
}
