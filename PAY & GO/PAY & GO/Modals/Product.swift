//
//  Product.swift
//  PAY & GO
//
//  Created by Ashish sharma on 07/02/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import Foundation

struct Product {
    
    var productBarCode: String
    var productName: String
    var productImage: String
    var productPrice: Double
    
    init(productCode code: String, productName name: String, productImage img: String,productPrice price: Double) {
        self.productBarCode = code
        self.productName = name
        self.productImage = img
        self.productPrice = price
    }
}
