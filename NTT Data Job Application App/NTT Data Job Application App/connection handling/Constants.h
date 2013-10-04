//
//  Constants.h
//  NTT Data Job Application App
//
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#ifndef NTT_Data_Job_Application_App_Constants_h
#define NTT_Data_Job_Application_App_Constants_h

// define connection types
typedef NS_ENUM (NSUInteger,OSConnectionType)
{
    OSCGetJobTitle = 30,
    OSCGetTopics = 32,
    OSCGetLocation = 34,
    OSCGetExperience = 36,
    OSCGetSearch = 72,
    OSCGetFreeTextSearch = 73,
    OSCGetTitle = 74,
    OSCGetFaq = 75,
    OSCGetApplicationsByDevice = 80,
    OSCGetApplicationsByDeviceAndReference = 81,
    OSCSendApplication = 90,
    OSCSendWithdrawApplication = 95
};

#endif
