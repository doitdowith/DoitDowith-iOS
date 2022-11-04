//
//  CertificationViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/03.
//

import UIKit
import PhotosUI

import RxCocoa
import RxSwift
import RxViewController
import RxKeyboard
import NSObject_Rx

class CertificationViewController: UIViewController {
  // MARK: Constant
  private let safeAreaBottomSize = UIApplication.safeAreaEdgeInsets.bottom
  private let viewModel: CertificationViewModelType
  
  // MARK: Initializer
  init?(coder: NSCoder, viewModel: CertificationViewModelType) {
    self.viewModel = viewModel
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.bind()
  }
  
  // MARK: Interface Builder
  @IBOutlet weak var certificationTextView: UITextView!
  @IBOutlet weak var imageCollectionView: UICollectionView!
  @IBOutlet weak var backButton: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var completeButton: UIButton!
  @IBOutlet weak var backgroundView: UIView!
  
  @IBOutlet weak var buttonViewBottomConstraint: NSLayoutConstraint!
  
  @IBAction func gallaryButtonDidTap(_ sender: UIButton) {
    var configuration = PHPickerConfiguration()
    configuration.filter = .images
    configuration.selectionLimit = 0
    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self
    self.present(picker, animated: true)
  }
  
  @IBAction func cameraButtonDidTap(_ sender: UIButton) {
    let camera = UIImagePickerController()
    camera.sourceType = .camera
    camera.allowsEditing = true
    camera.cameraDevice = .rear
    camera.cameraCaptureMode = .photo
    camera.delegate = self
    self.present(camera, animated: true)
  }
}

// MARK: Bind function
extension CertificationViewController {
  func bind() {
    self.bindLifeCycle()
    self.bindBackButton()
    self.bindKeyboard()
    self.bindImageCollectionView()
    self.bindBackgroundView()
  }
  
  func bindLifeCycle() {
    Observable
      .merge([rx.viewWillAppear.map { _ in true },
              rx.viewWillDisappear.map { _ in false }])
      .bind(onNext: { [weak navigationController] visible in
        navigationController?.isNavigationBarHidden = visible
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindBackButton() {
    self.backButton.rx
      .tapGesture()
      .when(.recognized)
      .bind(onNext: { [weak navigationController]_ in
        navigationController?.popViewController(animated: true)
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindKeyboard() {
    RxKeyboard.instance.visibleHeight
      .map { max(0, $0 - self.safeAreaBottomSize) }
      .drive(self.buttonViewBottomConstraint.rx.constant)
      .disposed(by: rx.disposeBag)
  }
  
  func bindImageCollectionView() {
    self.viewModel.output.images
      .debug()
      .drive(self.imageCollectionView.rx.items(cellIdentifier: ImageCell.identifier,
                                               cellType: ImageCell.self)) { _, element, cell in
        cell.configure(image: element)
      }
      .disposed(by: rx.disposeBag)
  }
  
  func bindBackgroundView() {
    self.backgroundView.rx.tapGesture()
      .withUnretained(self)
      .bind(onNext: { owner, _ in
        owner.view.endEditing(true)
      })
      .disposed(by: rx.disposeBag)
  }
}

// MARK: PHPicker ViewController Delegate
extension CertificationViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    var images: [UIImage] = []
    let group = DispatchGroup()
    for result in results where result.itemProvider.canLoadObject(ofClass: UIImage.self) {
      group.enter()
      result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
        defer { group.leave() }
        if let image = image as? UIImage {
          images.append(image)
        } else {
          print("Could not load image", error?.localizedDescription ?? "")
        }
      }
    }
    group.notify(queue: .main) {
      if !images.isEmpty {
        self.viewModel.input.selectedImages.accept(images)
      }
    }
  }
}

// MARK: UIImagePickerController Delegate
extension CertificationViewController: UIImagePickerControllerDelegate,
                                       UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
      self.viewModel.input.selectedImages.accept([image])
    }
    picker.dismiss(animated: true)
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
  }
}
