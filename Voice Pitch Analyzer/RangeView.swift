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
    override init(frame: CGRect) {
        super.init(frame: frame)

        let maleLabel = UILabel(frame: .zero)
        maleLabel.text = "Male Range"
        maleLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(maleLabel)

        let androgynousLabel = UILabel(frame: .zero)
        androgynousLabel.text = "Androgynous Range"
        androgynousLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(androgynousLabel)

        let femaleLabel = UILabel(frame: .zero)
        femaleLabel.text = "Female Range"
        femaleLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(femaleLabel)

//        let constraints = [
//            femaleLabel.rightAnchor.constraint(equalTo: .rightAnchor),
//            maleLabel.rightAnchor.constraint(equalTo: .rightAnchor),
//            androgynousLabel.rightAnchor.constraint(equalTo: .rightAnchor),
//        ]


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {

        let context = UIGraphicsGetCurrentContext();
        self.clearsContextBeforeDrawing = true

        context!.setFillColor(red: 147.0/255.0, green: 112.0/255.0, blue: 219.0/255.0, alpha: 1);
        var upperRect = bounds;
        upperRect.size.height = (bounds.size.height - 50) / 2.0
        context!.fill(upperRect);

        context!.setFillColor(red: 216.0/255.0, green: 191.0/255.0, blue: 216.0/255.0, alpha: 1);
        let middlerect = CGRect(x:0, y: upperRect.maxY, width: upperRect.width, height: 50);
        context!.fill(middlerect);

        context!.setFillColor(red: 230.0/255.0, green: 230.0/255.0, blue: 250.0/255.0, alpha: 1);
        let bottomrect = CGRect(x:0, y: middlerect.maxY, width: upperRect.width, height: upperRect.height);

        context!.fill(bottomrect);


    }
}
