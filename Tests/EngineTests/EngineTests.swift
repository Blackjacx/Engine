//
//  EngineTests.swift
//  Engine
//
//  Created by Stefan Herold on 19.11.20.
//

import Quick
import Nimble

final class EngineTests: QuickSpec {

    override func spec() {

        describe("Engine") {

            beforeEach {
            }

            it("behaves like xyz") {
                expect("Hello Quick/Nimble!") == "Hello Quick/Nimble!"
            }
        }
    }
}
