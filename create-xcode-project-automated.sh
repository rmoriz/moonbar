#!/bin/bash

# Automated Xcode project creation script
echo "🏗️ Creating Moonbar Xcode Project"
echo "================================="

PROJECT_NAME="Moonbar"
BUNDLE_ID="com.moriz.moonbar"

# Create project directory structure
echo "📁 Creating project structure..."
mkdir -p "$PROJECT_NAME.xcodeproj"
mkdir -p "$PROJECT_NAME"
mkdir -p "${PROJECT_NAME}Tests"

# Create basic project.pbxproj file
cat > "$PROJECT_NAME.xcodeproj/project.pbxproj" << 'EOF'
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
		1A000001000000000000001 /* main.swift in Sources */ = {isa = PBXBuildFile; fileRef = 1A000002000000000000001 /* main.swift */; };
		1A000003000000000000001 /* AppDelegate.swift in Sources */ = {isa = PBXBuildFile; fileRef = 1A000004000000000000001 /* AppDelegate.swift */; };
		1A000005000000000000001 /* BalanceProvider.swift in Sources */ = {isa = PBXBuildFile; fileRef = 1A000006000000000000001 /* BalanceProvider.swift */; };
		1A000007000000000000001 /* MoonshotProvider.swift in Sources */ = {isa = PBXBuildFile; fileRef = 1A000008000000000000001 /* MoonshotProvider.swift */; };
		1A000009000000000000001 /* Account.swift in Sources */ = {isa = PBXBuildFile; fileRef = 1A00000A000000000000001 /* Account.swift */; };
		1A00000B000000000000001 /* BalanceManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = 1A00000C000000000000001 /* BalanceManager.swift */; };
		1A00000D000000000000001 /* BalanceFetcher.swift in Sources */ = {isa = PBXBuildFile; fileRef = 1A00000E000000000000001 /* BalanceFetcher.swift */; };
		1A00000F000000000000001 /* Logger.swift in Sources */ = {isa = PBXBuildFile; fileRef = 1A000010000000000000001 /* Logger.swift */; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
		1A000001000000000000000 /* Moonbar.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = Moonbar.app; sourceTree = BUILT_PRODUCTS_DIR; };
		1A000002000000000000001 /* main.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = main.swift; sourceTree = "<group>"; };
		1A000004000000000000001 /* AppDelegate.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AppDelegate.swift; sourceTree = "<group>"; };
		1A000006000000000000001 /* BalanceProvider.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = BalanceProvider.swift; sourceTree = "<group>"; };
		1A000008000000000000001 /* MoonshotProvider.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MoonshotProvider.swift; sourceTree = "<group>"; };
		1A00000A000000000000001 /* Account.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Account.swift; sourceTree = "<group>"; };
		1A00000C000000000000001 /* BalanceManager.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = BalanceManager.swift; sourceTree = "<group>"; };
		1A00000E000000000000001 /* BalanceFetcher.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = BalanceFetcher.swift; sourceTree = "<group>"; };
		1A000010000000000000001 /* Logger.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Logger.swift; sourceTree = "<group>"; };
		1A000011000000000000001 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		1A000012000000000000001 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		1A000013000000000000001 = {
			isa = PBXGroup;
			children = (
				1A000014000000000000001 /* Moonbar */,
				1A000015000000000000001 /* Products */,
			);
			sourceTree = "<group>";
		};
		1A000014000000000000001 /* Moonbar */ = {
			isa = PBXGroup;
			children = (
				1A000016000000000000001 /* App */,
				1A000017000000000000001 /* Models */,
				1A000018000000000000001 /* Services */,
				1A000019000000000000001 /* Utilities */,
				1A000011000000000000001 /* Info.plist */,
			);
			path = Moonbar;
			sourceTree = "<group>";
		};
		1A000015000000000000001 /* Products */ = {
			isa = PBXGroup;
			children = (
				1A000001000000000000000 /* Moonbar.app */,
			);
			name = Products;
			sourceTree = "<group>";
		};
		1A000016000000000000001 /* App */ = {
			isa = PBXGroup;
			children = (
				1A000002000000000000001 /* main.swift */,
				1A000004000000000000001 /* AppDelegate.swift */,
			);
			path = App;
			sourceTree = "<group>";
		};
		1A000017000000000000001 /* Models */ = {
			isa = PBXGroup;
			children = (
				1A000006000000000000001 /* BalanceProvider.swift */,
				1A000008000000000000001 /* MoonshotProvider.swift */,
				1A00000A000000000000001 /* Account.swift */,
			);
			path = Models;
			sourceTree = "<group>";
		};
		1A000018000000000000001 /* Services */ = {
			isa = PBXGroup;
			children = (
				1A00000C000000000000001 /* BalanceManager.swift */,
				1A00000E000000000000001 /* BalanceFetcher.swift */,
			);
			path = Services;
			sourceTree = "<group>";
		};
		1A000019000000000000001 /* Utilities */ = {
			isa = PBXGroup;
			children = (
				1A000010000000000000001 /* Logger.swift */,
			);
			path = Utilities;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		1A00001A000000000000001 /* Moonbar */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = 1A00001B000000000000001 /* Build configuration list for PBXNativeTarget "Moonbar" */;
			buildPhases = (
				1A00001C000000000000001 /* Sources */,
				1A000012000000000000001 /* Frameworks */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = Moonbar;
			productName = Moonbar;
			productReference = 1A000001000000000000000 /* Moonbar.app */;
			productType = "com.apple.product-type.application";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		1A00001D000000000000001 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1540;
				LastUpgradeCheck = 1540;
				TargetAttributes = {
					1A00001A000000000000001 = {
						CreatedOnToolsVersion = 15.4;
					};
				};
			};
			buildConfigurationList = 1A00001E000000000000001 /* Build configuration list for PBXProject "Moonbar" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = 1A000013000000000000001;
			productRefGroup = 1A000015000000000000001 /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				1A00001A000000000000001 /* Moonbar */,
			);
		};
/* End PBXProject section */

/* Begin PBXSourcesBuildPhase section */
		1A00001C000000000000001 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				1A000001000000000000001 /* main.swift in Sources */,
				1A000003000000000000001 /* AppDelegate.swift in Sources */,
				1A000005000000000000001 /* BalanceProvider.swift in Sources */,
				1A000007000000000000001 /* MoonshotProvider.swift in Sources */,
				1A000009000000000000001 /* Account.swift in Sources */,
				1A00000B000000000000001 /* BalanceManager.swift in Sources */,
				1A00000D000000000000001 /* BalanceFetcher.swift in Sources */,
				1A00000F000000000000001 /* Logger.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		1A00001F000000000000001 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MACOSX_DEPLOYMENT_TARGET = 12.0;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = macosx;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			};
			name = Debug;
		};
		1A000020000000000000001 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MACOSX_DEPLOYMENT_TARGET = 12.0;
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = macosx;
				SWIFT_COMPILATION_MODE = wholemodule;
			};
			name = Release;
		};
		1A000021000000000000001 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				CODE_SIGN_ENTITLEMENTS = "";
				CODE_SIGN_STYLE = Automatic;
				COMBINE_HIDPI_IMAGES = YES;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				ENABLE_HARDENED_RUNTIME = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = Moonbar/Info.plist;
				INFOPLIST_KEY_NSHumanReadableCopyright = "Copyright © 2025 Moriz GmbH. All rights reserved.";
				INFOPLIST_KEY_NSMainNibFile = "";
				INFOPLIST_KEY_NSPrincipalClass = "";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/../Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.moriz.moonbar;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
			};
			name = Debug;
		};
		1A000022000000000000001 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				CODE_SIGN_ENTITLEMENTS = "";
				CODE_SIGN_STYLE = Automatic;
				COMBINE_HIDPI_IMAGES = YES;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				ENABLE_HARDENED_RUNTIME = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = Moonbar/Info.plist;
				INFOPLIST_KEY_NSHumanReadableCopyright = "Copyright © 2025 Moriz GmbH. All rights reserved.";
				INFOPLIST_KEY_NSMainNibFile = "";
				INFOPLIST_KEY_NSPrincipalClass = "";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/../Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.moriz.moonbar;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		1A00001B000000000000001 /* Build configuration list for PBXNativeTarget "Moonbar" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				1A000021000000000000001 /* Debug */,
				1A000022000000000000001 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		1A00001E000000000000001 /* Build configuration list for PBXProject "Moonbar" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				1A00001F000000000000001 /* Debug */,
				1A000020000000000000001 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */
	};
	rootObject = 1A00001D000000000000001 /* Project object */;
}
EOF

# Copy source files to Xcode project structure
echo "📄 Copying source files..."
cp -r Sources/* "$PROJECT_NAME/"

# Create Info.plist
cat > "$PROJECT_NAME/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>$(DEVELOPMENT_LANGUAGE)</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIconFile</key>
	<string></string>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>$(PRODUCT_NAME)</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>1.0</string>
	<key>CFBundleVersion</key>
	<string>1</string>
	<key>LSMinimumSystemVersion</key>
	<string>$(MACOSX_DEPLOYMENT_TARGET)</string>
	<key>LSUIElement</key>
	<true/>
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSExceptionDomains</key>
		<dict>
			<key>api.moonshot.ai</key>
			<dict>
				<key>NSExceptionRequiresForwardSecrecy</key>
				<false/>
				<key>NSExceptionMinimumTLSVersion</key>
				<string>TLSv1.2</string>
			</dict>
		</dict>
	</dict>
</dict>
</plist>
EOF

echo "✅ Xcode project created successfully!"
echo ""
echo "🚀 To test the project:"
echo "1. Set your API key: export MOONSHOT_API_KEY=\"sk-your-key\""
echo "2. Open project: open Moonbar.xcodeproj"
echo "3. Build and run: ⌘R"
echo ""
echo "📁 Project structure:"
find "$PROJECT_NAME" -type f -name "*.swift" | head -10