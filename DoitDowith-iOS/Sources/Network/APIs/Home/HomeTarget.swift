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
  case getWillDoCards(CardRequest)
  case getDoneCards(CardRequest)
  case getFriendList(FriendRequest)
  case kakao(CardRequest)
  case getCertificatePostList(CertificateBoardRequest)
  case getVoteMemberList(VoteMemberListRequest)
  case postChatRoom(CreateRoomRequest)
}

extension HomeTarget: TargetType {
  var baseURL: String {
    return "117.17.198.38:8080"
  }
  
  var method: HTTPMethod {
    switch self {
    case
        .getDoingCards,
        .getWillDoCards,
        .getDoneCards,
        .getFriendList,
        .kakao,
        .getCertificatePostList,
        .getVoteMemberList: return .get
    case .postChatRoom: return .post
    }
  }
  
  var path: String {
    switch self {
    case .getDoingCards(let request): return "/doing\(request.memberId)"
    case .getWillDoCards(let request): return "/willdo\(request.memberId)"
    case .getDoneCards(let request): return "/done\(request.memberId)"
    case .getFriendList(let request): return "/friends\(request.id)"
    case .kakao: return "/oauth2/authorization/kakao"
    case .getCertificatePostList(let request): return "/board\(request.id)"
    case .getVoteMemberList(let request): return "/board/vote\(request.id)"
    case .postChatRoom: return "/room"
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case .getDoingCards(let request),
        .getWillDoCards(let request),
        .getDoneCards(let request): return .body(request)
    case .getFriendList(let request): return .body(request)
    case .kakao(let request): return .body(request)
    case .getCertificatePostList(let request): return .body(request)
    case .getVoteMemberList(let request): return .body(request)
    case .postChatRoom(let request): return .body(request)
    }
  }
}
