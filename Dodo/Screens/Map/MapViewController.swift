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

final class MapViewController: UIViewController {
    private var bottomConstraint: NSLayoutConstraint?
    private var originalConstant: CGFloat = 0

    private let locationService: ILocationService
    private let geocodeService: IGeocodeService
    private let addressStorage: IAdressStorage
    private let addressPanelView = AddressPanelView()

    private var address: Address?

    init(locationService: ILocationService, geocodeService: IGeocodeService, addressStorage: IAdressStorage) {
        self.locationService = locationService
        self.geocodeService = geocodeService
        self.addressStorage = addressStorage

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var pinImageView: UIImageView = {
        var imageView =  UIImageView()
        imageView.image = UIImage(named: "pin")
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        return imageView
    }()
    
    private let closeButton: UIButton = {
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
    
    private lazy var mapView: MKMapView = {
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
    }
}

//MARK: Event Handler
extension MapViewController {
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
}

//MARK: Navigation Logic
extension MapViewController {
    @objc func navigateToAddressScreen() {

        let addressController = AddressListViewController()
        if let presentationController = addressController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        present(addressController, animated: true)
    }

    func navigateToAddAddress() {
        let addController = AddressAddViewController()
        present(addController, animated: true)
    }
}


//MARK: Observe Logic
extension MapViewController {
    func observe() {
        addressPanelView.onSaveButtonTapped = { [weak self] in
            guard let self else { return }
            guard let address = self.address else { return }
            self.addressStorage.append(address)
        }
        
        addressPanelView.onAddressChanged = { [weak self] addressText in
            guard let self else { return }
            self.showAddressOnMap(addressText)
        }

        addressPanelView.onAddressButtonTapped = { [weak self] in
            guard let self else { return }
            self.navigateToAddAddress()
        }
    }
}

//MARK: Display Logic
extension MapViewController {
    func showLocationOnMap(_ location: CLLocation) {
        let regionRadius: CLLocationDistance = 500.0
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
}

//MARK: Business Logic
extension MapViewController {
    func fetchAddressFromLocation(_ location: CLLocation, completion: @escaping (String) -> (Void)) {
        self.geocodeService.fetchAddressFromLocation(location) { [weak self] addressText in
            guard let self else { return }
            completion(addressText)
            
            self.geocodeService.fetchAddressFromLocation(location) { [weak self] address in
                print(address)
                self?.address = address
            }
        }
    }
    
    func showAddressOnMap(_ addressText: String) {
        geocodeService.fetchLocationFromAddress(addressText) { [weak self] location in
            guard let self else { return }
            self.showLocationOnMap(location)
        }
    }
    
    func showCurrentLocationOnMap() {
        locationService.fetchCurrentLocation { [weak self] location in
            guard let self else { return }

            showLocationOnMap(location)
            
            fetchAddressFromLocation(location) { [weak self] addressText in
                self?.addressPanelView.update(addressText: addressText)
            }
        }
    }
}

//MARK: Map Delegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        fetchAddressFromLocation(location) { [weak self] addressText in
            self?.addressPanelView.update(addressText: addressText)
        }
    }
    
//    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//        let center = mapView.centerCoordinate
//    }
}

//MARK: Layout
extension MapViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
        view.addSubview(pinImageView)
        view.addSubview(addressPanelView)
        view.addSubview(closeButton)
    }
    
    private func setupConstraints() {
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
