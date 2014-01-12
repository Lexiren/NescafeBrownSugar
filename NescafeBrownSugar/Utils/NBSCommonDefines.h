//
//  NBSCommonDefines.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#ifndef NescafeBrownSugar_NBSCommonDefines_h
#define NescafeBrownSugar_NBSCommonDefines_h

// iOS version check-functions defines
#define kNBSiOSVersionEqual(v)           ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define kNBSiOSVersionGreater(v)         ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define kNBSiOSVersionGreaterOrEqual(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define kNBSiOSVersionLess(v)            ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define kNBSiOSVersionLessOrEqual(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
// iOS version check-functions defines


// app launch
#define kNBSNotFirstAppLaunchUserDefaultsKey @"NotFirstAppLaunchDefaultsKey"
// app launch


#endif
