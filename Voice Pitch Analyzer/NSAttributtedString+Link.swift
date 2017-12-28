//
//  NSAttributtedString+Link.swift
//  Voice Pitch Analyzer
//
//  Created by Carola Nitz on 8/23/17.
//  Copyright © 2017 Carola Nitz. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {

    public func setAsLink(textToFind:String, linkURL:String) -> Bool {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedStringKey.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}

