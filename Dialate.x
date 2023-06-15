/*
Dialate : Created by Kota
*/
#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include <objc/runtime.h>

@protocol SBDockViewDelegate;
@class SBDockIconListView, SBHighlightView, MTMaterialView, SBWallpaperEffectView, UIImageView, UIView, _UILegibilitySettings, NSString;

@interface SBFloatingDockView : UIView {

	BOOL _useBuiltInAlphaTransformerAndBackdropScaleAdjustment;
	BOOL _recipeDynamic;
	BOOL _shadowed;
	NSMutableDictionary* _cmVisualStyleCategoriesToProviders;
	NSDictionary* _recipeNamesByTraitCollection;
	NSBundle* _recipeBundle;
	NSHashTable* _observers;
	UIView* _highlightView;
	BOOL _needsLayoutOnMoveToWindow;
	BOOL _highlighted;
	NSString* _groupNameBase;
	long long _recipe;
	long long _configuration;
}
@property (nonatomic,copy,readwrite) UIColor * backgroundColor; 
@property (assign,getter=isBlurEnabled,nonatomic) BOOL blurEnabled; 
-(BOOL)isBlurEnabled;
-(id)init;
@end

@interface SBDockView : UIView {

	BOOL _useBuiltInAlphaTransformerAndBackdropScaleAdjustment;
	BOOL _recipeDynamic;
	BOOL _shadowed;
	NSMutableDictionary* _cmVisualStyleCategoriesToProviders;
	NSDictionary* _recipeNamesByTraitCollection;
	NSBundle* _recipeBundle;
	NSHashTable* _observers;
	UIView* _highlightView;
	BOOL _needsLayoutOnMoveToWindow;
	BOOL _highlighted;
	NSString* _groupNameBase;
	long long _recipe;
	long long _configuration;
}
@property (nonatomic,copy,readwrite) UIColor * backgroundColor; 
@property (assign,getter=isBlurEnabled,nonatomic) BOOL blurEnabled; 
-(BOOL)isBlurEnabled;
-(id)init;
@end

@interface MTMaterialView : UIView {
	CALayer* _MTMaterialLayer;
}
@property (nonatomic,retain) CALayer * MTMaterialLayer;
@property (nonatomic,copy,readwrite) UIColor * backgroundColor; 
@property (assign,getter=isBlurEnabled,nonatomic) BOOL blurEnabled; 
-(BOOL)isBlurEnabled;
-(id)init;
@end

UIColor* fuckingHexColors(NSString* hexString) {
    if (!hexString) {
        NSLog(@"Dialate: Warning, you’re wanting to fuck some hex colors, but did not supply a NSString for this function. This is a bug. Did you add a safety check?");
	return [UIColor whiteColor];
    }
    NSString *daString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![daString containsString:@"#"]) {
        daString = [@"#" stringByAppendingString:daString];
    }
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:daString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];

    NSRange range = [hexString rangeOfString:@":" options:NSBackwardsSearch];
    NSString* alphaString;
    if (range.location != NSNotFound) {
        alphaString = [hexString substringFromIndex:(range.location + 1)];
    } else {
        alphaString = @"1.0"; //no opacity specified - just return 1 :/
    }

    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:[alphaString floatValue]];
}

NSUserDefaults *_preferences;
BOOL _enabled;
BOOL isBlurEnabled;

%hook SBDockView

-(NSArray *)subviews {
 id subviews = %orig;
 NSString *realBussyString = [_preferences objectForKey:@"realBussy"];
 for (MTMaterialView * origSubview in subviews) {
  if ([origSubview isMemberOfClass:%c(MTMaterialView)]) {
   origSubview.blurEnabled = NO;
   if (realBussyString) {
    origSubview.backgroundColor = fuckingHexColors(realBussyString);
   }
  }
 }
 return subviews;
}

-(CALayer *) layer {
		CALayer *origLayer = %orig;
		NSString *ImageColorString = [_preferences objectForKey:@"ImageShadowColor"];
  			if (ImageColorString) {
  		origLayer.shadowColor = fuckingHexColors(ImageColorString).CGColor; 
  		}
  		origLayer.shadowRadius = 6;
  		origLayer.shadowOffset = CGSizeMake(0.0f,1.0f);
  		origLayer.shadowOpacity = 2;
		return origLayer;
	}

%end

%hook SBFloatingDockPlatterView

-(NSArray *)subviews {
 id subviews = %orig;
 NSString *realBussyString = [_preferences objectForKey:@"realBussy"];
 for (MTMaterialView * origSubview in subviews) {
  if ([origSubview isMemberOfClass:%c(MTMaterialView)]) {
   origSubview.blurEnabled = NO;
   if (realBussyString) {
    origSubview.backgroundColor = fuckingHexColors(realBussyString);
   }
  }
 }
 return subviews;
}

-(CALayer *) layer {
		CALayer *origLayer = %orig;
		NSString *ImageColorString = [_preferences objectForKey:@"ImageShadowColor"];
  			if (ImageColorString) {
  		origLayer.shadowColor = fuckingHexColors(ImageColorString).CGColor; 
  		}
  		origLayer.shadowRadius = 6;
  		origLayer.shadowOffset = CGSizeMake(0.0f,1.0f);
  		origLayer.shadowOpacity = 2;
		return origLayer;
	}

%end

%ctor {
	_preferences = [[NSUserDefaults alloc] initWithSuiteName:@"online.transrights.dialate"];
	[_preferences registerDefaults:@{
		@"enabled" : @YES,
	}];
	_enabled = [_preferences boolForKey:@"enabled"];
	if(_enabled) {
		NSLog(@"[Dialate] Injection has begun");
		%init();
	} else {
		NSLog(@"[Dilate] Cured");
	}
}