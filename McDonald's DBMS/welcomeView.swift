//
//  welcomeView.swift
//  ieeeID
//
//  Created by Swapnil Dhanwal on 27/01/17.
//  Copyright © 2017 Swapnil Dhanwal. All rights reserved.
//

import UIKit

class welcomeView: UIView {
    
    var pages = Int()
    var messages = [String]()
    var mainView = UIView()
    var pageIndex = Int()
    var messageLabel = UILabel()
    var completionHandler : () -> Void
    var nextButton = UIButton()
    var nextButtonColor = UIColor()
    var textCol = UIColor()
    var backCol = UIColor()
    var showShadow = Bool()
    public var textAlignment : NSTextAlignment
    
    init(_ frame : CGRect, _ messagesArray : [String], _ backgroundColor : UIColor, _ textColor : UIColor, _ buttonColor : UIColor, _ completion : @escaping () -> Void)
    {

        pages = messagesArray.count
        messages = messagesArray
        pageIndex = 0
        completionHandler = completion
        nextButtonColor = buttonColor
        backCol = backgroundColor
        textCol = textColor
        textAlignment = NSTextAlignment.center
        showShadow = true
        super.init(frame: frame)
        self.frame = frame
        self.messageLabel.textAlignment = .left
        presentPage(backgroundColor, textColor, buttonColor, 0)
        self.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin, .flexibleRightMargin]
        if (self.showShadow == true)
        {
            
            let path = UIBezierPath(roundedRect: self.mainView.bounds, cornerRadius: 10)
            self.mainView.layer.shadowPath = path.cgPath
            self.mainView.layer.shadowOpacity = 0.3
            self.mainView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
            
        }
        
    }
    
    func showMainView(_ backgroundColor : UIColor, _ message : String, _ textColor : UIColor, _ buttonColor : UIColor) -> Void
    {

        for view in self.subviews
        {
            
            view.removeFromSuperview()
            
        }
        
        //configure mainView
        self.mainView = UIView(frame: self.bounds)
        self.mainView.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin]
        self.mainView.backgroundColor = backgroundColor
        self.mainView.layer.cornerRadius = 10
        if (self.showShadow == true)
        {
            
            let path = UIBezierPath(roundedRect: self.mainView.bounds, cornerRadius: 10)
            self.mainView.layer.shadowPath = path.cgPath
            self.mainView.layer.shadowOpacity = 0.3
            self.mainView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
            
        }
        self.addSubview(self.mainView)
        
        //configure messageLabel
        self.configureLabel(message, textColor)
        
        //configure nextButton
        self.configureNextButton(buttonColor)
        
        //animate the view from alpha 0 and 0.75X scale to alpha 1 and 1X scale 
        self.alpha = 0
        self.layer.setAffineTransform(CGAffineTransform(scaleX: 0.75, y: 0.75))
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { 
            
            self.alpha = 1
            self.layer.setAffineTransform(CGAffineTransform.identity)
            
        }) { (success) in
            
            
            
        }
        
    }
    
    func configureLabel(_ message : String, _ textColor : UIColor)
    {
        
        self.messageLabel = UILabel()
        let frame = CGRect(x: self.mainView.bounds.width*0.1, y: self.mainView.bounds.height*0.1, width: self.mainView.bounds.width*0.8, height: self.mainView.bounds.height*0.6)
        self.messageLabel.frame = frame
        self.messageLabel.numberOfLines = -1
        var attributedText = NSMutableAttributedString()
        if let f = UIFont(name: "Avenir Book", size: 30)
        {
            
            attributedText = NSMutableAttributedString(string: message, attributes: [NSFontAttributeName : f])
            self.messageLabel.attributedText = attributedText
            self.messageLabel.textColor = self.textCol
            
        }
        self.mainView.addSubview(messageLabel)
        
    }
    
    func configureNextButton(_ buttonColor : UIColor)
    {
        self.nextButton = UIButton(type: .roundedRect)
        self.nextButton.frame = CGRect(x: self.mainView.bounds.width*0.2, y: self.messageLabel.frame.maxY+self.mainView.frame.height*0.075, width: self.mainView.bounds.width*0.6, height: self.mainView.bounds.height*0.15)
        self.nextButton.backgroundColor = buttonColor
        var attributedTitle = NSMutableAttributedString()
        if let f = UIFont(name: "Avenir Book", size: 20)
        {
            
            attributedTitle = NSMutableAttributedString(string: "Next", attributes: [NSFontAttributeName : f])
            self.nextButton.setAttributedTitle(attributedTitle, for: .normal)
            
        }
        self.nextButton.layer.cornerRadius = 10
        self.nextButton.addTarget(self, action: #selector(welcomeView.next as (welcomeView) -> () -> ()), for: .touchUpInside)
        self.mainView.addSubview(nextButton)
        
    }
    
    func next()
    {
        
        self.makeInvisible { 
            
            self.nextUtil(self.backCol, self.textCol, self.nextButtonColor, self.pageIndex)
            
        }
        
    }
    
    func nextUtil(_ backgroundColor : UIColor, _ textColor : UIColor, _ buttonColor : UIColor, _ pageIndex : Int)
    {
        
        self.pageIndex += 1
        self.presentPage(backgroundColor, textColor, buttonColor, self.pageIndex)
        
    }
    
    func remove()
    {
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { 
            
            self.alpha = 0
            self.layer.setAffineTransform(CGAffineTransform(scaleX: 0.5, y: 0.5))
            
        }) { (success) in
            
            self.removeFromSuperview()
            
        }
        
    }
    
    func makeInvisible(_ completion : @escaping () -> Void)
    {
        
        UIView.animate(withDuration: 0.1, animations: {
            
            self.alpha = 0
            self.layer.setAffineTransform(CGAffineTransform(scaleX: 0.5, y: 0.5))
            
        }) { (success) in
            
            completion()
            
        }
        
    }
    
    func presentPage(_ backgroundColor : UIColor, _ textColor : UIColor, _ buttonColor : UIColor, _ pageIndex : Int)
    {
        
        if (pageIndex == self.pages)
        {
            
            makeInvisible({ 
                
                self.completionHandler()
                self.removeFromSuperview()
                
            })
            
        }
        else
        {
            
            let currentMessage = self.messages[pageIndex]
            self.showMainView(backgroundColor, currentMessage, textColor, buttonColor)
        
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
