import UIKit
import CoreData

class PlaylistController: UITableViewController {
    var playlists: [Playlists] = []
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
    
    @IBAction func editTableView(sender: UIBarButtonItem) {
        if editing {
            tableView.setEditing(false, animated: true)
            sender.title = NSLocalizedString("编辑", comment: "")
            sender.style = .Plain
            editing = false
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "完成"
            sender.style = .Done
            editing = true
        }
    }

    @IBAction func addPlaylist(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "新播放列表", message: NSLocalizedString("请输入播放列表的名字", comment: ""), preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "名字"
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if alert.textFields?.first?.text == "" || alert.textFields?.first?.text == nil {
                let failAlert = UIAlertController(title: NSLocalizedString("失败", comment: ""), message: NSLocalizedString("播放列表名不能为空", comment: ""), preferredStyle: .Alert)
                failAlert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .Default, handler: nil))
                self.presentViewController(failAlert, animated: true, completion: nil)
                return
            }
            let newPlaylist = Playlists(entity: NSEntityDescription.entityForName("Playlist", inManagedObjectContext: self.dataContext)!, insertIntoManagedObjectContext: self.dataContext)
            newPlaylist.name = alert.textFields?.first?.text
            self.playlists.append(newPlaylist)
            self.tableView.reloadData()
            self.dataContext.performBlock({ () -> Void in
                self.dataContext.saveData()
            })
        }))
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
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
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            dataContext.deleteObject(playlists[indexPath.row])
            self.dataContext.saveData()
            playlists.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPlaylistDetail" {
            let destination = segue.destinationViewController as! UtteranceListController
            destination.playlist = playlists[tableView.indexPathForSelectedRow!.row]
            destination.indexOfPlaylist = tableView.indexPathForSelectedRow!.row
        }
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
    }
}

extension NSManagedObjectContext {
    func saveData() -> Bool {
        do {
            try self.save()
            return true
        } catch let error as NSError {
            print(error)
            return false;
        }
    }
}
