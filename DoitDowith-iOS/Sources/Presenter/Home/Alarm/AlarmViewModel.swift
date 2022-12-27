//
//  AlarmViewModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/27.
//

import Foundation

import RxCocoa
import RxRelay
import RxSwift

protocol AlarmViewModelInput {
  var fetchAlarms: PublishRelay<Void> { get }
}
protocol AlarmViewModelOutput {
  var alarms: Driver<[Alarm]> { get }
}

protocol AlarmViewModelType: AlarmViewModelInput, AlarmViewModelOutput {
  var input: AlarmViewModelInput { get }
  var output: AlarmViewModelOutput { get }
}

final class AlarmViewModel: AlarmViewModelType,
                            AlarmViewModelInput,
                            AlarmViewModelOutput {
  var input: AlarmViewModelInput { return self }
  var output: AlarmViewModelOutput { return self }
  let disposeBag: DisposeBag = DisposeBag()
  
  // Input
  let fetchAlarms: PublishRelay<Void>
  
  // Output
  let alarms: Driver<[Alarm]>
  
  init() {
    let fetching = PublishRelay<Void>()
    let activating = BehaviorRelay<Bool>(value: false)
    let currentAlarm = PublishRelay<[Alarm]>()
    
    fetching
      .do(onNext: { _ in activating.accept(true) })
//      .flatMap { _ -> Observable<[Alarm]> in
//        let request = RequestType(endpoint: "alarm",
//                                  method: .get)
//        return APIService.shared.request(request: request)
//          .map { (response: AlarmResponse) -> [Alarm] in
//             return response.toDomain
//          }
//      }
        .map { _ -> [Alarm] in
          return [Alarm(title: "눈알가글님이 [특별한 한 끼 만들어 먹기] 미션에 초대했어요!",
                        date: "2021.08.13.(금)"),
                  Alarm(title: "호러오이 님이 친구 추가를 했어요!",
                        date: "2021.08.13.(금)")]
        }
      .do(onNext: { _ in activating.accept(false) })
      .bind(onNext: { alarm in currentAlarm.accept(alarm) })
      .disposed(by: disposeBag)
    
    self.fetchAlarms = fetching
    self.alarms = currentAlarm.asDriver(onErrorJustReturn: [])
  }
}
