//
//  AboutViewController.swift
//  tellmeexrate
//
//  Created by 乱序 on 15/1/20.
//  Copyright (c) 2015年 乱序. All rights reserved.
//

import UIKit

class AboutViewController: UITableViewController, NSLayoutManagerDelegate {

    @IBOutlet weak var aboutTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        aboutTextView.layoutManager.delegate = self
        
        
    }
    
//    func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
//        return 7
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
