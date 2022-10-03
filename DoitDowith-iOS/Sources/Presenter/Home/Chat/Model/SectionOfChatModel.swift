//
//  SectionOfChatModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/02.
//

import Foundation

import RxCocoa
import RxDataSources
import RxSwift

struct SectionOfChatModel {
  var header: String
  var items: [Item]
  
  init(header: String, items: [Item]) {
    self.header = header
    self.items = items
  }
}

extension SectionOfChatModel: SectionModelType {
  typealias Item = ChatModel
  
  init(original: SectionOfChatModel, items: [ChatModel]) {
    self = original
    self.items = items
  }
}
