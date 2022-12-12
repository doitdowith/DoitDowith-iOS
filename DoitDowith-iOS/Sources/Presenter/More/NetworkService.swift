//
//  NetworkService.swift
//  DoitDowith-iOS
//
//  Created by 이예림 on 2022/12/12.
//

import Foundation
import Alamofire

struct RequestModel<T: Codable> {
    let url: String
    let method: HTTPMethod
    let parameters: [String: Any]?
    let model: T.Type
    let header: [String: String]?
}

struct ResponseModel<T: Codable> {
    let data: T?
    let error: Error?
}

class NetworkLayer {
    static let shared = NetworkLayer()

    func request<T: Codable>(model: RequestModel<T>, completion: @escaping (ResponseModel<T>) -> Void) {
        guard let header = model.header else { return }
        AF.request(model.url, method: model.method, parameters: model.parameters, headers: HTTPHeaders(header)).responseData { response in
            do {
                let data = try JSONDecoder().decode(model.model, from: response.data!)
                completion(ResponseModel(data: data, error: response.error))
            } catch {
                completion(ResponseModel(data: nil, error: error))
            }
        }
    }
}
