//
//  RecordingDetailViewController.swift
//  Voice Pitch Analyzer
//
//  Created by Carola Nitz on 8/19/17.
//  Copyright © 2017 Carola Nitz. All rights reserved.
//

import UIKit

class RecordingDetailViewController: UIViewController {

    var pitchArray:Array<Double>?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let pitchArray = pitchArray, pitchArray.count > 0 {
            let rangeView = RangeView(min:pitchArray.min()!, max:pitchArray.max()!)

            rangeView.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(rangeView)

            let constraints = [
                rangeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                rangeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                rangeView.widthAnchor.constraint(equalTo: view.widthAnchor),
                rangeView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
            ]

            NSLayoutConstraint.activate(constraints)
        }
    }
}
