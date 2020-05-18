//
//  StartViewController.swift
//  havachat
//
//  Created by Sean Wells on 4/27/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func onArtistClick(_ sender: Any) {
        performSegue(withIdentifier: "ArtistStartSegue", sender: self)
    }
    
    
    @IBAction func onFanClick(_ sender: Any) {
        performSegue(withIdentifier: "FanStartSegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
