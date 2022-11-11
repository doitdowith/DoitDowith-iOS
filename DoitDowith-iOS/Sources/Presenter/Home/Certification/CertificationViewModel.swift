//
//  CertificationViewModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/03.
//

import Foundation

import RxCocoa
import RxSwift
import RxRelay
import RxDataSources

protocol CertificationViewModelInput {
  var selectedImages: PublishRelay<[UIImage]> { get }
  var completeButtonEnabled: BehaviorRelay<Bool> { get }
}

protocol CertificationViewModelOutput {
  var images: Driver<[UIImage]> { get }
  var completeButtonColor: Driver<UIColor> { get }
}

protocol CertificationViewModelType {
  var input: CertificationViewModelInput { get }
  var output: CertificationViewModelOutput { get }
}

class CertificationViewModel: CertificationViewModelInput,
                              CertificationViewModelOutput,
                              CertificationViewModelType {
  var input: CertificationViewModelInput { return self }
  var output: CertificationViewModelOutput { return self }
  
  let selectedImages: PublishRelay<[UIImage]>
  let completeButtonEnabled: BehaviorRelay<Bool>
  
  let images: Driver<[UIImage]>
  let completeButtonColor: Driver<UIColor>
  
  init() {
    self.selectedImages = PublishRelay<[UIImage]>()
    self.completeButtonEnabled = BehaviorRelay<Bool>(value: false)
    
    self.images = selectedImages.asDriver(onErrorJustReturn: [])
    self.completeButtonColor = completeButtonEnabled.map { (can) -> UIColor in
      if can {
        return UIColor(red: 67/255, green: 136/255, blue: 238/255, alpha: 1)
      } else {
        return UIColor(red: 186/255, green: 211/255, blue: 249/255, alpha: 1)
      }
    }
    .asDriver(onErrorJustReturn: UIColor(red: 186/255, green: 211/255, blue: 249/255, alpha: 1))
  }  
}
