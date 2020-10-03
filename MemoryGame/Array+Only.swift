//
//  Array+Only.swift
//  MemoryGame
//
//  Created by 楢崎修二 on 2020/10/03.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
