//
//  Distance.swift
//  Pods
//
//  Created by Jacob Holland on 7/20/17.
//
//

public struct Distance: Codable {
    fileprivate var value: Double
    
    public init(miles: Double?) {
        value = miles ?? 0.0
    }
    public init(kms: Double) {
        value = kms / 1.609344
    }
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let tempValue = try container.decode(Double?.self) {
			value = tempValue
		} else {
			value = 0.0
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		
		var container = encoder.singleValueContainer()
		try container.encode(value)
		
	}
    
    public var miles: Double { return value }
    public var kms: Double { return value * 1.609344 }
}
