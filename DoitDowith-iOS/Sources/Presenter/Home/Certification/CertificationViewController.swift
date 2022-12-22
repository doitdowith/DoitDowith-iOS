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

protocol CertificationViewControllerDelegate: AnyObject {
  func certificationViewController(_ certificateMessage: ChatModel)
}
class CertificationViewController: UIViewController {
  // MARK: Constant
  weak var delegate: CertificationViewControllerDelegate?
  var selectedImage: UIImage?
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
    self.addAction()
    self.addStyle()
  }
  
  // MARK: Interface Builder
  @IBOutlet weak var certificationTextView: UITextView!
  @IBOutlet weak var imageCollectionView: UICollectionView!
  @IBOutlet weak var backButton: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var completeButton: UIButton!
  @IBOutlet weak var backgroundView: UIView!
  
  @IBOutlet weak var modalBackgroundView: UIView!
  @IBOutlet weak var modalView: UIView!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var closeButton: UIButton!
  
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
  
  @IBAction func completeButtomDidTap(_ sender: UIButton) {
    guard let image = selectedImage,
          let data = image.pngData(),
          let name = UserDefaults.standard.string(forKey: "name") else { return }
    
    let base64 = data.base64EncodedString()
    self.delegate?.certificationViewController(ChatModel(type: .sendImageMessage,
                                                         name: name,
                                                         message: .text("\(name)님의 인증 메세지"),
                                                         image: .base64(base64),
                                                         time: Date.now.formatted(format: "yyyy-MM-dd hh:mm")))
    self.navigationController?.popViewController(animated: true)
  }
  
  func resignTextViewResponder() {
    if certificationTextView.isFirstResponder {
      certificationTextView.resignFirstResponder()
    }
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
    self.bindCertificationTextView()
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
      .withUnretained(self)
      .bind(onNext: { owner, _ in
        owner.resignTextViewResponder()
        owner.animateOpenModal()
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
  
  func bindCertificationTextView() {
    self.certificationTextView.rx.didBeginEditing
      .withLatestFrom(self.certificationTextView.rx.text)
      .filter { $0 != nil && $0! == "인증 글을 작성해보세요!" }
      .bind(onNext: { _ in
        self.certificationTextView.text = nil
        self.certificationTextView.textColor = .black
      })
      .disposed(by: rx.disposeBag)
    
    self.certificationTextView.rx.didEndEditing
      .withLatestFrom(self.certificationTextView.rx.text)
      .filter { $0 == nil || $0!.isEmpty }
      .bind(onNext: { _ in
        self.certificationTextView.text = "인증 글을 작성해보세요!"
        self.certificationTextView.textColor = .coolGray2
      })
      .disposed(by: rx.disposeBag)
    
    self.certificationTextView.rx.text
      .map { $0 != "인증 글을 작성해보세요!" && !$0!.isEmpty }
      .bind(onNext: {
        self.completeButton.rx.isUserInteractionEnabled.onNext($0)
        self.viewModel.input.completeButtonEnabled.accept($0)
      })
      .disposed(by: rx.disposeBag)
    
    self.viewModel.output.completeButtonColor
      .drive(onNext: { self.completeButton.setTitleColor($0, for: .normal) })
      .disposed(by: rx.disposeBag)
  }
}

// MARK: PHPicker ViewController Delegate
extension CertificationViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    var selectImages: [UIImage] = []
    let group = DispatchGroup()
    for result in results where result.itemProvider.canLoadObject(ofClass: UIImage.self) {
      group.enter()
      result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
        defer { group.leave() }
        if let image = image as? UIImage {
          selectImages.append(image)
        } else {
          print("Could not load image", error?.localizedDescription ?? "")
        }
      }
    }
    group.notify(queue: .main) {
      if !selectImages.isEmpty {
        self.selectedImage = selectImages[0]
        self.viewModel.input.selectedImages.accept(selectImages)
      }
    }
  }
}

// MARK: UIImagePickerController Delegate
extension CertificationViewController: UIImagePickerControllerDelegate,
                                       UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
      self.viewModel.input.selectedImages.accept([image])
    }
    picker.dismiss(animated: true)
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
  }
}

// MARK: Action function
extension CertificationViewController {
  func addAction() {
    self.closeButton.addTarget(self,
                               action: #selector(animateCloseModal),
                               for: .touchUpInside)
    self.cancelButton.addTarget(self,
                                action: #selector(animateCloseModal),
                                for: .touchUpInside)
    self.deleteButton.addTarget(self,
                                action: #selector(closeModalAndNavigation),
                                for: .touchUpInside)
  }
  
  func animateOpenModal() {
    self.view.layoutIfNeeded()
    self.modalBackgroundView.isHidden = false
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  @objc func animateCloseModal() {
    self.view.layoutIfNeeded()
    self.modalBackgroundView.isHidden = true
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  @objc func closeModalAndNavigation() {
    self.view.layoutIfNeeded()
    self.modalBackgroundView.isHidden = true
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    } completion: { _ in
      self.navigationController?.popViewController(animated: true)
    }
  }
}

// MARK: Style function
extension CertificationViewController {
  func addStyle() {
    self.modalView.layer.applySketchShadow(color: UIColor(red: 108/255,
                                                          green: 123/255,
                                                          blue: 137/255,
                                                          alpha: 0.22),
                                           x: 0,
                                           y: 0,
                                           blur: 12,
                                           spread: 0)
    self.modalView.layer.cornerRadius = 8
    
    self.deleteButton.layer.borderWidth = 1
    self.deleteButton.layer.cornerRadius = 2
    self.deleteButton.layer.borderColor = UIColor.lightGray3.cgColor
    
    self.cancelButton.layer.cornerRadius = 2
  }
}
