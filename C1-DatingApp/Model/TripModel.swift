//
//  Trip.swift
//  C1-DatingApp
//
//  Created by Ramdan on 11/04/25.
//

class NearbyTripModel: Identifiable {
    var imageName: String
    var name: String
    var location: String
    var time: String
    var price: Int
    
    init(imageName: String, name: String, location: String, time: String, price: Int) {
        self.imageName = imageName
        self.name = name
        self.location = location
        self.time = time
        self.price = price
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
