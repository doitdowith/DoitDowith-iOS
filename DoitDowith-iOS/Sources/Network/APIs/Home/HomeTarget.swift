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
  case getCertificatePostList(CertificateBoardRequest)
  case getVoteMemberList(VoteMemberListRequest)
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
    case .getCertificatePostList: return .get
    case .getVoteMemberList: return .get
    }
  }
  
  var path: String {
    switch self {
    case .getDoingCards(let request): return "/doing\(request.id)"
    case .getFriendList(let request): return "/friends\(request.id)"
    case .kakao: return "/oauth2/authorization/kakao"
    case .getCertificatePostList(let request): return "/board\(request.id)"
    case .getVoteMemberList(let request): return "/board/vote\(request.id)"
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case .getDoingCards(let request): return .body(request)
    case .getFriendList(let request): return .body(request)
    case .kakao(let request): return .body(request)
    case .getCertificatePostList(let request): return .body(request)
    case .getVoteMemberList(let request): return .body(request)
    }
  }
}
