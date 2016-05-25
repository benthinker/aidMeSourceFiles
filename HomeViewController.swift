//
//  HomeViewController.swift
//  
//
//  Created by Ben Siso on 04/03/2016.
//
//

import UIKit

class HomeViewController: UITableViewController {

    var aids : [aidClass]?
    @IBOutlet weak var userName: UINavigationItem!
    var aidsArr : [aidClass]?
    var aidsArrID : [String]?
    let ref = Firebase(url: "https://blinding-fire-5374.firebaseio.com")
    var arrAidToList : [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 240.0
        tableView.separatorInset.bottom = 5.0
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
//        if let user =  (ref.authData.providerData["displayName"] as? String)?.uppercaseString {
//            userName.title = user
//        }
        
        aids = [aidClass]()
        aidsArrID = [String]()
        let userID = "facebook:10154034832379925"
        getAidToList(userID) // get users that i am AidTo

    }
    
    

    // ----------------------------------------------------------------------------
    
    // GET ARRAY OF USERS U AID TO // BETA BETA BETA - NEED TO UPGRADE THE ALGO OF GETING USER'S AIDS
    func getAidToList(userID : String)  {
        if let path = ref.childByAppendingPath("users/\(userID)/aidToList") {
            
            path.observeSingleEventOfType(.Value, withBlock: { list  in
                dispatch_async(dispatch_get_main_queue()) {  () -> Void in
                    self.arrAidToList = (list.value! as! [String : String]).keys.sort()
                    if (self.arrAidToList?.count > 4) {
                        self.buildAidsIDArray(1)
                    } else {
                        self.buildAidsIDArray(4)
                    }
                }
            })
        }
    }
    
    // GET ARRAY OF AIDS ID
    func buildAidsIDArray(amountPerUser : UInt) {
        var newAidID : String?
        for userID in arrAidToList! {
            ref.childByAppendingPath("aids/\(userID)").queryLimitedToLast(amountPerUser).observeSingleEventOfType(.Value, withBlock: {
                snap in
                dispatch_async(dispatch_get_main_queue()) {  () -> Void in
                    for aidID in snap.children {
                        newAidID = aidID.key!! as String
                        self.aidsArrID!.append(newAidID!)
                    }
                    self.aidsArrID! = self.aidsArrID!.reverse()
                    self.updateUI()
                }
            })
        }
        
    }
    // ------ UPDATE FUNC -----------
    func updateUI() {
        self.tableView.reloadData()
    }
    // ------------------------------ Create Cell PER Index Path FUNC -------------------------------------
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeAidCell", forIndexPath: indexPath) as! HomeAidTableViewCell
        var numberOfUsers = 0
        if arrAidToList!.count >  1 {
            numberOfUsers  = indexPath.section
        }
        
        
            print("aidID : \(aidsArrID![indexPath.section]) || userID : \(arrAidToList![numberOfUsers]) ")
        if ((aids?.count)! - 1 >= indexPath.section) {
            cell.aid = aids![indexPath.section]  // set the cell Aid
           
            return cell
        }
        
            let userIDCount = numberOfUsers
            let aidIDCount = indexPath.section
            // ---------------- Setup a Cell ---------------------------
            var mone = 0 // count the number of images
            ref.childByAppendingPath("aids/\(arrAidToList![userIDCount])/\(aidsArrID![aidIDCount])").queryLimitedToLast(7).observeSingleEventOfType(.Value, withBlock: { photosLog in
                
                let newAid = aidClass(userID: self.arrAidToList![userIDCount], aidID: self.aidsArrID![aidIDCount], time: 0)
            
                    newAid.userName = photosLog.childSnapshotForPath("userName").value as? String
                    newAid.hashtag = photosLog.childSnapshotForPath("hashtag").value as? String
                    newAid.amount = photosLog.childSnapshotForPath("amount").value as? Int
                    newAid.time = photosLog.childSnapshotForPath("time").value as? Int
                
            
                for pID  in photosLog.childSnapshotForPath("aidPhotosID").children {
                        let photoID = pID.value!! as! String
                        newAid.aidKeys!.append(photoID)
                        if photoID != "" {
                            self.ref.childByAppendingPath("photos/\(photoID)/photoData").observeSingleEventOfType(.Value, withBlock: {photoData in
                                dispatch_async(dispatch_get_main_queue() ) { () -> Void in
                                    mone++
                                    let photoDataString = photoData.value as! String
                                    let image = self.change64ToImage(photoDataString)
                                    newAid.aidPhotos!.append(image)
                                    // check if finish to load all the photos's AIDS
                                    if mone == Int(photosLog.childSnapshotForPath("aidPhotosID").childrenCount) {
                                        self.aids!.append(newAid) // Make a List of Aids
                                        cell.aid = newAid  // set the cell Aid
                                    }
                                }
                            })
                    
                        }
                    }

                })
        return cell
    }
    

    // --------------------------------------------------------------------------
    
    
    @IBAction func backFromNewAidAdded (segue : UIStoryboardSegue) {
        print("_added new Aid - finished")
        self.tableView.reloadData()
    }
    
    @IBAction func backFromNewAidCanceled (segue : UIStoryboardSegue) {
        print("cancel new Aid ")
        
    }
    
    
//    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return false
//    }
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("aidPage", sender: nil)
//    }

    
    
    
    


    //---------------- AID : GETTING DATA ----------------------------------------
    // return - Get Image from Data String
    func change64ToImage(imgDataString : String) -> UIImage
    {
        let imageFromData = UIImage(data: NSData(base64EncodedString: imgDataString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
        return imageFromData!
    }
    //----------------------------------------------------------------------------
    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
       
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return aidsArrID!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3.5
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerV = UIView()
        footerV.backgroundColor = UIColor.clearColor()
        
        return footerV
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    /*
     Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
             Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
             Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
