//
//  AboutViewController.swift
//  Voice Pitch Analyzer
//
//  Created by Carola Nitz on 8/20/17.
//  Copyright © 2017 Carola Nitz. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UITextViewDelegate
{
    override func viewDidLoad() {
        title = NSLocalizedString("About", comment: "")
        view.backgroundColor = .white
        setupSubviews()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AboutViewController.close))
    }

    func setupSubviews() {
        let aboutText = UITextView()
        aboutText.delegate = self
        aboutText.isScrollEnabled = false;
        aboutText.isEditable = false;

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let attributes: [String : Any] = [NSParagraphStyleAttributeName: paragraph, NSFontAttributeName:UIFont.systemFont(ofSize: 15)]

        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let appname = "Voice-Pitch-Analyzer"
        let stringWithVersion = String.localizedStringWithFormat(NSLocalizedString("AboutText", comment:""), version!,appname)
        let attributedString = NSMutableAttributedString(string: stringWithVersion, attributes: attributes)

        _ = attributedString.setAsLink(textToFind: appname, linkURL: "https://github.com/purrprogramming/voice-pitch-analyzer/")

        aboutText.attributedText = attributedString
        aboutText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(aboutText)

        let constraints = [
            aboutText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            aboutText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            aboutText.widthAnchor.constraint(equalTo: view.widthAnchor, constant:-20)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }

    func close() {
        dismiss(animated: true) {}
    }
}
