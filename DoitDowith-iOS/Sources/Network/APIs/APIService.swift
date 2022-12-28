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
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
             print(json)
        }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
      }
  }
  func upload(with model: CertificateRequest, completion: @escaping ((Bool) -> Void)) {
    var headers: [String: String] = ["Content-Type": "multipart/form-data"]
    if let token = UserDefaults.standard.string(forKey: "token") {
      headers.updateValue("Bearer \(token)", forKey: "Authorization")
    }
    
    AF.upload(multipartFormData: { multipartFormData in
      multipartFormData.append(Data(model.message.utf8), withName: "contents")
      multipartFormData.append(Data(model.roomId.utf8), withName: "roomId")
      multipartFormData.append(model.image, withName: "file", fileName: "\(model.image).png", mimeType: "image/png")},
              to: URL(string: "http://117.17.198.38:8080/api/v1/chats/certification")!,
              headers: HTTPHeaders(headers))
    .responseJSON { response in
      print(response.response)
      guard let statusCode = response.response?.statusCode else { return }
      if statusCode >= 200 && statusCode < 300 {
        print("success")
        completion(true)
      } else {
        completion(false)
      }
    }
  }
}
