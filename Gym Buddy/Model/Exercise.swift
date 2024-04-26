//
//  Exercise.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 25.04.2024.
//

import Foundation
import SwiftUI

struct Exercise: Codable, Hashable {
    var bodyPart: String
    var equipment: String
    var gifUrl: String
    var id: String
    var name: String
    var target: String
}
