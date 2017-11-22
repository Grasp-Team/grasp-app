//
//  ContactPagerViewController.swift
//  grasp
//
//  Created by Charles Bai on 2017-11-21.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ContactPagerViewController: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .groupTableViewBackground
        settings.style.buttonBarItemBackgroundColor = .groupTableViewBackground
        settings.style.selectedBarBackgroundColor = Constants.Colors.blueTheme
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = Constants.Colors.blueTheme
        }
        
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let contactAcceptedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactAcceptedVC")
        let contactPendingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactPendingVC")
        return [contactPendingVC, contactAcceptedVC]
    }
}
