import RealmSwift

actor RealmActor {
    private var realm: Realm?
    
    init() {}
    
    func loadStationsSorted() async throws -> [RealmStation] {
        let db = try await existingOrNewRealmInstance()
        return Array(db.objects(RealmStation.self).sorted(by: \.index))
    }
    
    func save(stations: [RealmStation]) async throws {
        let db = try await existingOrNewRealmInstance()
        
        try await db.asyncWrite {
            db.deleteAll()
            for station in stations {
                db.create(RealmStation.self, value: station)
            }
        }
    }
}

private extension RealmActor {
    func existingOrNewRealmInstance() async throws -> Realm {
        if let realm = realm {
            return realm
        }
        
        let newInstance = try await Realm(actor: self)
        realm = newInstance
        return newInstance
    }
}
