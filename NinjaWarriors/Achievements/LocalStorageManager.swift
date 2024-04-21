//
//  LocalStorageManager.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 21/4/24.
//

import Foundation

class LocalStorageManager: StorageManager {
    var localFile: String

    init(filename: String) {
        localFile = filename
    }

    func save<T>(_ object: T) where T: Decodable, T: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)

            guard let saveFileURL = getOrCreateFile(withName: localFile) else {
                assertionFailure("Couldn't find documents directory when saving file")
                return
            }

            try data.write(to: saveFileURL)
        } catch {
            assertionFailure("Couldn't write data to file")
        }
    }

    func load<T>() -> T? where T: Decodable {
        let data: Data

        guard let file = getOrCreateFile(withName: localFile) else {
            assertionFailure("Couldn't find documents directory when loading file")
            return nil
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            assertionFailure("Data couldn't be loaded from file")
            return nil
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            assertionFailure("Couldn't decode JSON")
            return nil
        }
    }

    private func getOrCreateFile(withName name: String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        let saveFileURL = documentsDirectory.appendingPathComponent(localFile)

        if !FileManager.default.fileExists(atPath: saveFileURL.path) {
            FileManager.default.createFile(atPath: saveFileURL.path, contents: nil, attributes: nil)
        }

        return saveFileURL
    }
}
