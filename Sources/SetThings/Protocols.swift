//
//  Protocols.swift
//  SetThings
//
//  Created by kin on 5/2/25.
//
import SwiftUI
public struct TimeOnly: Codable, Hashable {
    public var hour: Int
    public var minute: Int
    
    public init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }

    public init(date: Date) {
        let cal = Calendar.current
        self.hour = cal.component(.hour, from: date)
        self.minute = cal.component(.minute, from: date)
    }

    public func toDate(on date: Date = Date()) -> Date {
        var comps = Calendar.current.dateComponents([.year, .month, .day], from: date)
        comps.hour = hour
        comps.minute = minute
        return Calendar.current.date(from: comps)!
    }
}

public struct DateOnly: Codable, Hashable {
    public var year: Int
    public var month: Int
    public var day: Int
    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    public init(date: Date) {
        let cal = Calendar.current
        self.year = cal.component(.year, from: date)
        self.month = cal.component(.month, from: date)
        self.day = cal.component(.day, from: date)
    }

    public func toDate(on date: Date = Date()) -> Date {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return Calendar.current.date(from: comps)!
    }
}
public enum ThingType {
    case text(placeholder: String = "", defaultValue: String? = nil)
    case number(placeholder: String = "", defaultValue: Decimal? = nil)
    case password(placeholder: String = "")
    case selectString([String], defaultValue: String? = nil)
    case bool(Bool)
    case time(TimeOnly)
    case date(DateOnly)
    case dateAndTime(Date)
    case color(Color)
    case view(AnyView)
    case block(AnyView)
    case section([ThingItem])
    case group([ThingItem])
    case slider(range: ClosedRange<Int>, defaultValue: Int? = nil, label: ((Int) -> AnyView)? = { value in
        AnyView(Text("\(value)"))
    })
}

public protocol ThingItem {
    var key: String { get }
    var name: String { get }
    var type: ThingType { get }
    var description: String? { get set }
}
public extension Bool {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let boolValue = try? container.decode(Bool.self) {
            self = boolValue
        } else if let stringValue = try? container.decode(String.self) {
            switch stringValue.lowercased() {
            case "true", "1", "yes": self = true
            case "false", "0", "no": self = false
            default:
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid boolean string: \(stringValue)")
            }
        } else if let intValue = try? container.decode(Int.self) {
            self = intValue != 0
        } else {
            throw DecodingError.typeMismatch(Bool.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected Bool, String, or Int"))
        }
    }
}
