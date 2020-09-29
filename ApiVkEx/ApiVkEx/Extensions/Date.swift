//
//  Date.swift
//  ApiVkEx
//
//  Created by Егор on 23.09.2020.
//  Copyright © 2020 Stroev Egor. All rights reserved.
//

import Foundation

extension Date {
    
    init(_ ts:Int64 ){
        
        if( ts >= 10000000 && ts < 99999999 ){ // KEY
            let key = ts
            let year    = Int( key / 1_0000 )
            let month   = Int( ( key % 1_0000 ) / 1_00 )
            let day     = Int( ( key % 1_0000  ) % 1_00 )
            
            var components:DateComponents?
            
            if month != 0 {
                components = DateComponents( year:year, month:month, day:day )
            }
            else{
                components = DateComponents( year: year, weekday: Calendar.iso8601().firstWeekday, weekOfYear:day )
            }
            
            guard
                components != nil,
                let date = Calendar.iso8601().date(from: components! )
                else { self = Date(timeIntervalSince1970: 0); return }
            
            self = date
            return
        }
        
        if ( Int64(ts) > 90_000_000_000 ){    // timestamp in milisecounds
            self =  Date(timeIntervalSince1970: TimeInterval(ts) / 1000 )
            return
        }
        
        // timestamp in secounds
        self =  Date( timeIntervalSince1970: TimeInterval( ts ) )
        
    }
    
    private static var dateForm: RelativeDateTimeFormatter = {
        var df = RelativeDateTimeFormatter()
        df.locale = Locale(identifier: "ru_RU")
        return df
    }()
    
    private static var dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        return df
    }()
    
    var adaptiveDateString: String {
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        if calendar.compare(self, to: currentDate, toGranularity: .hour) == .orderedSame {
            return Self.dateForm.localizedString(for: self, relativeTo: currentDate)
        }
        
        let df = Self.dateFormatter
        
        if calendar.isDateInToday(self) {
            
            df.dateFormat = "Сегодня в HH:ss"
            return df.string(from: self)
        }
        
        if calendar.isDateInYesterday(self) {
            
            df.dateFormat = "Вчера в HH:ss"
            return df.string(from: self)
        }
        
        df.dateFormat = "d MMMM yyyy"
        return df.string(from: self)
    }
}

extension Calendar {
    static func iso8601() -> Calendar {
        var cal = Calendar( identifier: .iso8601 )
        cal.timeZone    = TimeZone(secondsFromGMT: 0)!
        cal.locale      = Locale(identifier: "en_US_POSIX")
        return cal
    }
    
}
