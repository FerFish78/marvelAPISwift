//
//  ComicViewCell.swift
//  WebTests
//
//  Created by Fer Fish on 29/11/2018.
//  Copyright © 2018 Dev1. All rights reserved.
//

import UIKit

class ComicViewCell: UITableViewCell {

   @IBOutlet weak var imagen: UIImageView!
   
   @IBOutlet weak var cabecera: UILabel!
   
   @IBOutlet weak var detalle: UILabel!
   override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
