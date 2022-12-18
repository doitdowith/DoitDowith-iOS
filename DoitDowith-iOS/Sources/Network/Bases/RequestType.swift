//
//  RequestType.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/17.
//

import Foundation
import Alamofire

protocol RequestType: Encodable {
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }

    func asURLRequest() throws -> URLRequest
}

extension RequestType {
  var headers: HTTPHeaders? {
    return HTTPHeaders(["Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiI0YzA3YmUyOS1lZTQzLTQyOGYtYTk1My1iNjM1ODFmZjJmMDgiLCJleHAiOjE2NzA5MjU2NDV9.H5dUy0NvtC1p4ieeHhxokJkbo0SgLa4nzRpqhoR6J1yD35pxxK1hefm_2FTXzXLMp87I0z2BpS-FjrLq97w7Cg"])
  }
  var endpoint: String {
      return "\(APIService.shared.baseURL)\(self.endpoint)"
  }
  
  func asURLRequest() throws -> URLRequest {
      let url = try endpoint.asURL()
      var urlRequest = URLRequest(url: url)
      urlRequest.httpMethod = method.rawValue
      if let headers = headers {
        urlRequest.allHTTPHeaderFields = headers.dictionary
      }
      
      return try encoding.encode(urlRequest, with: parameters)
  }
}
