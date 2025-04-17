//
//  Trip.swift
//  C1-DatingApp
//
//  Created by Ramdan on 11/04/25.
//

import Foundation
import FirebaseFirestore
import CoreLocation
import GeoFireUtils

enum TravelType: Codable {
    case passenger
    case driver
}

enum TravelMode: Codable {
    case fourWheels
    case twoWheels
}

class NearbyTripModel: Identifiable {
    var imageName: String
    var name: String
    var location: String
    var time: String
    var price: Int
    let id = UUID()
    
    init(imageName: String, name: String, location: String, time: String, price: Int) {
        self.imageName = imageName
        self.name = name
        self.location = location
        self.time = time
        self.price = price
    }
}

struct TripLocation: Codable {
    var latitute: Double
    var longitude: Double
    var geoHash: String
    var name: String
}

struct Trip: Identifiable, Codable {
    @DocumentID var id: String?
    
    var type: TravelType
    var mode: TravelMode
    var date: Date
    var description: String = ""
    var vehicleType: String = ""
    var plateNumber: String = ""
    var seats: String = "0"
    var fee: String = "0"
    var from: TripLocation?
    var to: TripLocation?
    
    mutating func injectLocation(from: Place, to: Place) {
        let fromHash = GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: from.latitude, longitude: from.longitude))
        let toHash = GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: to.latitude, longitude: to.longitude))
        
        self.from = TripLocation(latitute: from.latitude, longitude: from.longitude, geoHash: fromHash, name: from.name)
        self.to = TripLocation(latitute: to.latitude, longitude: to.longitude, geoHash: toHash, name: to.name)
    }
}

func generateDummyTrips() -> [NearbyTripModel] {
    var trips: [NearbyTripModel] = []
    for _ in 0..<10 {
        trips.append(NearbyTripModel(
            imageName: "jensen_huang_1",
            name: "Jensen Huang",
            location: "Uluwatu Temple",
            time: "Mon, 10 April 2024, 10.00 WITA",
            price: 20000
        ))
    }
    return trips
}

let dummyTrips = generateDummyTrips()

func createTrip(trip: Trip, completion: @escaping (Result<String, Error>) -> Void) {
    do {
        let collectionRef = db.collection("trips")
        let docRef = collectionRef.document() // Generate a reference with a known ID

        let tripWithID = trip
        // Optional: set the trip's ID if your Trip model has one
        // tripWithID.id = docRef.documentID

        try docRef.setData(from: tripWithID) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(docRef.documentID))
            }
        }
    } catch {
        completion(.failure(error)) // encoding error
    }
}
