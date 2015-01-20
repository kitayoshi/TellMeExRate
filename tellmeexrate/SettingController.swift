//
//  SettingController.swift
//  tellmeexrate
//
//  Created by 乱序 on 15/1/20.
//  Copyright (c) 2015年 乱序. All rights reserved.
//

import UIKit

class SettingController: UITableViewController {
    
    @IBOutlet weak var cnyCell: UITableViewCell!
    @IBOutlet weak var usdCell: UITableViewCell!
    @IBOutlet weak var hkdCell: UITableViewCell!
    @IBOutlet weak var eurCell: UITableViewCell!
    @IBOutlet weak var gbpCell: UITableViewCell!
    @IBOutlet weak var jpyCell: UITableViewCell!
    
    @IBOutlet weak var updateTimeLabel: UILabel!
    
    var exchangeParentNavController : UINavigationController?
    var exchangeController : ExchangeController?
    
    var standardCurrency = Currency()
    var updateTime = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        exchangeParentNavController = self.tabBarController?.viewControllers![0] as UINavigationController?
        exchangeController = exchangeParentNavController?.viewControllers![0] as ExchangeController?

        checkStandardCurrency()
        setTime()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                standardCurrency = exchangeController!.cny;
            case 1:
                standardCurrency = exchangeController!.usd;
            case 2:
                standardCurrency = exchangeController!.hkd;
            case 3:
                standardCurrency = exchangeController!.eur;
            case 4:
                standardCurrency = exchangeController!.gbp;
            case 5:
                standardCurrency = exchangeController!.jpy;
            default:
                break;
            }
            exchangeController?.setStandardCurrency(standardCurrency)
            checkStandardCurrency()
        }
    }
    
    @IBAction func refreshButtonClick(sender: AnyObject) {
        exchangeController!.getNewRate()
        setTime()
    }
    
    
    func checkStandardCurrency() {
        cnyCell.accessoryType = (standardCurrency.eName == "CNY" as NSString) ? .Checkmark : .None
        usdCell.accessoryType = (standardCurrency.eName == "USD" as NSString) ? .Checkmark : .None
        hkdCell.accessoryType = (standardCurrency.eName == "HKD" as NSString) ? .Checkmark : .None
        eurCell.accessoryType = (standardCurrency.eName == "EUR" as NSString) ? .Checkmark : .None
        gbpCell.accessoryType = (standardCurrency.eName == "GBP" as NSString) ? .Checkmark : .None
        jpyCell.accessoryType = (standardCurrency.eName == "JPY" as NSString) ? .Checkmark : .None
    }
    
    func setTime() {
        let date = updateTime
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components( .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minutes = components.minute

        //在第一个 view 建立的时候，第二个 view 这里的 label 还没有出现呢！
        //所以会出现 fatal error: unexpectedly found nil while unwrapping an Optional value
        //加个 if 判断吧…
        
        if var label = updateTimeLabel {
            label.text = "\(year)-\(month)-\(day) \(hour):\(minutes)"
        }
        
    }
}
