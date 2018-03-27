//
//  RatingVc.swift
//  EQTaxi
//
//  Created by Equator Technologies on 01/03/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import UIKit
protocol RatingDelegate: class {
    func didclickRatingButton(dic_valuesRating:NSMutableDictionary)
    
}
class RatingVc: UIViewController,FloatRatingViewDelegate,UITextViewDelegate {
    weak var delegate: RatingDelegate?

    var str_driver = NSString()
    var str_car = NSString()
    var str_experience = NSString()

    
    
    @IBOutlet var comment: UITextView!
    @IBOutlet var viewRating_forDriver: FloatRatingView!
    @IBOutlet var viewRating_forcar: FloatRatingView!
    @IBOutlet var viewRating_forExperience: FloatRatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // For Driver---------------->
        viewRating_forDriver.backgroundColor = UIColor.clear
        viewRating_forDriver.delegate = self
        viewRating_forDriver.contentMode = UIViewContentMode.scaleAspectFit
        viewRating_forDriver.type = .wholeRatings
        
        
        // For car---------------->
        viewRating_forcar.backgroundColor = UIColor.clear
        viewRating_forcar.delegate = self
        viewRating_forcar.contentMode = UIViewContentMode.scaleAspectFit
        viewRating_forcar.type = .wholeRatings
        

        
        // For Experience---------------->
        viewRating_forExperience.backgroundColor = UIColor.clear
        viewRating_forExperience.delegate = self
        viewRating_forExperience.contentMode = UIViewContentMode.scaleAspectFit
        viewRating_forExperience.type = .wholeRatings
        
       
        
    }
    // MARK: textview Delegates------------>
    
    func textviewShouldReturn(_ textview: UITextView) -> Bool // called when 'return' key
    {
        if textview==comment {
            comment .resignFirstResponder()
        }
        
        return true
    }
    func dismissKeyboard()
    {
        if comment.isEditable {
            comment .resignFirstResponder()
        }
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n"
        {
            self.dismissKeyboard()
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textField: UITextView)
    {
        self.animateTextField(textField: textField, up:true)
        comment.text=""
        
    }
    
    func textViewDidEndEditing(_ textField: UITextView)
    {
        self.animateTextField(textField: textField, up:false)
        
    }
    
    func animateTextField(textField: UITextView, up: Bool)
    {
        let movementDistance:CGFloat = -250
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            self?.view.frame = CGRect(x: 0, y: 0, width: (self?.view.frame.width)!, height: (self?.view.frame.height)!)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        str_driver = String(format: "%.2f", self.viewRating_forDriver.rating) as NSString
        print("str_Driver :",str_driver)
        
        str_car = String(format: "%.2f", self.viewRating_forcar.rating) as NSString
        print("str_Car :",str_car)
        
        str_experience = String(format: "%.2f", self.viewRating_forExperience.rating) as NSString
        print("str_Experience :",str_experience)
    }
    @IBAction func didclickdoneButton(_ sender: Any) {
        let dic_value = NSMutableDictionary ()
        dic_value["driver"] = str_driver
         dic_value["car"] = str_car
         dic_value["experience"] = str_experience
         dic_value["comment"] = comment.text
        
        self.delegate? .didclickRatingButton(dic_valuesRating:dic_value)
    }
}

