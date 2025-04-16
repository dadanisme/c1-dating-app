//
//  NavigationManager.swift
//  C1-DatingApp
//
//  Created by Ramdan on 15/04/25.
//

import Foundation

class NavigationManager<T>: ObservableObject {
    @Published var path: [T] = []
}
