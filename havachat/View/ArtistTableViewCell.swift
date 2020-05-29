//
//  ArtistTableViewCell.swift
//  havachat
//
//  Created by Sean Wells on 4/23/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artistImageCell: UIImageView!
    @IBOutlet weak var artistNameCell: UILabel!
    @IBOutlet weak var artistTypeCell: UILabel!
    @IBOutlet weak var artistOnlineCell: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
