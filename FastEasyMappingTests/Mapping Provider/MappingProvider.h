// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMMapping;

@interface MappingProvider : NSObject

+ (FEMMapping *)carMappingWithPrimaryKey;
+ (FEMMapping *)carMapping;
+ (FEMMapping *)carWithRootKeyMapping;
+ (FEMMapping *)carNestedAttributesMapping;
+ (FEMMapping *)carWithDateMapping;
+ (FEMMapping *)phoneMapping;
+ (FEMMapping *)personMapping;

+ (FEMMapping *)personWithPhoneMapping;
+ (FEMMapping *)personWithCarMapping;

@end
