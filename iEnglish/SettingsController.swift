import UIKit
import AVFoundation

class SettingsController: UITableViewController {
    @IBOutlet var rateSlider: UISlider!
    @IBOutlet var pitchSlider: UISlider!
    @IBOutlet var volumeSlider: UISlider!
    @IBOutlet var voiceSelection: UISegmentedControl!
    @IBOutlet var repeatingSwitch: UISwitch!
    
    override func viewDidLoad() {
        automaticallyAdjustsScrollViewInsets = false
        rateSlider.minimumValue = AVSpeechUtteranceMinimumSpeechRate
        rateSlider.maximumValue = AVSpeechUtteranceMaximumSpeechRate
        rateSlider.value = UserSettings.prefRate
        pitchSlider.minimumValue = 0.5
        pitchSlider.maximumValue = 2.0
        pitchSlider.value = UserSettings.prefPitch
        volumeSlider.minimumValue = 0.1
        volumeSlider.maximumValue = 1.0
        volumeSlider.value = 1.0
        
        switch UserSettings.prefVoice {
        case .American:
            voiceSelection.selectedSegmentIndex = 1
        case .British:
            voiceSelection.selectedSegmentIndex = 0
        }
        
        repeatingSwitch.on = UserSettings.prefRepeating
    }

    @IBAction func rateChanged(sender: UISlider) {
        NSUserDefaults.standardUserDefaults().setFloat(sender.value + 100.0, forKey: "speechRate")
    }
    
    @IBAction func pitchChanged(sender: UISlider) {
        NSUserDefaults.standardUserDefaults().setFloat(sender.value, forKey: "speechPitch")
    }
    
    @IBAction func volumeChanged(sender: UISlider) {
        NSUserDefaults.standardUserDefaults().setFloat(sender.value, forKey: "speechVolume")
    }
    
    @IBAction func voiceChanged(sender: UISegmentedControl) {
        NSUserDefaults.standardUserDefaults().setInteger(sender.selectedSegmentIndex + 1, forKey: "speechVoice")
    }
    
    @IBAction func repeatingChanged(sender: UISwitch) {
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "repeating")
    }
}