//
//  ForecastCache.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/20.
//

import Foundation

final class ForecastCache {
    private let directory: URL
    private let fileManager = FileManager.default

    init(folderName: String = "ForecastCache") {
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        directory = caches.appendingPathComponent(folderName)
        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    private func fileName(lat: Double, lon: Double, locale: String) -> String {
        let latStr = String(format: "%.4f", lat)
        let lonStr = String(format: "%.4f", lon)
        return "\(latStr)_\(lonStr)_\(locale).json"
    }

    private func fileURL(lat: Double, lon: Double, locale: String) -> URL {
        return directory.appendingPathComponent(fileName(lat: lat, lon: lon, locale: locale))
    }

    // Save raw data
    func save(data: Data, lat: Double, lon: Double, locale: String) throws {
        let url = fileURL(lat: lat, lon: lon, locale: locale)
        try data.write(to: url)
    }

    // Load raw data
//    func load(lat: Double, lon: Double) throws -> Data? {
//        let url = fileURL(lat: lat, lon: lon)
//        guard fileManager.fileExists(atPath: url.path) else { return nil }
//        return try Data(contentsOf: url)
//    }

    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }

    func loadIfValid(lat: Double, lon: Double, locale: String) -> Data? {
        let url = fileURL(lat: lat, lon: lon, locale: locale)
        guard fileManager.fileExists(atPath: url.path) else { return nil }

        do {
            let attrs = try fileManager.attributesOfItem(atPath: url.path)
            if let modified = attrs[.modificationDate] as? Date,
               isSameDay(modified, Date()) {
                return try Data(contentsOf: url)
            }
        } catch {
            print("Failed to read file or metadata: \(error)")
        }
        return nil
    }
    
    func cleanUp(force: Bool = false) {
        guard let files = try? fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: [.contentModificationDateKey]) else {
            return
        }

        let calendar = Calendar.current
        let today = Date()

        for file in files {
            do {
                if force {
                    try fileManager.removeItem(at: file)
                    continue
                }

                let resourceValues = try file.resourceValues(forKeys: [.contentModificationDateKey])
                if let modifiedDate = resourceValues.contentModificationDate {
                    if !calendar.isDate(modifiedDate, inSameDayAs: today) {
                        try fileManager.removeItem(at: file)
                    }
                } else {
                    // If no date metadata, remove to be safe
                    try fileManager.removeItem(at: file)
                }
            } catch {
                print("Error deleting cache file: \(file.lastPathComponent) — \(error)")
            }
        }
    }}
