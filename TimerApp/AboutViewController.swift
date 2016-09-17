//
//  AboutViewController.swift
//  TimerApp
//
//  Created by Alexander Käßner on 03.08.16.
//  Copyright © 2016 David Symhoven. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // change version label with the actual bundle version
        let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionLabel.text = NSLocalizedString("VERSION", comment: "Version") + ": " + versionString!
    }

    @IBAction func openDevWebsite() {
       // UIApplication.shared.openURL(URL(string: "http://www.emka3.de")!)
        UIApplication.shared.open(URL(string: "http://www.emka3.de")!)
    }
    
    @IBAction func openDesignWebsite() {
        UIApplication.shared.open(URL(string: "http://www.alexkaessner.de")!)
    }

}
