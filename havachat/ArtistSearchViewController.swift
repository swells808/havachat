//
//  ArtistSearchViewController.swift
//  havachat
//
//  Created by Sean Wells on 4/23/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import SwiftyJSON
import Alamofire


class ArtistSearchViewController: UIViewController, UISearchBarDelegate, FUIAuthDelegate {
    
    var currentUser: User?
    var artistList = [Artist]()
    var resultsArray = [[String:Any]]()
    
    let artistRef = Database.database().reference(withPath: "artists")


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //FirebaseUI
        if Auth.auth().currentUser != nil {
          
        } else {
            FUIAuth.defaultAuthUI()?.shouldHideCancelButton = true
            let authUI = FUIAuth.defaultAuthUI()
            authUI?.delegate = self
            let providers: [FUIAuthProvider] = [
                FUIFacebookAuth(),
                FUIOAuth.appleAuthProvider()]

            authUI?.providers = providers
            let authViewController = authUI!.authViewController()
            self.present(authViewController, animated: true, completion: nil)
            
        }
        
        
        
        //Load All Table Data
        loadArtists()
    }
    
    @objc func userBackToStart() {
        performSegue(withIdentifier: "UserBackToStartSegue", sender: self)
    }
    
    func loadArtists() {
            artistRef.observeSingleEvent(of: .value, with: { (snapshot) in
                for case let item as DataSnapshot in snapshot.children {
                    if var itemData = item.value as? [String:Any] {
                        itemData["uid"] = item.key
                        self.resultsArray.append(itemData)
                    }
                }
                self.tableView.reloadData()
    //            print(self.resultsArray)
            })
            
        }

    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text?.lowercased(), searchText != "" {
            resultsArray.removeAll()
            queryText(searchText, inField: "artistUsername")
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter a username.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func queryText(_ text: String, inField child: String) {
        artistRef.queryOrdered(byChild: child)
        .queryStarting(atValue: text)
        .queryEnding(atValue: text+"\u{f8ff}")
            .observeSingleEvent(of: .value) { [weak self] (snapshot) in
                for case let item as DataSnapshot in snapshot.children {
                    //Dont show the current user in search results
//                    if self?.currentUser?.uid == item.key {
//                        continue
//                    }
                    
                    if var itemData = item.value as? [String:String] {
                        itemData["uid"] = item.key
                        self?.resultsArray.append(itemData)
                    }
                }
                self?.tableView.reloadData()
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
      let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        
//        loginViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(userBackToStart))
        
        loginViewController.view.backgroundColor = UIColor.white
        
        let marginInsets: CGFloat = 16
        let imageHeight: CGFloat = 180
        let imageY = self.view.center.y - imageHeight
        
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
        
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "Havachat-Blue")
        logoImageView.contentMode = .scaleAspectFit
        loginViewController.view.addSubview(logoImageView)
        
        return loginViewController
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            let indexPaths=self.tableView!.indexPathForSelectedRow
            let indexPath = indexPaths! as NSIndexPath
            let vc = segue.destination as! ArtistDetailViewController
            vc.artistData = self.resultsArray[indexPath.row]
        }
    }
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
    }
    

extension ArtistSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath)
        
        if let artistCell = cell as? ArtistTableViewCell {
            let artistData = resultsArray[indexPath.row]
            artistCell.artistNameCell.text = artistData["artistUsername"] as? String
            artistCell.artistTypeCell.text = artistData["artistField"] as? String
            artistCell.artistOnlineCell.text = artistData["isLoggedOn"] as? String
            let itemURL = URL(string: (artistData["pPictureUrl"] as? String)!)
            ImageService.getImage(withURL: itemURL!) { (image) in
                artistCell.artistImageCell.image = image
            }
            
        }
        
        return cell
    }
    
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
