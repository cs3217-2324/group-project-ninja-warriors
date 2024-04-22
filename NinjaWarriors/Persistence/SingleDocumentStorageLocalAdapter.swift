//
//  LocalStorageManager.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 21/4/24.
//

import Foundation

class SingleDocumentStorageLocalAdapter: SingleDocumentStorageManager {
    var localFile: String

    init(filename: String) {
        localFile = filename
    }

    func save<T: Codable>(_ object: T) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)

            guard let saveFileURL = getOrCreateFile(withName: localFile) else {
                assertionFailure("Could not get or create file")
                return
            }
            try data.write(to: saveFileURL)
        } catch {
            assertionFailure("Could not write data to file")
        }
    }

    func load<T>(_ completion: @escaping (T?, Error?) -> Void) where T: Decodable {
        let data: Data

        guard let file = getOrCreateFile(withName: localFile) else {
            completion(nil, NSError(domain: "AppErrorDomain", code: -1,
                                    userInfo: [NSLocalizedDescriptionKey:
                                                "Couldn't find documents directory when loading file"]))
            return
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            completion(nil, error)
            return
        }

        do {
            let decoder = JSONDecoder()
            let decodedObject = try decoder.decode(T.self, from: data)
            completion(decodedObject, nil) // Call completion handler with decoded object and no error
        } catch {
            completion(nil, error) // Call completion handler with decoding error
        }
    }

    private func getOrCreateFile(withName name: String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first else {
            return nil
        }

        let saveFileURL = documentsDirectory.appendingPathComponent(localFile)

        if !FileManager.default.fileExists(atPath: saveFileURL.path) {
            FileManager.default.createFile(atPath: saveFileURL.path, contents: nil, attributes: nil)
        }

        return saveFileURL
    }
}
