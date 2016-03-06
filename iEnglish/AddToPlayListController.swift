import UIKit
import CoreData

class AddToPlayListController: UITableViewController {
    var playlists: [Playlists] = []
    var stringToAdd: String!
    let dataContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
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
        cell.textLabel?.text = playlists[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let playlistToAddTo = playlists[indexPath.row]
        let entity = NSEntityDescription.entityForName("Utterance", inManagedObjectContext: dataContext)
        let utterance = Utterance(entity: entity!, insertIntoManagedObjectContext: dataContext)
        utterance.string = stringToAdd
        utterance.playlist = playlistToAddTo
        dataContext.saveData()
    }
}
