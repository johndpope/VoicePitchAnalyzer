//
//  RangeView.swift
//  Voice Pitch Analyzer
//
//  Created by Carola Nitz on 8/19/17.
//  Copyright © 2017 Carola Nitz. All rights reserved.
//

import UIKit

class RangeView: UIView {

    //65 to 525
    var min:Double
    var max:Double

    init(min:Double, max:Double) {
        self.min = min
        self.max = max

        super.init(frame: .zero)
        let maleLabel = UILabel(frame: .zero)
        maleLabel.text = "Male\nRange"
        maleLabel.numberOfLines = 0
        maleLabel.textAlignment = .right
        maleLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(maleLabel)

        let androgynousLabel = UILabel(frame: .zero)
        androgynousLabel.text = "Androgynous\nRange"
        androgynousLabel.numberOfLines = 0
        androgynousLabel.textAlignment = .right
        androgynousLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(androgynousLabel)

        let femaleLabel = UILabel(frame: .zero)
        femaleLabel.text = "Female\nRange"
        femaleLabel.numberOfLines = 0
        femaleLabel.textAlignment = .right
        femaleLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(femaleLabel)
        
        let constraints = [
            femaleLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            femaleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            maleLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            maleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            androgynousLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            androgynousLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {

        let context = UIGraphicsGetCurrentContext();
        self.clearsContextBeforeDrawing = true
        context!.setFillColor(UIColor.white.cgColor)
        context!.fill(bounds);

        //femaleRange goes from 165hz - 255. The entire screen should show 340HZ
        //therefor 165 is 48.f percent of the screen and 255 is 75 percent
        //since we draw this upside down I have to take 1 -


        let femaleRangeStart = bounds.height * (1 - 0.4852)
        let femaleRangeEnd = bounds.height * (1 - 0.75)
        let femaleRange = CGRect(x:0, y:femaleRangeStart, width: bounds.width, height: femaleRangeEnd - femaleRangeStart);
        context!.setFillColor(red: 147.0/255.0, green: 112.0/255.0, blue: 219.0/255.0, alpha: 0.5);
        context!.fill(femaleRange);
        //male range 85 to 180
        let maleRangeStart = bounds.height * (1 - 0.25)
        let maleRangeEnd = bounds.height * (1 - 0.5294)

        let maleRange = CGRect(x:0, y:maleRangeStart, width: bounds.width, height: maleRangeEnd - maleRangeStart);
        context!.setFillColor(red: 230.0/255.0, green: 230.0/255.0, blue: 250.0/255.0, alpha: 0.5);
        context!.fill(maleRange);

        let yourmin = (1.0 - min/340)
        let yourmax = (1.0 - max/340)

        let yourRangeStart = bounds.height * CGFloat(yourmin)
        let yourRangeEnd = bounds.height * CGFloat(yourmax)
        let yourRange = CGRect(x:0, y:yourRangeStart, width: bounds.width, height: yourRangeEnd - yourRangeStart);
        context!.setFillColor(red: 147.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5);
        context!.fill(yourRange);

    }
}
