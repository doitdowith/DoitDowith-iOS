//
//  ChatModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/28.
//

import Foundation

enum ChatType: CaseIterable {
    case send
    case receive
}

struct ChatModel {
    let type: ChatType
    let name: String
    let message: String
    let time: Date
}
