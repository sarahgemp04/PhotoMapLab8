//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit


class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var pickedImage: UIImage!
    @IBOutlet weak var cameraImgView: UIImageView!
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var selectedLocation: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location of San Francisco
        let mapCenter = CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667)
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: mapCenter, span: mapSpan)
        
        //Set map view location to region (SF)
        mapView.setRegion(region, animated: false)
        
        //Set camera imgae
        cameraImgView.image = #imageLiteral(resourceName: "camera")
        
        //Setup imagepicker controller
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        //If can atke photos set to camera, else set to photo library
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            print("Camera is gucci!!")
            imagePicker.sourceType = .camera
        } else {
            print("Camera ain't available")
            imagePicker.sourceType = .photoLibrary
        }
        
    }
    
    //Action function for camera image view. Loads the imagePicker view Controller to select an image.
    @IBAction func loadImage(_ sender: AnyObject) {
        
        print("loadImageCalled")
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let original = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //Set instance var pickedImage.
        self.pickedImage = original
        
        dismiss(animated: true) { 
            self.performSegue(withIdentifier: "tagSegue", sender: nil)
        }
    }
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        
        addPin(latitude: latitude, longitude: longitude)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        // Add the image you stored from the image picker
        imageView.image = pickedImage
        
        return annotationView
    }
    
    func addPin(latitude: NSNumber, longitude: NSNumber) {
        let annotation = MKPointAnnotation()
        let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        annotation.coordinate = locationCoordinate
        annotation.title = String(describing: latitude)
        mapView.addAnnotation(annotation)
    }
    
    //Override prepareForSegue function to set delegate of locationsVIewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let locationsViewController = segue.destination as! LocationsViewController
        locationsViewController.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
       /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
