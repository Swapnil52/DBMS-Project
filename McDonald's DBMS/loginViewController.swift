//
//  ViewController.swift
//  McDonald's DBMS
//
//  Created by Swapnil Dhanwal on 08/04/2017.
//  Copyright © 2017 Swapnil Dhanwal. All rights reserved.
//

import UIKit

class loginViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var user : [String : AnyObject]!
    var region : String!
    var welcome : welcomeView!
    var phoneNumberView : UIView!
    var mainView : UIView!
    var phoneLabel : UILabel!
    var phoneTextField : UITextField!
    var addressTextField : UITextField!
    var nameTextField : UITextField!
    var phoneButton : UIButton!
    var phoneNumber : String?
    var pickerView = UIPickerView()
    var goButton : UIButton!
    var regionsArray : [String]!
    var detailsLabel : UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.object(forKey: "user") != nil
        {
            
            self.user = UserDefaults.standard.object(forKey: "user") as! [String : AnyObject]
            for _view in self.view.subviews
            {
                
                _view.removeFromSuperview()
                
            }
            self.configurePhoneNumberView()
        }
        
        if UserDefaults.standard.object(forKey: "user") == nil
        {
            
            //remove all views
            for _view in self.view.subviews
            {
                
                _view.removeFromSuperview()
                
            }

            
            //show the welcome screen
            let welcomeFrame = CGRect(x: self.view.bounds.width/2-self.view.bounds.width*0.8/2, y: self.view.bounds.height/2-self.view.bounds.height*0.6/2, width: self.view.bounds.width*0.8, height: self.view.bounds.height*0.6)
            
            self.welcome = welcomeView(welcomeFrame, ["Welcome to McDonald's Online", "If you are an existing customer, please provide your details!"], UIColor.red, UIColor.white, UIColor.white, {
                
                print("show login controls")
                //add keyboard selector
                NotificationCenter.default.addObserver(self, selector: #selector(loginViewController.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(loginViewController.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
                self.configurePhoneNumberView()
                
            })
            
            self.view.addSubview(welcome)
            
            
        }
        else
        {
            //            print(user)
            //load menu
            self.performSegue(withIdentifier: "showMenuSegue", sender: self)
            
        }

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    func configurePhoneNumberView() -> Void
    {
        
        
        self.phoneNumberView = UIView(frame: CGRect(x: self.view.bounds.width*0.05, y: self.view.bounds.height*0.4, width: self.view.bounds.width*0.9, height: self.view.bounds.height*0.2))
        self.phoneNumberView.backgroundColor = UIColor.red
        self.phoneNumberView.layer.cornerRadius = 10
        let path = UIBezierPath(roundedRect: self.phoneNumberView.bounds, cornerRadius: 10)
        self.phoneNumberView.layer.shadowPath = path.cgPath
        self.phoneNumberView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        self.phoneNumberView.layer.shadowOpacity = 0.3
        self.phoneNumberView.alpha = 0
        self.view.addSubview(self.phoneNumberView)
        
        self.phoneLabel = UILabel(frame: CGRect(x: self.phoneNumberView.bounds.width*0.10, y: self.phoneNumberView.bounds.height*0.10, width: self.phoneNumberView.bounds.width*0.35, height: self.phoneNumberView.bounds.height/5))
        self.phoneLabel.text = "Phone number"
        self.phoneLabel.font = UIFont(name: "Avenir Book", size: 18)
        self.phoneLabel.adjustsFontSizeToFitWidth = true
        self.phoneLabel.textColor = UIColor.white
        self.phoneLabel.backgroundColor = UIColor.clear
        self.phoneNumberView.addSubview(self.phoneLabel)
        
        self.phoneTextField = UITextField(frame: CGRect(x: self.phoneNumberView.bounds.width*0.90-self.phoneNumberView.bounds.width*0.35, y: self.phoneNumberView.bounds.height*0.10, width: self.phoneNumberView.bounds.width*0.4, height: self.phoneNumberView.bounds.height/5))
        self.phoneTextField.backgroundColor = UIColor.white
        self.phoneTextField.font = UIFont(name: "Avenir Book", size: 18)
        self.phoneTextField.textColor = UIColor.black
        self.phoneTextField.layer.cornerRadius = 10
        self.phoneTextField.delegate = self
        self.phoneNumberView.addSubview(self.phoneTextField)
        
        self.phoneButton = UIButton(type: .custom)
        self.phoneButton.frame = CGRect(x: self.phoneNumberView.bounds.width/2-self.phoneNumberView.bounds.width*0.5/2, y: (self.phoneNumberView.bounds.height-self.phoneTextField.bounds.maxY)/2 + self.phoneNumberView.bounds.width/2*0.2, width: self.phoneNumberView.bounds.width*0.5, height: self.phoneNumberView.bounds.height*0.2)
        self.phoneButton.backgroundColor = UIColor.white
        self.phoneButton.layer.cornerRadius = 10
        var s = NSMutableAttributedString()
        if let f = UIFont(name: "Avenir Book", size: 15)
        {
            
            s = NSMutableAttributedString(string: "OK", attributes: [NSFontAttributeName : f])
            
        }
        self.phoneButton.setAttributedTitle(s, for: .normal)
        self.phoneButton.addTarget(self, action: #selector(loginViewController.ok), for: .touchUpInside)
        self.phoneNumberView.addSubview(phoneButton)
        
        //animation
        self.phoneNumberView.layer.setAffineTransform(CGAffineTransform(scaleX: 0.5, y: 0.5))
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            
            self.phoneNumberView.alpha = 1
            self.phoneNumberView.layer.setAffineTransform(CGAffineTransform.identity)
            
        }) { (success) in
            
            //do something after animation completes
            
        }
        
        
    }
    
    func ok() -> Void
    {
        
        if (self.phoneTextField != nil)
        {
            
            self.phoneTextField.resignFirstResponder()
            
        }
        
        if (self.phoneTextField.text == "")
        {
            
            showAlert("Please enter a number", {
                
                self.phoneTextField.text = ""
                
            })
            return;
            
        }
        
        if ((self.phoneTextField.text?.characters.count)! < 10)
        {
            
            showAlert("Please enter a valid phone number", {
                
                self.phoneTextField.text = ""
                
            })
            return;
            
        }
        
        for c in (self.phoneTextField.text?.unicodeScalars)!
        {
            let value = c.value
            if !((value >= 48 && value <= 57))
            {
                
                showAlert("Please enter only alphanumeric characters", {
                    
                    self.phoneTextField.text = ""
                    
                })
                return;
                
            }
            
        }
        
        self.phoneNumber = self.phoneTextField.text
        //remove phoneNumberView from the screen
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            
            self.phoneNumberView.alpha = 0
            self.phoneNumberView.layer.setAffineTransform(CGAffineTransform(scaleX: 0.5, y: 0.5))
            
        }) { (success) in
            
            //do something after animation completes
            //show the mainView here
            self.getCustomer("http://127.0.0.1/connect.php?number=\(self.phoneNumber!)", { (success, result) in
                
                if success == true
                {
                    
                    DispatchQueue.main.async(execute: {
                        
                        if result.count == 0
                        {
                            
                            //user does not exist. Create a new entry in the database for user
                            //show mainView
                            self.configureAddressScreen()
                            
                        }
                        else
                        {
                            
                            //proceed to main menu
                            for customer in result
                            {
                                
                                self.user = customer
                                UserDefaults.standard.set(self.user, forKey: "user")
                                self.performSegue(withIdentifier: "showMenuSegue", sender: nil)
                                
                            }
                            
        
                        }
                        
                    })
                    
                }
                else
                {
                    
                    self.showAlert("An error occurred", { 
                        
                        //do something
                        
                    })
                    
                }
                
            })
            
            
        }
        
    }

    //show the user details view
    func configureAddressScreen() -> Void
    {
        
        self.mainView = UIView(frame: CGRect(x: self.view.bounds.width/2-self.view.bounds.width*0.8/2, y: self.view.bounds.height/2-self.view.bounds.height*0.8/2, width: self.view.bounds.width*0.8, height: self.view.bounds.height*0.8))
        self.mainView.backgroundColor = UIColor.red
        self.mainView.layer.cornerRadius = 10
        let path = UIBezierPath(roundedRect: self.mainView.bounds, cornerRadius: 10)
        self.mainView.layer.shadowPath = path.cgPath
        self.mainView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        self.mainView.layer.shadowOpacity = 0.3
        self.view.addSubview(self.mainView)
        
        
        //remove all subviews in mainView just in case
        for view in self.mainView.subviews
        {
            
            view.removeFromSuperview()
            
        }
        
        //configure detailLabel
        self.detailsLabel = UILabel(frame: CGRect(x: self.mainView.bounds.width*0.1, y:
            0, width: self.mainView.bounds.width*0.8, height: self.mainView.bounds.height*0.1))
        self.detailsLabel.font = UIFont(name: "Avenir Book", size: 18)
        self.detailsLabel.textAlignment = .center
        self.detailsLabel.text = "Enter your details"
        self.mainView.addSubview(self.detailsLabel)
        
        //configure nameTextField
        self.nameTextField = UITextField(frame: CGRect(x: self.mainView.bounds.width*0.1, y: self.detailsLabel.frame.maxY + 10, width: self.mainView.bounds.width*0.8, height: self.mainView.bounds.height*0.1))
        self.nameTextField.placeholder = "Enter your name"
        self.nameTextField.font = UIFont(name: "Avenir Book", size: 15)
        self.nameTextField.textAlignment = .center
        self.nameTextField.adjustsFontSizeToFitWidth = true
        self.nameTextField.backgroundColor = UIColor.white
        self.nameTextField.layer.cornerRadius = 10
        self.nameTextField.keyboardType = .asciiCapable
        self.nameTextField.delegate = self
        self.mainView.addSubview(nameTextField)
        
        //configure phoneTextField
        self.addressTextField = UITextField(frame: CGRect(x: self.mainView.bounds.width*0.1, y: self.nameTextField.frame.maxY + self.mainView.bounds.height*0.1, width: self.mainView.bounds.width*0.8, height: self.mainView.bounds.height*0.1))
        self.addressTextField.placeholder = "Enter your street address"
        self.addressTextField.font = UIFont(name: "Avenir Book", size: 15)
        self.addressTextField.adjustsFontSizeToFitWidth = true
        self.addressTextField.textAlignment = .center
        self.addressTextField.layer.cornerRadius = 10
        self.addressTextField.backgroundColor = UIColor.white
        self.addressTextField.keyboardType = .asciiCapable
        self.addressTextField.delegate = self
        self.mainView.addSubview(addressTextField)
        
        //configure pickerView
        self.pickerView = UIPickerView(frame: CGRect(x: self.mainView.bounds.width*0.1, y: self.addressTextField.frame.maxY + self.mainView.bounds.height*0.1, width: self.mainView.bounds.width*0.8, height: self.mainView.bounds.height*0.2))
        self.pickerView.backgroundColor = UIColor.white
        self.pickerView.layer.cornerRadius = 10
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.regionsArray = ["North Delhi", "South Delhi", "East Delhi", "West Delhi"]
        self.pickerView.reloadAllComponents()
        self.mainView.addSubview(self.pickerView)
        
        //configure Go button
        self.goButton = UIButton(type: .custom)
        self.goButton.frame = CGRect(x: self.mainView.bounds.width/2 - self.mainView.bounds.width*0.3/2, y: self.pickerView.frame.maxY + self.mainView.bounds.height*0.1, width: self.mainView.bounds.width*0.3, height: self.mainView.bounds.height*0.1)
        self.goButton.addTarget(self, action: #selector(loginViewController.go), for: .touchUpInside)
        var s = NSMutableAttributedString()
        if let f = UIFont(name: "Avenir Book", size: 20)
        {
            
            s = NSMutableAttributedString(string: "Go!", attributes: [NSFontAttributeName : f])
            
        }
        self.goButton.layer.cornerRadius = 10
        self.goButton.backgroundColor = UIColor.white
        self.goButton.setAttributedTitle(s, for: .normal)
        self.mainView.addSubview(self.goButton)
        
    }
    
    //Function to send request to server to insert new user into the DB
    func go() -> Void
    {
        
        
        self.region = self.regionsArray[self.pickerView.selectedRow(inComponent: 0)]
        
        let _region = self.region.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let name = self.nameTextField.text?.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let streetAddress = self.addressTextField.text?.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        
        let urlString = "http://127.0.0.1/insertCustomer.php?name=\(name!)&streetAddress=\(streetAddress!)&region=\(_region!)&phoneNumber=\(self.phoneNumber!)"
        
        self.addCustomer(urlString) { (success, result) in
            
            if (success == true)
            {
                
                print("user added!")
                if result.count > 0
                {
                    
                    for customer in result
                    {
                        
                        self.user = customer
                        UserDefaults.standard.set(self.user, forKey: "user")
                        self.performSegue(withIdentifier: "showMenuSegue", sender: self)
                        
                    }
                    
                }
                
            }
            
        }
        
    }

    
    //MARK : Keyboard notifications
    
    func keyboardWillShow(_ notification : NSNotification) -> Void
    {
        
        let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if (self.phoneTextField != nil)
        {
            
            if (keyboardFrame.minY < self.phoneTextField.frame.maxY)
            {
                
                let dy = self.phoneTextField.frame.maxY - keyboardFrame.minY
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.phoneTextField.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: dy))
                    
                })
                
                
            }
            
        }
        else if (self.addressTextField != nil)
        {
            
            if (keyboardFrame.minY < self.addressTextField.frame.maxY)
            {
                
                let dy = self.addressTextField.frame.maxY - keyboardFrame.minY
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.addressTextField.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: dy))
                    
                })
                
                
            }
            
        }
        else if (self.nameTextField != nil)
        {
            
            if (keyboardFrame.minY < self.nameTextField.frame.maxY)
            {
                
                let dy = self.nameTextField.frame.maxY - keyboardFrame.minY
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.nameTextField.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: dy))
                    
                })
                
                
            }
            
            
        }
        
    }
    
    func keyboardWillHide(_ notification : NSNotification) -> Void
    {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            if (self.phoneTextField != nil)
            {
                
                self.phoneTextField.layer.setAffineTransform(CGAffineTransform.identity)
                
                
            }
            if (self.addressTextField != nil)
            {
                
                self.addressTextField.layer.setAffineTransform(CGAffineTransform.identity)
                
            }
            if (self.nameTextField != nil)
            {
                
                self.addressTextField.layer.setAffineTransform(CGAffineTransform.identity)
                
            }
            
        })
        
        
    }
    
    func getCustomer(_ urlString : String, _ completion : @escaping (_ success : Bool, _ result : [[String : AnyObject]]) -> Void) -> Void
    {
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        print(urlString)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error
            {
                
                DispatchQueue.main.async(execute: { 
                    
                    self.showAlert("\(error.localizedDescription)", { 
                        
                        completion(false, [])
                        
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
                            
                            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : AnyObject]]
                            
                            completion(true, jsonData!)
                            
                        }
                        catch
                        {
                            
                            self.showAlert("Unable to fetch data", {
                                
                                completion(false, [])
                                
                            })
                            
                        }
                        
                    }
                    
                })
                
            }
            
        }
        task.resume()
        
        
    }
    
    func addCustomer(_ urlString : String, _ completion : @escaping (_ success : Bool, _ result : [[String : AnyObject]]) -> Void) -> Void
    {
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        print(urlString)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error
            {
                
                DispatchQueue.main.async(execute: {
                    
                    self.showAlert(error.localizedDescription, {
                        
                        //do something
                        completion(false, [])
                        
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
                            
                            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : AnyObject]]
                            
                            completion(true, jsonData!)
                            
                        }
                        catch
                        {
                            
                            self.showAlert("Could not connect to the server", { 
                                
                                completion(false, [])
                                
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
    
    //MARK : Delegate and Datasource methods
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        
        return 1
        
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        
        return self.regionsArray.count
        
    }

    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var s = NSMutableAttributedString()
        if let f = UIFont(name: "Avenir Book", size: 18)
        {
            
            s = NSMutableAttributedString(string: self.regionsArray[row], attributes: [NSFontAttributeName : f])
            
        }
        return s
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        if component == 0
        {
            
            return 20
            
        }
        return 10
        
    }
    
    //UITextField delegate methods
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        for c in (textField.text?.unicodeScalars)!
        {
            let value = c.value
            if !((value >= 65 && value <= 90) || (value >= 97 && value <= 122) || (value >= 48 && value <= 57) || c == " " || c == ",")
            {
                
                showAlert("Please enter only alphanumeric characters", {
                    
                    textField.text = ""
                    textField.resignFirstResponder()
                    
                })
                
            }
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

