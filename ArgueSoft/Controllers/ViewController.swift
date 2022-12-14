//
//  ViewController.swift
//  ArgueSoft
//
//  Created by Chris waters on 11/19/22.
//

import UIKit
import AVFoundation
import GoogleMobileAds



class ViewController: UIViewController {
    
    var bannerView: GADBannerView!
    
    
 // var sliderValue = 5
   // var endedSliderValue = -5
    
    @IBOutlet weak var dbLevel: UILabel!
    @IBOutlet weak var loudMessage: UILabel!
    var player: AVAudioPlayer!
   
    
    @IBOutlet weak var soundMeter: UIProgressView!
   
  
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 50))
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: adSize)

           addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-4427278532535845/6588134703"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
      
        setUpAudioCapture()
        // Do any additional setup after loading the view.
        UIApplication.shared.isIdleTimerDisabled = true

      
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: bottomLayoutGuide,
                            attribute: .top,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
     }
    
    
    private func setUpAudioCapture() {
            
        let recordingSession = AVAudioSession.sharedInstance()
            
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try recordingSession.setActive(true)
                
            recordingSession.requestRecordPermission({ result in
                    guard result else { return }
            })
                
            captureAudio()
                
        } catch {
            print("ERROR: Failed to set up recording session.")
        }
    }
    
    private func captureAudio() {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("recording.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            
            let audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            audioRecorder.isMeteringEnabled = true
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                audioRecorder.updateMeters()
                let db = audioRecorder.averagePower(forChannel: 0)
               // print(db)
                self.dbLevel.text = String("\(db) db")
                
                let soundLevel = Float((db / 50) * -1)
              //  print("Sound Level is  + \(soundLevel)")
                self.soundMeter.progress = Float(soundLevel)
                
                
                
                if Int(db) > -5 {
                    print("Too Lound")
                    self.fadeMessage(message: "Too Loud.  Please take a breath", color: .blue, finalAlpha: 0.0)
                   // self.loudMessage.text = "Too Lound. Please take a Breathe."
                 
                   
                    self.playSound()
                }
            }
        } catch {
            print("ERROR: Failed to start recording process.")
        }
    }
    
    func playSound(){
        
        let soundNum = Int.random(in: 0...8)
        
        let stringNum = String(soundNum)
        print("string number is \(stringNum)")
        
        let url = Bundle.main.url(forResource: stringNum, withExtension: "wav")
        self.player = try! AVAudioPlayer(contentsOf: url!)
        self.player.play()
    }
   
    func fadeMessage(message:String, color:UIColor, finalAlpha: CGFloat) {
        loudMessage.text          = message
        loudMessage.alpha         = 1.0
        loudMessage.isHidden      = false
        loudMessage.textAlignment = .center
        loudMessage.backgroundColor     = color
        loudMessage.layer.cornerRadius  = 5
        loudMessage.layer.masksToBounds = true
        
        UIView.animate(withDuration: 7.0, animations: { () -> Void in
            self.loudMessage.alpha = finalAlpha
        })
    }
    
    

}

