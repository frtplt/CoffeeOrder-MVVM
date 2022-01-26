//
//  AddCoffeeOrderViewModel.swift
//  Coffee
//
//  Created by Firat on 24.01.2022.
//

import Foundation

struct AddCoffeeOrderViewModel {
    
    var name: String?
    var email: String?
    
    var types: [String] {
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var selectedType: String?
    var selectedSize: String?
    
    var sizes: [String] {
        return CoffeeSize.allCases.map { $0.rawValue.capitalized }
    }
    
}
