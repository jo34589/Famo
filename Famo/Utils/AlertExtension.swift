//
//  AlertExtension.swift
//  Famo
//
//  Created by 엔나루 on 2022/10/11.
//

import Foundation
import UIKit

extension AppDelegate {

    // Global Alert
    // Define Your number of buttons, styles and completion
    ///vc: self
    static func openAlert(vc: UIViewController,
                          title: String,
                          message: String,
                          alertStyle:UIAlertController.Style,
                          actionTitles:[String],
                          actionStyles:[UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)]){

        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for(index, indexTitle) in actionTitles.enumerated(){
            let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
            alertController.addAction(action)
        }
        vc.present(alertController, animated: true)
    }
}
