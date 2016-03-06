import UIKit

class DataPasserNavController: UINavigationController {
    var data: String!
    
    override func viewDidLoad() {
        if topViewController is AddToPlayListController {
            let vc = topViewController as! AddToPlayListController
            vc.stringToAdd = data
        }
    }
}

