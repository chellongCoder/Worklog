//
//  ShieldConfigurationExtension.swift
//  ShieldConfigurationExtension
//
//  Created by Longnn on 05/05/2024.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        ShieldConfiguration(backgroundBlurStyle: UIBlurEffect.Style.dark,
                            icon: UIImage(systemName: "stopwatch"),
                            title: ShieldConfiguration.Label(text: "No app for you", color: .black),
                            subtitle: ShieldConfiguration.Label(text: "Sorry, no apps for you", color: .black),
                            primaryButtonLabel: ShieldConfiguration.Label(text: "Ask for a break?", color: .white),
                            secondaryButtonLabel: ShieldConfiguration.Label(text: "Quick Quick", color: .blue))
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        ShieldConfiguration(backgroundBlurStyle: UIBlurEffect.Style.extraLight,
                            icon: UIImage(systemName: "stopwatch"),
                            title: ShieldConfiguration.Label(text: "No app for you", color: .black),
                            subtitle: ShieldConfiguration.Label(text: "Sorry, no apps for you", color: .black),
                            primaryButtonLabel: ShieldConfiguration.Label(text: "Ask for a break?", color: .white),
                            secondaryButtonLabel: ShieldConfiguration.Label(text: "Quick Quick", color: .blue))
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration(backgroundBlurStyle: UIBlurEffect.Style.systemThickMaterial,
                            backgroundColor: UIColor.white,
                            icon: UIImage(systemName: "stopwatch"),
                            title: ShieldConfiguration.Label(text: "No app for you", color: .black),
                            subtitle: ShieldConfiguration.Label(text: "Sorry, no apps for you", color: .black),
                            primaryButtonLabel: ShieldConfiguration.Label(text: "Ask for a break?", color: .white),
                            secondaryButtonLabel: ShieldConfiguration.Label(text: "Quick Quick", color: .blue))
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration(backgroundBlurStyle: UIBlurEffect.Style.systemThickMaterial,
                            backgroundColor: UIColor.white,
                            icon: UIImage(systemName: "stopwatch"),
                            title: ShieldConfiguration.Label(text: "No app for you", color: .black),
                            subtitle: ShieldConfiguration.Label(text: "Sorry, no apps for you", color: .black),
                            primaryButtonLabel: ShieldConfiguration.Label(text: "Ask for a break?", color: .white),
                            secondaryButtonLabel: ShieldConfiguration.Label(text: "Quick Quick", color: .blue))
    }
}
