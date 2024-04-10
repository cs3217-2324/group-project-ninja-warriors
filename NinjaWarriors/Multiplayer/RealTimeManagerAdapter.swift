//
//  RealTimeManagerAdapter.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 18/3/24.
//

import Foundation
import FirebaseDatabase

final class RealTimeManagerAdapter: EntitiesManager {
    private let databaseRef = Database.database().reference()
    private var entitiesRef: DatabaseReference
    private let matchId: String
    private let componentKey = "component"
    private var listenerHandle: DatabaseHandle?
    private var test: [String: [String: Any]]?

    init(matchId: String) {
        self.matchId = matchId
        entitiesRef = databaseRef.child(matchId)
    }

    func getEntitiesRef() -> DatabaseReference {
        entitiesRef
    }

    // MARK: Decode / Retrieve
    private func getEntityTypes(from entitiesDict: [String: [String: Any]]) -> [String] {
        return Array(entitiesDict.keys)
    }

    private func getIds(of type: String, from entitiesDict: [String: [String: Any]]) -> [String] {
        guard let entitiesData = entitiesDict[type] else {
            return []
        }
        return Array(entitiesData.keys)
    }

    private func getComponentTypes(from idDict: [String: Any]) -> [String]? {
        return Array(idDict.keys)
    }

    private func getDict(from ref: DatabaseReference) async throws -> [String: [String: Any]] {
        let dataSnapshot = try await ref.getData()
        guard let dict = dataSnapshot.value as? [String: [String: Any]] else {
            throw NSError(domain: "Invalid data format", code: -1, userInfo: nil)
        }
        return dict
    }

    /*
    private func getEntititesDict() async throws -> [String: [String: Any]] {
        let dataSnapshot = try await entitiesRef.getData()
        guard let dict = dataSnapshot.value as? [String: [String: Any]] else {
            throw NSError(domain: "Invalid data format", code: -1, userInfo: nil)
        }
        return dict
    }
    */

    ///*
    private func testing() {
        // Fetch data once
        entitiesRef.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else {
                return
            }
            self.test = value
        }
    }

    //*/

    /*
    private func getEntitiesDict(completion: @escaping (Result<[String: [String: Any]], Error>) -> Void) {
        entitiesRef.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else {
                completion(.failure(NSError(domain: "Invalid data format", code: -1, userInfo: nil)))
                return
            }
            completion(.success(value))
        }
    }
    */

    /*
    private func getEntititesDict() async throws -> [String: [String: Any]] {
        let dataSnapshot = try await entitiesRef.getData()
        guard let entitiesDict = dataSnapshot.value as? [String: [String: Any]] else {
            throw NSError(domain: "Invalid entity data format", code: -1, userInfo: nil)
        }
        return entitiesDict
    }
    */

    /*
    private func getEntititesDict() async throws -> [String: [String: Any]] {
        // Record the start time
        var startTime = DispatchTime.now()

        // Fetch data asynchronously
        var dataSnapshot = try await entitiesRef.getData()

        // Record the end time after getting dataSnapshot
        var dataSnapshotTime = DispatchTime.now()

        // Calculate the time taken for getting dataSnapshot
        var timeToGetDataSnapshot = Double(dataSnapshotTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000
        print("Time taken to get dataSnapshot AAAA: \(timeToGetDataSnapshot) seconds")



        // Record the start time
        startTime = DispatchTime.now()

            testing { result in
                // Record the end time after fetching data
                let endTime = DispatchTime.now()

                switch result {
                case .success:
                    // Data fetched successfully
                    if let testData = self.getTestData() {
                        // Use the fetched data
                        print(testData)
                    } else {
                        print("No data available")
                    }
                case .failure(let error):
                    // Handle the error
                    print("Error fetching data: \(error)")
                }

                // Calculate the time difference
                let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                let elapsedTimeInSeconds = Double(elapsedTime) / 1_000_000_000
                print("Time taken for testing!!!: \(elapsedTimeInSeconds) seconds")
            }








        // Record the start time
        startTime = DispatchTime.now()

        // Fetch data asynchronously
        dataSnapshot = try await Database.database().reference().child("test").getData()

        // Record the end time after getting dataSnapshot
        dataSnapshotTime = DispatchTime.now()

        // Calculate the time taken for getting dataSnapshot
        timeToGetDataSnapshot = Double(dataSnapshotTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000
        print("Time taken to get dataSnapshot BBBB: \(timeToGetDataSnapshot) seconds")







        // Record the start time for extracting value from dataSnapshot
        let extractValueStartTime = DispatchTime.now()

        guard let entitiesDict = dataSnapshot.value as? [String: [String: Any]] else {
            throw NSError(domain: "Invalid entity data format", code: -1, userInfo: nil)
        }

        // Record the end time after extracting value from dataSnapshot
        let extractValueEndTime = DispatchTime.now()

        // Calculate the time taken for extracting value from dataSnapshot
        let timeToExtractValue = Double(extractValueEndTime.uptimeNanoseconds - extractValueStartTime.uptimeNanoseconds) / 1_000_000_000
        print("Time taken to extract value from dataSnapshot: \(timeToExtractValue) seconds")

        return entitiesDict
    }
    */

    private func getComponentTypeRegistry(for wrapperType: String) -> Codable.Type? {
        let wrapperTypes: [String: Codable.Type] = [
            "SkillCasterWrapper": SkillCasterWrapper.self,
            "SpriteWrapper": SpriteWrapper.self,
            "HealthWrapper": HealthWrapper.self,
            "ColliderWrapper": ColliderWrapper.self,
            "ScoreWrapper": ScoreWrapper.self,
            "RigidbodyWrapper": RigidbodyWrapper.self,
            "EnvironmentEffectWrapper": EnvironmentEffectWrapper.self
        ]
        return wrapperTypes[wrapperType]
    }

    private func getComponentWrapperType(of type: String) -> Codable.Type? {
        let wrapperTypeName = "\(type)" + Constants.wrapperName
        guard let wrapperType = getComponentTypeRegistry(for: wrapperTypeName) else {
            return nil
        }
        return wrapperType
    }

    private func getWrapperType(of type: String) -> Codable.Type? {
        let wrapperTypeName = "\(type)" + Constants.wrapperName
        guard let wrapperType = NSClassFromString(Constants.directory + wrapperTypeName) as? Codable.Type else {
            return nil
        }
        return wrapperType
    }

    private func getWrapperType(from id: EntityID) async throws -> String? {
        let (_, wrapperType) = try await decodeEntities(id: id)
        return wrapperType
    }

    private func getEntity(from dict: Any, with wrapper: Codable.Type) -> Entity? {
        do {
            let entityData = try JSONSerialization.data(withJSONObject: dict, options: [])
            guard let entityWrapper: EntityWrapper = try JSONDecoder().decode(wrapper, from: entityData) as? EntityWrapper else {
                return nil
            }
            guard let entity = entityWrapper.toEntity() else {
                return nil
            }
            return entity
        } catch {
            print("Error while getting entity:", error)
            return nil
        }
    }

    private func getEntititesDict() async throws -> [String: [String: Any]] {
        let dataSnapshot = try await entitiesRef.getData()
        guard let entitiesDict = dataSnapshot.value as? [String: [String: Any]] else {
            throw NSError(domain: "Invalid entity data format", code: -1, userInfo: nil)
        }
        return entitiesDict
    }

    private func decodeEntities(id: EntityID? = nil) async throws -> ([Entity]?, String?) {
        var entities: [Entity] = []
        let entitiesDict = try await getEntititesDict()
        let entityTypes = getEntityTypes(from: entitiesDict)

        for entityType in entityTypes {
            guard let wrapperType = getWrapperType(of: entityType) else {
                return (nil, nil)
            }
            let entityIds = getIds(of: entityType, from: entitiesDict)

            for entityId in entityIds {
                if id != nil && entityId != id {
                    continue
                }
                guard let dataDict = entitiesDict[entityType]?[entityId],
                      let entity = getEntity(from: dataDict, with: wrapperType) else {
                    return (nil, nil)
                }
                entities.append(entity)
                if id != nil && entityId == id {
                    return (entities, entityType)
                }
            }
        }
        return (entities, nil)
    }

    func getAllEntities() async throws -> [Entity]? {
        let (entities, _) = try await decodeEntities()
        return entities
    }

    func getEntity(entityId: EntityID) async throws -> Entity? {
        let (entities, _) = try await decodeEntities(id: entityId)
        guard let entities = entities else {
            return nil
        }
        return entities[0]
    }

    private func getComponent(from dict: Any, with wrapper: Codable.Type, ref: Entity) -> Component? {
        do {
            let componentData = try JSONSerialization.data(withJSONObject: dict, options: [])
            guard let componentWrapper: ComponentWrapper = try JSONDecoder().decode(wrapper, from: componentData) as? ComponentWrapper else {
                print("Error: Failed to decode component wrapper")
                return nil
            }

            guard let componentEntity = componentWrapper.toComponent(entity: ref) else {
                print("Error: Failed to convert wrapper to component for \(componentWrapper)")
                return nil
            }
            return componentEntity
        } catch {
            print("Error in decoding component: \(error)")
            print("Error dict", dict)
            return nil
        }
    }

    func getEntitiesWithComponents(_ entityId: EntityID) async throws -> ([Entity], [EntityID: [Component]]) {
        var entities: [Entity] = []
        var entityComponent: [EntityID: [Component]] = [:]
        let entitiesDict = try await getEntititesDict()
        let entityTypes = getEntityTypes(from: entitiesDict)

        for entityType in entityTypes {
            try processEntities(for: entityType, withEntities: entitiesDict, into: &entityComponent,
                                for: &entities, id: entityId)
        }
        return (entities, entityComponent)
    }

    /*
    func getEntitiesWithComponents() async throws -> ([Entity], [EntityID: [Component]]) {
        var entities: [Entity] = []
        var entityComponent: [EntityID: [Component]] = [:]
        let entitiesDict = try await getEntititesDict()
        let entityTypes = getEntityTypes(from: entitiesDict)

        for entityType in entityTypes {
            try processEntities(for: entityType, withEntities: entitiesDict, into: &entityComponent,
                                for: &entities, id: nil)
        }
        return (entities, entityComponent)
    }
    */

    func getEntitiesWithComponents() async throws -> ([Entity], [EntityID: [Component]]) {
        // Record the start time
        let startTime = DispatchTime.now()

        var entities: [Entity] = []
        var entityComponent: [EntityID: [Component]] = [:]

        // Record the start time for fetching entities dictionary
        let entitiesDictStartTime = DispatchTime.now()

        let entitiesDict = try await getEntititesDict()

        // Record the end time after fetching entities dictionary
        let entitiesDictEndTime = DispatchTime.now()

        // Calculate the time taken for fetching entities dictionary
        let entitiesDictTime = Double(entitiesDictEndTime.uptimeNanoseconds - entitiesDictStartTime.uptimeNanoseconds) / 1_000_000_000
        print("Time taken to get entities dictionary: \(entitiesDictTime) seconds")

        // Record the start time for getting entity types
        let entityTypesStartTime = DispatchTime.now()

        let entityTypes = getEntityTypes(from: entitiesDict)

        // Record the end time after getting entity types
        let entityTypesEndTime = DispatchTime.now()

        // Calculate the time taken for getting entity types
        let entityTypesTime = Double(entityTypesEndTime.uptimeNanoseconds - entityTypesStartTime.uptimeNanoseconds) / 1_000_000_000
        print("Time taken to get entity types: \(entityTypesTime) seconds")

        // Record the start time for processing entities
        let processEntitiesStartTime = DispatchTime.now()

        for entityType in entityTypes {
            try processEntities(for: entityType, withEntities: entitiesDict, into: &entityComponent,
                                for: &entities, id: nil)
        }

        // Record the end time after processing entities
        let processEntitiesEndTime = DispatchTime.now()

        // Calculate the time taken for processing entities
        let processEntitiesTime = Double(processEntitiesEndTime.uptimeNanoseconds - processEntitiesStartTime.uptimeNanoseconds) / 1_000_000_000
        print("Time taken to process entities: \(processEntitiesTime) seconds")

        // Record the end time
        let endTime = DispatchTime.now()

        // Calculate the total time taken for the entire function
        let totalTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000
        print("Total time taken for getEntitiesWithComponents: \(totalTime) seconds")

        return (entities, entityComponent)
    }


    private func processEntities(for entityType: String,
                                 withEntities entitiesDict: [String: [String: Any]],
                                 into entityComponent: inout [EntityID: [Component]],
                                 for entities: inout [Entity], id: EntityID?) throws {
        let entityIds = getIds(of: entityType, from: entitiesDict)

        for entityId in entityIds {
            if id != nil && entityId != id {
                continue
            }
            guard let data = entitiesDict[entityType]?[entityId] as? [String: Any] else {
                return
            }
            guard let idData = data[componentKey] as? [String: Any],
                  let componentTypes = getComponentTypes(from: idData) else {
                return
            }
            // Add any new entities to decode
            var entityInstance: Entity
            if entityType == "Player" {
                entityInstance = Player(id: entityId)
            } else if entityType == "Obstacle" {
                entityInstance = Obstacle(id: entityId)
            } else if entityType == "SlashAOE" {
                entityInstance = SlashAOE(id: entityId, casterEntity: Player(id: entityId))
            } else {
                entityInstance = ClosingZone(id: entityId)
            }

            try processComponents(for: entityId, withComponentTypes: componentTypes, from: idData,
                                  into: &entityComponent, for: &entities, ref: entityInstance)
        }
    }

    private func processComponents(for entityId: EntityID, withComponentTypes componentTypes: [String],
                                   from idData: [String: Any],
                                   into entityComponent: inout [EntityID: [Component]],
                                   for entities: inout [Entity], ref entityInstance: Entity) throws {

        for componentType in componentTypes {
            guard let componentWrapper = getComponentWrapperType(of: componentType),
                  let componentDict = idData[componentType],
                  let component = getComponent(from: componentDict, with: componentWrapper, ref: entityInstance) else {
                continue
            }
            if entityComponent[entityId] == nil {
                entityComponent[entityId] = [component]
            } else {
                entityComponent[entityId]?.append(component)
            }
        }
        remapAttachedCollider(with: entityId, from: &entityComponent)
        entities.append(entityInstance)
    }

    private func remapAttachedCollider(with entityId: EntityID,
                                       from entityComponent: inout [EntityID: [Component]]) {
        if let components = entityComponent[entityId] {
            var rigidbodyComponent: Rigidbody?
            var colliderComponent: Collider?

            for component in components {
                if let rigidbody = component as? Rigidbody {
                    rigidbodyComponent = rigidbody
                } else if let collider = component as? Collider {
                    colliderComponent = collider
                }
            }
            if let rigidbody = rigidbodyComponent, let collider = colliderComponent {
                rigidbody.attachedCollider = collider
            }
        }
    }

    // MARK: Encode / Upload
    private func formEntityDict(from entity: Entity) throws -> [String: Any] {
        let entityData = try JSONEncoder().encode(entity.wrapper())

        guard let entityDict = try JSONSerialization.jsonObject(with: entityData, options: []) as? [String: Any] else {
            throw NSError(domain: "com.yourapp", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to serialize player data"])
        }
        return entityDict
    }

    private func formComponentDict(from components: [Component]) -> [String: Any] {
        var componentDict: [String: Any] = [:]

        for (index, component) in components.enumerated() {
            let key = NSStringFromClass(type(of: component))
                .components(separatedBy: ".").last ?? componentKey + "\(index)"

            guard let data = component.wrapper(),
                  let componentData = try? JSONEncoder().encode(data),
                  let dataDict = try? JSONSerialization.jsonObject(with: componentData,
                                                                   options: []) as? [String: Any] else {
                continue
            }
            componentDict[key] = dataDict
        }
        return componentDict
    }

    func uploadEntity(entity: Entity, components: [Component]? = nil) async throws {
        let entityName = NSStringFromClass(type(of: entity))
            .components(separatedBy: ".").last ?? "entity"

        let entityRef = entitiesRef.child(entityName).child(entity.id)

        entityRef.observeSingleEvent(of: .value) { [unowned self] snapshot in
            //guard let self = self else { return print("return")}

            if snapshot.exists() {
                self.updateExistingEntity(snapshot, entityRef, entity, components)

            } else {
                
                if let components = components {
                    self.createEntity(snapshot, entityRef, entity, components)
                } else {
                    self.createEntity(snapshot, entityRef, entity)
                }
            }
        }
    }

    private func updateExistingEntity(_ snapshot: DataSnapshot, _ entityRef: DatabaseReference,
                              _ entity: Entity, _ components: [Component]?) {
        guard var entityDict = snapshot.value as? [String: Any] else {
            print("Data at \(entityRef) is not in the expected format")
            return
        }

        guard let components = components else {
            return
        }
        // Case 1a: If componentKey exists, merge newComponentDict with existingComponentDict
        if entityDict[self.componentKey] is [String: Any] {
            updateExistingComponents(&entityDict, components)
        // Case 1b: If componentKey doesn't exist, append newComponentDict
        } else {
            appendNewComponents(&entityDict, components)
        }
        entityRef.setValue(entityDict)
    }

    private func updateExistingComponents(_ entityDict: inout [String: Any], _ components: [Component]) {
        guard var existingComponentDict = entityDict[componentKey] as? [String: Any] else { return }

        let newComponentDict = formComponentDict(from: components)
        existingComponentDict.merge(newComponentDict) { (_, new) in new }
        entityDict[componentKey] = existingComponentDict
    }

    private func appendNewComponents(_ entityDict: inout [String: Any], _ components: [Component]) {
        let newComponentDict = formComponentDict(from: components)
        entityDict[componentKey] = newComponentDict
    }

    private func createEntity(_ snapshot: DataSnapshot, _ entityRef: DatabaseReference, _ entity: Entity, _ components: [Component]? = nil) {
        var newEntityDict: [String: Any] = [:]

        if let entityDict = try? formEntityDict(from: entity) {
            newEntityDict.merge(entityDict) { (_, new) in new }
        }

        let finalComponents = components ?? entity.getInitializingComponents()
            
        let componentDict = formComponentDict(from: finalComponents)
        newEntityDict[componentKey] = componentDict

        entityRef.setValue(newEntityDict)
    }

    // MARK: Delete
    func delete(entity: Entity) {
        let entityName = NSStringFromClass(type(of: entity))
            .components(separatedBy: ".").last ?? "entity"

        let entityId = entity.id

        let entityRef = entitiesRef.child(entityName).child(entityId)
        entityRef.removeValue { error, _ in
            if let error = error {
                print("Error deleting entity: \(error)")
            } else {
                print("Entity deleted successfully")
            }
        }
    }

    func delete(component: Component, from entity: Entity) {
        let entityName = NSStringFromClass(type(of: entity))
            .components(separatedBy: ".").last ?? "entity"

        let componentName = NSStringFromClass(type(of: component))
            .components(separatedBy: ".").last ?? "component"

        let entityId = entity.id

        let entityRef = entitiesRef.child(entityName).child(entityId)
            .child(componentKey).child(componentName)

        entityRef.removeValue { error, _ in
            if let error = error {
                print("Error deleting component: \(error)")
            } else {
                print("Entity deleted successfully")
            }
        }
    }

    func delete() {
        entitiesRef.removeValue { error, _ in
            if let error = error {
                print("Error deleting match data: \(error)")
            } else {
                print("Entity deleted successfully")
            }
        }
    }

    func deleteAllKeysExcept(matchId: String) {
        let ref = Database.database().reference()
        ref.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists() else {
                return
            }

            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let key = rest.key
                if key != matchId {
                    ref.child(key).removeValue()
                }
            }
        }
    }

    // MARK: Listeners
    func addEntitiesListener(completion: @escaping (DataSnapshot) -> Void) {
        removeEntitiesListener()
        listenerHandle = entitiesRef.observe(.value) { snapshot in
            completion(snapshot)
        }
    }

    func removeEntitiesListener() {
        if let handle = listenerHandle {
            entitiesRef.removeObserver(withHandle: handle)
        }
        listenerHandle = nil
    }

    func addPlayerListeners() -> [PlayerPublisher] {
        var listenerPublishers: [PlayerPublisher] = []
        let playersListener = PlayersListener(matchId: matchId)
        playersListener.startListening()

        listenerPublishers.append(playersListener.getPublisher())
        return listenerPublishers
    }
}
