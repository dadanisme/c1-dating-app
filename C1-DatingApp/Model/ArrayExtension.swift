//
//  ArrayExtension.swift
//  C1-DatingApp
//
//  Created by Ramdan on 21/04/25.
//

import Foundation

extension Array {
    func asyncCompactMap<T>(_ transform: (Element) async throws -> T?) async rethrows -> [T] {
        var results: [T] = []
        for element in self {
            if let value = try await transform(element) {
                results.append(value)
            }
        }
        return results
    }
}
