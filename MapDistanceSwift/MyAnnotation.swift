//
//  MyAnnotation.swift
//  MapDistanceSwift
//
//  Created by Yogesh Padekar on 5/30/17.
//  Copyright © 2017 Yogesh Padekar. All rights reserved.
//

import UIKit
import MapKit

class MyAnnotation: MKAnnotationView {
    var contentView: UIView?


    deinit {
        contentView = nil
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        autoreleasepool {
            backgroundColor = UIColor.clear
            canShowCallout = false
            centerOffset = CGPoint(x: CGFloat(0), y: CGFloat(-120))
            frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(250), height: CGFloat(220))
            let _contentView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width:
                CGFloat(frame.size.width), height: CGFloat(frame.size.height)))
            _contentView.backgroundColor = UIColor.clear
            addSubview(_contentView)
            contentView = _contentView
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
