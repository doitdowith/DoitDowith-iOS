//
//  HomeTarget.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/12.
//

import Foundation

import Alamofire

enum HomeTarget {
  case getDoingCards(CardRequest)
  case getFriendList(FriendRequest)
  case kakao(CardRequest)
}

extension HomeTarget: TargetType {
  var baseURL: String {
    return "117.17.198.38:8080"
  }
  
  var method: HTTPMethod {
    switch self {
    case .getDoingCards: return .get
    case .getFriendList: return .get
    case .kakao: return .get
    }
  }
  
  var path: String {
    switch self {
    case .getDoingCards(let request): return "/doing\(request.id)"
    case .getFriendList(let request): return "/friends\(request.id)"
    case .kakao: return "/oauth2/authorization/kakao"
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case .getDoingCards(let request): return .body(request)
    case .getFriendList(let request): return .body(request)
    case .kakao(let request): return .body(request)
    }
  }
}
