import Foundation
import SwiftData

@MainActor
final class MemoryService {
    static let shared = MemoryService()
    
    private init() {}
    
    /// Save a new learned memory or correction
    func saveMemory(
        title: String,
        content: String,
        category: String = "general",
        isCorrection: Bool = false,
        in context: ModelContext
    ) -> UserMemory {
        let memory = UserMemory(
            title: title,
            content: content,
            category: category,
            isCorrection: isCorrection
        )
        context.insert(memory)
        try? context.save()
        return memory
    }
    
    /// Delete a memory
    func deleteMemory(_ memory: UserMemory, in context: ModelContext) {
        context.delete(memory)
        try? context.save()
    }
}
