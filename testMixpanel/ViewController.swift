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
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        button.setTitle("press me", for: .normal)
        button.center = self.view.center
        self.view.addSubview(button)
        
        button.addTarget(self, action: #selector(buttonPress), for: .touchDown)
        
        Mixpanel.sharedInstance()?.track("EnterFirstVC", properties: nil)
    }

    @objc func buttonPress() {
        var property = [String:Any]()
        property["array"] = ["123","456"]
        property["string"] = 123456
        property["int"] = 123
        property["float"] = Float(123.0)
        property["double"] = Double(123.0)
        property["bool"] = true
        property["nil"] = nil
        property["NSNumberInt"] = NSNumber(value: 123)
        property["NSNumberFloat"] = NSNumber(value: Float(123.0))
        property["NSNumberDouble"] = NSNumber(value: Double(123.0))
        property["json"] = self.loadJSON(fileName: "sample")//[String:Any]?
        
        Mixpanel.sharedInstance()?.track("ButtonDidPress", properties:property)
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

