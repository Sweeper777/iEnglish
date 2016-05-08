import UIKit
import AVFoundation
import Toast_Swift

class ListenViewController: UITableViewController, UITextFieldDelegate {
    let synthesizer = AVSpeechSynthesizer()
    @IBOutlet var textToListen: UITextField!
    @IBOutlet var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.contentMode = .ScaleAspectFit
        textToListen.delegate = self
    }
    
    @IBAction func addToPlaylist(sender: UIBarButtonItem) {
        if textToListen.text == nil || textToListen.text!.isEmpty {
            let alert = UIAlertController(title: NSLocalizedString("加入播放列表失败", comment:""), message: NSLocalizedString("请在加入播放列表前先输入文字", comment: ""), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        performSegueWithIdentifier("addToPlaylist", sender: self)
    }
    
    @IBAction func listen(sender: UIButton) {
        view.endEditing(true)
        let str = textToListen.text!
        let utterance = UserSettings.getPrefUtterance(str)
        synthesizer.stopSpeakingAtBoundary(.Immediate)
        synthesizer.speakUtterance(utterance)
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? AddToPlayListController {
            tableView.visibleCells.first?.makeToast(String(format: NSLocalizedString("成功将 \"%@\" 加入播放列表", comment: ""), vc.stringToAdd), duration: 3, position: .Bottom, title: nil, image: UIImage(named: "tick")!, style: nil, completion: nil)
        }
    }
    
    @IBAction func unwindCancel(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addToPlaylist" {
            let destination = segue.destinationViewController as! DataPasserNavController
            destination.data = textToListen.text
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

