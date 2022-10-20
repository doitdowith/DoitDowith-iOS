//
//  HomeService.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/03.
//

import Foundation

import RxSwift
import Alamofire

// mock 데이터 가져오기위해 만든 간단한 api
enum HomeErrorType: Error {
  case pathError
  case decodeError
}
protocol HomeServiceProtocol {
  func fetchCardList() -> Observable<[Card]>
}
struct HomeService: HomeServiceProtocol {
  func fetchCardList() -> Observable<[Card]> {
    return Observable.create { emitter in
      guard let path = Bundle.main.path(forResource: "homeMock", ofType: "json") else {
        emitter.onError(HomeErrorType.pathError)
        return Disposables.create()
      }
      guard let jsonString = try? String(contentsOfFile: path) else {
        emitter.onError(HomeErrorType.decodeError)
        return Disposables.create()
      }
      let data = jsonString.data(using: .utf8)
      guard let data = data, let result = try? JSONDecoder().decode([Card].self, from: data) else {
        emitter.onCompleted()
        return Disposables.create()
      }
      emitter.onNext(result)
      emitter.onCompleted()
      return Disposables.create()
    }
  }
}
