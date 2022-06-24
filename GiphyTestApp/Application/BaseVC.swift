//
//  BaseVC.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

import UIKit
import Combine

class BaseVC: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    deinit {
        print("\(self.nameOfClass) deinit")
    }
}
