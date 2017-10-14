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
            let minAverage = calculateMinAverage()
            let maxAverage = calculateMaxAverage()
            let rangeView = RangeView(min:minAverage, max:maxAverage)

            rangeView.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(rangeView)

            let constraints = [
                rangeView.leftAnchor.constraint(equalTo: view.leftAnchor),
                rangeView.rightAnchor.constraint(equalTo: view.rightAnchor),
                rangeView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
                rangeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]

            NSLayoutConstraint.activate(constraints)
        }
    }

    func calculateMinAverage() -> Double {
        var minsorted = pitchArray
        minsorted = minsorted!.sorted()
        let elements = minsorted!.count / 3
        minsorted = Array(minsorted!.prefix(elements))

        return calculateAverage(pitches:minsorted!)
    }

    func calculateMaxAverage() -> Double {
        var maxSorted = pitchArray
        maxSorted = maxSorted!.sorted()
        let elements = maxSorted!.count / 3
        maxSorted = Array(maxSorted!.suffix(elements))

        return calculateAverage(pitches:maxSorted!)
    }

    func  calculateAverage(pitches:Array<Double>) -> Double {
        var sum = 0.0;
        if (pitches.count != 0) {
            for pitch in pitches {
                sum += pitch;
            }
            return sum / Double(pitches.count);
        }
        return sum;
    }
}
