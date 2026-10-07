import Foundation
import SwiftData

@Model
public final class UserProfile {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var handle: String
    public var avatarEmoji: String
    public var tier: String
    public var tokenBalance: Int
    public var totalTokens: Int
    public var joinedDate: Date
    
    public init(
        id: UUID = UUID(),
        name: String = "Alex",
        handle: String = "@alex.aura",
        avatarEmoji: String = "⚡️",
        tier: String = "Pro Monthly",
        tokenBalance: Int = 84200,
        totalTokens: Int = 100000,
        joinedDate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.handle = handle
        self.avatarEmoji = avatarEmoji
        self.tier = tier
        self.tokenBalance = tokenBalance
        self.totalTokens = totalTokens
        self.joinedDate = joinedDate
    }
}
