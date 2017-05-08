//
//  ViewModel.swift
//  Example
//
//  Created by Tal Shrestha on 08/05/2017.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum AppInput {
    case Key1
    case Key2
}

enum AppState {
    case State1
    case State2
}

struct ViewModel {
    
    var appInput = Variable<AppInput>(.Key1)
    
    var appState: Observable<AppState> {
        return self.appInput.asObservable().map({ _ in
            print("This should only appear once")
            return .State1
        }).share()
    }
}
