//
//  Extension_UIViewController.swift
//  PAY & GO
//
//  Created by Ashish sharma on 08/02/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

extension UIViewController {
    
    func presentAlert(withStr str: String,shouldVibrate vibrate:Bool? = false, completion: ((Bool) -> Void)? = nil ) {
        let alertController = UIAlertController(title: "Pay & Go", message: str, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if completion != nil {
                completion!(true)
            }}
        ))
        
        if vibrate! {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        present(alertController, animated: true, completion: nil)
    }
}
