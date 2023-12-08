//
//  ImageSearcher.swift
//  QulixTest
//
//  Created by Alex on 8.12.23.
//

import Foundation

protocol ImageSearcher {
    var step: String {get set}
    var query: String {get set}
    var offset: String {get set}
    func search(for query: String)
    func getNext()
}
