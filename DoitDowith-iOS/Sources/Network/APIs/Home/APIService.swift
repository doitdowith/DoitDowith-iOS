//
//  NetworkLayer.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/17.
//

import Foundation

import Alamofire
import RxAlamofire
import RxCocoa
import RxSwift

class APIService: ReactiveCompatible {
  typealias ReactiveBase = APIService
  
  static let shared = APIService()
  let baseURL = "http://117.17.198.38:8080/api/v1/members"
  
  private init() { }
  func request<T: Decodable>(request: RequestType) -> Observable<T> {
    var headers = request.headers
    if let token = UserDefaults.standard.string(forKey: "token") {
      headers.updateValue("Bearer \(token)", forKey: "Authorization")
    }
    return RxAlamofire
      .request(request.method,
               "http://117.17.198.38:8080/api/v1/\(request.endpoint)",
               parameters: request.parameters,
               encoding: JSONEncoding.default,
               headers: HTTPHeaders(headers))
      .responseData()
      .observe(on: MainScheduler.instance)
      .map { (response, data) -> T in
        print(data)
        let statusCode = response.statusCode
        print(statusCode)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
      }
  }
  
//  func request<U: Decodable>(request: RequestType) -> Observable<U> {
//    return RxAlamofire
//      .request(request.method,
//               "http://117.17.198.38:8080/api/v1/members",
//               parameters: request.parameters,
//               encoding: JSONEncoding.default,
//               headers: ["Content-Type": "application/json"])
//      .responseData()
//      .observe(on: MainScheduler.instance)
//      .map({ (response, data) -> U in
//        print(data)
//        let statusCode = response.statusCode
//        print(statusCode)
//        let decoder = JSONDecoder()
//        return try decoder.decode(U.self, from: data)
//      })
//  }
}
