//
//  SearchModel.swift
//  C1-DatingApp
//
//  Created by Ramdan on 12/04/25.
//

struct Place: Identifiable {
    let id = UUID()
    var name: String
    var subtitle: String
    var distance: CLLocationDistance? = nil
    var latitude: Double
    var longitude: Double
}

import MapKit

func distanceBetween(_ from: MKMapItem, _ to: MKMapItem) -> CLLocationDistance {
    let loc1 = CLLocation(latitude: from.placemark.coordinate.latitude,
                          longitude: from.placemark.coordinate.longitude)
    let loc2 = CLLocation(latitude: to.placemark.coordinate.latitude,
                          longitude: to.placemark.coordinate.longitude)
    
    return loc1.distance(from: loc2) // returns distance in meters
}

func getPlaceFromCoordinates(latitude: Double, longitude: Double, completion: @escaping (Place?) -> Void) {
    let geocoder = CLGeocoder()
    let location = CLLocation(latitude: latitude, longitude: longitude)
    
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
        if let error = error {
            print("Reverse geocoding failed: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        if let placemark = placemarks?.first {
            // You can customize the output based on what you want
            
            let place = Place(name: placemark.name ?? "", subtitle: placemark.description, latitude: latitude, longitude: longitude)
            
            completion(place)
        } else {
            completion(nil)
        }
    }
}

class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var results: [Place] = []
    @Published var errorMessage: String? = nil
    private var searchTask: Task<Void, Never>?
    private var debounceTask: Timer?
    
    
    func search(from userLocation: CLLocation?) {
        debounceTask?.invalidate() // Cancel the previous debounce task
        
        // Set up a new debounce task to delay the search by 0.5 seconds
        debounceTask = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.performSearch(userLocation)
        }
    }
    
    private func performSearch(_ userLocation: CLLocation?) {
        searchTask?.cancel() // Cancel any ongoing search task
        print(query)
        searchTask = Task {
            guard !query.isEmpty else {
                await MainActor.run { results = [] }
                return
            }
            
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
             
            if let userLocation = userLocation {
                let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
                request.region = region
            }
            
            let search = MKLocalSearch(request: request)
            
            do {
                let response = try await search.start()
                 let newResults = response.mapItems.map { result in
                    let distance: CLLocationDistance? = {
                        guard let userLocation = userLocation else {
                            return nil
                        }
                        
                        let placeLocation = CLLocation(latitude: result.placemark.coordinate.latitude, longitude: result.placemark.coordinate.longitude)
                        
                        return placeLocation.distance(from: userLocation)
                    }()
                    
                    
                    return Place(
                        name: result.name ?? "Unknown",
                        subtitle: result.placemark.title ?? "",
                        distance: distance,
                        latitude: result.placemark.coordinate.latitude,
                        longitude: result.placemark.coordinate.longitude
                    )
                    
                }
                
                await MainActor.run {
                    self.results = newResults
                }
            } catch {
                print("Search failed: \(error.localizedDescription)")
                await MainActor.run {
                    self.errorMessage = "Search failed: \(error.localizedDescription)"
                }
            }
        }
    }
}
