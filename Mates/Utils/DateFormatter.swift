//
//  DateFormatter.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/20/25.
//

import Foundation


func timeAgo(from isoDateString: String) -> String {
    
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    var parsedDate: Date?

    // Try parsing with fractional seconds
    parsedDate = isoFormatter.date(from: isoDateString)

    // Fallback if that fails
    if parsedDate == nil {
        isoFormatter.formatOptions = [.withInternetDateTime]
        parsedDate = isoFormatter.date(from: isoDateString)
    }

    // If both fail, return fallback string
    guard let postDate = parsedDate else {
        return ""
    }

    
    let now = Date()
    let difference = Calendar.current.dateComponents([.day], from: postDate, to: now)
    
    if let days = difference.day, days >= 7 {
        return formatFullDate(postDate)
    }else{
        return formatRelatveDate(from: postDate, to: now)
    }

    
}


private func formatRelatveDate(from date: Date, to now: Date) -> String {
    
    let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date, to: now)
    

    if let day = components.day, day > 0 {
        if day == 1 {
            return "\(day )day ago"
        }else{
            return "\(day) days ago"
        }
    }
    
    if let hour = components.hour, hour > 0 {
        if hour == 1 {
            return "\(hour) hour ago"
        }else{
            return "\(hour) hours ago"
        }
    }
    
    if let minute = components.minute, minute > 0 {
        if minute == 1 {
            return "\(minute) minute ago"
        }else{
            return "\(minute) minutes ago"
        }
    }
    
    if let second = components.second, second > 0 {
        if second == 1 {
            return "\(second) second ago"
        }else{
            return "\(second) seconds ago"
        }
    }
    
    
    return "Just now"
    
}


private func formatFullDate(_ date: Date) -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d'\(daySuffix(from: date))', yyyy"
    return formatter.string(from: date)
}

private func daySuffix(from date: Date) -> String {
    let day = Calendar.current.component(.day, from: date)
    
    switch day {
    case 11, 12, 13: return "th"
    default:
        switch day % 10 {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
        }
    }
}
