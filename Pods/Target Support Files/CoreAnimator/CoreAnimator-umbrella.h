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

#import "LSAnimator.h"
#import "LSAnimatorBlocks.h"
#import "LSAnimatorChain.h"
#import "LSAnimatorLinker.h"
#import "LSKeyframeAnimation.h"
#import "LSKeyframeAnimationFunctions.h"
#import "CoreAnimator.h"

FOUNDATION_EXPORT double CoreAnimatorVersionNumber;
FOUNDATION_EXPORT const unsigned char CoreAnimatorVersionString[];

