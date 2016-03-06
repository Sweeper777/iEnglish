import AVFoundation

class UserSettings {
    static var prefRate: Float {
        let rate = NSUserDefaults.standardUserDefaults().floatForKey("speechRate")
        if rate == 0 {
            return AVSpeechUtteranceDefaultSpeechRate
        } else {
            return rate - 100.0
        }
    }
    
    static var prefPitch: Float {
        let pitch = NSUserDefaults.standardUserDefaults().floatForKey("speechPitch")
        if pitch == 0 {
            return 1.0
        } else {
            return pitch
        }
    }
    
    static var prefVolume: Float {
        let volume = NSUserDefaults.standardUserDefaults().floatForKey("speechVolume")
        if volume == 0 {
            return 0.1
        } else {
            return volume
        }
    }
    
    enum Voice: String {
        case British = "en-gb"
        case American = "en-us"
    }
    
    static var prefVoice: Voice {
        let voice = NSUserDefaults.standardUserDefaults().integerForKey("speechVoice")
        if voice == 0 {
            return .British
        } else {
            switch voice {
            case 2:
                return .American
            case 1:
                fallthrough
            default:
                return .British
            }
        }
    }
    
    static func getPrefUtterance(string: String) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: string)
        utterance.pitchMultiplier = UserSettings.prefPitch
        utterance.rate = UserSettings.prefRate
        utterance.volume = prefVolume
        utterance.voice = AVSpeechSynthesisVoice(language: prefVoice.rawValue)
        return utterance
    }
}