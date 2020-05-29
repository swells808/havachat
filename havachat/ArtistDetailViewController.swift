//
//  ArtistDetailViewController.swift
//  havachat
//
//  Created by Sean Wells on 5/26/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import SwiftyJSON
import Alamofire

class ArtistDetailViewController: UIViewController {
    
    var artistData = [String:Any]()
    var currentUser = Auth.auth().currentUser
    var artistUID = ""
    
    var fiveMinDouble = ""
    var tenMinDouble = ""
    var fifteenMinDouble = ""

    @IBOutlet weak var artistProfileImage: UIImageView!
    @IBOutlet weak var artistUsername: UILabel!
    @IBOutlet weak var artistField: UILabel!
    @IBOutlet weak var artistHeadline: UILabel!
    @IBOutlet weak var fiveMinButton: UIButton!
    @IBOutlet weak var tenMinButton: UIButton!
    @IBOutlet weak var fifteenMin: UIButton!
    @IBOutlet weak var artistBio: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        artistUsername?.text = artistData["artistUsername"] as? String
        artistField?.text = artistData["artistField"] as? String
        artistHeadline?.text = artistData["artistHeadline"] as? String
        artistBio?.text = artistData["artistBio"] as? String
        fiveMinDouble = (artistData["fiveMin"] as? String)!
        tenMinDouble = (artistData["tenMin"] as? String)!
        fifteenMinDouble = (artistData["fifteenMin"] as? String)!
        artistUID = (artistData["uid"] as? String)!
        fiveMinButton.setTitle("Click to start a Live Video Call for 5 minutes for $\(fiveMinDouble)", for: .normal)
        tenMinButton.setTitle("Click to start a Live Video Call for 10 minutes for $\(tenMinDouble)", for: .normal)
        fifteenMin.setTitle("Click to start a Live Video Call for 15 minutes for $\(fifteenMinDouble)", for: .normal)
        let itemURL = URL(string: (artistData["pPictureUrl"] as? String)!)
        ImageService.getImage(withURL: itemURL!) { (image) in
            self.artistProfileImage.image = image
        }
        
    }
    
    
    
    
    @IBAction func fiveMinPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "startCall", sender: self)
    }
    @IBAction func tenMinPressed(_ sender: UIButton) {
        
    }
    @IBAction func fifteenMinPressed(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
            if segue.identifier == "startCall" {
                if let videoController = segue.destination as? VideoViewController {
                    let uids = [currentUser?.uid ?? "", self.artistUID].sorted { $0 < $1 }
                    let channelName = uids[0] + uids[1]
                    videoController.setChannelName(channel: channelName)
                    videoController.setUserName(name: currentUser?.displayName ?? "")
                    
                    let request = AF.request("https://havachat-videochat.herokuapp.com/access_token?channel=\(channelName)&uid=\(uids[0])")
                    

                    request.responseJSON { (response) in
                        guard let tokenDict = response.value as! [String : Any]? else { return }
                        let token = tokenDict["token"] as! String
                        // use the generated token here
                        videoController.tempToken = token 
                        }
                     }
                    
                }
            }
    
    /*
    // MARK: - Navigation

    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using segue.destination.
    //        // Pass the selected object to the new view controller.
    //        if segue.identifier == "startCall" {
    //            guard let userData = sender as? [String: String] else {
    //                assert(false, "startCall segue triggered improperly")
    //                return
    //            }
    //            if let videoController = segue.destination as? VideoViewController {
    //                let uids = [currentUser?.uid ?? "", userData["uid"] ?? ""].sorted { $0 < $1 }
    //                let channelName = uids[0] + uids[1]
    //                videoController.setChannelName(channel: channelName)
    //                videoController.setUserName(name: currentUser?.username)
    //                let request = AF.request("https://havachat-videochat.herokuapp.com/access_token?channel=\(channelName)&uid=\(String(describing: currentUser?.uid))")
    //
    //                request.responseJSON { (response) in
    //                    guard let tokenDict = response.value as! [String : Any]? else { return }
    //                    let token = tokenDict["token"] as! String
    //                    // use the generated token here
    //                    }
    //                 }
    //
    //            }
    //        }
    */

}
