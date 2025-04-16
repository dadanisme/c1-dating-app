//
//  Trip.swift
//  C1-DatingApp
//
//  Created by Ramdan on 11/04/25.
//

import Foundation

enum TravelType {
    case passenger
    case driver
}

enum TravelMode {
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

class Trip: Identifiable {
    var type: TravelType
    var mode: TravelMode
    var date: Date
    var description: String = ""
    var vehicleType: String = ""
    var plateNumber: String = ""
    var seats: Int = 0
    var fee: Int = 0
    
    init(type: TravelType, mode: TravelMode, date: Date, description: String? = nil, vehicleType: String? = nil, plateNumber: String? = nil, seats: Int? = nil, fee: Int? = nil) {
        self.type = type
        self.mode = mode
        self.date = date
        self.description = description ?? ""
        self.vehicleType = vehicleType ?? ""
        self.plateNumber = plateNumber ?? ""
        self.seats = seats ?? 0
        self.fee = fee ?? 0
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
