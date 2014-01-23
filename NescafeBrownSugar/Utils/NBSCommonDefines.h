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
#define NBS_iOSVersionEqualTo(v)           ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define NBS_iOSVersionGreaterThan(v)         ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define NBS_iOSVersionGreaterOrEqualTo(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define NBS_iOSVersionLessThan(v)            ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define NBS_iOSVersionLessOrEqualTo(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
// iOS version check-functions defines

// ---- screen size defines ---- //
#define NBS_IsDeviceScreenSize4Inch ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
// ---- screen size defines ---- //
#define NBS_IsDeviceScreenSize4InchOrBigger ([[UIScreen mainScreen] bounds].size.height >= 568)

// app launch
#define kNBSNotFirstAppLaunchUserDefaultsKey @"NotFirstAppLaunchDefaultsKey"
// app launch


#endif
