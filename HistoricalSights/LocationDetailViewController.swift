//
//  LocationDetailViewController.swift
//  HistoricalSights
//
//  Created by Qiwei Wang on 6/9/19.
//  Copyright © 2019 Qiwei Wang. All rights reserved.
//

import UIKit
import MapKit
import CoreData
class LocationDetailViewController: UIViewController {
    @IBOutlet weak var DetailImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    var locationDetail: Location?
    @IBOutlet weak var DtitleLabel: UILabel!
    @IBOutlet weak var DsubtitleLabel: UILabel!
    @IBOutlet weak var Ddescription: UILabel!
    @IBOutlet weak var DmapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DtitleLabel.text = locationDetail!.title
        DsubtitleLabel.text = locationDetail!.subtitle
        Ddescription.text = locationDetail!.descriptions
        addressLabel.text = locationDetail!.address
        DetailImageView?.image = loadImageData(fileName: (locationDetail?.image!)!)
        let annotation = LocationAnnotation(newTitle: DtitleLabel.text!, newSubtitle: DsubtitleLabel.text!, latitude: locationDetail!.latitude, longitude: locationDetail!.longitude, icon: locationDetail!.icon!)
        DmapView.addAnnotation(annotation)
        focusOn(annotation: annotation)
        // Do any additional setup after loading the view.
    }
    func focusOn(annotation: MKAnnotation) {
        DmapView.selectAnnotation(annotation, animated: true)
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000,
                                            longitudinalMeters: 1000)
        DmapView.setRegion(DmapView.regionThatFits(zoomRegion), animated: true)
    }
    
    func loadImageData(fileName: String) -> UIImage? {
        var image: UIImage?
        if isPurnInt(string: fileName){
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                        .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            
            if let pathComponent = url.appendingPathComponent(fileName) {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                let fileData = fileManager.contents(atPath: filePath)
                image = UIImage(data: fileData!)
            }
        }else{
            image = UIImage(named: fileName)
        }
        return image
    }
    // Cited from: https://blog.csdn.net/hengyunbin/article/details/85260760
    func isPurnInt(string: String) -> Bool {
        let scan: Scanner = Scanner(string: string)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
