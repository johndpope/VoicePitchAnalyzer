//
//  RecordingDetailViewController.swift
//  Voice Pitch Analyzer
//
//  Created by Carola Nitz on 8/19/17.
//  Copyright © 2017 Carola Nitz. All rights reserved.
//

import UIKit

class RecordingDetailViewController: UIViewController {

    var pitchArray:Array<Double>!

    init(array:Array<Double>) {
        pitchArray = array
        super.init(nibName: "", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let rangeView = RangeView()
        rangeView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(rangeView)

        let constraints = [
            rangeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rangeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rangeView.widthAnchor.constraint(equalTo: view.widthAnchor),
            rangeView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
        ]

        NSLayoutConstraint.activate(constraints)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
