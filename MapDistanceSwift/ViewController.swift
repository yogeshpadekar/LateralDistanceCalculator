//
//  ViewController.swift
//  MapDistanceSwift
//
//  Created by Yogesh Padekar on 5/30/17.
//  Copyright © 2017 Yogesh Padekar. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    let LAT1 = "Replace by LAT1"
    let LON1 = "Replace by LON1"
    let LAT2 = "Replace by LAT2"
    let LON2 = "Replace by LON2"
    @IBOutlet fileprivate var mapView: MKMapView!
    fileprivate var routeLine: MKPolyline?
    fileprivate var renderer: MKPolylineRenderer?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var coordinateArray = [CLLocationCoordinate2D](repeating: CLLocationCoordinate2D(), count: 2)
        coordinateArray[0] = CLLocationCoordinate2DMake(LAT1, LON1)
        coordinateArray[1] = CLLocationCoordinate2DMake(LAT2, LON2)
        routeLine = MKPolyline(coordinates: coordinateArray, count: 2)
        routeLine?.title = distanceBetweenLocations()
        //If you want the route to be visible
        mapView.add(routeLine!)
        createAndAddAnnotation(forCoordinate: centerOfLine())
        createAndAddAnnotation(forCoordinate: coordinateArray[0])
        createAndAddAnnotation(forCoordinate: coordinateArray[1])
        mapView.visibleMapRect = (routeLine?.boundingMapRect)!
    }

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if (renderer == nil) {
            renderer = MKPolylineRenderer(overlay: overlay)
            renderer?.strokeColor = UIColor.white
            renderer?.lineWidth = 1.0
        }
        return renderer!
    }


    func mapView(_ mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView {
        var pinView: MKAnnotationView? = nil
        let defaultPinID: String = "com.invasivecode.pin"
        pinView = (mapView.dequeueReusableAnnotationView(withIdentifier: defaultPinID))
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: defaultPinID)
        }
        
        if annotation.coordinate.latitude != LAT1 &&  annotation.coordinate.latitude != LAT2{
            pinView?.canShowCallout = false
            let img = UIImage(named: "DistanceBackground")
            pinView?.image = ViewController.drawText(distanceBetweenLocations(), in: img!, at:
                CGPoint(x: 13, y: (img?.size.height)!/2 - 10))
        } else {
            pinView?.canShowCallout = true
            pinView?.image = UIImage(named: "Hole")
        }
        return pinView!
    }

    func createAndAddAnnotation(forCoordinate coordinate: CLLocationCoordinate2D) {
        let geoCoder = CLGeocoder()
        let annotationPoint = MKPointAnnotation()
        annotationPoint.coordinate = coordinate
        if(centerOfLine().latitude == coordinate.latitude && centerOfLine().longitude ==
            coordinate.longitude) {
            annotationPoint.title = "Place 1 - Place 2"
            annotationPoint.subtitle = distanceBetweenLocations()
        } else {
            geoCoder.reverseGeocodeLocation(CLLocation.init(latitude: coordinate.latitude,
                                                            longitude: coordinate.longitude),
                                            completionHandler: { (placeMarks, error) in

                                                if coordinate.latitude == self.LAT1 {
                                                    annotationPoint.title = "Place 1"
                                                } else {
                                                    annotationPoint.title = "Place 2"
                                                }
                                                if placeMarks?.count == 0 {
                                                    annotationPoint.subtitle = "Unknown place"
                                                } else {
                                                    let placemark:CLPlacemark = placeMarks![0]
                                                    annotationPoint.subtitle = placemark.subLocality

                                                }
            })
        }
        mapView.addAnnotation(annotationPoint)
        annotationPoint.coordinate = coordinate
    }

    func distanceBetweenLocations() -> String {
        let newLocation = CLLocation(latitude: LAT1, longitude: LON1)
        let oldLocation = CLLocation(latitude: LAT2, longitude: LON2)
        let fDistance: CLLocationDistance = newLocation.distance(from: oldLocation)
        return fDistance < 1000 ? String(format: "%.2f m", fDistance) : String(format: "%.2f km",
                                                                               fDistance / 1000)
    }

    func centerOfLine() -> CLLocationCoordinate2D {
        let lon1: Double = LON1 * .pi / 180
        let lon2: Double = LON2 * .pi / 180
        let lat1: Double = LAT1 * .pi / 180
        let lat2: Double = LAT2 * .pi / 180
        let dLon: Double = lon2 - lon1
        let x: Double = cos(lat2) * cos(dLon)
        let y: Double = cos(lat2) * sin(dLon)
        let lat3: Double = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + x) * (cos(lat1) + x) + y
            * y))
        let lon3: Double = lon1 + atan2(y, cos(lat1) + x)
        var center = CLLocationCoordinate2D()
        center.latitude = lat3 * 180 / .pi
        center.longitude = lon3 * 180 / .pi
        return center
    }

    class func drawText(_ text: String, in image: UIImage, at point: CGPoint) -> UIImage {
        let font = UIFont.boldSystemFont(ofSize: 12)
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let rect = CGRect(x: point.x, y: point.y, width: image.size.width, height: image.size.height)
        (text as NSString).draw(in: rect, withAttributes:
            [NSFontAttributeName : font, NSForegroundColorAttributeName: UIColor.white])
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

