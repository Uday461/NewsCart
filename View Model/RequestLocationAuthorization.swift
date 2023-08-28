//
//  RequestLocationAuthorization.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 28/08/23.
//

import Foundation
import CoreLocation
import MoEngageGeofence
class RequestLocationAuthorization{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
          //  enableLocationFeatures()
            break
            
        case .restricted, .denied:  // Location services currently unavailable.
         //   disableLocationFeatures()
            break
            
        case .notDetermined:        // Authorization not determined yet.
           manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
}
