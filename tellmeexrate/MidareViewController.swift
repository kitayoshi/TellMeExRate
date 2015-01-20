//
//  MidareViewController.swift
//  tellmeexrate
//
//  Created by 乱序 on 15/1/20.
//  Copyright (c) 2015年 乱序. All rights reserved.
//

import UIKit

class MidareViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 2:
                UIApplication.sharedApplication().openURL(NSURL(string:"mailto:midare@utakana.de")!)
            case 3:
                UIApplication.sharedApplication().openURL(NSURL(string:"http://mida.re")!)
            case 4:
                UIApplication.sharedApplication().openURL(NSURL(string:"http://www.zhihu.com/midare")!)
            default:
                break;
            }
        }
    }

    // MARK: - Table view data source

}
