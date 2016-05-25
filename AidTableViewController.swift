//
//  AidTableViewController.swift
//  AidMe
//
//  Created by Ben Siso on 14/04/2016.
//  Copyright © 2016 Ben Siso. All rights reserved.
//

import UIKit

class AidTableViewController: UITableViewController {
    // var that i get from advance
    var aidUserID : String? { didSet{ if aidID != nil { update() } }}
    var aidID : String? { didSet{ if aidUserID != nil { update() } }}
    
    var voteAlready = false
    var ref = Firebase(url: "https://blinding-fire-5374.firebaseio.com/")
    var photos = [UIImage]()
    var photosIDArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ref?.authData.uid == nil
        {
            print("no user")
        }
    }
    
    func update()
    {
        let photosList = ref.childByAppendingPath("aids/\(aidUserID)/\(aidID)/aidPhotosID")
        var photoDataString = String()
        var index = 0
        while (photosList?.valueForKey("\(index)") != nil)
        {
            photosIDArray.append(photosList.valueForKey(("\(index)")) as! String)
            photoDataString = (photosList?.valueForKey("\(index)"))! as! String
            photos.append(change64ToImage(photoDataString))
            index++
        }
    }
    
    // return - Get Image from Data String
    func change64ToImage(imgDataString : String) -> UIImage
    {
        let imageFromData = UIImage(data: NSData(base64EncodedString: imgDataString, options: [])!)
        return imageFromData!
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return photos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("photo", forIndexPath: indexPath) as! AidTableViewCell
       
        cell.photoID = photosIDArray[indexPath.row]
        cell.aidPhoto.image = photos[indexPath.row]
        if voteAlready == true {
            cell.clickedAlready = true
        } else if cell.clickedAlready == true {
            voteAlready = true
        }
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
