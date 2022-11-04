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
}

protocol CertificationViewModelOutput {
  var images: Driver<[UIImage]> { get }
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
  let images: Driver<[UIImage]>
  
  init() {
    self.selectedImages = PublishRelay<[UIImage]>()
    self.images = selectedImages.asDriver(onErrorJustReturn: [])
  }
}
