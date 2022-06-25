//
//  UITextFieldExtensions.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .map { ($0.object as? UITextField)?.text }
        .eraseToAnyPublisher()
    }
}
