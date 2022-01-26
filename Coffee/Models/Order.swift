//
//  Order.swift
//  Coffee
//
//  Created by Firat on 24.01.2022.
//

import Foundation
import UIKit

enum CoffeeType: String, Codable, CaseIterable {
    
    case latte
    case mocha
    case americano
    case filtercoffee
    
}

enum CoffeeSize: String, Codable, CaseIterable {
    
    case small
    case medium
    case large
    
}

struct Order: Codable {
    
    var name: String
    var email: String
    var size: CoffeeSize
    var type: CoffeeType

}

extension Order {
    
    static var all: Resource<[Order]> = {
        
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("URL is incorrect")
    }
        return Resource<[Order]>(url: url)
    }()
    
    static func create(vm: AddCoffeeOrderViewModel) -> Resource<Order?> {
        
        let order = Order(vm)
        
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("URL is incorrect")
        }
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Encoding error")
        }
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = HTPPMethod.post
        resource.body = data
        
        return resource
    }
}

extension Order {
    
    init?(_ vm: AddCoffeeOrderViewModel){
        
        guard let name = vm.name,
        let email = vm.email,
        let size = CoffeeSize(rawValue: vm.selectedSize!.lowercased()),
        let type = CoffeeType(rawValue: vm.selectedType!.lowercased()) else {
          return nil
        }
    
    self.name = name
    self.email = email
    self.type = type
    self.size = size
    
}
}
