//
//  DateExtension.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 28.04.2024.
//

import Foundation

extension Date {
    
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
    func getCurrentDay(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Set the date format to get the day of the week name
        return formatter.string(from: date)
    }

}
