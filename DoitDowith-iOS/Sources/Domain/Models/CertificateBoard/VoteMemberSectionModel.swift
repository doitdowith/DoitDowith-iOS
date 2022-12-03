//
//  VoteMemberSectionModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/02.
//

import Foundation
import RxDataSources

enum VoteMemberSectionModel {
    case firstSection(items: [VoteMember])
    case secondSection(items: [VoteMember])
    case thirdSection(items: [VoteMember])
}

extension VoteMemberSectionModel: SectionModelType {
    typealias Item = VoteMember

    var items: [VoteMember] {
        switch self {
        case .firstSection(let items):
            return items
        case .secondSection(let items):
            return items
        case .thirdSection(let items):
            return items
        }
    }

    init(original: Self, items: [Self.Item]) {
        self = original
    }
}
