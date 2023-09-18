//
//  FileUtils.swift
//
//
//  Created by Michael Borgmann on 17/09/2023.
//

import Foundation

/// A utility class for working with files and directories.
class FileUtils {
    
    /// Retrieves the contents of a directory specified by the given URL.
    ///
    /// - Parameter directoryURL: The URL of the directory to retrieve the contents of.
    /// - Returns: An array of `URL` objects representing the contents of the directory,
    ///            or `nil` if the directory does not exist or an error occurred.
    static func directoryContent(in directoryURL: URL) -> [URL]? {
        
        FileManager.default
            .enumerator(at: directoryURL, includingPropertiesForKeys: nil)?
            .allObjects
            .compactMap { $0 as? URL }
    }
}
