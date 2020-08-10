//
// Copyright © 2020 NHSX. All rights reserved.
//

import XCTest

class UseCaseBuilder {
    private(set) var useCase: UseCase
    private(set) var screenshots = [String: Data]()
    
    var app: XCUIApplication?
    var deviceConfiguration: DeviceConfiguration?
    
    init(useCase: UseCase) {
        self.useCase = useCase
    }
    
    func step(name: String, description: () -> String = { "" }) {
        guard let app = app, let deviceConfiguration = deviceConfiguration else {
            preconditionFailure("Can only add a step after setting the application and configuration.")
        }
        
        let fileName = "\(useCase.screenshotsFolderName)/\(name) (\(deviceConfiguration.joinedTags)).png"
        let data = app.windows.firstMatch.screenshot().pngRepresentation
        let screenshot = UseCase.Screenshot(fileName: fileName, tags: deviceConfiguration.screenshotTags)
        
        screenshots[fileName] = data
        
        if let index = useCase.steps.firstIndex(where: { $0.name == name }) {
            useCase.steps[index].screenshots.append(screenshot)
        } else {
            let step = UseCase.Step(
                name: name,
                description: description(),
                screenshots: [screenshot]
            )
            useCase.steps.append(step)
        }
    }
    
    func clearScreenshots() {
        screenshots.removeAll(keepingCapacity: true)
    }
}

private extension DeviceConfiguration {
    
    var joinedTags: String {
        screenshotTags.joined(separator: " - ")
    }
    
    var screenshotTags: [String] {
        [orientation.tag, contentSize.tag, interfaceStyle.tag]
    }
    
}

private extension UIDeviceOrientation {
    var tag: String {
        switch self {
        case .portrait: return "portrait"
        case .portraitUpsideDown: return "portrait-upside-down"
        case .landscapeRight: return "landscape-right"
        case .landscapeLeft: return "landscape-left"
        default: return "orientation-unknown"
        }
    }
}

private extension UIContentSizeCategory {
    var tag: String {
        switch self {
        case .extraSmall: return "content-size-XS"
        case .small: return "content-size-S"
        case .medium: return "content-size-M"
        case .large: return "content-size-L"
        case .extraLarge: return "content-size-XL"
        case .extraExtraLarge: return "content-size-XXL"
        case .extraExtraExtraLarge: return "content-size-XXXL"
        case .accessibilityMedium: return "content-size-AccessibilityM"
        case .accessibilityLarge: return "content-size-AccessibilityL"
        case .accessibilityExtraLarge: return "content-size-AccessibilityXL"
        case .accessibilityExtraExtraLarge: return "content-size-AccessibilityXXL"
        case .accessibilityExtraExtraExtraLarge: return "content-size-AccessibilityXXXL"
        default: return "content-size-unknown"
        }
    }
}

private extension InterfaceStyle {
    var tag: String {
        rawValue
    }
}
