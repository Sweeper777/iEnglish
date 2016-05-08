import UIKit
import CoreData

class AddToPlayListController: UITableViewController {
    var playlists: [Playlists] = []
    var stringToAdd: String!
    let dataContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var success = false
    
    override func viewDidLoad() {
        if dataContext != nil {
            let entity = NSEntityDescription.entityForName("Playlist", inManagedObjectContext: dataContext)
            let request = NSFetchRequest()
            request.entity = entity
            let playlists = try? dataContext.executeFetchRequest(request)
            if playlists != nil {
                for item in playlists! {
                    self.playlists.append(item as! Playlists)
                }
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell1") ?? UITableViewCell()
        if playlists.isEmpty {
            cell.textLabel?.text = NSLocalizedString("你没有播放列表", comment: "")
            return cell
        }
        cell.textLabel?.text = playlists[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if playlists.isEmpty {
            return 1
        }
        
        return playlists.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if playlists.isEmpty {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }
        
        success = true
        let playlistToAddTo = playlists[indexPath.row]
        let entity = NSEntityDescription.entityForName("Utterance", inManagedObjectContext: dataContext)
        let utterance = Utterance(entity: entity!, insertIntoManagedObjectContext: dataContext)
        utterance.string = stringToAdd
        utterance.playlist = playlistToAddTo
        dataContext.saveData()
        performSegueWithIdentifier("unwind", sender: self)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("选择一个播放列表", comment: "")
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        performSegueWithIdentifier("unwind", sender: self)
    }
}
