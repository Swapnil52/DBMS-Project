//
//  settingsViewController.swift
//  McDonald's DBMS
//
//  Created by Swapnil Dhanwal on 08/04/2017.
//  Copyright © 2017 Swapnil Dhanwal. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    var cancelButton : UIButton!
    var regionsArray : [String]!
    var detailsLabel : UILabel!
    var region : String!
    var user : String!
    var _user : [String : AnyObject]!
    var logoutButton : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { 
            
            self.configureAddressScreen()
            if UserDefaults.standard.object(forKey: "user") != nil
            {
                
                self._user = UserDefaults.standard.object(forKey: "user") as! [String : AnyObject]
                
            }
            
            
        }) { (success) in
            
            //do something
            //add keyboard selector
            NotificationCenter.default.addObserver(self, selector: #selector(loginViewController.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(loginViewController.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        
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
        self.goButton.frame = CGRect(x: self.mainView.bounds.width*0.025, y: self.pickerView.frame.maxY + self.mainView.bounds.height*0.1, width: self.mainView.bounds.width*0.3, height: self.mainView.bounds.height*0.1)
        self.goButton.addTarget(self, action: #selector(settingsViewController.go), for: .touchUpInside)
        var s = NSMutableAttributedString()
        if let f = UIFont(name: "Avenir Book", size: 20)
        {
            
            s = NSMutableAttributedString(string: "Go!", attributes: [NSFontAttributeName : f])
            
        }
        self.goButton.layer.cornerRadius = 10
        self.goButton.backgroundColor = UIColor.white
        self.goButton.setAttributedTitle(s, for: .normal)
        self.mainView.addSubview(self.goButton)
        
        //configure the logout button
        self.logoutButton = UIButton(type: .custom)
        self.logoutButton.frame = CGRect(x: self.mainView.bounds.width*(0.3 + 0.05), y: self.pickerView.frame.maxY + self.mainView.bounds.height*0.1, width: self.mainView.bounds.width*0.3, height: self.mainView.bounds.height*0.1)
        self.logoutButton.addTarget(self, action: #selector(settingsViewController.logout), for: .touchUpInside)
        if let f = UIFont(name: "Avenir Book", size: 20)
        {
            
            s = NSMutableAttributedString(string: "Logout", attributes: [NSFontAttributeName : f])
            
        }
        self.logoutButton.layer.cornerRadius = 10
        self.logoutButton.backgroundColor = UIColor.white
        self.logoutButton.setAttributedTitle(s, for: .normal)
        self.mainView.addSubview(self.logoutButton)
        
        //configure the cancel button
        self.cancelButton = UIButton(type: .custom)
        self.cancelButton.frame = CGRect(x: self.mainView.bounds.width*(0.65+0.025), y: self.pickerView.frame.maxY + self.mainView.bounds.height*0.1, width: self.mainView.bounds.width*0.3, height: self.mainView.bounds.height*0.1)
        self.cancelButton.addTarget(self, action: #selector(settingsViewController.cancel), for: .touchUpInside)
        if let f = UIFont(name: "Avenir Book", size: 20)
        {
            
            s = NSMutableAttributedString(string: "Cancel!", attributes: [NSFontAttributeName : f])
            
        }
        self.cancelButton.layer.cornerRadius = 10
        self.cancelButton.backgroundColor = UIColor.white
        self.cancelButton.setAttributedTitle(s, for: .normal)
        self.mainView.addSubview(self.cancelButton)
        
    }
    
    //Function to logout the user
    func logout() -> Void
    {
        
        self._user = nil
//        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        self.dismiss(animated: true) {
            
            //do something
            
            
        }
        
    }
    
    //Function to cancel the details update
    func cancel() -> Void
    {
        
        self.dismiss(animated: true) { 
            
            //do something
            
        }
        
    }
    
    //Function to send request to server to insert new user into the DB
    func go() -> Void
    {
        
        for view in self.mainView.subviews
        {
            
            if (view is UITextField)
            {
                
                if (view as? UITextField)?.text == ""
                {
                    
                    self.showAlert("Please enter a valid value", { 
                        
                        //do something
                        
                    })
                    return;
                    
                }
                
            }
            
        }
        
        self.region = self.regionsArray[self.pickerView.selectedRow(inComponent: 0)]
        
        let _region = self.region.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let name = self.nameTextField.text?.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let streetAddress = self.addressTextField.text?.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        
        if let user = self._user
        {
            
            if let phone = user["Phone"] as? String
            {
                
                self.phoneNumber = phone
                
            }
            
        }
        
        let urlString = "http://127.0.0.1/updateCustomer.php?newName=\(name!)&newAddress=\(streetAddress!)&newRegion=\(_region!)&number=\(self.phoneNumber!)"
        
        self.updateCustomer(urlString) { (success, result) in
            
            if (success == true)
            {
                
                print("Done!")
                
                self.dismiss(animated: true, completion: nil)
                
                
                
            }
            else
            {
                
                self.showAlert("Something went wrong", { 
                    
                    //do something
                    
                })
                
            }
            
        }
        
    }
    
    func updateCustomer(_ urlString : String, _ completion : @escaping (_ success : Bool, _ result : [String : AnyObject]) -> Void) -> Void
    {
        
        let url = URL(string : urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        print(urlString)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error
            {
                
                DispatchQueue.main.async {
                    
                    
                    self.showAlert("\(error.localizedDescription)", { 
                        
                        //do something
                        completion(false, [:])
                        
                    })
                    
                }
                
            }
            else
            {
                
                DispatchQueue.main.async(execute: { 
                    
                    if let data = data
                    {
                        
                        do
                        {
                            
                            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : AnyObject]]
                            for item in jsonData!
                            {
                                
                                
                                self._user = item
                                UserDefaults.standard.set(self._user, forKey: "user")
                                completion(true, item)
                                
                                if let success = item["Success"] as? String
                                {
                                    
                                    if success == "0"
                                    {
                                        
                                        completion(false, [:])
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        catch
                        {
                            
                            self.showAlert("Could not connect to the server", { 
                                
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

}
