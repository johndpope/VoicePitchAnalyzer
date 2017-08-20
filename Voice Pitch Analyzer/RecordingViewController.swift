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

    var recordButton: UIButton
    var cancelButton: UIButton
    var aboutButton:UIButton
    var pitchArray:Array<Double> = Array()
    var textView: UITextView
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
        recordButton.setTitleColor(.black, for: .normal)

        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.setTitleColor(.black, for: .normal)
        //back to the overview
        //cancelButton.addTarget(self, action: #selector(RecordingViewController.startRecording), for: .touchUpInside)
        textView.font = UIFont.systemFont(ofSize: 22)
        textView.isEditable = false
        [recordButton, cancelButton, textView].forEach {
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
                    var dict = texts![lang!] as! [String]
                    let randomNumber = Int(arc4random() % 457)
                    textView.text = dict[randomNumber]
                    print(object)
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
        let constraints = [
            textView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor),
            textView.bottomAnchor.constraint(equalTo: recordButton.topAnchor),
            recordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            recordButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            recordButton.leftAnchor.constraint(equalTo: cancelButton.rightAnchor),
            cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            cancelButton.rightAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        recordButton = UIButton(type: .custom)
        cancelButton = UIButton(type: .custom)
        textView = UITextView()
        aboutButton = UIButton(type: UIButtonType.infoDark)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        let detailViewController = RecordingDetailViewController()
        detailViewController.pitchArray = pitchArray
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    func showAboutScreen() {
        let aboutvc = AboutViewController()
        let navigationvc = UINavigationController(rootViewController: aboutvc)
        present(navigationvc, animated: true, completion: nil)
    }

    // MARK:PitchEngineDelegate
    func pitchEngineDidReceivePitch(_ pitchEngine: PitchEngine, pitch: Pitch)
    {
        if pitch.frequency < 340.0 && pitch.frequency > 65.0 {
            pitchArray.append(pitch.frequency)
        }
        print(pitch.frequency)
    }

    func pitchEngineDidReceiveError(_ pitchEngine: PitchEngine, error: Error){
        //  print(error)
    }

    func pitchEngineWentBelowLevelThreshold(_ pitchEngine: PitchEngine){
        //intentionally left empty
    }

}
