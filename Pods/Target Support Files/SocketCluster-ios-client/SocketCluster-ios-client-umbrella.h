#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SCChannel.h"
#import "SCMessage.h"
#import "SCSocket.h"

FOUNDATION_EXPORT double SocketCluster_ios_clientVersionNumber;
FOUNDATION_EXPORT const unsigned char SocketCluster_ios_clientVersionString[];

