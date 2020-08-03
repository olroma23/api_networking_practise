//
//  TableViewCell.swift
//  Networking
//
//  Created by Roman Oliinyk on 22.06.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

//    var stringURL = ""
    
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberOfLessons: UILabel!
    @IBOutlet weak var numberOfTests: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        courseImageView.image = UIImage(named: stringURL)
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
