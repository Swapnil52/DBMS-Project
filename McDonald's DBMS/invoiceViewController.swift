//
//  invoiceViewController.swift
//  McDonald's Online
//
//  Created by Swapnil Dhanwal on 04/04/2017.
//  Copyright © 2017 Swapnil Dhanwal. All rights reserved.
//

import UIKit

class invoiceViewController: UIViewController {
    
    var _user : [String : AnyObject]!
    var user : String!
    var region : String!
    var phone : String!
    var amount : String!
    var menuPrice : [String : Int]!
    var menuQuantity : [String : Int]!
    var menuIds : [String]!
    var menuNames : [String : String]!
    var totalAmount : Int!
    var orderString : String!
    var mainView : UIView!
    var billTextView : UITextView!
    var titleLabel : UILabel!
    var Eid : String!
    var confirmButton : UIButton!
    var cancelButton : UIButton!
    var employeeName : String!
    var slider : UISlider!
    var ratingButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "user") != nil
        {
            
            self._user = UserDefaults.standard.object(forKey: "user") as! [String : AnyObject]
            if let C_name = self._user["C_name"] as?  String
            {
                
                self.user = C_name
                
            }
            if let O_name = self._user["O_name"] as? String
            {
                
                self.region = O_name
                
            }
            
        }
        
        self.configureMainView()
        // Do any additional setup after loading the view.
    }
    
    func configureMainView() -> Void
    {
        self.view.backgroundColor = UIColor.white
        
        //setting up the mainView
        self.mainView = UIView(frame: CGRect(x: self.view.bounds.width*0.1, y: self.view.bounds.height*0.1, width: self.view.bounds.width*0.8, height: self.view.bounds.height*0.8))
        self.mainView.backgroundColor = UIColor.red
        self.mainView.layer.cornerRadius = 10
        self.mainView.clipsToBounds = false
        self.mainView.layer.shadowPath = UIBezierPath(roundedRect: self.mainView.bounds, cornerRadius: 10).cgPath
        self.mainView.layer.shadowOpacity = 0.3
        self.mainView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        self.view.addSubview(self.mainView)
        
        //setting up the titleLabel
        self.titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.mainView.bounds.width, height: self.mainView.bounds.height*0.1))
        self.titleLabel.font = UIFont(name: "Avenir Book", size: 20)
        self.titleLabel.text = "Your Order Details"
        self.titleLabel.textAlignment = .center
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.textColor = UIColor.yellow
        self.mainView.addSubview(self.titleLabel)
        
        //setting up the textView
        self.billTextView = UITextView(frame: CGRect(x: self.mainView.bounds.width*0.1, y: self.titleLabel.frame.maxY + 10, width: self.mainView.bounds.width*0.8, height: (self.mainView.bounds.height-self.titleLabel.frame.maxY)*0.8))
        self.billTextView.textContainer.lineFragmentPadding = 10
        let textTab = NSTextTab(textAlignment: .right, location: self.billTextView.bounds.width-20, options: [:])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.tabStops = [textTab]
        var str = "Item\tAmount\n\n"
        var s = NSMutableAttributedString()
        if let f = UIFont(name: "Avenir Book", size: 18)
        {
            
            s = NSMutableAttributedString(string: str, attributes: [NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : f, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleThick.rawValue])
        }
        var total = 0
        for fid in self.menuIds
        {
            
            if (self.menuQuantity[fid]! > 0)
            {
                
                let str = "\(self.menuNames[fid]!) x \(self.menuQuantity[fid]!)\t\(self.menuQuantity[fid]! * self.menuPrice[fid]!)\n\n"
                total += self.menuQuantity[fid]! * self.menuPrice[fid]!
                if let f = UIFont(name: "Avenir Book", size: 17)
                {
                    
                    s.append(NSMutableAttributedString(string: str, attributes: [NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : f]))
                    
                }
                
                
            }
            
        }
        str = "Total\t14.0% VAT\n"
        if let f = UIFont(name: "Avenir Book", size: 18)
        {
            
            s.append(NSMutableAttributedString(string: str, attributes: [NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : f, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleThick.rawValue]))
            str = "\(total)\t\(Float(total) * 1.14)"
            s.append(NSMutableAttributedString(string: str, attributes: [NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : f]))
            self.totalAmount = Int(Float(total) * 1.14)
            
        }
        
        self.billTextView.attributedText = s
        self.billTextView.isEditable = false
        self.billTextView.layer.cornerRadius = 10
        self.mainView.addSubview(self.billTextView)
        
        self.confirmButton = UIButton(type: .custom)
        self.confirmButton.frame = CGRect(x: self.mainView.bounds.width*0.1, y: self.billTextView.frame.maxY + 20, width: self.mainView.bounds.width*0.35, height: self.mainView.bounds.height*0.1)
        if let f = UIFont(name: "Avenir Book", size: 20)
        {
            
            self.confirmButton.setAttributedTitle(NSMutableAttributedString(string: "Confirm", attributes: [NSFontAttributeName : f, NSForegroundColorAttributeName : UIColor.black]), for: .normal)
            
        }
        self.confirmButton.titleLabel?.textAlignment = .center
        self.confirmButton.backgroundColor = UIColor.white
        self.confirmButton.layer.cornerRadius = 10
        self.confirmButton.addTarget(self, action: #selector(invoiceViewController.confirm), for: .touchUpInside)
        self.confirmButton.layer.shadowPath = UIBezierPath(roundedRect: self.confirmButton.bounds, cornerRadius: 10).cgPath
        self.confirmButton.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        self.confirmButton.layer.shadowOpacity = 0.3
        self.mainView.addSubview(self.confirmButton)
        
        self.cancelButton = UIButton(type: .custom)
        self.cancelButton.frame = CGRect(x: self.mainView.bounds.width*0.55, y: self.billTextView.frame.maxY + 20, width: self.mainView.bounds.width*0.35, height: self.mainView.bounds.height*0.1)
        if let f = UIFont(name: "Avenir Book", size: 20)
        {
            
            self.cancelButton.setAttributedTitle(NSMutableAttributedString(string: "Cancel", attributes: [NSFontAttributeName : f, NSForegroundColorAttributeName : UIColor.black]), for: .normal)
            
        }
        self.cancelButton.titleLabel?.textAlignment = .center
        self.cancelButton.backgroundColor = UIColor.white
        self.cancelButton.layer.cornerRadius = 10
        self.cancelButton.addTarget(self, action: #selector(invoiceViewController.cancel), for: .touchUpInside)
        self.cancelButton.layer.shadowPath = UIBezierPath(roundedRect: self.cancelButton.bounds, cornerRadius: 10).cgPath
        self.cancelButton.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        self.cancelButton.layer.shadowOpacity = 0.3
        self.mainView.addSubview(self.cancelButton)

        
    }
    
    func randRange (lower: Int , upper: Int) -> Int {
        
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
        
    }
    
    //MARK : Request Sender methods
    
    func confirm() -> Void
    {
        
        //send order request to the restaurant
        self.sendRequest(orderString) { (success, result) in
            
            if success == true
            {
                let randomEid = self.randRange(lower: 1, upper: 4)
                self.Eid = String(randomEid)
                
                if let customer = self._user
                {
                    
                    if let Phone = customer["Phone"] as? String
                    {
                        
                        if let C_name = customer["C_name"] as? String
                        {
                            
                            if let region = customer["O_name"] as? String
                            {
                                
                                let urlString = "http://127.0.0.1/insertInvoice.php?Phone=\(Phone)&Eid=\(String(randomEid))&CustomerName=\(C_name.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)&Amount=\(self.totalAmount!)&Region=\(region.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)"
                                self.sendRequest(urlString, completion: { (success, result) in
                                    
                                    
                                    let urlString = "http://127.0.0.1/getEmployee.php?Eid=\(String(randomEid))&region=\(self.region.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)"
                                    
                                    self.getEmployee(urlString, completion: { (success, result) in
                                        
                                        if success == true
                                        {
                                            
                                            for employee in result
                                            {
                                                
                                                if let E_name = employee["E_name"] as? String
                                                {
                                                    
                                                    self.employeeName = E_name
                                                    
                                                }
                                                
                                            }
                                            self.configureRatingView()
                                            
                                        }
                                        
                                    })
                                    
                                    
                                    
                                })

                                
                            }
                            
                        }
                        
                    }
                    
                }
                

            }
            else
            {
                
                self.showAlert("Unable to process request", {
                    
                    //do something
                    
                })
                
            }
        }
        
    }
    
    func configureRatingView() -> Void
    {
        
        //clear mainView of all subviews
        if self.mainView != nil
        {
            
            for view in self.mainView.subviews
            {
                
                view.removeFromSuperview()
                
            }
            self.mainView.removeFromSuperview()
            
        }
        
        //setting up the mainView
        self.mainView = UIView(frame: CGRect(x: self.view.bounds.width*0.25, y: self.view.bounds.height*0.3, width: self.view.bounds.width*0.5, height: self.view.bounds.height*0.4))
        self.mainView.backgroundColor = UIColor.red
        self.mainView.layer.cornerRadius = 10
        self.mainView.clipsToBounds = false
        self.mainView.layer.shadowPath = UIBezierPath(roundedRect: self.mainView.bounds, cornerRadius: 10).cgPath
        self.mainView.layer.shadowOpacity = 0.3
        self.mainView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        self.view.addSubview(self.mainView)
        
        //setting up the titleLabel
        self.titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.mainView.bounds.width, height: self.mainView.bounds.height*0.2))
        self.titleLabel.font = UIFont(name: "Avenir Book", size: 20)
        self.titleLabel.text = "Your order was delivered by \(employeeName!)\nPlease rate your experience"
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .center
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.textColor = UIColor.yellow
        self.mainView.addSubview(self.titleLabel)
        
        self.slider = UISlider(frame: CGRect(x: self.mainView.bounds.width*0.1, y: self.titleLabel.frame.maxY + 30, width: self.mainView.bounds.width*0.8, height: self.mainView.bounds.height*0.1))
        self.slider.isContinuous = false
        self.slider.maximumValue = 5
        self.slider.minimumValue = 0
        self.slider.setValue(2.5, animated: true)
        self.slider.addTarget(self, action: #selector(invoiceViewController.sliderSlid(_:)), for: .valueChanged)
        self.mainView.addSubview(self.slider)
        
        self.ratingButton = UIButton(type: .custom)
        self.ratingButton.frame = CGRect(x: self.mainView.bounds.width*0.2, y: self.slider.frame.maxY + 30, width: self.mainView.bounds.width*0.6, height: self.mainView.bounds.height*0.1)
        if let f = UIFont(name: "Avenir Book", size: 20)
        {
            
            let s = NSMutableAttributedString(string: "Rate \(Int(self.slider.value))", attributes: [NSFontAttributeName : f, NSForegroundColorAttributeName : UIColor.black])
            self.ratingButton.setAttributedTitle(s, for: .normal)
            
        }
        self.ratingButton.addTarget(self, action: #selector(invoiceViewController.rate(_:)), for: .touchUpInside)
        self.ratingButton.backgroundColor = UIColor.white
        self.ratingButton.layer.cornerRadius = 10
        self.mainView.addSubview(self.ratingButton)
        
    }
    
    func rate(_ button : UIButton) -> Void
    {
        
        let rating = Int(self.slider.value)
        let urlString = "http://127.0.0.1/addRating.php?Eid=\(self.Eid!)&Region=\(self.region.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)&Rating=\(rating)"
        self.sendRequest(urlString) { (success, result) in
            
            if (success == true)
            {
                
                self.dismiss(animated: true, completion: { 
                    
                    //do something
                    
                })
                
            }
            else
            {
                
                self.showAlert("Could not process request", { 
                    
                    //do something
                    
                })
                
            }
            
        }
    
        
    }
    
    
    func sliderSlid(_ slider : UISlider) -> Void
    {
        
        var s = NSMutableAttributedString()
        if let f = UIFont(name: "Avenir Book", size: 20)
        {
            
            s = NSMutableAttributedString(string: "Rate \(Int(slider.value))", attributes: [NSFontAttributeName : f, NSForegroundColorAttributeName : UIColor.black])
            self.ratingButton.setAttributedTitle(s, for: .normal)
            print(Int(slider.value))
            
        }
        
    }

    
    func cancel() -> Void
    {
        
        //cancel order and return to menuViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func getEmployee(_ urlString : String, completion : @escaping (_ success : Bool, _ result : [[String : AnyObject]]) -> Void)
    {
        
        print(urlString)
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil
            {
                
                DispatchQueue.main.async(execute: {
                    
                    self.showAlert((error?.localizedDescription)!, {
                        
                        //do something
                        completion(false, [])
                        
                    })
                    
                })
                
            }
                
            else
            {
                
                if let data = data
                {
                    DispatchQueue.main.async(execute: {
                        
                        do
                        {
                            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : AnyObject]]
                            completion(true, jsonData!)
                            
                        }
                        catch
                        {
                            self.showAlert("Something went wrong", {
                                
                                //do something
                                completion(false, [])
                                
                            })
                            
                        }
                        
                    })
                    
                }
                
                
            }
            
        }
        
        task.resume()
    }

    
    func sendRequest(_ urlString : String, completion : @escaping (_ success : Bool, _ resultJson : [String : AnyObject]) -> Void)
    {
        
        print(urlString)
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil
            {
                
                DispatchQueue.main.async(execute: {
                    
                    self.showAlert((error?.localizedDescription)!, {
                        
                        //do something
                        completion(false, [:])
                        
                    })
                    
                })
                
            }
                
            else
            {
                
                if let data = data
                {
                    DispatchQueue.main.async(execute: {
                        
                        do
                        {
                            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : AnyObject]
                            completion(true, jsonData!)
                            
                        }
                        catch
                        {
                            
                            completion(false, [:])
                            
                        }
                        
                    })
                    
                }
                
                
            }
            
        }
        
        task.resume()
    }

    func clearCart(_ urlString : String, completion : @escaping (_ success : Bool, _ result : [String : AnyObject]) -> Void) -> Void
    {
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            
            if let error = error
            {
                
                DispatchQueue.main.async(execute: {
                    
                    self.showAlert(error.localizedDescription, {
                        
                        //do something
                        completion(false, [:])
                        
                    })
                    
                })
                
            }
            else
            {
                
                DispatchQueue.main.async(execute: {
                    
                    if let data = data
                    {
                        
                        do
                        {
                            
                            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : AnyObject]
                            completion(true, jsonData!)
                            
                        }
                        catch
                        {
                            
                            self.showAlert("Something went wrong", {
                                
                                //do something
                                completion(false, [:])
                                
                            })
                            
                        }
                    }
                    
                })
                
            }
        }
        task.resume()
        
        
    }
    
    func showAlert(_ error : String, _ completion : @escaping () -> Void) -> Void
    {
        
        let alert = UIAlertController(title: "An Error Occurred", message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            completion()
            
        }))
        self.present(alert, animated: true) {
            
            //do domething
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
