//
//  AboutViewController.swift
//  Voice Pitch Analyzer
//
//  Created by Carola Nitz on 8/20/17.
//  Copyright © 2017 Carola Nitz. All rights reserved.
//

import UIKit

class AboutViewController:UIViewController
{
    override func viewDidLoad() {
        title = NSLocalizedString("About", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AboutViewController.close))
    }

    func close(){
        dismiss(animated: true) {}
    }
}
