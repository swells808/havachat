//
//  ArtistSettingsSection.swift
//  havachat
//
//  Created by Sean Wells on 5/2/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

protocol SectionType {
    var containsSwitch: Bool { get }
}

enum ArtistSettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Social
    case Communications

    var description: String {
        switch self {
        case .Social: return "Social"
        case .Communications: return "Communications"
        }
    }
}

enum SocialOptions: Int, CaseIterable, SectionType {
    case editProfile
    case logout
    
    var containsSwitch: Bool { return false }
    
    var description: String {
        switch self {
        case .editProfile: return "Edit Profile"
        case .logout: return "Logout"
        }
    }
}

enum CommunicationOptions: Int, CaseIterable, SectionType {
    case notifications
    case email
    case reportCrashes
    
    var containsSwitch: Bool {
        switch self {
        case .notifications: return true
        case .email: return false
        case .reportCrashes: return false 
        }
    }
    
    var description: String {
        switch self {
        case .notifications: return "Notifications"
        case .email: return "Email"
        case .reportCrashes: return "Report Crashes"
        }
    }
}
