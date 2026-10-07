import os

files = [
    "AuraApp.swift",
    "Theme/AuraTheme.swift",
    "Views/MainTabView.swift",
    "Views/Chat/ChatView.swift",
    "Views/Today/TodayView.swift",
    "Views/Tasks/TasksView.swift",
    "Views/Profile/ProfileView.swift",
    "Views/Onboarding/OnboardingView.swift",
    "Views/Modals/CapabilitiesSheet.swift",
    "Views/Modals/ConnectedAppsSheet.swift",
    "Views/Modals/UsageSheet.swift",
    "Views/Modals/WidgetsPreviewSheet.swift",
    "Views/Modals/LiveActivitiesSheet.swift",
    "Views/Modals/CalendarSyncSheet.swift"
]

pbx_dir = "AuraIOS/Aura.xcodeproj"
os.makedirs(pbx_dir, exist_ok=True)

# Generate unique IDs
file_refs = {}
build_files = {}

idx = 100
for f in files:
    fid = f"AA{idx:06X}0000000000000001"
    bid = f"BB{idx:06X}0000000000000001"
    file_refs[f] = fid
    build_files[f] = bid
    idx += 1

plist_ref = "CC0000010000000000000001"

pbxproj = f"""// !$*UTF8*$!
{{
	archiveVersion = 1;
	classes = {{
	}};
	objectVersion = 56;
	objects = {{

/* Begin PBXBuildFile section */
"""

for f in files:
    bid = build_files[f]
    fid = file_refs[f]
    name = os.path.basename(f)
    pbxproj += f"\t\t{bid} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {fid} /* {name} */; }};\n"

pbxproj += """/* End PBXBuildFile section */

/* Begin PBXFileReference section */
\t\tA00000010000000000000001 /* Aura.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = Aura.app; sourceTree = BUILT_PRODUCTS_DIR; };
\t\t""" + plist_ref + """ /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
"""

for f in files:
    fid = file_refs[f]
    name = os.path.basename(f)
    pbxproj += f"\t\t{fid} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = \"{name}\"; sourceTree = \"<group>\"; }};\n"

pbxproj += """/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
\t\tA00000020000000000000001 /* Frameworks */ = {
\t\t\tisa = PBXFrameworksBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
\t\tA00000030000000000000001 = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\tA00000040000000000000001 /* Aura */,
\t\t\t\tA00000050000000000000001 /* Products */,
\t\t\t);
\t\t\tsourceTree = "<group>";
\t\t};
\t\tA00000050000000000000001 /* Products */ = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\tA00000010000000000000001 /* Aura.app */,
\t\t\t);
\t\t\tname = Products;
\t\t\tsourceTree = "<group>";
\t\t};
\t\tA00000040000000000000001 /* Aura */ = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
"""

for f in files:
    fid = file_refs[f]
    name = os.path.basename(f)
    pbxproj += f"\t\t\t\t{fid} /* {name} */,\n"

pbxproj += f"""\t\t\t\t{plist_ref} /* Info.plist */,
\t\t\t);
\t\t\tpath = Aura;
\t\t\tsourceTree = "<group>";
\t\t};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
\t\tA00000060000000000000001 /* Aura */ = {{
\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = A00000070000000000000001 /* Build configuration list for PBXNativeTarget "Aura" */;
\t\t\tbuildPhases = (
\t\t\t\tA00000080000000000000001 /* Sources */,
\t\t\t\tA00000020000000000000001 /* Frameworks */,
\t\t\t\tA00000090000000000000001 /* Resources */,
\t\t\t);
\t\t\tbuildRules = (
\t\t\t);
\t\t\tdependencies = (
\t\t\t);
\t\t\tname = Aura;
\t\t\tproductName = Aura;
\t\t\tproductReference = A00000010000000000000001 /* Aura.app */;
\t\t\tproductType = "com.apple.product-type.application";
\t\t}};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
\t\tA00000100000000000000001 /* Project object */ = {{
\t\t\tisa = PBXProject;
\t\t\tattributes = {{
\t\t\t\tBuildIndependentTargetsInParallel = 1;
\t\t\t\tLastUpgradeCheck = 1500;
\t\t\t\tTargetAttributes = {{
\t\t\t\t\tA00000060000000000000001 = {{
\t\t\t\t\t\tCreatedOnToolsVersion = 15.0;
\t\t\t\t\t}};
\t\t\t\t}};
\t\t\t}};
\t\t\tbuildConfigurationList = A00000110000000000000001 /* Build configuration list for PBXProject "Aura" */;
\t\t\tcompatibilityVersion = "Xcode 14.0";
\t\t\tdevelopmentRegion = en;
\t\t\thasScannedForEncodings = 0;
\t\t\tknownRegions = (
\t\t\t\ten,
\t\t\t\tBase,
\t\t\t);
\t\t\tmainGroup = A00000030000000000000001;
\t\t\tproductRefGroup = A00000050000000000000001 /* Products */;
\t\t\tprojectDirPath = "";
\t\t\tprojectRoot = "";
\t\t\ttargets = (
\t\t\t\tA00000060000000000000001 /* Aura */,
\t\t\t);
\t\t}};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
\t\tA00000090000000000000001 /* Resources */ = {{
\t\t\tisa = PBXResourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
\t\tA00000080000000000000001 /* Sources */ = {{
\t\t\tisa = PBXSourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
"""

for f in files:
    bid = build_files[f]
    name = os.path.basename(f)
    pbxproj += f"\t\t\t\t{bid} /* {name} in Sources */,\n"

pbxproj += """\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
\t\tA00000120000000000000001 /* Debug */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tCLANG_ANALYZER_NONNULL = YES;
\t\t\t\tENABLE_TESTABILITY = YES;
\t\t\t\tGCC_DYNAMIC_NO_PIC = NO;
\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;
\t\t\t\tGCC_PREPROCESSOR_DEFINITIONS = (
\t\t\t\t\t"DEBUG=1",
\t\t\t\t\t"$(inherited)",
\t\t\t\t);
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;
\t\t\t\tONLY_ACTIVE_ARCH = YES;
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Onone";
\t\t\t};
\t\t\tname = Debug;
\t\t};
\t\tA00000130000000000000001 /* Release */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tCLANG_ANALYZER_NONNULL = YES;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_COMPILATION_MODE = wholemodule;
\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-O";
\t\t\t};
\t\t\tname = Release;
\t\t};
\t\tA00000140000000000000001 /* Debug */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_TEAM = "";
\t\t\t\tENABLE_PREVIEWS = YES;
\t\t\t\tGENERATE_INFOPLIST_FILE = NO;
\t\t\t\tINFOPLIST_FILE = Aura/Info.plist;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (
\t\t\t\t\t"$(inherited)",
\t\t\t\t\t"@executable_path/Frameworks",
\t\t\t\t);
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.aura.memoryai;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t};
\t\t\tname = Debug;
\t\t};
\t\tA00000150000000000000001 /* Release */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_TEAM = "";
\t\t\t\tENABLE_PREVIEWS = YES;
\t\t\t\tGENERATE_INFOPLIST_FILE = NO;
\t\t\t\tINFOPLIST_FILE = Aura/Info.plist;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (
\t\t\t\t\t"$(inherited)",
\t\t\t\t\t"@executable_path/Frameworks",
\t\t\t\t);
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.aura.memoryai;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t};
\t\t\tname = Release;
\t\t};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
\t\tA00000110000000000000001 /* Build configuration list for PBXProject "Aura" */ = {
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\tA00000120000000000000001 /* Debug */,
\t\t\t\tA00000130000000000000001 /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t};
\t\tA00000070000000000000001 /* Build configuration list for PBXNativeTarget "Aura" */ = {
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\tA00000140000000000000001 /* Debug */,
\t\t\t\tA00000150000000000000001 /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t};
/* End XCConfigurationList section */

\t};
\trootObject = A00000100000000000000001 /* Project object */;
}
"""

with open(os.path.join(pbx_dir, "project.pbxproj"), "w") as f:
    f.write(pbxproj)
print("Successfully generated Aura.xcodeproj!")
