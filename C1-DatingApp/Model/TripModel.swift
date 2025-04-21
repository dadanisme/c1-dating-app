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

enum TravelType: String, Codable {
    case passenger = "Passenger"
    case driver = "Driver"
}

enum TravelMode: String, Codable {
    case fourWheels = "Four Wheels"
    case twoWheels = "Two Wheels"
}

class NearbyTrip: ObservableObject {
    @Published var trips: [Trip] = []
    @Published var isLoading: Bool = false
    private var fetchTask: Task<Void, Never>?
    
    @MainActor
    func fetchData (userLocation: CLLocation) async {
        if(self.isLoading) {
            return
        }
        self.isLoading = true
        

        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let radiusInM: Double = 10 * 1000
        let queryBounds = GFUtils.queryBounds(forLocation: center, withRadius: radiusInM)
        let queries = queryBounds.map { bound -> Query in
            return db.collection("trips")
                .order(by: "from.geoHash")
                .whereField("type", isEqualTo: TravelType.driver.rawValue)
                .start(at: [bound.startValue])
                .end(at: [bound.endValue])
        }
        
        do {
            let matchingDocs = try await withThrowingTaskGroup(of: [QueryDocumentSnapshot].self) { group -> [QueryDocumentSnapshot] in
                for query in queries {
                    group.addTask {
                        try await fetchMatchingDocs(from: query, center: center, radiusInMeters: radiusInM)
                    }
                }
                var matchingDocs = [QueryDocumentSnapshot]()
                for try await documents in group {
                    matchingDocs.append(contentsOf: documents)
                }
                return matchingDocs
            }
            
            let newTrips = await matchingDocs.asyncCompactMap { document -> Trip? in
                do {
                    var trip = try document.data(as: Trip.self)
                    let userId = trip.createdBy ?? ""
                    
                    let docRef = db.collection("users").document(userId)
                    let userSnapshot = try await docRef.getDocument()
                    
                    // Example of assigning extra data if needed
                    let user = try userSnapshot.data(as: User.self)
                    trip.user = user // assuming you have a `user` property on Trip
                    
                    return trip
                } catch {
                    print("Error processing document: \(error)")
                    return nil
                }
            }
            
            // Make sure UI updates happen on the main thread.
            self.trips = newTrips
            self.isLoading = false
        } catch {
            print("Unable to fetch snapshot data. \(error)")
        }
        
        self.isLoading = false
        
        
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
    var createdAt: Timestamp?
    var createdBy: String?
    var user: User?
    
    mutating func injectLocation(from: Place, to: Place) {
        let fromHash = GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: from.latitude, longitude: from.longitude))
        let toHash = GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: to.latitude, longitude: to.longitude))
        
        self.from = TripLocation(latitute: from.latitude, longitude: from.longitude, geoHash: fromHash, name: from.name)
        self.to = TripLocation(latitute: to.latitude, longitude: to.longitude, geoHash: toHash, name: to.name)
    }
    
    func createTrip(_ userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let collectionRef = db.collection("trips")
            let docRef = collectionRef.document() // Generate a reference with a known ID
            
            var tripWithID = self
            tripWithID.id = docRef.documentID
            tripWithID.createdBy = userId
            tripWithID.createdAt = Timestamp.init(date: Date())
            
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
}

@Sendable func fetchMatchingDocs(
    from query: Query,
    center: CLLocationCoordinate2D,
    radiusInMeters: Double)
async throws -> [QueryDocumentSnapshot] {
    let snapshot = try await query.getDocuments()
    // Collect all the query results together into a single list
    return snapshot.documents.filter { document in
        do {
            let doc = try document.data(as: Trip.self)
            let lat = doc.from?.latitute ?? 0
            let lng = doc.from?.longitude ?? 0
            let coordinates = CLLocation(latitude: lat, longitude: lng)
            let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)
            
            // We have to filter out a few false positives due to GeoHash accuracy, but
            // most will match
            let distance = GFUtils.distance(from: centerPoint, to: coordinates)
            return distance <= radiusInMeters
        }  catch {
            return false
        }
    }
}
