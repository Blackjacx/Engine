//
//  String+Random.swift
//  Engine
//
//  Created by Stefan Herold on 07.09.22.
//

import Foundation

public extension String {

    // MARK: - Random Text Generation

    enum Randomizer {
        case words(Int)
        case length(Int)
        case randomWords(max: Int)
        case randomLength(max: Int)

        /// Generates a random number between 1 and max.
        /// Except you specify 0 as upper bound. Then you'll get always 0.
        static func random(upTo max: Int) -> Int {
            guard max > 0 else {  return 0 }
            return Int.random(in: 0...max)
        }
    }

    static func random(using method: Randomizer) -> String {

        let loremIpsumBaseString = "Lorem ipsum dolor sit amet, cons" +
        "ectetuer adipiscing elit. Nam cursus. Morbi ut mi. Nullam enim leo, eg" +
        "estas id, condimentum at, laoreet mattis, massa. Sed eleifend nonummy " +
        "diam. Praesent mauris ante, elementum et, bibendum at, posuere sit ame" +
        "t, nibh. Duis tincidunt lectus quis dui viverra vestibulum. Suspendiss" +
        "e vulputate aliquam dui. Nulla elementum dui ut augue. Aliquam vehicul" +
        "a mi at mauris. Maecenas placerat, nisl at consequat rhoncus, sem nunc" +
        " gravida justo, quis eleifend arcu velit quis lacus. Morbi magna magna" +
        ", tincidunt a, mattis non, imperdiet vitae, tellus. Sed odio est, auct" +
        "or ac, sollicitudin in, consequat vitae, orci. Fusce id felis. Vivamus" +
        " sollicitudin metus eget eros."

        switch method {
        case .randomWords(let max):
            return randomWordsString(of: Randomizer.random(upTo: max), from: loremIpsumBaseString)
        case .words(let count):
            return randomWordsString(of: count, from: loremIpsumBaseString)
        case .randomLength(let max):
            return randomLengthString(of: Randomizer.random(upTo: max), from: loremIpsumBaseString)
        case .length(let length):
            return randomLengthString(of: length, from: loremIpsumBaseString)
        }
    }

    private static func randomLengthString(of length: Int, from base: String) -> String {

        let workingBase: String
        
        if length > base.count {
            workingBase = String(repeating: (base + " "), count: Int(length) / base.count + 1)
        } else {
            workingBase = base
        }

        let start = workingBase.startIndex
        let end = workingBase.index(start, offsetBy: Swift.max(length, 0))
        return String(workingBase[start..<end])
    }

    private static func randomWordsString(of count: Int, from base: String) -> String {

        var result: [String] = []
        let availableWords = base.components(separatedBy: " ")
        let availableWordCount = availableWords.count
        for i in 0..<Swift.max(count, 0) {
            let word = availableWords[i % availableWordCount]
            result.append(word)
        }
        return result.joined(separator: " ")
    }
}
