//
//  File.swift
//  
//
//  Created by Nickolay Truhin on 27.02.2021.
//

import Foundation
import Vapor
import Fluent
import Botter

struct UserHistoryEntry: Codable {
    let nodeId: UUID
    let nodePayload: NodePayload?
}

struct UserPlatformId: Codable {
    let id: Int64 // chatId for tg, userId for vk
    let username: String?
}

protocol UserProtocol: Cloneable where TwinType: UserProtocol {
    
    var id: UUID? { get set }
    var history: [UserHistoryEntry] { get set }
    var nodeId: UUID? { get set }
    var nodePayload: NodePayload? { get set }
    var platformIds: [TypedPlatform<UserPlatformId>] { get set }
    var name: String? { get set }
    
    init()
    static func create(id: UUID?, history: [UserHistoryEntry], nodeId: UUID?, nodePayload: NodePayload?, platformIds: [TypedPlatform<UserPlatformId>], name: String?, app: Application) -> Future<Self>
}

extension UserProtocol {
    static func create(other: TwinType, app: Application) -> Future<Self> {
        Self.create(id: other.id, history: other.history, nodeId: other.nodeId, nodePayload: other.nodePayload, platformIds: other.platformIds, name: other.name, app: app)
    }
    
    static func create(id: UUID? = nil, history: [UserHistoryEntry] = [], nodeId: UUID? = nil, nodePayload: NodePayload? = nil, platformIds: [TypedPlatform<UserPlatformId>], name: String?, app: Application) -> Future<Self> {
        let instance = Self.init()
        instance.id = id
        instance.history = history
        instance.nodeId = nodeId
        instance.nodePayload = nodePayload
        instance.platformIds = platformIds
        instance.name = name
        return instance.saveIfNeeded(app: app)
    }
}
