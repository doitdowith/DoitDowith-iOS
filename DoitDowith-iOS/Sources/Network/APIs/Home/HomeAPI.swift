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
}

class HomeAPI: HomeAPIProtocol {
  init() { }
  
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
  
  func getCertificatePostList(request: CertificateBoardRequest) -> RxSwift.Single<[CertificationPost]> {
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
}
