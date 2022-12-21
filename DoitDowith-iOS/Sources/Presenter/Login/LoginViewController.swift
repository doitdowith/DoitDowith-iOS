//
//  LoginViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/08.
//
import UIKit

import RxCocoa
import RxSwift
import NSObject_Rx
import SnapKit
import Then
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewController: UIViewController {
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
  
  func postToken(token: String) {
    APIService.shared
      .request(request: RequestType(endpoint: "members",
                                    method: .post,
                                    parameters: ["accessToken": token]))
      .bind(onNext: { (response: LoginResponse) in
        print("local token: ", response.accessToken)
        UserDefaults.standard.set(response.accessToken, forKey: "token")
        UserDefaults.standard.set(response.email, forKey: "email")
        UserDefaults.standard.set(response.memberId, forKey: "memberId")
        UserDefaults.standard.set(response.name, forKey: "name")
        UserDefaults.standard.set(response.profileImage, forKey: "profileImage")
      })
      .disposed(by: rx.disposeBag)
  }
  
  func navigateHome() {
    guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarVC") as? TabBarViewController else { return }
    vc.modalPresentationStyle = .overFullScreen
    present(vc, animated: true)
  }
  
  @objc func didTapLogin() {
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
        guard let self = self,
              let token = oauthToken,
              error == nil else {
          return
        }
        self.postToken(token: token.accessToken)
        self.navigateHome()
      }
    } else {
      UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
        guard let self = self,
              let token = oauthToken,
              error == nil else {
          return
        }
        self.postToken(token: token.accessToken)
        self.navigateHome()
      }
    }
  }
}
