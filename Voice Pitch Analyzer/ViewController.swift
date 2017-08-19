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

        welcomeText.text = "Hey There!\n\nTo properly analyse it, we need about one minute of audio recording of your voice. For this purpose, we’ll provide you with a text of a length approximate to this time frame. Of course you’re free to say anything else, too, as long as it’s in your natural voice.";
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(ViewController.showNextScreen), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showNextScreen(){
        let recordingViewController = RecordingViewController()
        let navController = UINavigationController(rootViewController: recordingViewController)
        present(navController, animated: true){}
    }


}
