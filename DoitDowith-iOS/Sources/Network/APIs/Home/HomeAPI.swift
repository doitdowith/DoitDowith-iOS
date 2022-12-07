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

protocol HomeAPIProtocol {
  func getDoingCard(request: CardRequest) -> Single<[Card]>
  func getFriendList(request: FriendRequest) -> Single<[Friend]>
  func getCertificatePostList(request: CertificateBoardRequest) -> Single<[CertificationPost]>
  func getVoteMemberList(request: VoteMemberListRequest) -> Single<[VoteMember]>
  
  func postChatRoom(request: MissionRoomRequest)
}

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
  
  func postChatRoom(request: MissionRoomRequest) {
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
}
