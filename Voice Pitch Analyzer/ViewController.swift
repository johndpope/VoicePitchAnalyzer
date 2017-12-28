//
//  ViewController.swift
//  Voice Pitch Analyzer
//
//  Created by Carola Nitz on 8/18/17.
//  Copyright © 2017 Carola Nitz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeText.text = NSLocalizedString("Welcome", comment: "")
        nextButton.setTitle(NSLocalizedString("Gotit", comment: ""), for: .normal)
        nextButton.addTarget(self, action: #selector(ViewController.showNextScreen), for: .touchUpInside)
    }

    @objc func showNextScreen() {
        dismiss(animated: true) {}
    }


}
