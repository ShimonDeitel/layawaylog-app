import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [Item] = []
    @Published var isPro: Bool = false

    /// Free tier item cap. Deliberately set above the seed-data count so a
    /// fresh install never hits the paywall immediately.
    let freeLimit = 20

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("layawaylog_items.json")
    }()

    init() {
        load()
    }

    var isAtFreeLimit: Bool {
        !isPro && items.count >= freeLimit
    }

    func add(_ item: Item) -> Bool {
        guard !isAtFreeLimit else { return false }
        items.insert(item, at: 0)
        save()
        return true
    }

    func update(_ item: Item) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Item) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([Item].self, from: data) {
            items = decoded
        } else {
            items = [
            Item(field1: "Ana Reyes", field2: "600", status: "Active"),
            Item(field1: "Tom Baker", field2: "450", status: "Paid Off"),
            Item(field1: "Grace Lee", field2: "300", status: "Overdue"),
            Item(field1: "Wes Hunt", field2: "900", status: "Active"),
            Item(field1: "Nia Ford", field2: "250", status: "Active")
            ]
            save()
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
