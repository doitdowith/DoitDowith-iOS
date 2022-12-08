//
//  LoginViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/08.
//
import UIKit
import SnapKit
import Then

class LoginViewController: UIViewController {
  private let guestLoginButton = UIButton().then {
    $0.setTitle("로그인 없이 둘러보기", for: .normal)
    $0.setTitleColor(UIColor(hex: 0xA9AFB9), for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    $0.setUnderline()
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  private let kakaoLoginButton = UIButton().then {
    $0.setImage(UIImage(named: "kakao_icon"), for: .normal)
    $0.setTitle("카카오 로그인", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
    $0.tintColor = UIColor(hex: 0x000000)
    
    $0.backgroundColor = UIColor(hex: 0xFEE500)
    $0.layer.cornerRadius = 2
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    if #available(iOS 15.0, *) {
      var config = UIButton.Configuration.plain()
      config.imagePadding = 6
      $0.configuration = config
    } else {
      $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  private let appleLoginButton = UIButton().then {
    $0.setTitle("Apple 로그인", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
    $0.backgroundColor = UIColor(hex: 0x000000)
    $0.layer.cornerRadius = 2
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .equalSpacing
    $0.spacing = 12
    $0.translatesAutoresizingMaskIntoConstraints = false
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addBackground(with: "background")
    
    view.addSubview(guestLoginButton)
    guestLoginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    
    view.addSubview(stackView)
    stackView.addArrangedSubview(kakaoLoginButton)
    kakaoLoginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    stackView.addArrangedSubview(appleLoginButton)
    appleLoginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    
    setConstraints()
  }
}
extension LoginViewController {
  func setConstraints() {
    guestLoginButton.snp.makeConstraints { make in
      make.bottom.equalTo(stackView.snp.top).offset(-16)
      make.centerX.equalToSuperview()
    }
    kakaoLoginButton.snp.makeConstraints { make in
      make.height.equalTo(48)
    }
    appleLoginButton.snp.makeConstraints { make in
      make.height.equalTo(48)
    }
    stackView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.bottom.equalToSuperview().offset(-50)
      make.width.equalToSuperview().offset(-16)
    }
  }
  @objc func didTapLogin() {
    // Log user in or yell at them for error
    // code
    
    // navigate home
//    let mainAppTabBarVC = TabBarViewController()
//    mainAppTabBarVC.modalPresentationStyle = .fullScreen
//    present(mainAppTabBarVC, animated: true)
  }
}
