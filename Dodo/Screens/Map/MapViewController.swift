//
//  MapViewController.swift
//  Dodo
//
//  Created by Rishat Zakirov on 29.10.2024.
//

import UIKit
import MapKit
import CoreLocation
import SnapKit

class MapViewController: UIViewController {
    var bottomConstraint: NSLayoutConstraint?
    var originalConstant: CGFloat = 0
    
    var locationService = LocationService()
    var geocodeService = GeocodeService()
    let addressStorage = AddressStorage()
    let addressPanelView = AddressPanelView()
    
    var address: Address?
    
    var pinImageView: UIImageView = {
        var imageView =  UIImageView()
        imageView.image = UIImage(named: "pin")
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        return imageView
    }()
    

    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: configuration), for: .normal)
        button.tintColor = .black
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        
        button.addTarget(nil, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var mapView: MKMapView = {
        var mapView = MKMapView()
        mapView.delegate = self
        
        return mapView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        showCurrentLocationOnMap()
        observe()
        transitToAddAddress()
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func navigateToAddressScreen() {
        
        let addressController = AddressListViewController()
        if let presentationController = addressController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        
        present(addressController, animated: true)
    }
    


}

//MARK: Observe Logic
extension MapViewController {
    func observe() {
        
        
        addressPanelView.onSaveButtonTapped = {
            
            guard let address = self.address else { return }
            print("SaveButton tapped ->", address)
            self.addressStorage.append(address)
            
        }
        
        addressPanelView.onAddressChanged = { [weak self] addressText in
            guard let self else {return}
            self.showAddressOnMap(addressText)
            
        }
    }
}

//MARK: Business Logic
extension MapViewController {
    func fetchAddressFromLocation(_ location: CLLocation, completion: @escaping (String) -> (Void)) {
        
       
        
        self.geocodeService.fetchAddressFromLocation(location) { addressText in
            completion(addressText)
            
            self.geocodeService.fetchAddressFromLocation(location) { address in
                print(address)
                self.address = address
            }
        }
        
        
    }
    
    func showAddressOnMap(_ addressText: String) {
        geocodeService.fetchLocationFromAddress(addressText) { [weak self] location in
            guard let self else {return}
            self.showLocationOnMap(location)
        }
    }
    
    func showCurrentLocationOnMap() {
        locationService.fetchCurrentLocation { [weak self] location in
            guard let self else {return}
            
            showLocationOnMap(location)
            
            fetchAddressFromLocation(location) { [weak self] addressText in
                self?.addressPanelView.update(addressText: addressText)
            }
            
        
        }
    }
    
    func showLocationOnMap(_ location: CLLocation) {
        let regionRadius: CLLocationDistance = 500.0
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    func transitToAddAddress() {
        self.addressPanelView.onAddressButtonTapped = {
            self.navigateToAddAddress()
        }
    }
    
    func navigateToAddAddress() {
        let addController = AddressAddViewController()
        present(addController, animated: true)
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        print("did change ->", center)
        
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        fetchAddressFromLocation(location) { addressText in
            self.addressPanelView.update(addressText: addressText)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        print("will change ->", center)
    }
}



//MARK: LAYOUT
extension MapViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
        view.addSubview(pinImageView)
        view.addSubview(addressPanelView)
        view.addSubview(closeButton)

    }
    
    func setupConstraints() {
        addressPanelView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        mapView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(addressPanelView.snp.top)
        }
        
        pinImageView.snp.makeConstraints { make in
            make.center.equalTo(mapView)
        }
        
        closeButton.snp.makeConstraints { make in
            make.left.top.equalTo(view.safeAreaLayoutGuide).offset(5)
        }
      
    }
}
