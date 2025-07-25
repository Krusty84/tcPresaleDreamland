//
//  Teamcenter.swift
//  tcPresaleDreamland
//
//  Created by Sedoykin Alexey on 02/06/2025.
//

import Foundation

// MARK: Codable models for the login response

/// Holds server info fields from login response
struct ServerInfo: Codable {
    let DisplayVersion: String?  // Version display string
    let HostName: String?        // Server host name
    let Locale: String?          // Server locale code
    let LogFile: String?         // Path to server log file
    let SiteLocale: String?      // Locale for the site
    let TcServerID: String?      // Teamcenter server ID
    let UserID: String?          // Logged-in user ID
    let Version: String?         // Server version number
}

/// Top-level login response with QName and serverInfo
struct LoginResponse: Codable {
    let qName: String?           // XML QName value
    let serverInfo: ServerInfo?  // Server information

    enum CodingKeys: String, CodingKey {
        case qName = ".QName"    // Map JSON field ".QName"
        case serverInfo = "serverInfo"
    }
}

/// Represents a session object with IDs and type info
struct SessionObject: Codable {
    let objectID: String?   // Optional object identifier
    let cParamID: String?   // Optional parameter ID
    let uid: String         // Unique ID
    let className: String   // Class name of object
    let type: String        // Object type string
}

typealias ExtraInfo = [String: String]  // Simple key-value extra info

/// Service data includes plain strings and basic folder models
struct SessionServiceData: Codable {
    let plain: [String]                       // Plain text entries
    let modelObjects: [String: FolderBasic]   // FolderBasic models by UID
}

/// Full response for GetTCSessionInfo API call
struct SessionInfoResponse: Codable {
    let qName: String?                 // XML QName
    let serverVersion: String          // Version of server
    let transientVolRootDir: String    // Root directory for transients
    let isInV7Mode: Bool               // Mode flag
    let moduleNumber: Int              // Module number
    let bypass: Bool                   // Bypass setting
    let journaling: Bool               // Journaling enabled
    let appJournaling: Bool            // App journaling
    let secJournaling: Bool            // Security journaling
    let admJournaling: Bool            // Admin journaling
    let privileged: Bool               // Privileged session flag
    let isPartBOMUsageEnabled: Bool    // BOM part usage
    let isSubscriptionMgrEnabled: Bool // Subscription manager

    // Main session objects for user, group, role, etc.
    let user: SessionObject
    let group: SessionObject
    let role: SessionObject
    let tcVolume: SessionObject
    let project: SessionObject
    let workContext: SessionObject
    let site: SessionObject

    let textInfos: [String]            // Text info entries
    let extraInfo: ExtraInfo           // Extra key-value pairs
    let serviceData: SessionServiceData? // Optional service data

    enum CodingKeys: String, CodingKey {
        case qName = ".QName"
        case serverVersion, transientVolRootDir, isInV7Mode, moduleNumber
        case bypass, journaling, appJournaling, secJournaling, admJournaling
        case privileged, isPartBOMUsageEnabled, isSubscriptionMgrEnabled
        case user, group, role, tcVolume, project, workContext, site
        case textInfos, extraInfo
        case serviceData = "ServiceData"
    }
}

// MARK: Codable models for expandFolder response

/// Basic info for a folder, may be in first level or modelObjects
struct FolderBasic: Codable {
    let objectID: String? // Optional ID if present
    let uid: String       // Unique identifier
    let className: String // Class name string
    let type: String      // Object type
}

/// One element of "output" array from expandFolder API
struct ExpandFolderOutput: Codable {
    let inputFolder: FolderBasic     // The folder we expanded
    let fstlvlFolders: [FolderBasic] // Subfolders at first level
    // itemsOutput and itemRevsOutput can be added if needed
}

/// ServiceData for expandFolder with plain entries and modelObjects
struct ExpandServiceData: Codable {
    let plain: [String]                        // Plain text entries
    let modelObjects: [String: FolderBasic]    // FolderBasic models by UID
}

/// Top-level response for expandFolder API
struct ExpandFolderResponse: Codable {
    let qName: String?                      // XML QName
    let output: [ExpandFolderOutput]?       // Expand output list
    let serviceData: ExpandServiceData?     // Service data

    enum CodingKeys: String, CodingKey {
        case qName = ".QName"
        case output
        case serviceData = "ServiceData"
    }
}

// MARK: Codable models for getProperties response

/// Holds database and UI values for one property
struct PropertyValue: Codable {
    let dbValues: [String]?  // Raw database values
    let uiValues: [String]?  // Formatted UI values
}

/// One model object entry in getProperties response
struct ModelObject: Codable {
    let objectID: String?                // Optional object ID
    let uid: String?                     // Unique ID
    let className: String?               // Class name
    let type: String?                    // Object type
    let props: [String: PropertyValue]?  // Property values by name
}

/// Top-level response for getProperties API
struct GetPropertiesResponse: Codable {
    let qName: String?                          // XML QName
    let plain: [String]?                        // Plain text entries
    let modelObjects: [String: ModelObject]?    // ModelObject entries by UID

    enum CodingKeys: String, CodingKey {
        case qName = ".QName"
        case plain, modelObjects
    }
}

// MARK: Codable models for createItem response

/// Output for createItem API: nested item and revision
struct CreateItemsOutput: Codable {
    struct NestedObject: Codable {
        let uid: String  // UID of created item or revision
    }
    let item: NestedObject    // Created item
    let itemRev: NestedObject // Created item revision
}

/// Top-level for createItem API
struct CreateItemsResponse: Codable {
    let output: [CreateItemsOutput]?  // List of created outputs

    enum CodingKeys: String, CodingKey {
        case output
    }
}

// MARK: Codable models for createFolder response

/// Output for createFolder API: nested folder object
struct CreateFoldersOutput: Codable {
    struct FolderObj: Codable {
        let uid: String      // UID of new folder
        let className: String // Class name of folder
        let type: String     // Object type string
    }
    let folder: FolderObj   // Created folder object
}

/// Top-level for createFolder API
struct CreateFoldersResponse: Codable {
    let output: [CreateFoldersOutput]?  // List of created folders

    enum CodingKeys: String, CodingKey {
        case output
    }
}

// MARK: Codable models for getItemFromId response

/// Top-level response for getItemFromId API
struct GetItemFromIdResponse: Codable {
    let qName: String?                 // e.g. "...GetItemFromIdResponse"
    let output: [GetItemFromIdOutput]? // Array of item + revision outputs

    enum CodingKeys: String, CodingKey {
        case qName = ".QName"
        case output
    }
}

/// One entry of item + its revisions
struct GetItemFromIdOutput: Codable {
    let item: FolderBasic            // Reuses FolderBasic (uid, className, type)
    let itemRevOutput: [ItemRevOutput]

    enum CodingKeys: String, CodingKey {
        case item
        case itemRevOutput
    }
}

/// Wrapper for the revision inside GetItemFromIdOutput
struct ItemRevOutput: Codable {
    let itemRevision: FolderBasic    // uid, className, type
}

// MARK: Codable models for createBOMWindows response

/// Top-level response for CreateBOMWindows API
struct CreateBOMWindowsResponse: Codable {
    let qName: String?                        // e.g. "...CreateBOMWindowsResponse"
    let output: [CreateBOMWindowsOutput]?     // List of outputs

    enum CodingKeys: String, CodingKey {
        case qName = ".QName"
        case output
    }
}

/// One output entry with window and line
struct CreateBOMWindowsOutput: Codable {
    let clientId: String                      // Echoed clientId
    let bomWindow: FolderBasic                // UID, className, type of BOMWindow
    let bomLine: FolderBasic                  // UID, className, type of BOMLine
}

// MARK: Codable models for saveBOMWindows response

/// Top-level for SaveBOMWindows API
struct SaveBOMWindowsResponse: Codable {
    let qName: String?                      // e.g. "...SaveBOMWindowsResponse"
    let serviceData: SaveBOMWindowsServiceData

    enum CodingKeys: String, CodingKey {
        case qName = ".QName"
        case serviceData = "ServiceData"
    }
}

/// Holds the list of updated UIDs and any returned objects
struct SaveBOMWindowsServiceData: Codable {
    let updated: [String]                   // UIDs of updated objects
    let modelObjects: [String: ModelObject] // Map of UID → full object info

    enum CodingKeys: String, CodingKey {
        case updated
        case modelObjects = "modelObjects"
    }
}


// MARK: Codable models for closeBOMWindows response

/// Top-level response for CloseBOMWindows API
struct CloseBOMWindowsResponse: Codable {
    let qName: String?                          // e.g. "...CloseBOMWindowsResponse"
    let serviceData: CloseBOMWindowsServiceData // decoded from "ServiceData"

    enum CodingKeys: String, CodingKey {
        case qName = ".QName"
        case serviceData = "ServiceData"
    }
}

/// Holds the list of deleted BOM window UIDs
struct CloseBOMWindowsServiceData: Codable {
    let deleted: [String]
}

// MARK: Codable models for addOrUpdateChildrenToParentLine response

/// Top-level response for AddOrUpdateChildrenToParentLine API
struct AddOrUpdateChildrenToParentLineResponse: Codable {
    let qName: String?                                 // XML QName
    let itemLines: [ItemLine]?                         // Updated or created child lines
    let itemelementLines: [ItemElementLine]?           // Updated or created element‐lines
    let serviceData: AddOrUpdateChildrenServiceData?   // Created/updated UIDs & errors

    enum CodingKeys: String, CodingKey {
        case qName    = ".QName"
        case itemLines
        case itemelementLines
        case serviceData = "ServiceData"
    }
}

/// One BOM‐line entry in the response
struct ItemLine: Codable {
    let clientId: String
    let bomline: FolderBasic
}

/// One element‐line entry (if any) in the response
struct ItemElementLine: Codable {
    let clientId: String
    let itemelementLine: FolderBasic
}

/// ServiceData with created/updated UIDs and any partial errors
struct AddOrUpdateChildrenServiceData: Codable {
    let updated: [String]?
    let created: [String]?
    let modelObjects: [String: FolderBasic]?
    let partialErrors: [PartialError]?

    enum CodingKeys: String, CodingKey {
        case updated, created, modelObjects, partialErrors
    }
}

/// One error block for a single UID
struct PartialError: Codable {
    let uid: String
    let errorValues: [ErrorValue]
}

/// Detailed error info
struct ErrorValue: Codable {
    let message: String
    let code: Int
    let level: Int
}



