//
//  ResponseType.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/17.
//

import Foundation
import Alamofire

protocol ResponseType: Decodable {
    var statusCode: Int { get }
    var data: Data? { get }

    func decode<T: Decodable>(type: T.Type) throws -> T
}

extension ResponseType {
  func decode<T>(type: T.Type) throws -> T where T: Decodable {
    let decoder = JSONDecoder()
    return try decoder.decode(type, from: data!)
  }
}
