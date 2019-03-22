//
//  CheckoutViewController.swift
//  PAY & GO
//
//  Created by Ashish sharma on 07/02/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    @IBOutlet weak var cartTable: UITableView!
    
    var products: [Product]?
    
    var manager: CoreDataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CoreDataManager.sharedManager
        manager?.delegate = self
        self.getProducts()
    }
    
    override func viewWillLayoutSubviews() {
        self.navigationItem.setRightBarButton(getClearButton(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getProducts()
        self.cartTable.reloadData()
        
        self.tabBarItem.badgeValue = String(describing: manager?.getCartCount())
    }
    
    func getClearButton() -> UIBarButtonItem {
        
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearCart))
        button.title = "Clear"
        button.tintColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        
        return button
    }
    
    @objc func clearCart() {
        manager?.clearCart()
        self.getProducts()
        self.cartTable.reloadData()
    }
    
}

extension CheckoutViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as! CartTableViewCell
        
        guard let product = products?[indexPath.row] else { return cell }
        
        cell.setupCell(withProduct: product)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99
    }
    
}

//MARK: Core data delegate

extension CheckoutViewController: CoreDataManagerDelegate {
   
    func cartUpdated(withProduct: Product) {
        print("something added in cart")
    }
    
    func cartCleared() {
        presentAlert(withStr: "Your cart has been emptied",shouldVibrate: true)
    }
}

//MARK: Internal function to get products

extension CheckoutViewController {
    
    func getProducts() {
        
        self.products = []
        
        guard let products = manager?.getCartFromDB() else { return }
        
        for prod in products {
            
            let name = prod.value(forKey: "productName") as? String ?? ""
            let code = prod.value(forKey: "productBarCode") as? String ?? ""
            let image = prod.value(forKey: "productImage") as? String ?? ""
            let price = prod.value(forKey: "productPrice") as? Double ?? 0.0
            let prod = Product.init(productCode: code, productName: name, productImage: image, productPrice: price)
            
            self.products?.append(prod)
        }
    }

    
}
