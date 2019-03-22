//
//  CartTableViewCell.swift
//  PAY & GO
//
//  Created by Ashish sharma on 08/02/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var proImage: UIImageView!
    
    @IBOutlet weak var proName: UILabel!
    
    @IBOutlet weak var proBarCode: UILabel!
    
    @IBOutlet weak var proPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(withProduct product: Product) {
        self.proName.text = product.productName
        self.proBarCode.text = product.productBarCode
        self.proPrice.text = String(describing: product.productPrice)
     
        if let url = URL(string: product.productImage) {
            self.proImage.downloadImage(from: url) }
    }
}
