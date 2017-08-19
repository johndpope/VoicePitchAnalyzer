//
//  RecordingViewController.swift
//  Voice Pitch Analyzer
//
//  Created by Carola Nitz on 8/18/17.
//  Copyright © 2017 Carola Nitz. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {

    var recordButton: UIButton
    var cancelButton: UIButton!

    var textView: UITextView!
    var recorder:AVAudioRecorder!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        setupAudioRecorder()
    }

    func setupSubviews(){
        view.backgroundColor = .white

        recordButton.setTitle("Record", for: .normal)
        recordButton.addTarget(self, action: #selector(RecordingViewController.startRecording), for: .touchUpInside)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.titleLabel?.textAlignment = .center
        recordButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(recordButton)

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.setTitleColor(.black, for: .normal)
        //back to the overview
        //cancelButton.addTarget(self, action: #selector(RecordingViewController.startRecording), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(cancelButton)

        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)

        textView.text = "Erstes Kapitel\n\n Das Atelier schwamm in einem starken Rosendufte, und wenn der leichte Sommerwind die B\u{00e4}ume im Garten wiegte, so flo\u{00df} durch die offene T\u{00fc}r der schwere Geruch des Flieders herein oder der zartere Duft des Rotdorns. Aus der Ecke seines Diwans mit persischen Satteltaschen, auf dem Lord Henry Wotton lag und wie gew\u{00f6}hnlich unz\u{00e4}hlige Zigaretten rauchte, konnte er gerade noch den Schimmer der honigs\u{00fc}\u{00df}en und honigfarbigen Bl\u{00fc}ten eines Goldregenstrauches wahrnehmen, dessen zitternde Zweige nur seufzend die Last einer so flammenden Sch\u{00f6}nheit zu tragen schienen, und dann und wann huschten die phantastischen Schatten vorbeifliegender V\u{00f6}gel \u{00fc}ber die langen bastseidenen Vorh\u{00e4}nge, die vor das gro\u{00df}e Fenster gezogen waren. Das gab einen Augenblick lang eine Art japanischer Stimmung und lie\u{00df} den Lord an die bleichen, nephritgelben Maler der Stadt Tokio denken, die mit Hilfe einer Kunst, die notwendigerweise erstarrt genannt werden mu\u{00df}, das Gef\u{00fc}hl von Schnelligkeit und Bewegung hervorzubringen suchen. Das tiefe Gesumme der Bienen, die ihren zweifelnden Flug durch das hohe, ungem\u{00e4}hte Gras nahmen oder mit eint\u{00f6}niger Z\u{00e4}higkeit um die bestaubten Goldtrichter des wuchernden Gei\u{00df}blattes kreisten, lie\u{00df} die Stille noch dr\u{00fc}ckender scheinen."

    }

    func setupAudioRecorder() {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        path = path?.appending("MyAudioMemo.m4a")

        let outputFileURL = URL(fileURLWithPath: path!)

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
        } catch {
            print(error)
        }

        let recordSetting = [
            AVFormatIDKey : NSNumber(value:kAudioFormatMPEG4AAC),
            AVSampleRateKey : NSNumber(value:44100.0),
            AVNumberOfChannelsKey : NSNumber(value:2),
        ]

         do {
            try recorder = AVAudioRecorder(url: outputFileURL, settings: recordSetting)
         } catch {
            print(error)
        }
        recorder.delegate = self
        recorder.isMeteringEnabled = true;
        recorder.prepareToRecord()
    }

    func fillText(){

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        recordButton = UIButton(type: .custom)
        cancelButton = UIButton(type: .custom)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startRecording() {

        recordButton.removeTarget(self, action: nil, for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(RecordingViewController.stopRecording), for: .touchUpInside)
        recordButton.setTitle("Stop", for: .normal)
        try! AVAudioSession.sharedInstance().setActive(true)

        recorder.record()
    }

    func stopRecording() {
        recorder.stop()
        recordButton.removeTarget(self, action: nil, for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(RecordingViewController.startRecording), for: .touchUpInside)
        recordButton.setTitle("Start Recording", for: .normal)
        try! AVAudioSession.sharedInstance().setActive(false)
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        let detailViewController = RecordingDetailViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
        recorder.url
    }
}
