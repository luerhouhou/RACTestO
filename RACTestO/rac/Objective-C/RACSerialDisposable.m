//
//  RACSerialDisposable.m
//  ReactiveCocoa
//
//  Created by Justin Spahr-Summers on 2013-07-22.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import "RACSerialDisposable.h"
#import <libkern/OSAtomic.h>
#import <pthread.h>
@interface RACSerialDisposable () {
	// The receiver's `disposable`. This variable must only be referenced while
	// _spinLock is held.
	RACDisposable * _disposable;

	// YES if the receiver has been disposed. This variable must only be modified
	// while _spinLock is held.
	BOOL _disposed;

	// A spinlock to protect access to _disposable and _disposed.
	//
	// It must be used when _disposable is mutated or retained and when _disposed
	// is mutated.
    pthread_mutex_t _mutex;
}

@end

@implementation RACSerialDisposable

#pragma mark Properties

- (BOOL)isDisposed {
	return _disposed;
}

- (RACDisposable *)disposable {
	RACDisposable *result;

	__RACLock(&_mutex);
	result = _disposable;
	__RACUnlock(&_mutex);

	return result;
}

- (void)setDisposable:(RACDisposable *)disposable {
	[self swapInDisposable:disposable];
}

#pragma mark Lifecycle

+ (instancetype)serialDisposableWithDisposable:(RACDisposable *)disposable {
	RACSerialDisposable *serialDisposable = [[self alloc] init];
	serialDisposable.disposable = disposable;
	return serialDisposable;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        pthread_mutex_init(&_mutex, 0);
    }
    return self;
}

- (id)initWithBlock:(void (^)(void))block {
	self = [self init];
	if (self == nil) return nil;

	self.disposable = [RACDisposable disposableWithBlock:block];

	return self;
}

#pragma mark Inner Disposable

- (RACDisposable *)swapInDisposable:(RACDisposable *)newDisposable {
	RACDisposable *existingDisposable;
	BOOL alreadyDisposed;

	__RACLock(&_mutex);
	alreadyDisposed = _disposed;
	if (!alreadyDisposed) {
		existingDisposable = _disposable;
		_disposable = newDisposable;
	}
    __RACUnlock(&_mutex);

	if (alreadyDisposed) {
		[newDisposable dispose];
		return nil;
	}

	return existingDisposable;
}

#pragma mark Disposal

- (void)dispose {
	RACDisposable *existingDisposable;

	__RACLock(&_mutex);
	if (!_disposed) {
		existingDisposable = _disposable;
		_disposed = YES;
		_disposable = nil;
	}
    __RACUnlock(&_mutex);
	
	[existingDisposable dispose];
}

- (void)dealloc
{
    pthread_mutex_destroy(&_mutex);
}

@end
