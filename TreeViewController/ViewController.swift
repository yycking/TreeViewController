//
//  ViewController.swift
//  TreeViewController
//
//  Created by YehYungCheng on 2016/4/21.
//  Copyright © 2016年 YehYungCheng. All rights reserved.
//

import UIKit

class ViewController: TreeViewController, TreeDataDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.expandable = true
        var data:[String: AnyObject] = [:]
        if let path = NSBundle.mainBundle().pathForResource("city", ofType: "json"){
            if let jsonData = NSData(contentsOfFile: path) {
                do {
                    if let jsonResult: NSArray = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSArray{
                        for city in jsonResult {
                            let name = city["city"] as! String
                            let indexes = city["indexes"] as! NSArray
                            var array: [String: AnyObject] = [:]
                            for index in indexes {
                                let areas = index["areas"] as! NSArray
                                for area in areas {
                                    let town = area["name"] as! String
                                    let villages = area["villages"] as! NSArray
                                    array[town] = villages
                                }
                            }
                            data[name] = array
                        }
                    }
                } catch {}
            }
        }
        self.treeData = data
        self.treeDataDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func treeViewController(treeViewController: TreeViewController!, clickAtNode node: TreeViewNode!) {
        print("click on text \(node.text) at level \(node.level)")
    }
}

