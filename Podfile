xcodeproj 'Slickster/Slickster.xcodeproj'
use_frameworks!

target 'Slickster' do
    
    pod 'AFNetworking', '2.6.1'
    pod 'BDBOAuth1Manager', '1.6.0'
    pod 'SwipeView', '1.3.2'
    pod 'FontAwesome.swift', '0.6.3'
    pod 'SVProgressHUD', '1.1.3'
    pod 'Parse', '1.13.0'
    pod 'ParseUI', '1.2.0'
    pod 'Bolts', '1.8.4'
    pod 'ParseFacebookUtilsV4', '1.11.1'
    pod 'ParseTwitterUtils', '1.11.0'
    pod 'FBSDKCoreKit', '4.17.0'
    pod 'FBSDKLoginKit', '4.17.0'
    pod 'FBSDKShareKit', '4.17.0'
    pod 'DrawerController', '1.1.1'
    pod 'SwiftyJSON', '2.3.3'
    pod 'CVCalendar', '1.3.1'
    pod 'GoogleUtilities', '1.1.0'
    pod 'GoogleAppUtilities', '1.0.0'
    pod 'GoogleAuthUtilities', '1.0.1'
    pod 'GoogleInterchangeUtilities', '1.1.0'
    pod 'GoogleNetworkingUtilities', '1.0.0'
    pod 'GoogleSymbolUtilities', '1.0.3'
    pod 'Google/SignIn', '1.2.1'
    pod 'TPKeyboardAvoiding', '1.2.10'
    pod 'DBCamera', '2.4.1'
    pod 'QBImagePickerController', '3.2.0'
    pod 'Fabric', '1.6.7'
    pod 'Crashlytics', '3.7.0'
    pod 'CSStickyHeaderFlowLayout', '0.2.10'
end

# Strip alpha/beta notations from build numbers
post_install do |installer|
    plist_buddy = "/usr/libexec/PlistBuddy"
    
    installer.pods_project.targets.each do |target|
        plist = "Pods/Target Support Files/#{target}/Info.plist"
        version = `#{plist_buddy} -c "Print CFBundleShortVersionString" "#{plist}"`.strip
        
        stripped_version = /([\d\.]+)/.match(version).captures[0]
        
        version_parts = stripped_version.split('.').map { |s| s.to_i }
        
        # ignore properly formatted versions
        unless version_parts.slice(0..2).join('.') == version
            
            major, minor, patch = version_parts
            
            major ||= 0
            minor ||= 0
            patch ||= 999
            
            fixed_version = "#{major}.#{minor}.#{patch}"
            
            puts "Changing version of #{target} from #{version} to #{fixed_version} to make it pass iTC verification."
            
            `#{plist_buddy} -c "Set CFBundleShortVersionString #{fixed_version}" "#{plist}"`
        end
    end
end