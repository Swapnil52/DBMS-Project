//
//  menuViewController.swift
//  McDonald's Online
//
//  Created by Swapnil Dhanwal on 04/04/2017.
//  Copyright © 2017 Swapnil Dhanwal. All rights reserved.
//

import UIKit

class menuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    var region : String!
    var _user : [String : AnyObject]!
    var user : String!
    var menuItems : [String]!
    var menuIds = [String]()
    var menuQuantity = [String : Int]()
    var menuPrices = [String : Int]()
    var menuNames = [String : String]()
    @IBOutlet weak var placeOrderOutlet: UIButton!
    
    @IBAction func placeOrder(_ sender: Any) {
        
        //send request to place order
        let orderString = self.generateOrderString()
        
        if (orderString == "")
        {
            
            showAlert("Please select at least one menu item", { 
                
                //do something
                
            })
            
        }
        else
        {
            
            let updateOutletString = "http://127.0.0.1/updateOutlet.php?region=\(region.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)&\(orderString)"
            
            if let customer = self._user
            {
                
                if let Phone = customer["Phone"] as? String
                {
                    
                    
                    let clearUrlString = "http://127.0.0.1/deleteCart.php?number=\(Phone)&region=\(self.region.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)"
                    
                    self.clearCart(clearUrlString, completion: { (success, result) in
                        
                        if success == true
                        {
                            
                            let urlString = "http://127.0.0.1/saveCart.php?number=\(Phone)&region=\(self.region.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)&\(orderString)"
                            
                            self.saveCart(urlString, completion: { (success, result) in
                                
                                if success == true
                                {
                                    
                                    let invoiceVC = invoiceViewController()
                                    invoiceVC.region = self.region
                                    invoiceVC.menuIds = self.menuIds
                                    invoiceVC.menuQuantity = self.menuQuantity
                                    invoiceVC.menuPrice = self.menuPrices
                                    invoiceVC.menuNames = self.menuNames
                                    invoiceVC.orderString = updateOutletString
                                    self.present(invoiceVC, animated: true, completion: nil)
                                    
                                }
                                
                            })

                            
                        }
                        
                    })
                    
                    
                }
                
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.object(forKey: "user") != nil
        {
            
            self._user = UserDefaults.standard.object(forKey: "user") as! [String : AnyObject]
            if let C_name = self._user["C_name"] as? String
            {
                
                self.user = C_name
                
            }
            if let O_name = self._user["O_name"] as? String
            {
                
                self.region = O_name
                
            }
            
            
            
            self.nameLabel.adjustsFontSizeToFitWidth = true
            self.nameLabel.text = "Welcome \(self.user!)!"
            
            self.menuItems.removeAll()
            self.menuIds.removeAll()
            self.menuPrices.removeAll()
            self.menuNames.removeAll()
            self.menuQuantity.removeAll()
            
            let urlString = "http://127.0.0.1/getMenuItems.php?region=\(self.region.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)"
            self.getMenu(urlString) { (success, result) in
                
                if (success == true)
                {
                    
                    for item in result
                    {
                        
                        if let F_name = item["F_name"] as? String
                        {
                            
                            self.menuItems.append(F_name)
                            
                        }
                        if let F_id = item["F_id"] as? String
                        {
                            
                            self.menuIds.append(F_id)
                            self.menuQuantity[F_id] = 0
                            
                            if let F_price = item["F_price"] as? String
                            {
                                
                                self.menuPrices[F_id] = Int(F_price)
                                
                            }
                            
                            if let F_name = item["F_name"] as? String
                            {
                                
                                self.menuNames[F_id] = F_name
                                
                            }
                            
                        }
                        
                    }
                    
                    if let customer = self._user
                    {
                        
                        if let number = customer["Phone"] as? String
                        {
                            
                            let urlString = "http://127.0.0.1/getCart.php?number=\(number)"
                            self.getCart(urlString, completion: { (success, result) in
                                
                                if (success == true)
                                {
                                    
                                    for item in result
                                    {
                                        
                                        if let F_id = item["F_id"] as? String
                                        {
                                            
                                            if let qty = item["Qty"] as? String
                                            {
                                                
                                                self.menuQuantity[F_id] = Int(qty)
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    self.menuTableView.reloadData()
                                    
                                }
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
            }

            
        }
        else
        {
            
            self.dismiss(animated: true, completion: {
                
                //do something
                
            })
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure tableView
        if UserDefaults.standard.object(forKey: "user") == nil
        {
            
            self.dismiss(animated: true, completion: { 
                
                //do something
                
            })
            
        }
        self.configureView()
        
    }
    
    //MARK : UI Configuration
    
    func configureView() -> Void
    {
        
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        self.menuItems = []
        self.menuIds = []
        self.menuTableView.separatorColor = UIColor.clear
        self.placeOrderOutlet.layer.cornerRadius = 10
        self.placeOrderOutlet.layer.shadowPath = UIBezierPath(roundedRect: self.placeOrderOutlet.bounds, cornerRadius: 10).cgPath
        self.placeOrderOutlet.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        self.placeOrderOutlet.layer.shadowOpacity = 0.4
        
        
        
    }
    
    //MARK : Request sender methods
    
    func generateOrderString() -> String
    {
        
        var orderString = ""
        
        for fid in self.menuIds
        {
            var partialString = ""
            if (self.menuQuantity[fid]! > 0)
            {
                
                let cost : Int = self.menuQuantity[fid]! //* self.menuPrices[fid]!;
                partialString = "\(fid)=\(cost)&"
                
            }
            if (orderString == "")
            {
                orderString = partialString
            }
            else
            {
                orderString.append(partialString)
            }
        }
       
        return String(orderString.characters.dropLast())
        
    }
    
    func getCart(_ urlString : String, completion : @escaping (_ success : Bool, _ result : [[String : AnyObject]]) -> Void) -> Void
    {
        
        let url = URL(string : urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
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
                            
                            self.showAlert("Something went wrong", { 
                                
                                completion(false, [])
                                
                            })
                            
                        }
                        
                    }

                    
                })
                
            }
            
        }
        task.resume()
        
    }
    
    func getMenu(_ urlString : String, completion : @escaping (_ success : Bool, _ resultJson : [[String : AnyObject]]) -> Void)
    {
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil
            {
                
                DispatchQueue.main.async(execute: {
                    
                    self.showAlert((error?.localizedDescription)!, {
                        
                        //do something
                        
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
                            
                            //do something
                            completion(false, [])
                            
                        }
                        
                    })
                    
                }
                
                
            }
            
        }
        
        task.resume()
    }
    
    func saveCart(_ urlString : String, completion : @escaping (_ success : Bool, _ result : [String : AnyObject]) -> Void) -> Void
    {
        
        let url = URL(string: urlString)
        print(urlString)
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
    
    func clearCart(_ urlString : String, completion : @escaping (_ success : Bool, _ result : [String : AnyObject]) -> Void) -> Void
    {
        
        let url = URL(string: urlString)
        print(urlString)
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
    
    //MARK : Delegate and datasource methods
    
    //UITableView delegate and datasource methods
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.menuItems.count
        
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = self.menuTableView.dequeueReusableCell(withIdentifier: "menuItemCell") as? menuItemCell
        let fid = self.menuIds[indexPath.row]
        cell?.quantity.text = String(describing: self.menuQuantity[fid]!)
        cell?.itemName.text = self.menuItems[indexPath.row]
        cell?.paddingView.layer.cornerRadius = 5
        cell?.paddingView.layer.shadowPath = UIBezierPath(roundedRect: cell!.paddingView.bounds, cornerRadius: 5).cgPath
        cell?.paddingView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        cell?.paddingView.clipsToBounds = false
        cell?.paddingView.layer.shadowOpacity = 0.3
        cell?.plusOutlet.tag = indexPath.row
        cell?.minusOutlet.tag = indexPath.row
        cell?.plusOutlet.addTarget(self, action: #selector(menuViewController.plus(_:)), for: .touchUpInside)
        cell?.minusOutlet.addTarget(self, action: #selector(menuViewController.minus(_:)), for: .touchUpInside)
        cell?.thumbnailImageView.image = UIImage(named: "\(self.menuIds[indexPath.row]).jpg")
        cell?.thumbnailImageView.clipsToBounds = true
        let circlePath = CAShapeLayer()
        cell?.thumbnailImageView.layer.cornerRadius = (cell?.thumbnailImageView.bounds.width)!/2
        cell?.thumbnailImageView.layer.masksToBounds = true
        circlePath.path = UIBezierPath(arcCenter: cell!.thumbnailImageView.center, radius: cell!.thumbnailImageView.bounds.height, startAngle: 0, endAngle: 5, clockwise: true).cgPath
        cell?.thumbnailImageView.layer.mask = circlePath
        cell?.thumbnailImageView.layer.borderColor = UIColor.black.cgColor
        cell?.thumbnailImageView.layer.borderWidth = 2
        return cell!
        
        
    }
        
    func plus(_ button : UIButton) -> Void
    {
        
        let curId : String = menuIds[button.tag]
        self.menuQuantity[curId]! += 1
        
    }
    
    func minus(_ button : UIButton) -> Void
    {
        
        let curId : String = menuIds[button.tag]
        let curQty = self.menuQuantity[curId]!
        if (curQty != 0)
        {
            
            self.menuQuantity[curId]! -= 1
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
