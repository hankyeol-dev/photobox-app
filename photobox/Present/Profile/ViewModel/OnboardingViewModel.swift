//
//  OnboardingViewModel.swift
//  photobox
//
//  Created by 강한결 on 7/23/24.
//

import Foundation

protocol StartNavigation: AnyObject {
    func goToProfileSettingView()
}

final class OnboardingViewModel: ViewModelProtocol {
    
    weak var navigator: StartNavigation?
    
    var startButtonTouchInput = Observable<Void?>(nil)
    
    init(navigator: StartNavigation) {
        self.navigator = navigator
        
        bindingInput()
    }
    
    func bindingInput() {
        startButtonTouchInput.bindingWithoutInitCall { [weak self] _ in
            guard let self else { return }
            self.navigator?.goToProfileSettingView()
        }
    }
}
