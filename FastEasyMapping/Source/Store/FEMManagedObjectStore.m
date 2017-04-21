// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMManagedObjectStore.h"

#import <CoreData/CoreData.h>

#import "FEMManagedObjectMapping.h"
#import "FEMObjectCache.h"

__attribute__((always_inline)) void validateMapping(FEMMapping *mapping) {
    NSCAssert(mapping.entityName != nil, @"Entity name can't be nil. Please, use -[FEMMapping initWithEntityName:]");
}

@implementation FEMManagedObjectStore {
    FEMObjectCache *_cache;
}

#pragma mark - Init

- (instancetype)initWithContext:(NSManagedObjectContext *)context {
    NSParameterAssert(context != nil);
    self = [super init];
    if (self) {
        _context = context;
    }

    return self;
}

#pragma mark - Transaction

- (void)beginTransaction:(nullable NSMapTable<FEMMapping *, NSSet<id> *> *)presentedPrimaryKeys {
    _cache = [[FEMObjectCache alloc] initWithContext:self.context presentedPrimaryKeys:presentedPrimaryKeys];
}

- (NSError *)commitTransaction {
    _cache = nil;

    NSError *error = nil;
    if (self.saveContextOnCommit && self.context.hasChanges && ![self.context save:&error]) {
        return error;
    }

    return nil;
}

+ (BOOL)requiresPrefetch {
    return YES;
}

- (id)newObjectForMapping:(FEMMapping *)mapping {
    validateMapping(mapping);

    NSString *entityName = [mapping entityName];
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.context];
}

- (id)registeredObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping {
    validateMapping(mapping);

    return [_cache existingObjectForRepresentation:representation mapping:mapping];
}

- (void)registerObject:(id)object forMapping:(FEMMapping *)mapping {
    validateMapping(mapping);

    [_cache addExistingObject:object mapping:mapping];
}

- (NSDictionary *)registeredObjectsForMapping:(FEMMapping *)mapping {
    validateMapping(mapping);

    return [_cache existingObjectsForMapping:mapping];
}

- (BOOL)canRegisterObject:(id)object forMapping:(FEMMapping *)mapping {
    validateMapping(mapping);

    return mapping.primaryKey != nil && [object isInserted];
}

#pragma mark - FEMRelationshipAssignmentContextDelegate

- (void)assignmentContext:(FEMRelationshipAssignmentContext *)context deletedObject:(id)object {
    NSAssert([object isKindOfClass:NSManagedObject.class], @"Wrong class");
    [self.context deleteObject:object];
}

@end
