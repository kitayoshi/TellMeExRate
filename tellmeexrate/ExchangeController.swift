//
//  ExchangeController.swift
//  tellmeexrate
//
//  Created by 乱序 on 15/1/20.
//  Copyright (c) 2015年 乱序. All rights reserved.
//

import UIKit
import CoreData

class mytableView : UITableView {
    
    @IBOutlet weak var standardInput: UITextField!
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        standardInput.resignFirstResponder()
    }
}

class ExchangeController: UITableViewController,UITextFieldDelegate {
    
    @IBOutlet weak var standardInput: UITextField!
    @IBOutlet weak var standardLabel: UILabel!
    @IBOutlet weak var standardImageView: UIImageView!
    
    @IBOutlet weak var cnyLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var hkdLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    
    var settingParentNavController : UINavigationController?
    var settingController : SettingController?

    var standardCurrency = Currency()
    var cny = Currency()
    var usd = Currency(_chnName: "美元", _eName: "USD", _nationalFlag: UIImage(named: "United-States.png")!, _oneHundredEqualsCNY: 621.35)
    var hkd = Currency(_chnName: "港币", _eName: "HKD", _nationalFlag: UIImage(named: "Hong-Kong.png")!, _oneHundredEqualsCNY: 80.14)
    var eur = Currency(_chnName: "欧元", _eName: "EUR", _nationalFlag: UIImage(named: "European-Union.png")!, _oneHundredEqualsCNY: 719.52)
    var gbp = Currency(_chnName: "英镑", _eName: "GBP", _nationalFlag: UIImage(named: "United-Kingdom.png")!, _oneHundredEqualsCNY: 938.86)
    var jpy = Currency(_chnName: "日元", _eName: "JPY", _nationalFlag: UIImage(named: "Japan.png")!, _oneHundredEqualsCNY: 5.26)
    var updateTime = NSDate(timeIntervalSince1970: 1421744080)
    
    var rate = [NSManagedObject]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Rate")
        
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            
            if results != [] {
                usd.oneHundredEqualsCNY = results[0].valueForKey("usd2cny") as Float
                hkd.oneHundredEqualsCNY = results[0].valueForKey("hkd2cny") as Float
                eur.oneHundredEqualsCNY = results[0].valueForKey("eur2cny") as Float
                gbp.oneHundredEqualsCNY = results[0].valueForKey("gbp2cny") as Float
                jpy.oneHundredEqualsCNY = results[0].valueForKey("jpy2cny") as Float
                
                var standardCurrencyEName = results[0].valueForKey("standardCurrency") as String?
                
                switch standardCurrencyEName! {
                case "CNY":
                    setStandardCurrency (cny)
                case "USD":
                    setStandardCurrency (usd)
                case "HKD":
                    setStandardCurrency (hkd)
                case "EUR":
                    setStandardCurrency (eur)
                case "GBP":
                    setStandardCurrency (gbp)
                case "JPY":
                    setStandardCurrency (jpy)
                default:
                    break
                }
                
                updateTime = results[0].valueForKey("updateTime") as NSDate
                
                setNewUpdateTime(updateTime)
                
                let nowDate = NSDate()
                var timeGap = nowDate.timeIntervalSinceDate(updateTime)
                
                if (timeGap / 60 / 60) > 2 {
                    println("rererefre")
                    getNewRate()
                }

            } else {
                let entity =  NSEntityDescription.entityForName("Rate",
                    inManagedObjectContext:
                    managedContext)
                let rate = NSManagedObject(entity: entity!,
                    insertIntoManagedObjectContext:managedContext)
                
                rate.setValue(self.usd.oneHundredEqualsCNY, forKey: "usd2cny")
                rate.setValue(self.hkd.oneHundredEqualsCNY, forKey: "hkd2cny")
                rate.setValue(self.eur.oneHundredEqualsCNY, forKey: "eur2cny")
                rate.setValue(self.gbp.oneHundredEqualsCNY, forKey: "gbp2cny")
                rate.setValue(self.jpy.oneHundredEqualsCNY, forKey: "jpy2cny")
                
                rate.setValue(self.standardCurrency.eName, forKey: "standardCurrency")
                rate.setValue(self.updateTime, forKey: "updateTime")
                
                setNewUpdateTime(updateTime)
                
                var error: NSError?
                if !managedContext.save(&error) {
                    println("Could not save \(error), \(error?.userInfo)")
                }
            }
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let oldText:NSString = standardInput.text
        let newText:NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        if newText.length <= 0 {
            setLabel(100)
        } else {
            setLabel(newText.floatValue)
        }
        
        return true
    }
    
    func getNewRate () {
        var jhOpenidSupplier = JHOpenidSupplier.shareSupplier();
        jhOpenidSupplier.registerJuheAPIByOpenId("JH1ded735690310d0dd6b3a7d2595a700f") //Open ID
        
        var path = "http://op.juhe.cn/onebox/exchange/query";
        var api_id = "80";
        var method = "GET";
        var param = ["key":"2975e28463f27841b7e697f866f6ed30", "dtype":"json"];
        var juhepai = JHAPISDK.shareJHAPISDK();
        
        juhepai.executeWorkWithAPI(path, APIID: api_id, parameters: param, method: method,
            success:{responseObject in
                if let result = responseObject["result"] as? NSDictionary {
                    if let list = result["list"] as? NSArray{
                        if let usdArray = list[0] as? NSArray { if let usd2cny = usdArray[2] as? NSString { self.usd.oneHundredEqualsCNY = usd2cny.floatValue } }
                        if let hkdArray = list[1] as? NSArray { if let hkd2cny = hkdArray[2] as? NSString { self.hkd.oneHundredEqualsCNY = hkd2cny.floatValue } }
                        if let eurArray = list[2] as? NSArray { if let eur2cny = eurArray[2] as? NSString { self.eur.oneHundredEqualsCNY = eur2cny.floatValue } }
                        if let gbpArray = list[3] as? NSArray { if let gbp2cny = gbpArray[2] as? NSString { self.gbp.oneHundredEqualsCNY = gbp2cny.floatValue } }
                        if let jpyArray = list[4] as? NSArray { if let jpy2cny = jpyArray[2] as? NSString { self.jpy.oneHundredEqualsCNY = jpy2cny.floatValue } }
                    }
                }
                
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                let managedContext = appDelegate.managedObjectContext!
                
                let fetchRequest = NSFetchRequest(entityName: "Rate")
                
                var error: NSError?
                
                let fetchedResults =
                managedContext.executeFetchRequest(fetchRequest,
                    error: &error) as [NSManagedObject]?
                
                if let results = fetchedResults {
                    
                    if results != [] {
                        results[0].setValue(self.usd.oneHundredEqualsCNY, forKey: "usd2cny")
                        results[0].setValue(self.hkd.oneHundredEqualsCNY, forKey: "hkd2cny")
                        results[0].setValue(self.eur.oneHundredEqualsCNY, forKey: "eur2cny")
                        results[0].setValue(self.gbp.oneHundredEqualsCNY, forKey: "gbp2cny")
                        results[0].setValue(self.jpy.oneHundredEqualsCNY, forKey: "jpy2cny")
                        
                        results[0].setValue(self.standardCurrency.eName as String, forKey: "standardCurrency")
                        
                        
                        self.updateTime = NSDate()
                        
                        results[0].setValue(self.updateTime, forKey: "updateTime")
                        
                        self.setNewUpdateTime(self.updateTime)
                        
                        if !managedContext.save(&error) {
                            println("Could not save \(error), \(error?.userInfo)")
                        }
                    }
                } else {
                    println("Could not fetch \(error), \(error!.userInfo)")
                }
                
                self.setLabel(100)
            },
            failure:{error in
                println(error)
            }
        )
    }
    
    func setStandardCurrency (_currency:Currency){
        standardCurrency = _currency
        standardLabel.text = standardCurrency.eName
        standardImageView.image = standardCurrency.nationalFlag
        setLabel(100)
        
        settingParentNavController = self.tabBarController?.viewControllers![1] as UINavigationController?
        settingController = settingParentNavController?.viewControllers![0] as SettingController?
        settingController?.standardCurrency = standardCurrency
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Rate")
        
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            
            if results != [] {
                results[0].setValue(self.usd.oneHundredEqualsCNY, forKey: "usd2cny")
                results[0].setValue(self.hkd.oneHundredEqualsCNY, forKey: "hkd2cny")
                results[0].setValue(self.eur.oneHundredEqualsCNY, forKey: "eur2cny")
                results[0].setValue(self.gbp.oneHundredEqualsCNY, forKey: "gbp2cny")
                results[0].setValue(self.jpy.oneHundredEqualsCNY, forKey: "jpy2cny")
                results[0].setValue(self.standardCurrency.eName as String, forKey: "standardCurrency")
                
                if !managedContext.save(&error) {
                    println("Could not save \(error), \(error?.userInfo)")
                }
            }
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }

    }
    
    func setNewUpdateTime (_date: NSDate) {
        settingParentNavController = self.tabBarController?.viewControllers![1] as UINavigationController?
        settingController = settingParentNavController?.viewControllers![0] as SettingController?
        settingController?.updateTime = _date;
    }
    
    func setLabel (_standardInputFloat:Float) {
        let cnyLabelFloat = _standardInputFloat / 100 * standardCurrency.oneHundredEqualsCNY
        let usdLabelFloat = cnyLabelFloat / usd.oneHundredEqualsCNY * 100
        let hkdLabelFloat = cnyLabelFloat / hkd.oneHundredEqualsCNY * 100
        let eurLabelFloat = cnyLabelFloat / eur.oneHundredEqualsCNY * 100
        let gbpLabelFloat = cnyLabelFloat / gbp.oneHundredEqualsCNY * 100
        let jpyLabelFloat = cnyLabelFloat / jpy.oneHundredEqualsCNY * 100
        
        let cnyLabelString = NSString(format:"%.2f",cnyLabelFloat)
        let usdLabelString = NSString(format:"%.2f",usdLabelFloat)
        let hkdLabelString = NSString(format:"%.2f",hkdLabelFloat)
        let eurLabelString = NSString(format:"%.2f",eurLabelFloat)
        let gbpLabelString = NSString(format:"%.2f",gbpLabelFloat)
        let jpyLabelString = NSString(format:"%.2f",jpyLabelFloat)
        
        cnyLabel.text = "¥ \(cnyLabelString)"
        usdLabel.text = "$ \(usdLabelString)"
        hkdLabel.text = "HK$ \(hkdLabelString)"
        eurLabel.text = "€ \(eurLabelString)"
        gbpLabel.text = "£ \(gbpLabelString)"
        jpyLabel.text = "¥ \(jpyLabelString)"
    }
}
