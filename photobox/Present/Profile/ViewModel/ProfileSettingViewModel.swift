//
//  ProfileSettingViewModel.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import Foundation

struct ProfileDidLoadOutput {
    var currentNickname: String
    var currentImage: ProfileImages
    var mbtiButtons: [[MbtiButton]]
}

// 계정 생성 후 수정일 경우
// 1. currentProfileImage set
// 2. currentNickname set
// 3. currentMbti set


final class ProfileSettingViewModel: ViewModelProtocol {
        
    
    // MARK: Observable로 관리하지 않는 value
    var isInitial: Bool
    var currentProfileImage: ProfileImages?
    private var currentNickname = ""
    private var currentMbti = [["E", "I"], ["N", "S"], ["F", "T"], ["P", "J"]].map {
        $0.map { MbtiButton(value: $0, isSelected: false) }
    }
    private lazy var currentMbtis = currentMbti.map { _ in return "" }
    
    
    // MARK: Input
    var didLoadInput = Observable<Void?>(nil)
    var nicknameInput = Observable<String?>("")
    var mbtiButtonTouchInput = Observable<(Int, String?)?>(nil)
    var saveUserProfileInput = Observable<Void?>(nil)
    var deleteUserProfileInput = Observable<Void?>(nil)
    
    // MARK: Output
    var didLoadOutput = Observable<ProfileDidLoadOutput?>(nil)
    var nicknameOutput = Observable<Result<String, ValidateService.ValidationErrors>>(.failure(.isEmpty))
    var profileCreationOutput = Observable<Bool>(false)
    var saveProfileOutput = Observable<Void?>(nil)
    
    init(isInitial: Bool) {
        self.isInitial = isInitial
        
        bindingInput()
    }
    
    
    func bindingInput() {
        didLoadInput.bindingWithoutInitCall { [weak self] _ in
            guard let self else { return }
            self.bindingDidLoadOutput()
        }
        
        nicknameInput.bindingWithoutInitCall { [weak self] text in
            guard let self else { return }
            self.bindingNicknameField(for: text)
        }
        
        mbtiButtonTouchInput.bindingWithoutInitCall { [weak self] value in
            guard let self, let value else { return }
            self.bindingMbtiButton(tag: value.0, title: value.1)
        }

        saveUserProfileInput.bindingWithoutInitCall { [weak self] _ in
            guard let self else { return }
            self.saveUserProfile()
        }
        
        deleteUserProfileInput.bindingWithoutInitCall { _ in
            UserDefaultsService.shared.removeValues()
        }
    }
    
    func bindUpdateValues(profileImageName: String, nickname: String, mbti: String) {
        if let image = ProfileImages(rawValue: profileImageName) {
            currentProfileImage = image
        }
        currentNickname = nickname
        
        let compare = mbti.map { String($0) }
        
        currentMbti.enumerated().forEach { index, buttons in
            buttons.enumerated().forEach { idx, button in
                if button.value == compare[index] {
                    currentMbti[index][idx].isSelected = true
                }
            }
        }
        currentMbtis = compare
        validatingProfileCreation()
    }
    

    // 최초에 뷰를 띄우기 위해 동작
    private func bindingDidLoadOutput() {
        if let currentProfileImage, !currentNickname.isEmpty {
            didLoadOutput.value = ProfileDidLoadOutput(
                currentNickname: currentNickname,
                currentImage: currentProfileImage,
                mbtiButtons: currentMbti
            )
        } else {
            if let profileImage = ProfileImages.allCases.randomElement() {
                currentProfileImage = profileImage
                
                didLoadOutput.value = ProfileDidLoadOutput(
                    currentNickname: currentNickname,
                    currentImage: profileImage,
                    mbtiButtons: currentMbti
                )
            }
        }
    }
    
    // MBTI 버튼 액션이 바인딩 되었을 때 동작
    private func bindingMbtiButton(tag: Int, title: String?) {
        guard let title else { return }
        let mbtiResults = currentMbtis[tag]
        var mbtiButton = currentMbti[tag]
        
        if mbtiResults.isEmpty {
            currentMbtis[tag] += title
            
            mbtiButton = mbtiButton.map {
                if $0.value == title {
                    return MbtiButton(value: $0.value, isSelected: true)
                } else {
                    return $0
                }
            }
        } else {
            
            if mbtiResults == title {
                currentMbtis[tag] = ""
                mbtiButton = mbtiButton.map {
                    if $0.value == title {
                        return MbtiButton(value: $0.value, isSelected: false)
                    } else {
                        return $0
                    }
                }
            } else {
                currentMbtis[tag] = title
                mbtiButton = mbtiButton.map {
                    if $0.value == title {
                        return MbtiButton(value: $0.value, isSelected: true)
                    } else {
                        return MbtiButton(value: $0.value, isSelected: false)
                    }
                }
            }
        }
        
        currentMbti[tag] = mbtiButton
        didLoadOutput.value?.currentNickname = currentNickname
        didLoadOutput.value?.mbtiButtons = currentMbti
        validatingProfileCreation()
    }
    
    // NicknameField에 입력이 발생할 때 동작
    private func bindingNicknameField(for nickname: String?) {
        guard let nickname else { return }
        currentNickname = nickname
        validatingProfileCreation()
        do {
            try ValidateService.shared.validateNickname(nickname)
            nicknameOutput.value = .success(Text.Labels.NICKNAME_SUCCESS.rawValue)
            validatingProfileCreation()
        } catch ValidateService.ValidationErrors.isEmpty {
            nicknameOutput.value = .failure(.isEmpty)
            profileCreationOutput.value = false
        } catch ValidateService.ValidationErrors.isLowerOrOverCount {
            nicknameOutput.value = .failure(.isLowerOrOverCount)
            profileCreationOutput.value = false
        } catch ValidateService.ValidationErrors.isContainNumber {
            nicknameOutput.value = .failure(.isContainNumber)
            profileCreationOutput.value = false
        } catch ValidateService.ValidationErrors.isContainSpecialLetter {
            nicknameOutput.value = .failure(.isContainSpecialLetter)
            profileCreationOutput.value = false
        } catch { 
            profileCreationOutput.value = false
        }
    }
    
    private func mappingMbti() -> String {
        return currentMbtis.joined()
    }
    
    // 매 이벤트가 있을 때마다 동작
    private func validatingProfileCreation() {
        // 1. 프로필 이미지가 정해졌나?
        // 2. 닉네임이 정확하게 등록되어 있는가?
        // 3. mbti가 정해졌나?
        
        guard currentProfileImage != nil else {
            profileCreationOutput.value = false
            return
        }
        
        guard mappingMbti().count == 4 else {
            profileCreationOutput.value = false
            return
        }

        do {
            try ValidateService.shared.validateNickname(currentNickname)
            profileCreationOutput.value = true
        } catch {
            profileCreationOutput.value = false
        }
    }
    
    // 유저 프로필 저장 이벤트가 들어왔을 때 동작
    // nickname > profileImage > mbti 순서로 입력
    private func saveUserProfile() {
        validatingProfileCreation()
        
        if profileCreationOutput.value {
            if let currentProfileImage {
                let data = [currentNickname, currentProfileImage.rawValue, mappingMbti()]
                UserDefaultsService.shared.setValues(for: data)
                
                // 여기서 네비게이팅
                saveProfileOutput.value = ()
            }
        }
    }
}
