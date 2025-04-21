//
//  FirestoreModel.swift
//  C1-DatingApp
//
//  Created by Ramdan on 17/04/25.
//

import FirebaseFirestore
import Foundation

let db = Firestore.firestore()


func formatTimestamp(_ timestamp: Timestamp?) -> String {

    if let timestamp = timestamp {
        let date = timestamp.dateValue()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US") // or "id_ID" if you want in Indonesian
        formatter.dateFormat = "EEE, dd MMM yyyy, HH.mm"
        
        // Convert to WITA (UTC+8)
        formatter.timeZone = TimeZone(identifier: "Asia/Makassar")
        
        let formattedDate = formatter.string(from: date)
        return "\(formattedDate) WITA"
    } else {
        return "Invalid Date"
    }
}

func formatToRupiah(_ amountString: String) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencySymbol = "Rp"
    formatter.locale = Locale(identifier: "id_ID")
    formatter.maximumFractionDigits = 0

    if let amount = Int(amountString) {
        return formatter.string(from: NSNumber(value: amount)) ?? "Rp0"
    } else {
        return "Rp0"
    }
}
