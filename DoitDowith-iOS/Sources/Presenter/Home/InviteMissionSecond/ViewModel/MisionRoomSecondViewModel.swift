//
//  MisionRoomSecondViewModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/05.
//

import Foundation

import RxCocoa
import RxRelay
import RxSwift

protocol MissionRoomSecondViewModelOutput {
  var model: BehaviorRelay<[UIColor]> { get }
}

protocol MissionRoomSecondViewModelType {
  var output: MissionRoomSecondViewModelOutput { get }
}

final class MisionRoomSecondViewModel: MissionRoomSecondViewModelType,
                                       MissionRoomSecondViewModelOutput {
  var output: MissionRoomSecondViewModelOutput { return self }
  
  let model: BehaviorRelay<[UIColor]>
  
  init() {
    let colors = BehaviorRelay<[UIColor]>(value: [UIColor(red: 253/255, green: 236/255, blue: 236/255, alpha: 1),
                                                  UIColor(red: 253/255, green: 243/255, blue: 232/255, alpha: 1),
                                                  UIColor(red: 245/255, green: 247/255, blue: 229/255, alpha: 1),
                                                  UIColor(red: 229/255, green: 243/255, blue: 251/255, alpha: 1),
                                                  UIColor(red: 235/255, green: 235/255, blue: 252/255, alpha: 1),
                                                  UIColor(red: 255/255, green: 237/255, blue: 250/255, alpha: 1)])
    self.model = colors
  }
}
