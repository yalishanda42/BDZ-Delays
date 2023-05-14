import RealmSwift

class RealmStation: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var index: Int
    
    convenience init(id: Int, index: Int) {
        self.init()
        self.id = id
        self.index = index
    }
}
