//
//  ViewController.swift
//  Example
//
//  Created by Tal Shrestha on 08/05/2017.
//  Copyright © 2017 None. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class ViewController: NSViewController {
    
    let disposeBag = DisposeBag()
    
    let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.appState.subscribe({event in
            print("Subscription 1")
        }).addDisposableTo(disposeBag)
        self.viewModel.appState.subscribe({event in
            print("Subscription 2")
        }).addDisposableTo(disposeBag)
        self.viewModel.appState.subscribe({event in
            print("Subscription 3")
        }).addDisposableTo(disposeBag)
        
        self.viewModel.appInput.value = .Key1
    }


}

