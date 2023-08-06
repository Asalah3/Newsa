//
//  Utilites.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 03/06/2023.
//

import Foundation
import SystemConfiguration
import UIKit

class Utilites{
    
    static func displayAlert(title : String , message: String , action : UIAlertAction , controller :UIViewController){
        let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(action)
        alert.addAction(cancelAction)
        controller.present(alert, animated: true,completion: nil)
    }
    
    static func displayToast(message : String, seconds: Double, controller: UIViewController){
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.view.backgroundColor = UIColor(named: "move")
        alert.view.layer.cornerRadius = 15
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    static func isConnectedToNetwork(complication:@escaping (Bool) -> Void) {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            complication(false)
            return
        }
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            complication(false)
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        complication(isReachable && !needsConnection)
    }
    
    static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    static func checkMode() {
        if #available(iOS 13.0, *){
            let appDelegate = UIApplication.shared.windows.first
           if UserDefaults.standard.darkMode {
                appDelegate?.overrideUserInterfaceStyle = .dark
                return
            }else{
                appDelegate?.overrideUserInterfaceStyle = .light
                return
            }
        }
    }
}

extension UserDefaults {
    private enum UserDefaultsKeys : String{
        case darkMode
    }
    var darkMode : Bool {
        get{
            bool(forKey: UserDefaultsKeys.darkMode.rawValue)
        }set{
            set(newValue, forKey: UserDefaultsKeys.darkMode.rawValue)
        }
    }
}
