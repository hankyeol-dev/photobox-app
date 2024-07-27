//
//  ProfileImageSettingViewModel.swift
//  photobox
//
//  Created by 강한결 on 7/24/24.
//

import Foundation

final class ProfileImageSettingViewModel: ViewModelProtocol {
    
    var sender: ((ProfileImages) -> Void)?
    
    // MARK: NotObservableValue
    var currentImage: ProfileImages?
    
    // MARK: Input
    var didLoadInput = Observable<Void?>(nil)
    var collecionItemSelectInput = Observable<ProfileImages?>(nil)
    
    // MARK: Output
    var didLoadOutput = Observable<ProfileImages?>(nil)
    
    init() {        
        bindingInput()
    }
    
    func bindingInput() { 
        
        didLoadInput.bindingWithoutInitCall { [weak self] _ in
            guard let self else { return }
            bindingDidLoadOutput()
        }
        
        collecionItemSelectInput.bindingWithoutInitCall { [weak self] profileImage in
            if let self, let profileImage {
                self.currentImage = profileImage
                self.didLoadOutput.value = profileImage
            }
        }
        
    }
    
    func bindingDidLoadOutput() {
        if let currentImage {
            didLoadOutput.value = currentImage
        }
    }
}
