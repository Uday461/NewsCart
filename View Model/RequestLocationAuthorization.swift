//
//  RequestLocationAuthorization.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 28/08/23.
//

import Foundation
import CoreLocation
import MoEngageGeofence
import MoEngageCore
class RequestLocationAuthorization: MoEngageGeofenceDelegate{
    func geofenceEnterTriggered(withLocationManager locationManager: CLLocationManager?, andRegion region: CLRegion?, forAccountMeta accountMeta: MoEngageCore.MoEngageAccountMeta) {
        LogManager.logging("Geofence Entered")
    }
    
    func geofenceExitTriggered(withLocationManager locationManager: CLLocationManager?, andRegion region: CLRegion?, forAccountMeta accountMeta: MoEngageCore.MoEngageAccountMeta) {
        LogManager.logging("Geofence Exited")
    }
    
    static func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:  // Location services are available.
          //  enableLocationFeatures()
            MoEngageSDKGeofence.sharedInstance.startGeofenceMonitoring()
            break
            
        case .restricted, .denied:  // Location services currently unavailable.
         //   disableLocationFeatures()
            MoEngageSDKGeofence.sharedInstance.stopGeofenceMonitoring()
            break
    
        case .notDetermined:        // Authorization not determined yet.
           manager.requestAlwaysAuthorization()
            break
            
        default:
            break
        }
    }
}
