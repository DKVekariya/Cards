//
//  User.swift
//  Cards
//
//  Created by Divyesh Vekariya on 04/04/21.
//

import Foundation
import Combine


class Api {
    // MARK: - Welcome
    struct User: Codable {
        let id: Int
        let name, username, email: String
        let address: Address
        let phone: String
        var city:String {
            address.city
        }
        struct Address: Codable {
            let street: String
            let suite: String
            let city: String
        }
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case username
            case email
            case phone
            case address
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            name = try container.decode(String.self, forKey: .name)
            username = try container.decode(String.self, forKey: .username)
            email = try container.decode(String.self, forKey: .email)
            phone = try container.decode(String.self, forKey: .phone)
            address = try container.decode(Address.self, forKey: .address)
       
        }
    }
    
    func getUsers() -> AnyPublisher<[User], Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string:"http://jsonplaceholder.typicode.com/users")!)
            .tryMap({ $0.data })
            .decode(type: [User].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    enum Errors: Error{
        case connectionError
        case decodingError(error:Error?)
        case underlyingError(error:Error?)
    }
    
    
}

