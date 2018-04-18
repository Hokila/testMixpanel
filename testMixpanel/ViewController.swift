//
//  ViewController.swift
//  testMixpanel
//
//  Created by Hokila Jan on 2018/4/18.
//  Copyright © 2018年 Hokila Jan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        Mixpanel.sharedInstance()?.track("EnterFirstVC", properties: nil)
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        button.setTitle("press me", for: .normal)
        button.center = self.view.center
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(buttonPress), for: .touchDown)
        
        let idButton = UIButton(type: .system)
        idButton.setTitle("update identity", for: .normal)
        idButton.frame = button.frame.offsetBy(dx: 0, dy: 50)
        self.view.addSubview(idButton)
        idButton.addTarget(self, action: #selector(userStatusButtonPress), for: .touchDown)
        
        if let distinctId = Mixpanel.sharedInstance()?.distinctId {
            Mixpanel.sharedInstance()?.createAlias("UserID", forDistinctID: distinctId, usePeople: true)
        }
        
        //call this at login
        Mixpanel.sharedInstance()?.identify("RealUserID", usePeople: true)
    }

    @objc func buttonPress() {
        var property = [String:Any]()
        property["array"] = ["123","456"]
        property["string"] = 123456
        property["int"] = 123
        property["float"] = Float(123.456)
        property["double"] = Double(123.456)
        property["bool"] = true
        property["nil"] = nil
        property["NSNumberInt"] = NSNumber(value: 123)
        property["NSNumberFloat"] = NSNumber(value: Float(123.0))
        property["NSNumberDouble"] = NSNumber(value: Double(123.0))
        property["json"] = self.loadJSON(fileName: "sample")  //[String:Any]?
        
        Mixpanel.sharedInstance()?.track("ButtonDidPress", properties:property)
    }
    
    @objc func userStatusButtonPress() {

        guard let people =  Mixpanel.sharedInstance()?.people else {
            return
        }
        
        people.set("Plan", to: "Premium")
        people.set("$name", to: "hokila")
        people.set("$email", to: "hokila@swag.live")
        people.set("$phone", to: "1234567")
        
        people.increment("Service Launch Count", by: 1)
    }
    
    func loadJSON(fileName:String,type:String = "json") -> [String:Any]? {
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: type) else {
            return nil
        }
        
        guard let loadData = NSData(contentsOfFile: path)  else {
            return nil
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: loadData as Data, options: []) as? [String: Any] else {
            return nil
        }
        
        return json
    }
}

