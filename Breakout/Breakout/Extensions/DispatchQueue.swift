//
//  DispatchQueue.swift
//  Breakout
//
//  Created by Faiz Ikhwan on 13/11/2019.
//  Copyright © 2019 Faiz Ikhwan. All rights reserved.
//

import Foundation

extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}
