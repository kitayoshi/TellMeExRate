//
//  nation.swift
//  tellmeexrate
//
//  Created by 乱序 on 15/1/20.
//  Copyright (c) 2015年 乱序. All rights reserved.
//

import Foundation
import UIKit

class Currency {
    var chnName:NSString = "人民币"
    var eName:NSString = "CNY"
    var nationalFlag:UIImage = UIImage(named: "China.png")!
    var oneHundredEqualsCNY:Float = 100
    
    init (_chnName:NSString,_eName:NSString,_nationalFlag:UIImage,_oneHundredEqualsCNY:Float) {
        self.chnName = _chnName
        self.eName = _eName
        self.nationalFlag = _nationalFlag
        self.oneHundredEqualsCNY = _oneHundredEqualsCNY
    }
    
    init () {
        
    }
}