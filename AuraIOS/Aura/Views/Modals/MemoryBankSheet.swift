import SwiftUI
import SwiftData

struct MemoryBankSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \UserMemory.learnedAt, order: .reverse) private var memories: [UserMemory]
    
    @State private var selectedFilter: String = "Tất cả"
    @State private var showingAddMemory: Bool = false
    @State private var newTitle: String = ""
    @State private var newContent: String = ""
    @State private var newCategory: String = "preferences"
    
    let filterTabs = ["Tất cả", "Sở thích", "Công việc", "Dự án", "Đã học"]
    
    private var filteredMemories: [UserMemory] {
        switch selectedFilter {
        case "Sở thích":
            return memories.filter { $0.category == "preferences" }
        case "Công việc":
            return memories.filter { $0.category == "work" }
        case "Dự án":
            return memories.filter { $0.category == "projects" }
        case "Đã học":
            return memories.filter { $0.isCorrection }
        default:
            return memories
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.auraBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header Banner
                        VStack(spacing: 8) {
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 38))
                                .foregroundStyle(Color.auraAmber)
                                .padding(.top, 10)
                            
                            Text("Bộ nhớ & Bài học của Nova")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(.white)
                            
                            Text("Nova ghi nhớ sở thích, bối cảnh công việc và tự động học hỏi mỗi khi bạn đính chính câu trả lời.")
                                .font(.system(size: 13))
                                .foregroundStyle(Color.auraTextSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        
                        // Category Filter Bar
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(filterTabs, id: \.self) { tab in
                                    let isSelected = selectedFilter == tab
                                    Button {
                                        AuraHaptic.selection()
                                        selectedFilter = tab
                                    } label: {
                                        Text(tab)
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundStyle(isSelected ? .black : .white)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 8)
                                            .background(
                                                Capsule()
                                                    .fill(isSelected ? Color.auraAmber : Color.auraCard)
                                                    .overlay(
                                                        Capsule().stroke(isSelected ? Color.clear : Color.auraBorder, lineWidth: 0.8)
                                                    )
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // Memories List
                        if filteredMemories.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "tray")
                                    .font(.system(size: 32))
                                    .foregroundStyle(Color.auraTextMuted)
                                Text("Chưa có ký ức nào trong mục này")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.auraTextMuted)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(filteredMemories) { memory in
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack {
                                            Label(memory.categoryDisplayName, systemImage: memory.categoryIcon)
                                                .font(.system(size: 11, weight: .bold))
                                                .foregroundStyle(memory.isCorrection ? Color.auraSuccess : Color.auraAmber)
                                            
                                            Spacer()
                                            
                                            Text(memory.learnedAt, format: .dateTime.day().month().hour().minute())
                                                .font(.system(size: 11))
                                                .foregroundStyle(Color.auraTextMuted)
                                            
                                            Button {
                                                AuraHaptic.selection()
                                                MemoryService.shared.deleteMemory(memory, in: modelContext)
                                            } label: {
                                                Image(systemName: "trash")
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(Color.auraTextMuted)
                                            }
                                        }
                                        
                                        Text(memory.title)
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundStyle(.white)
                                        
                                        Text(memory.content)
                                            .font(.system(size: 13))
                                            .foregroundStyle(Color.auraTextSecondary)
                                            .lineSpacing(3)
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 18)
                                            .fill(Color.auraCard)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 18)
                                                    .stroke(memory.isCorrection ? Color.auraSuccess.opacity(0.3) : Color.auraBorder, lineWidth: 0.8)
                                            )
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Bộ nhớ AI")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Đóng") {
                        dismiss()
                    }
                    .foregroundStyle(Color.auraAmber)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddMemory = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.auraAmber)
                    }
                }
            }
            .sheet(isPresented: $showingAddMemory) {
                NavigationStack {
                    Form {
                        Section("Tiêu đề") {
                            TextField("Ví dụ: Sở thích ăn uống, Giờ làm việc...", text: $newTitle)
                        }
                        
                        Section("Phân loại") {
                            Picker("Danh mục", selection: $newCategory) {
                                Text("Sở thích").tag("preferences")
                                Text("Công việc").tag("work")
                                Text("Dự án").tag("projects")
                                Text("Gia đình").tag("family")
                                Text("Chung").tag("general")
                            }
                        }
                        
                        Section("Nội dung ghi nhớ") {
                            TextEditor(text: $newContent)
                                .frame(height: 100)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.auraBackground)
                    .navigationTitle("Thêm Ghi nhớ mới")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Hủy") { showingAddMemory = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Lưu") {
                                guard !newTitle.isEmpty, !newContent.isEmpty else { return }
                                _ = MemoryService.shared.saveMemory(
                                    title: newTitle,
                                    content: newContent,
                                    category: newCategory,
                                    in: modelContext
                                )
                                newTitle = ""
                                newContent = ""
                                showingAddMemory = false
                            }
                            .foregroundStyle(Color.auraAmber)
                        }
                    }
                }
                .presentationDetents([.medium])
            }
        }
    }
}
