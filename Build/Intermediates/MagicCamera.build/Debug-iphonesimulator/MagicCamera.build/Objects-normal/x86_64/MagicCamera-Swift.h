// Generated by Apple Swift version 2.1 (swiftlang-700.1.101.6 clang-700.1.76)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if defined(__has_include) && __has_include(<uchar.h>)
# include <uchar.h>
#elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
#endif

typedef struct _NSZone NSZone;

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted) 
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
#endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
@import UIKit;
@import CoreBluetooth;
@import LTMorphingLabel;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIActivityIndicatorView;
@class UIViewController;

SWIFT_CLASS("_TtC11MagicCamera17ActivityIndicator")
@interface ActivityIndicator : NSObject
@property (nonatomic, strong) UIActivityIndicatorView * __null_unspecified activityIndicator;
- (void)start:(UIViewController * __nonnull)myself;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UIWindow;
@class UIApplication;
@class NSURL;
@class NSManagedObjectModel;
@class NSPersistentStoreCoordinator;
@class NSManagedObjectContext;

SWIFT_CLASS("_TtC11MagicCamera11AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow * __nullable window;
- (BOOL)application:(UIApplication * __nonnull)application didFinishLaunchingWithOptions:(NSDictionary * __nullable)launchOptions;
- (void)applicationWillResignActive:(UIApplication * __nonnull)application;
- (void)applicationDidEnterBackground:(UIApplication * __nonnull)application;
- (void)applicationWillEnterForeground:(UIApplication * __nonnull)application;
- (void)applicationDidBecomeActive:(UIApplication * __nonnull)application;
- (void)applicationWillTerminate:(UIApplication * __nonnull)application;
@property (nonatomic, strong) NSURL * __nonnull applicationDocumentsDirectory;
@property (nonatomic, strong) NSManagedObjectModel * __nonnull managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator * __nonnull persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext * __nonnull managedObjectContext;
- (void)saveContext;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSBundle;
@class NSCoder;

SWIFT_CLASS("_TtC11MagicCamera14BackCameraMode")
@interface BackCameraMode : UIViewController
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class AVCaptureSession;
@class AVCaptureDevice;
@class AVCaptureStillImageOutput;
@class UIButton;

SWIFT_CLASS("_TtC11MagicCamera20CameraViewController")
@interface CameraViewController : UIViewController
@property (nonatomic, strong) AVCaptureSession * __null_unspecified mySession;
@property (nonatomic, strong) AVCaptureDevice * __null_unspecified myDevice;
@property (nonatomic, strong) AVCaptureStillImageOutput * __null_unspecified myImageOutput;
@property (nonatomic, strong) UIButton * __null_unspecified myButton;
@property (nonatomic, strong) UIButton * __null_unspecified backButton;
- (void)viewDidLoad;
- (void)onClickButton:(UIButton * __nonnull)sender;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC11MagicCamera15FrontCameraMode")
@interface FrontCameraMode : CameraViewController
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class CBUUID;
@class NSNotification;
@class CBCentralManager;
@class CBPeripheral;
@class NSNumber;
@class NSError;
@class CBService;
@class CBCharacteristic;

SWIFT_CLASS("_TtC11MagicCamera14ViewController")
@interface ViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate, LTMorphingLabelDelegate>
@property (nonatomic) BOOL ble_new;
@property (nonatomic, readonly, copy) NSArray<CBUUID *> * __nonnull UUID_VSP;
@property (nonatomic, readonly, strong) CBUUID * __nonnull UUID_TX;
@property (nonatomic, readonly, strong) CBUUID * __nonnull UUID_RX;
@property (nonatomic, readonly, strong) ActivityIndicator * __nonnull indicator;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewDidLoad;
- (void)outString;
- (void)onOrientationChange:(NSNotification * __nonnull)notification;
- (void)rootBoot;
- (void)makeParts;
- (void)centralManagerDidUpdateState:(CBCentralManager * __nonnull)central;
- (void)centralManager:(CBCentralManager * __nonnull)central didDiscoverPeripheral:(CBPeripheral * __nonnull)peripheral advertisementData:(NSDictionary<NSString *, id> * __nonnull)advertisementData RSSI:(NSNumber * __nonnull)RSSI;
- (void)centralManager:(CBCentralManager * __nonnull)central didConnectPeripheral:(CBPeripheral * __nonnull)peripheral;
- (void)centralManager:(CBCentralManager * __nonnull)central didFailToConnectPeripheral:(CBPeripheral * __nonnull)peripheral error:(NSError * __nullable)error;
- (void)peripheral:(CBPeripheral * __nonnull)peripheral didDiscoverServices:(NSError * __nullable)error;
- (void)peripheral:(CBPeripheral * __nonnull)peripheral didDiscoverCharacteristicsForService:(CBService * __nonnull)service error:(NSError * __nullable)error;
- (void)peripheral:(CBPeripheral * __nonnull)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic * __nonnull)characteristic error:(NSError * __nullable)error;
- (void)peripheral:(CBPeripheral * __nonnull)peripheral didUpdateValueForCharacteristic:(CBCharacteristic * __nonnull)characteristic error:(NSError * __nullable)error;
- (void)peripheral:(CBPeripheral * __null_unspecified)peripheral didWriteValueForCharactertistic:(CBCharacteristic * __null_unspecified)characteristic error:(NSError * __null_unspecified)error;
- (void)bootCamera;
- (void)alert:(NSString * __nonnull)titleString messageString:(NSString * __nonnull)messageString buttonString:(NSString * __nonnull)buttonString;
- (void)didReceiveMemoryWarning;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

#pragma clang diagnostic pop
