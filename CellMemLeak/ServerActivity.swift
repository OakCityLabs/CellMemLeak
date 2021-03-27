//
//  ServerActivity.swift
//  CellMemLeak
//
//  Created by Jay Lyerly on 3/26/21.
//

import Foundation

/// Hardware monitoring
struct ServerActivity: Codable {
    
    var prettyDiskFree: String {
        return ByteCountFormatter.string(fromByteCount: disk.free,
                                         countStyle: .memory)
    }
    
    var prettyDiskTotal: String {
        return ByteCountFormatter.string(fromByteCount: disk.total, countStyle: .decimal)
    }
    
    var prettyMemUsed: String {
        return ByteCountFormatter.string(fromByteCount: memory.total - memory.available,
                                         countStyle: .memory)
    }
    
    var prettyMemTotal: String {
        return ByteCountFormatter.string(fromByteCount: memory.total, countStyle: .memory)
    }
    
    var memPercentUsed: Int {
        return Int((memory.total - memory.available) * 100 / memory.total)
    }
    
    var timestamp: String
    var disk: DiskStat
    var memory: MemoryStat
    var cpu: CPUStat
    var gpu: [GPUStat]
}

struct DiskStat: Codable {
    var free: Int64
    var percent: Double
    var total: Int64
}

struct MemoryStat: Codable {
    
    var available: Int64
    var total: Int64

}

struct CPUStat: Codable {

    var percent: Double
    var loadPercent: Double
    
    enum CodingKeys: String, CodingKey {
        case percent
        case loadPercent = "load_percent"
    }
}

struct GPUStat: Codable {
    var name: String
    var gpuUsagePercent: Double
    var memoryUsagePercent: Double
    var memoryFree: Double
    var memoryUsed: Double
    var memoryTotal: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case gpuUsagePercent = "gpu_usage_percent"
        case memoryUsagePercent = "memory_usage_percent"
        case memoryFree = "memory_free"
        case memoryUsed = "memory_used"
        case memoryTotal = "memory_total"
    }
    
}
