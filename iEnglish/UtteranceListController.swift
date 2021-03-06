import UIKit
import CoreData
import AVFoundation

class UtteranceListController: UITableViewController, AVSpeechSynthesizerDelegate {
    @IBOutlet var playStopBtn: UIBarButtonItem!
    var playlist: Playlists!
    var indexOfPlaylist: Int!
    var isPlaying = false
    var nowPlayingIndex = 0
    let dataContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    let synthesizer = AVSpeechSynthesizer()
    
    @IBAction func editTableView(sender: UIBarButtonItem) {
        if editing {
            tableView.setEditing(false, animated: true)
            sender.title = NSLocalizedString("编辑", comment: "")
            sender.style = .Plain
            editing = false
        } else {
            if isPlaying {
                return
            }
            
            tableView.setEditing(true, animated: true)
            sender.title = "完成"
            sender.style = .Done
            editing = true
        }
    }
    
    @IBAction func playClick(sender: UIBarButtonItem) {
        if isPlaying {
            isPlaying = false
            synthesizer.stopSpeakingAtBoundary(.Immediate)
            sender.image = UIImage(named: "play")
            nowPlayingIndex = 0
        } else {
            if editing {
                return
            }
            
            sender.image = UIImage(named: "stop")
            isPlaying = true
            if nowPlayingIndex < playlist.utterrances?.count {
                let utterance = UserSettings.getPrefUtterance((playlist.utterrances![nowPlayingIndex] as! Utterance).string!)
                //utterance.postUtteranceDelay = 0.3\
                synthesizer.speakUtterance(utterance)
            } else {
                sender.image = UIImage(named: "play")
            }
        }
    }
    
    override func viewDidLoad() {
        title = playlist.name
        synthesizer.delegate = self
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.utterrances!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = playlist.utterrances![indexPath.row].string
        cell.textLabel?.backgroundColor = UIColor(red: 0xca / 0xff, green: 1, blue: 0xc7 / 0xff, alpha: 1)
        cell.contentView.backgroundColor = UIColor(red: 0xca / 0xff, green: 1, blue: 0xc7 / 0xff, alpha: 1)
        cell.editingAccessoryView?.backgroundColor = UIColor(red: 0xca / 0xff, green: 1, blue: 0xc7 / 0xff, alpha: 1)
        return cell
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        synthesizer.stopSpeakingAtBoundary(.Immediate)
        synthesizer.speakUtterance(UserSettings.getPrefUtterance((tableView.cellForRowAtIndexPath(indexPath)?.textLabel!.text)!))
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            dataContext.deleteObject(playlist.utterrances![indexPath.row] as! Utterance)
            self.dataContext.saveData()
            let entity = NSEntityDescription.entityForName("Playlist", inManagedObjectContext: dataContext)
            let request = NSFetchRequest()
            request.entity = entity
            playlist = try! dataContext.executeFetchRequest(request)[indexOfPlaylist] as! Playlists
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor(red: 0xca / 0xff, green: 1, blue: 0xc7 / 0xff, alpha: 1)
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        if !isPlaying {
            return
        }
        
        nowPlayingIndex += 1
        if nowPlayingIndex >= playlist.utterrances!.count {
            if UserSettings.prefRepeating {
                nowPlayingIndex = 0
                let utterance = UserSettings.getPrefUtterance((playlist.utterrances![nowPlayingIndex] as! Utterance).string!)
                utterance.postUtteranceDelay = 0.3
                synthesizer.speakUtterance(utterance)
            } else {
                isPlaying = false
                playStopBtn.image = UIImage(named: "play")
                nowPlayingIndex = 0
            }
        } else {
            let utterance = UserSettings.getPrefUtterance((playlist.utterrances![nowPlayingIndex] as! Utterance).string!)
            utterance.postUtteranceDelay = 0.3
            synthesizer.speakUtterance(utterance)
        }
    }
}
