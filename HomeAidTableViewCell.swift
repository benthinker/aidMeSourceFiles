//
//  HomeAidTableViewCell.swift
//  AidMe
//
//  Created by Ben Siso on 21/03/2016.
//  Copyright © 2016 Ben Siso. All rights reserved.
//

import UIKit

class HomeAidTableViewCell: UITableViewCell {
    // ------------ VIEWS ----------------------------
    @IBOutlet weak var showingImage: UIImageView!
    @IBOutlet weak var imageCounterLabel: UILabel!
    @IBOutlet weak var timeLestLabel: UILabel!
    @IBOutlet weak var hashtagLabel: UILabel! { didSet { hashtagLabel.text!.uppercaseString}}
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var grayBox: UIView!
    @IBOutlet weak var numberOfPhotosImage: UIImageView!
    var endOfTime : Int = 0
    
    
    // ------------ PROPERTIES -----------------------
    var timer : NSTimer?
    var aid : aidClass? { didSet {
        updateUI()
        } }

    var photos : [UIImage]?
    var ref : Firebase?
    // -----------------------------------------------
    
    override func awakeFromNib() {
        // Initialization code
        super.awakeFromNib()
        spinner.startAnimating()
        self.selectionStyle = UITableViewCellSelectionStyle.None // disable the gray effect on cell after highlighting it.
        timer = NSTimer()
        turnViewsOff()
        
 
    }
    
    
    func updateUI() {
        timer?.invalidate()
        turnViewsOn()
        imageCounterLabel.text = ("\(aid!.amount!)")
        hashtagLabel.text = ("#\(aid!.hashtag!)")
        userNameLabel.text = ("\(aid!.userName!)")
        timeCountingDown(aid!.time!)
        animateImages()
        spinner.stopAnimating()
    }
    
    // ---------------- Timer Functions ---------------
    func timeEnd() {
        timer?.invalidate()
        timeLestLabel.text = "DONE!"
        
    }
    
    func timeCountingDown(time : Int) {
        endOfTime = aid!.time! - Int(CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970)
        if endOfTime <= 0 {
            timeEnd()
        } else {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.8 , target: self, selector: "getTimeLeft", userInfo: nil, repeats: true)
        }
        
    }

    
    // --------------- TIME FORMATTER -------------------------------
    func startShowingTimeInGoodContext(time : Int) -> String {
        
        var hours = 0
        var min = 0
        var sec = 0
        if time/3600 >= 1 {
            hours = time/3600
            if time - hours*3600 > 0 {
                min = (time - hours*3600 ) / 60
                if (time - hours*3600)/60 > 0 {
                    sec = (time - hours*3600)%60
                    return ("\(hours) : \(min >= 10 ? "\(min)" : "0\(min)") : \(sec >= 10 ? "\(sec)" : "0\(sec)")")
                } else {
                    return ("\(hours) : \(min >= 10 ? "\(min)" : "0\(min)") : 00")
                }
            } else {
                if (time - hours*3600)%60 > 0 {
                    return ("\(hours) : 00 : \(sec >= 10 ? "\(sec)" : "0\(sec)")")
                } else {
                    return ("\(hours) : 00 : 00")
                }
            }
            
        } else {
            
            if time - hours*3600 > 0 {
                min = (time - hours*3600 ) / 60
                if (time - hours*3600)%60 > 0 {
                    sec = (time - hours*3600)%60
                    return ("\(min >= 10 ? "\(min)" : "0\(min)") : \(sec >= 10 ? "\(sec)" : "0\(sec)")")
                } else {
                    return ("\(min >= 10 ? "\(min)" : "0\(min)") : 00")
                }
            } else {
                if (time - hours*3600)%60 > 0 {
                    return ("00 : \(sec)")
                } else  {
                    return ("00 : 00")
                }
            }
            
        }
        
        
        
    }
    // ----------------------------------------------
    
    func getTimeLeft() {
        if endOfTime > 0 {
            endOfTime--
            timeLestLabel.text = ("\(startShowingTimeInGoodContext(endOfTime))")
        } else {
            timeEnd()
        }
    }
    // -----------------------------------------------
    func animateImages () {
        if aid?.aidPhotos!.count > 0 {
            showingImage.animationImages = aid?.aidPhotos
            showingImage.animationDuration = 3
            showingImage.startAnimating()
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func turnViewsOn () {
        showingImage.hidden = false
        imageCounterLabel.hidden = false
        hashtagLabel.hidden = false
        userNameLabel.hidden = false
        grayBox.hidden = false
        timeLestLabel.hidden = false
        numberOfPhotosImage.hidden = false
        
    }
    func turnViewsOff () {
        showingImage.hidden = true
        imageCounterLabel.hidden = true
        hashtagLabel.hidden = true
        userNameLabel.hidden = true
        grayBox.hidden = true
        timeLestLabel.hidden = true
        numberOfPhotosImage.hidden = true
        
    }
    

}
