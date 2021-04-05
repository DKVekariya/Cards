//
//  User.swift
//  Cards
//
//  Created by Divyesh Vekariya on 04/04/21.
//

import Foundation

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
extension User: Identifiable {
    
}

class Api {
    func getUsers(complitionBlock: @escaping ([User]) -> ()) {
       let url = NSURL(string:"http://jsonplaceholder.typicode.com/users")
        guard let requestUrl = url else { return }
        var request = URLRequest(url: requestUrl as URL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    print(error)
                }
            } else {
                do {
                    let users = try JSONDecoder().decode([User].self, from: data!)
                    DispatchQueue.main.async {
                        complitionBlock(users)
                    }
                } catch let error {
                    print("JSON Error\(error)")
                }
            }
        }
        task.resume()
    }
    
    enum errors: Error{
        case connectionError
        case decodingError(error:Error?)
        case underlyingError(error:Error?)
    }
    
    
}

