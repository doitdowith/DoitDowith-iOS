//
//  HomeAPI.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/12.
//

import Foundation

import Alamofire
import RxCocoa
import RxSwift

class HomeAPI {
  static let shared = HomeAPI()
  
  private init() { }
  
  func getDoingCard(request: CardRequest) -> Single<[Card]> {
    return Single.create { single in
      AF.request(HomeTarget.getDoingCards(request))
        .responseDecodable { (response: AFDataResponse<CardResponse>) in
          switch response.result {
          case .success(let response):
            single(.success(response.toDomain))
          case .failure(let error):
            single(.failure(error))
          }
        }
      return Disposables.create()
    }
  }
  
  func getFriendList(request: FriendRequest) -> Single<[Friend]> {
    return Single.create { single in
      AF.request(HomeTarget.getFriendList(request))
        .responseDecodable { (response: AFDataResponse<FriendResponse>) in
          switch response.result {
          case .success(let response):
            single(.success(response.toDomain))
          case .failure(let error):
            single(.failure(error))
          }
        }
      return Disposables.create()
    }
  }
  
  func getCertificatePostList(request: CertificateBoardRequest) -> Single<[CertificationPost]> {
    return Single.create { single in
      AF.request(HomeTarget.getCertificatePostList(request))
        .responseDecodable { (response: AFDataResponse<CertificateBoardResponse>) in
          switch response.result {
          case .success(let response):
            single(.success(response.toDomain))
          case .failure(let error):
            single(.failure(error))
          }
        }
      return Disposables.create()
    }
  }
  
  func getVoteMemberList(request: VoteMemberListRequest) -> Single<[VoteMember]> {
    return Single.create { single in
      AF.request(HomeTarget.getVoteMemberList(request))
        .responseDecodable { (response: AFDataResponse<VoteMemberListResponse>) in
          switch response.result {
          case .success(let response):
            single(.success(response.toDomain))
          case .failure(let error):
            single(.failure(error))
          }
        }
      return Disposables.create()
    }
  }
  
  func postChatRoom(request: CreateRoomRequest) {
    AF.request(HomeTarget.postChatRoom(request))
      .responseDecodable { (response: AFDataResponse<MissionRoomResponse>) in
        switch response.result {
        case .success(let response):
          print(response)
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
  }
  
  func getMockChat() -> Single<[Card]> {
    return Single.create { single in
      guard let path = Bundle.main.path(forResource: "homeMock", ofType: "json"),
            let jsonString = try? String(contentsOfFile: path),
            let data = jsonString.data(using: .utf8),
            let result = try? JSONDecoder().decode([Card].self, from: data) else {
        single(.failure(ErrorType.Error))
        return Disposables.create()
      }
      single(.success(result))
      return Disposables.create()
    }
  }
  
  func saveMockChat(card: Card) {
    guard let path = Bundle.main.path(forResource: "homeMock", ofType: "json"),
          let jsonString = try? String(contentsOfFile: path),
          let data = jsonString.data(using: .utf8),
          var result = try? JSONDecoder().decode([Card].self, from: data) else {
      return
    }
    result.append(card)
    print(result)
    
    let jsonEncoder = JSONEncoder()
    guard let jsonData = try? jsonEncoder.encode(result),
          let jsonString = String(data: jsonData, encoding: .utf8) else { return }
    
    if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first {
      let pathWithFilename = documentDirectory.appendingPathComponent("mock.json")
      print(pathWithFilename)
      do {
        try jsonString.write(to: pathWithFilename,
                             atomically: true,
                             encoding: .utf8)
      } catch {
        // Handle error
      }
    }
  }
}

extension JSONSerialization {
    static func loadJSON(withFilename filename: String) throws -> Any? {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves])
            return jsonObject
        }
        return nil
    }
    
    static func save(jsonObject: Any, toFilename filename: String) throws -> Bool {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            try data.write(to: fileURL, options: [.atomicWrite])
            return true
        }
        
        return false
    }
}
