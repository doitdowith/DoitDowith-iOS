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
  let baseURL = "http://117.17.198.38:8080"
  
  private init() { }
  
  func request<T: RequestType, U: ResponseType>(request: T) -> Observable<U> {
    return RxAlamofire
      .request(request.method,
               request.endpoint,
               parameters: request.parameters,
               encoding: JSONEncoding.default,
               headers: request.headers)
      .validate(statusCode: 200..<300)
      .responseData()
      .observe(on: MainScheduler.instance)
      .map({ (response, data) -> U in
        let statusCode = response.statusCode
        let decoder = JSONDecoder()
        return try decoder.decode(U.self, from: data)
      })
  }
}
