//
//  MapVC.swift
//  SignUpInWithDelegation&Map
//
//  Created by KhaleD HuSsien on 19/10/2021.
//

import UIKit
import MapKit

protocol setLocationDelegation {
    func Address(message: String)
}

class MapVC: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var addressLable: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var mapShow: MKMapView!
    @IBOutlet weak var goBtn: UIButton!
    
    //MARK: Variable
    var delegate: setLocationDelegation?
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000000
    var previousLoction: CLLocation?
    var directionArray: [MKDirections] = []
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapShow.delegate = self
        checkLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        confirmBtn.layer.cornerRadius = 7.0
        goBtn.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        goBtn.layer.cornerRadius = 0.5 * goBtn.bounds.size.width
        goBtn.clipsToBounds = true
    }
    
    //MARK: Functions
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checkLocationAuthorization()
        }else{
            print("pls check ur location services")
        }
    }
    
    func setUpLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case  .authorizedWhenInUse:
            startTrackingUserLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .denied:
            showAlert(title: "", message: "Please open your location services to get your address location")
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    func startTrackingUserLocation(){
        mapShow.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLoction = getCenterLocation(for: mapShow)
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapShow.setRegion(region, animated: true)
        }
    }
    
    func getCenterLocation(for MapShow: MKMapView) -> CLLocation{
        let latitude = MapShow.centerCoordinate.latitude
        let longitude = MapShow.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func getDirections(){
        guard let location = locationManager.location?.coordinate else{ return }
        let request = createDirectionsRequest(from: location)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        directions.calculate { [unowned self] (response , error) in
            guard let response = response else {return}
            for route in response.routes {
                self.mapShow.addOverlay(route.polyline)
                self.mapShow.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D)-> MKDirections.Request{
        let destinationCoordinate       =  getCenterLocation(for: mapShow).coordinate
        let startingLocation            =  MKPlacemark(coordinate: coordinate)
        let destination                 =  MKPlacemark(coordinate: destinationCoordinate)
        let request                     =  MKDirections.Request()
        request.source                  =  MKMapItem(placemark: startingLocation)
        request.destination            =  MKMapItem(placemark: destination)
        request.transportType           =  .automobile
        request.requestsAlternateRoutes  =  true
        return request
    }
    
    func resetMapView(withNew direction: MKDirections){
        mapShow.removeOverlays(mapShow.overlays)
        directionArray.append(direction)
        let _ = directionArray.map {$0.cancel()}
        
    }
    
    //MARK: Actions
    @IBAction func ConfirmBtnTapped(_ sender: UIButton) {
        let location = addressLable.text ?? ""
        delegate?.Address(message: location)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goDirectionsBtnTapped(_ sender: UIButton) {
        getDirections()
    }
}
//MARK: Extensions
extension MapVC: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

extension MapVC: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapShow)
        let geoCoder = CLGeocoder()
        
        guard let previousLoction = self.previousLoction else{return}
        guard center.distance(from: previousLoction ) > 50 else {return}
        self.previousLoction = center
        geoCoder.cancelGeocode()
        geoCoder.reverseGeocodeLocation(center){ (placemarks , error) in
            if let error = error {
                self.showAlert(title: "Sorry", message: "can't find your location \(error.localizedDescription)")
            }
            guard let placemark = placemarks?.first else{return}
            let streetnumber = placemark.subThoroughfare ?? ""
            let streetname = placemark.thoroughfare ?? ""
            let countryname = placemark.country ?? ""
            let cityname = placemark.locality ?? ""
            self.addressLable.text = "\(countryname) \(cityname) \(streetnumber) \(streetname)"
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = UIColor(named: "ColorApp")
        return renderer
    }
}
