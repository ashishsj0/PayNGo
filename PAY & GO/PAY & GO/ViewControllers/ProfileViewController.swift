//
//  ProfileViewController.swift
//  PAY & GO
//
//  Created by Ashish sharma on 07/02/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var settingsTable: UITableView!
    
     let options = ["Password","Notifications","Privacy","Speak to us","Feedback","Sign Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingsTable.dataSource = self
        self.settingsTable.delegate = self
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileOptionsCell")
        
        cell?.textLabel?.text = options[indexPath.row]
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentAlert(withStr: "Hi, we are working on \(options[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
