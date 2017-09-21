//
//  RecordingViewController.swift
//  Voice Pitch Analyzer
//
//  Created by Carola Nitz on 8/18/17.
//  Copyright © 2017 Carola Nitz. All rights reserved.
//

import UIKit
import Beethoven
import Pitchy

class RecordingViewController: UIViewController, PitchEngineDelegate {

    var recordButton = UIButton(type: .custom)
    var textView = UITextView()
    var aboutButton = UIButton(type: UIButtonType.infoDark)
    var pitchArray:Array<Double> = Array()

    let firstAppearanceKey = "firstAppearance"

    lazy var pitchEngine: PitchEngine = { [weak self] in
        var config = Config(bufferSize: 4096, estimationStrategy: .yin)
        let pitchEngine = PitchEngine(config: config, delegate: self)

        return pitchEngine
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presentIntroIfNeeded()
        setupSubviews()
        setupConstraints()
    }

    func presentIntroIfNeeded(){
        let firstTime = UserDefaults.standard.bool(forKey: firstAppearanceKey)
        if !firstTime {
            let mainsb = UIStoryboard(name: "Main", bundle: nil)
            let introScreen = mainsb.instantiateInitialViewController()
            present(introScreen!, animated: true) {}
            UserDefaults.standard.set(true, forKey: firstAppearanceKey)
        }
    }

    func setupSubviews(){
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("Recording", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: aboutButton)
        aboutButton.addTarget(self, action: #selector(RecordingViewController.showAboutScreen), for: .touchUpInside)
        recordButton.setTitle(NSLocalizedString("Record", comment: ""), for: .normal)
        recordButton.addTarget(self, action: #selector(RecordingViewController.startRecording), for: .touchUpInside)
        recordButton.titleLabel?.textAlignment = .center
        recordButton.setBackgroundImage(imageFromColor(color:.vpapurple), for: .normal)
        recordButton.setTitleColor(.white, for: .normal)
        recordButton.layer.cornerRadius = 10
        recordButton.layer.masksToBounds = true

        textView.font = UIFont.systemFont(ofSize: 22)
        textView.isEditable = false
        [recordButton, textView].forEach {
            ($0 as! UIView).translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0 as! UIView)
        }
        fillText()
    }

    func fillText(){
        do {
            var lang = NSLocale.preferredLanguages.first
            lang = lang!.substring(to: lang!.index(lang!.startIndex, offsetBy: 2))
            if (lang != "de" && lang != "en" && lang != "it" && lang != "pt") {
                lang = "en"
            }
            if let file = Bundle.main.url(forResource: lang, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    let texts = object["texts"] as? [String : Any]
                    if let texts = texts {
                        var dict = texts[lang!] as! [String]
                        let randomNumber = Int(arc4random() % 457)
                        if randomNumber < dict.count {
                            textView.text = dict[randomNumber]
                        }
                        print(object)
                    } else {
                        print("no text object in json")
                    }
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func setupConstraints()
    {
        NSLayoutConstraint.activate( [
            textView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor),
            textView.bottomAnchor.constraint(equalTo: recordButton.topAnchor),
            recordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:-8),
            recordButton.heightAnchor.constraint(equalToConstant:44),
            recordButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            recordButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant:10),
        ])
    }

    func startRecording() {

        recordButton.removeTarget(self, action: nil, for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(RecordingViewController.stopRecording), for: .touchUpInside)
        recordButton.setTitle(NSLocalizedString("Stop", comment: ""), for: .normal)

        pitchEngine.start()
    }

   
    func stopRecording() {
        recordButton.removeTarget(self, action: nil, for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(RecordingViewController.startRecording), for: .touchUpInside)
        recordButton.setTitle(NSLocalizedString("Record", comment: ""), for: .normal)
        pitchEngine.stop()
        if ( pitchArray.count > 0) {
            let detailViewController = RecordingDetailViewController()
            detailViewController.pitchArray = pitchArray
            navigationController?.pushViewController(detailViewController, animated: true)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("No Samples", comment:""), message: NSLocalizedString("No Samples description", comment:""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func showAboutScreen() {
        let aboutvc = AboutViewController()
        let navigationvc = UINavigationController(rootViewController: aboutvc)
        present(navigationvc, animated: true, completion: nil)
    }

    // MARK:PitchEngineDelegate
    func pitchEngineDidReceivePitch(_ pitchEngine: PitchEngine, pitch: Pitch)
    {
        //filtering the too high and too low values out
        if pitch.frequency < 340.0 && pitch.frequency > 65.0 {
            pitchArray.append(pitch.frequency)
        }
    }

    func pitchEngineDidReceiveError(_ pitchEngine: PitchEngine, error: Error){
        //  print(error)
    }

    func pitchEngineWentBelowLevelThreshold(_ pitchEngine: PitchEngine){
        //intentionally left empty
    }

    func imageFromColor(color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
