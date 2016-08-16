//
//  ViewController.m
//  RACTestO
//
//  Created by zhanglu on 16/6/7.
//  Copyright © 2016年 zhanglu. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "EXTScope.h"
#import <AFNetworking.h>
#import <LocalAuthentication/LocalAuthentication.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end

@implementation ViewController

- (IBAction)resetClick:(id)sender {
//    [self viewDidLoad];
    [@[@1,@2,@3,@4,@5,@6,@7,@8,@9].rac_sequence.signal subscribeNext:^(id x) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(<#delayInSeconds#> * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            <#code to be executed after a specified delay#>
//        });
        NSLog(@"%@",x);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //--------------------1
//    RACSignal *signal = @[@1,@2,@3,@4,@5,@6,@7,@8,@9].rac_sequence.signal;
//    [signal subscribeNext:^(id x) {//创建定时器依次打印
//        NSLog(@"1--//%@",x);
//    }];
    
    //--------------------2
//    __block unsigned subscriptions = 0;
//    
//    RACSignal *loggingSignal = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
//        subscriptions++;
//        [subscriber sendCompleted];//触发Completed方法
//        return nil;
//    }];
//    
//    // Does not output anything yet
//    RACSignal *logging = [loggingSignal doCompleted:^{//通过前一个信号1来创建新的信号2，并在1执行前插入信号2的任务
//        NSLog(@"about to complete subscription %u", subscriptions);
//    }];
//    
//    // Outputs:
//    // about to complete subscription 1
//    // subscription 1
//    [logging subscribeNext:^(id x) {
//        NSLog(@"subscription %u", subscriptions);
//    } error:^(NSError *error) {
//        NSLog(@"subscription %u", subscriptions);
//    } completed:^{//赋值并订阅
//        NSLog(@"subscription %u", subscriptions);
//    }];
//    [loggingSignal subscribeCompleted:^{//给self.completed 赋值并订阅，1与logging是两个不同的信号
//        NSLog(@"subscription %u", subscriptions);
//    }];
    
//    RACSequence *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence;
//    
//    // Contains: AA BB CC DD EE FF GG HH II
//    RACSequence *mapped = [letters map:^(NSString *value) {
//        return [value stringByAppendingString:value];
//    }];
//    
//    [mapped.signal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
//    RACSequence *numbers = [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence;
//    
//    // Contains: 2 4 6 8
//    RACSequence *filtered = [numbers filter:^ BOOL (NSString *value) {
//        return (value.intValue % 2) == 0;
//    }];
    
//    RACSequence *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence;
//    RACSequence *numbers = [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence;
//    
//    // Contains: A B C D E F G H I 1 2 3 4 5 6 7 8 9
//    RACSequence *concatenated = [letters concat:numbers];//[@[letters, numbers] flatten] 联合打平
    
    //-----------------3
//    RACSequence *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence;
//    RACSequence *numbers = [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence;
//    RACSequence *sequenceOfSequences = @[ letters, numbers ].rac_sequence;
//    
//    [sequenceOfSequences.signal subscribeNext:^(id x) {
//        NSLog(@"3--//%@",x);
//    }];
//    
//    // Contains: A B C D E F G H I 1 2 3 4 5 6 7 8 9
//    RACSequence *flattened = [sequenceOfSequences flatten];//嵌套打平
//    
//    [flattened.signal subscribeNext:^(id x) {
//        NSLog(@"3----//%@",x);
//    }];

    //-----------------4
    RACSubject *letters = [RACSubject subject];
    RACSubject *numbers = [RACSubject subject];
    RACSignal *signalOfSignals = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:letters];//sendNext就是执行nextBlock
            [subscriber sendNext:numbers];
            [subscriber sendCompleted];
    
        });
                return nil;
    }];
  
    [letters subscribeNext:^(id x) {
        NSLog(@"letters--1//%@", x);
    }];
    [letters subscribeNext:^(id x) {//RACSubject可以有多个订阅者
        NSLog(@"letters--2//%@", x);
    }];
    [numbers subscribeNext:^(id x) {
        NSLog(@"numbers//%@", x);
    }];
    
    [signalOfSignals subscribeNext:^(NSString *x) {//未打平
        NSLog(@"%@", x);
    }];
    [signalOfSignals subscribeNext:^(id x) {//RACSignal会向每一个订阅者分别发送完整的消息
        NSLog(@"RACSignal同一时间只有一个订阅者//%@",x);
    }];
    RACSignal *flattened = [signalOfSignals flatten];
    
    // Outputs: A 1 B C 2
    [flattened subscribeNext:^(NSString *x) {
        NSLog(@"%@", x);
    }];
    
    [letters sendNext:@"A"];//RACSubject同一时间可以有多个订阅者， sendNext会执行所有订阅者的nextBlock
    [numbers sendNext:@"1"];
    [letters sendNext:@"B"];
    [letters sendNext:@"C"];
    [numbers sendNext:@"2"];
    
    //--------------5
//    RACSequence *numbers = [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence;
//    
//    // Contains: 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9
//    RACSequence *extended = [numbers flattenMap:^(NSString *num) {
//        return @[ num, num ].rac_sequence;
//    }];
//    
//    [extended.signal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
//    
//    // Contains: 1_ 3_ 5_ 7_ 9_
//    RACSequence *edited = [numbers flattenMap:^(NSString *num) {
//        if (num.intValue % 2 == 0) {
//            return [RACSequence empty];
//        } else {
//            NSString *newNum = [num stringByAppendingString:@"_"];
//            return [RACSequence return:newNum];
//        }
//    }];
//    [edited.signal subscribeNext:^(id x) {
//        NSLog(@"--%@",x);
//    }];
//    RACSignal *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence.signal;
//    
//    [[letters
//      flattenMap:^(NSString *letter) {
//          return [database saveEntriesForLetter:letter];
//      }]
//     subscribeCompleted:^{
//         NSLog(@"All database entries saved successfully.");
//     }];
    
//    RACSignal *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence.signal;
//    
//    // The new signal only contains: 1 2 3 4 5 6 7 8 9
//    //
//    // But when subscribed to, it also outputs: A B C D E F G H I
//    RACSignal *sequenced = [[letters
//                             doNext:^(NSString *letter) {
//                                 NSLog(@"%@", letter);
//                             }]
//                            then:^{
//                                return [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence.signal;
//                            }];
//    
//    [sequenced subscribeNext:^(id x) {
//        NSLog(@"--%@",x);
//    }];
    
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSLog(@"第一步");
//        [subscriber sendNext:@"11111111"];
//        [subscriber sendCompleted];
//        return nil;
//    }];
//    
////    [signal subscribeNext:^(id x) {
////        NSLog(@"--%@",x);
////    }];
////    
//    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSLog(@"第二步");
//        [subscriber sendNext:@"2222222"];
//        return nil;
//    }];
//    
////    [[signal concat:signal1] subscribeNext:^(id x) {//concat 只有当第一个信号sendCompleted之后，第二个信号才会接着执行 先后顺序
////        NSLog(@"concat//%@",x);
////    }];
//    
//    [[[signal ignoreValues] concat:signal1] subscribeNext:^(id x) {//concat 只有当第一个信号sendCompleted之后，第二个信号才会接着执行
//        NSLog(@"concat//%@",x);
//    }];
////    [[signal concat:[@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence.signal] subscribeNext:^(id x) {
////        NSLog(@"//%@",x);
////    }];
//    
//    [[signal then:^RACSignal *{ //只有当第一个信号sendCompleted之后，第二个信号才会接着执行 先后顺序，then会忽略第一个信号所有的sendNext，相当于[[signal ignoreValues] concat:signal1]
//        return [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence.signal;
//    }] subscribeNext:^(id x) {
//        NSLog(@"//%@",x);
//    }];
    
//    RACSubject *letters = [RACSubject subject];
//    RACSubject *numbers = [RACSubject subject];
//    RACSignal *merged = [RACSignal merge:@[ letters, numbers ]];//将信号组合并打平，每一个sendNext就作为merge结果sendNext
//    
//    // Outputs: A 1 B C 2
//    [merged subscribeNext:^(NSString *x) {
//        NSLog(@"%@", x);
//    }];
//    
//    [letters sendNext:@"A"];
//    [numbers sendNext:@"1"];
//    [letters sendNext:@"B"];
//    [letters sendNext:@"C"];
//    [numbers sendNext:@"2"];
    
//    RACSubject *letters = [RACSubject subject];
//    RACSubject *numbers = [RACSubject subject];
//    RACSignal *combined = [RACSignal
//                           combineLatest:@[ letters, numbers ]//等都有结果后，把两个信号最新的结果sendNext
//                           reduce:^(NSString *letter, NSString *number) {
//                               return [letter stringByAppendingString:number];
//                           }];
//    
//    // Outputs: B1 B2 C2 C3
//    [combined subscribeNext:^(id x) {
//        NSLog(@"%@", x);
//    }];
//    
//    [letters sendNext:@"A"];
//    [letters sendNext:@"B"];
//    [numbers sendNext:@"1"];
//    [numbers sendNext:@"2"];
//    [letters sendNext:@"C"];
//    [numbers sendNext:@"3"];
    
    //switchToLatest 每次都会监听最近的sendNext的信号。
//    RACSubject *letters = [RACSubject subject];
//    NSLog(@"--------------------1");
//    RACSubject *numbers = [RACSubject subject];
//    NSLog(@"--------------------2");
//    RACSubject *signalOfSignals = [RACSubject subject];
//    NSLog(@"--------------------3");
//    
//    RACSignal *switched = [signalOfSignals switchToLatest];// takeUntil:signal
//    NSLog(@"--------------------4");
//    // Outputs: A B 1 D
//    [switched subscribeNext:^(NSString *x) {
//        NSLog(@"%@", x);
//    }];
//    NSLog(@"--------------------5");
//    
//    [signalOfSignals sendNext:letters];
//    NSLog(@"--------------------6");
//    [letters sendNext:@"A"];
//    NSLog(@"--------------------7");
//    [letters sendNext:@"B"];
//    NSLog(@"--------------------8");
//    
//    [signalOfSignals sendNext:numbers];
//    NSLog(@"--------------------9");
//    [letters sendNext:@"C"];
//    NSLog(@"--------------------10");
//    [letters sendNext:@"C"];
//    NSLog(@"--------------------11");
//    [numbers sendNext:@"1"];
//    NSLog(@"--------------------12");
//    
//    [signalOfSignals sendNext:letters];
//    NSLog(@"--------------------13");
//    [numbers sendNext:@"2"];
//    NSLog(@"--------------------14");
//    [letters sendNext:@"D"];
    
    //
    //    RACSignal *signalInterval = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] take:3];
    //
    //    RACSignal *bindSignal = [signalInterval bind:^RACStreamBindBlock{
    //        return ^(id value, BOOL *stop) {
    //            NSLog(@"inner value: %@", value);
    //            return [RACSignal return:value];
    //        };
    //    }];
    //
    //    [bindSignal subscribeNext:^(id x) {
    //        NSLog(@"outer value: %@", x);
    //    }];
    
    //    RACSignal *signalInterval = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] take:3];
    //
    //    RACSignal *bindSignal = [signalInterval bind:^RACStreamBindBlock{
    //        return ^(NSDate *value, BOOL *stop) {
    //            NSLog(@"inner value: %@", value);
    //
    //            NSTimeInterval nowTime = [value timeIntervalSince1970];
    //            return [RACSignal return:@(nowTime)];
    //        };
    //    }];
    //
    //    [bindSignal subscribeNext:^(id x) {
    //        NSLog(@"outer value: %@", x);
    //    }];
    
    /**
     *  有效三次的间隔为1秒定时器信号，此时 signalInterval 是一个 signal of NSDates
     */
    //    RACSignal *signalInterval = [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] take:3];
    //
    //    /**
    //     *  将定时器信号里的值修改成 RACSignal 类型
    //     *  此时，signalInterval 变成了一个 signal of signals
    //     */
    //    signalInterval = [signalInterval map:^id(NSDate *value) {
    //        return [value description];
    //    }];
    //
    //    RAC(self, value) = signalInterval;
    
    /**
     *  既然 signalInterval 里的值都是信号，那直接将这些信号返回即可
     */
    //    RACSignal *signal = [signalInterval flattenMap:^RACStream *(RACSignal *returnSignal) {
    //        return returnSignal;
    //    }];
    
    /**
     *  由于 signalInterval 里的值都是包含了一个 NSDate 值的 RACReturnSignal,
     *  经过 `-flattenMap:` 过后，signal 就变成了 signal of NSDates。
     */
    //    [signal subscribeNext:^(id x) {
    //        NSLog(@"value: %@", x);
    //    }];
    
    //    RACSignal *signal = [RACSignal interval:3.0 onScheduler:[RACScheduler mainThreadScheduler]];
    //    signal = [signal take:5];
    ////    NLSubscriber *subS = [NLSubscriber subscriberWithNext:^(id x) {
    ////    } error:^(NSError *error) {
    ////    } completed:^{
    ////    }];
    ////    [signal subscribe:subS];
    //    [signal nl_subscribeNext:^(id x) {
    //        NSLog(@"next%@",x);
    //    } error:^(NSError *error) {
    //        NSLog(@"error");
    //    } completed:^{
    //        NSLog(@"complete");
    //    }];
    
    
    
    //察值：第一次初始化也会响应
    //    @weakify(self);
    //    [RACObserve(self, value) subscribeNext:^(NSString* x) {
    ////        @strongify(self);
    //        NSLog(@"察值%@",x);
    //    }];
    //
    //    //------------根据signal0的输入来确定enable的值
    //    RACSignal *signal0 = [RACSignal createSignal:^RACDisposable *(id subscriber) {
    //        [subscriber sendNext:@"唱歌"];
    //        [subscriber sendCompleted];
    //        return nil;
    //    }];
    //
    //    RAC(self, value) = [signal0 map:^id(NSString* value) {
    //        if ([value isEqualToString:@"唱歌"]) {
    //            return @"跳舞";//返回的值会赋给self.value
    //        }
    //        return @"1";
    //    }];
    //
    //    RAC(self, enable) = [signal0 map:^id(NSString* value) {
    //        if ([value isEqualToString:@"唱歌"]) {
    //            return @(YES);//返回的值会赋给self.value
    //        }
    //        return @(NO);
    //    }];
    //----------------
    //    RACChannelTerminal *channelA = RACChannelTo(self, valueA);
    //    RACChannelTerminal *channelB = RACChannelTo(self, valueB);
    //    [[channelA map:^id(NSString *value) {
    //        if ([value isEqualToString:@"西"]) {
    //            return @"东";
    //        }
    //        return value;
    //    }] subscribe:channelB];
    //    [[channelB map:^id(NSString *value) {
    //        if ([value isEqualToString:@"左"]) {
    //            return @"右";
    //        }
    //        return value;
    //    }] subscribe:channelA];
    //    //符合条件的才会进到下一步，但不影响值的改变
    //    [[RACObserve(self, valueA) filter:^BOOL(id value) {
    //        return NO;
    //    }] subscribeNext:^(NSString* x) {
    //        NSLog(@"你向%@", x);
    //    }];
    //    [[RACObserve(self, valueB) filter:^BOOL(id value) {
    //        return NO;
    //    }] subscribeNext:^(NSString* x) {
    //        NSLog(@"他向%@", x);
    //    }];
    //    self.valueA = @"东";
    //    self.valueB = @"右";
    //--------------
    //相当于给makeAnApp方法添加一个执行完成后执行的后续方法，
    //    RACSignal *ProgrammerSignal =
    //    [self rac_signalForSelector:@selector(makeAnApp)
    //                   fromProtocol:@protocol(Programmer)];
    //    [ProgrammerSignal subscribeNext:^(RACTuple* x) {
    //        NSLog(@"花了一个月，app写好了");
    //    }];
    //    [self makeAnApp];
    
    //----------
    //
    //    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"代码之道频道" object:nil] subscribeNext:^(NSNotification* x) {
    //        NSLog(@"技巧：%@", x.userInfo[@"技巧"]);
    //    }];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"代码之道频道" object:nil userInfo:@{@"技巧":@"用心写"}];
    //
    //------------连接
    //    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        [subscriber sendNext:@"我恋爱啦"];
    //        [subscriber sendCompleted];
    //        return nil;
    //    }];
    //    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        [subscriber sendNext:@"我结婚啦"];
    //        [subscriber sendCompleted];
    //        return nil;
    //    }];
    //    RACSignal *signalC = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        [subscriber sendNext:@"我高兴"];
    //        [subscriber sendCompleted];
    //        return nil;
    //    }];
    //    //顺序执行
    //    [[[signalA concat:signalB] concat:signalC] subscribeNext:^(id x) {
    //        NSLog(@"%@",x);
    //    }];
    
    //---------合并
//    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [subscriber sendNext:@"纸厂污水"];
//            //        [subscriber sendError:nil];
//            
//        });
//        return nil;
//    }];
//    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [subscriber sendNext:@"电镀厂污水"];
//        //        [subscriber sendError:@"电镀厂污水"];
//        return nil;
//    }];
//    //只执行一次，执行最快返回的，都完成才算完成，有一个错误就都错误
//    [[[RACSignal merge:@[signalA, signalB]]replayLast] subscribeNext:^(id x) {
//        NSLog(@"处理%@",x);
//    } error:^(NSError *error) {
//        
//    }];
    
    //----------组合
    //    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id subscriber) {
    //        [subscriber sendNext:@"白"];
    ////        [subscriber sendError:nil];
    //        return nil;
    //    }];
    //    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id subscriber) {
    //        [subscriber sendNext:@"白"];
    ////        [subscriber sendError:nil];
    //        return nil;
    //    }];
    //    RACSignal *signalC = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        [subscriber sendNext:@"我高兴"];
    ////        [subscriber sendError:@"电镀厂污水"];
    //        return nil;
    //    }];
    //
    //    //可能会执行很多次，有一个错误就completed
    //    [[RACSignal combineLatest:@[signalA, signalB, signalC]] subscribeNext:^(RACTuple* x) {
    //        RACTupleUnpack(NSString *stringA, NSString *stringB, NSString *stringC) = x;
    //        NSLog(@"我们是%@%@%@的", stringA, stringB, stringC);
    //    }error:^(NSError *error) {
    //
    //    }];
    //
    //    //---------归约
    //    RACSignal *sugarSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        [subscriber sendNext:@"糖"];
    //        return nil;
    //    }];
    //    RACSignal *waterSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        [subscriber sendNext:@"水"];
    //        return nil;
    //    }];
    //    //
    //    [[RACSignal combineLatest:@[sugarSignal, waterSignal] reduce:^id (NSString* sugar, NSString*water){
    //        return [sugar stringByAppendingString:water];
    //    }] subscribeNext:^(id x) {
    //        NSLog(@"%@", x);
    //    }];
    
    //---------压缩
    //    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        [subscriber sendNext:@"红1"];
    //        [subscriber sendNext:@"白1"];
    //        return nil;
    //    }];
    //    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        [subscriber sendNext:@"白"];
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //        [subscriber sendNext:@"hong2"];
    //        });
    //        return nil;
    //    }];
    //    [signalA subscribeNext:^(id x) {
    //        NSLog(@"%@",x);
    //    }];
    //    //你是红的，我是黄的，我们就是红黄的，你是白的，我没变，哦，那就等我变了再说吧。
    //    [[signalA zipWith:signalB] subscribeNext:^(RACTuple* x) {
    //        RACTupleUnpack(NSString *stringA, NSString *stringB) = x;
    //        NSLog(@"我们是%@%@的", stringA, stringB);
    //    }];
    
    //-------映射
    //    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        [subscriber sendNext:@"石"];
    //        return nil;
    //    }] map:^id(NSString* value) {
    //        if ([value isEqualToString:@"石"]) {
    //            return @"金";
    //        }
    //        return value;
    //    }];
    //    [signal subscribeNext:^(id x) {
    //        NSLog(@"%@", x);
    //    }];
    
    //-----------过滤
    //    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        [subscriber sendNext:@(15)];
    //        [subscriber sendNext:@(17)];
    //        [subscriber sendNext:@(21)];
    //        [subscriber sendNext:@(14)];
    //        [subscriber sendNext:@(30)];
    //        return nil;
    //    }] filter:^BOOL(NSNumber* value) {
    //        return value.integerValue >= 18;
    //    }] subscribeNext:^(id x) {
    //        NSLog(@"%@", x);
    //    }];
    
    //    //--------扁平，每一次sendNext都算作新的Signal来发起流程。
    //    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        NSLog(@"打蛋液");
    //        [subscriber sendNext:@"蛋液"];
    //        [subscriber sendNext:@"蛋液0"];
    //        [subscriber sendNext:@"蛋液1"];
    ////        [subscriber sendCompleted];
    //        return nil;
    //    }] flattenMap:^RACStream *(NSString* value) {
    //        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //                NSLog(@"把%@倒进锅里面煎",value);
    //                [subscriber sendNext:@"煎蛋"];
    //                [subscriber sendNext:@"煎蛋11111"];
    //                [subscriber sendNext:@"煎蛋22222"];
    //                [subscriber sendCompleted];
    //            return nil;
    //        }];
    //    }] flattenMap:^RACStream *(NSString* value) {
    //        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //            NSLog(@"把%@装到盘里", value);
    //            [subscriber sendNext:@"上菜"];
    //            [subscriber sendCompleted];
    //            return nil;
    //        }];
    //    }] subscribeNext:^(id x) {//会执行多次，直到所有的Signal都执行完
    //        NSLog(@"%@", x);
    //    }];
    
    //-------------顺序执行，只有当上一个completed后才会执行下一个，就算是执行很多个next或者出现错误也不会执行下一个。任何一步没有完成都不会进入下一步
    //    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        NSLog(@"打开冰箱门");
    ////        [subscriber sendCompleted];
    //        [subscriber sendError:nil];
    //        return nil;
    //    }] then:^RACSignal *{
    //        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //            NSLog(@"把大象塞进冰箱");
    //            [subscriber sendCompleted];
    //            return nil;
    //        }];
    //    }] then:^RACSignal *{
    //        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //            NSLog(@"关上冰箱门");
    //            [subscriber sendCompleted];
    //            return nil;
    //        }];
    //    }] subscribeCompleted:^{
    //        NSLog(@"把大象塞进冰箱了");
    //    }];
    
    //    RACCommand *aCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    //        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //            NSLog(@"我投降了");
    //            [subscriber sendCompleted];
    //            return nil;
    //        }];
    //    }];
    //    [aCommand execute:@NO];
    //
    //
    //    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        NSLog(@"等等我，我还有10秒钟就到了");
    //        [subscriber sendNext:nil];
    //        [subscriber sendCompleted];
    //        return nil;
    //    }] delay:10] subscribeNext:^(id x) {
    //        NSLog(@"我到了");
    //    }];
    
    //---------重放，一次制作，多次观看
    //    RACSignal *replaySignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        NSLog(@"大导演拍了一部电影《我的男票是程序员》");
    //        [subscriber sendNext:@"《我的男票是程序员》"];
    //        return nil;
    //    }] replay];
    //    //sendNext不能拿出来
    //    [replaySignal subscribeNext:^(id x) {
    //        NSLog(@"小明看了%@", x);
    //    }];
    //    [replaySignal subscribeNext:^(id x) {
    //        NSLog(@"小红也看了%@", x);
    //    }];
    
    //---------定时循环，每8小时执行一次
    //    [[RACSignal interval:60*60*8 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
    //        NSLog(@"吃药");
    //    }];
    
    //---------超时
    //    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //            NSLog(@"我快到了");
    //            [subscriber sendNext:nil];
    //            [subscriber sendCompleted];
    //            return nil;
    //        }] delay:60*70] subscribeNext:^(id x) {
    //            [subscriber sendNext:nil];
    //            [subscriber sendCompleted];
    //        }];
    //        return nil;
    //    }] timeout:60*60 onScheduler:[RACScheduler mainThreadScheduler]] subscribeError:^(NSError *error) {
    //        NSLog(@"等了你一个小时了，你还没来，我走了");
    //    }];
    
    //-------多次重试，直到成功
    //    __block int failedCount = 0;
    //    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        if (failedCount < 100) {
    //            failedCount++;
    //            NSLog(@"我失败了");
    //            [subscriber sendError:nil];
    //        }else{
    //            NSLog(@"经历了数百次失败后");
    //            [subscriber sendNext:nil];
    //        }
    //        return nil;
    //    }] retry] subscribeNext:^(id x) {
    //        NSLog(@"终于成功了");
    //    }];
    
    //----------节流--------有问题
    //    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        [subscriber sendNext:@"旅客A"];
    ////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [subscriber sendNext:@"旅客B"];
    ////        });
    ////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [subscriber sendNext:@"旅客C"];
    //            [subscriber sendNext:@"旅客D"];
    //            [subscriber sendNext:@"旅客E"];
    ////        });
    ////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [subscriber sendNext:@"旅客F"];
    ////        });
    //        return nil;
    //    }] throttle:3] subscribeNext:^(id x) {
    //        NSLog(@"%@通过了",x);
    //    }];
    
    //    //-----------条件
    //    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
    //            [subscriber sendNext:@"直到世界的尽头才能把我们分开"];
    //        }];
    //        return nil;
    //    }] takeUntil:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            NSLog(@"世界的尽头到了");
    //            [subscriber sendNext:@"世界的尽头到了"];
    //        });
    //        return nil;
    //    }]] subscribeNext:^(id x) {
    //        NSLog(@"%@", x);
    //    }];
    
    //    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
    //            [subscriber sendNext:@"直到世界的尽头才能把我们分开"];
    //        }];
    //        return nil;
    //    }] takeUntil:[self rac_signalForSelector:@selector(viewDidAppear:)]] subscribeNext:^(id x) {
    //        NSLog(@"%@", x);
    //    }];
    //
    
//    __block NSInteger count = 0;
//
//    self.resetBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            if (count++ % 2) {
//                [subscriber sendNext:@"1111"];
//                [subscriber sendCompleted];
//            } else
//            [subscriber sendError:nil];
//            return nil;
//        }];
//    }];
    
//    NSURL* url = [NSURL URLWithString:@"http://www.jianshu.com"];
//    RACSignal* getDataSignal = [NSData rac_readContentsOfURL:url options:NSDataReadingUncached
//                                                   scheduler:[RACScheduler mainThreadScheduler]];
//    [getDataSignal subscribeNext:^(id x) {
//        NSLog(@"%@",x);  //这里的x就是NSData数据
//    }];
    
//    self.resetBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        return [RACSignal empty];
//    }];
//    
//    [[self.resetBtn.rac_command.executionSignals switchToLatest] subscribeNext:^(id x) {
//        NSLog(@"---------------------%@",x);
//    }];
//    [self.resetBtn.rac_command.executing subscribeNext:^(id x) {
//        NSLog(@"---------------------%@",x);
//    }];
//    [self.resetBtn.rac_command.errors subscribeNext:^(id x) {
//        NSLog(@"---------------------==");
//    }];
//    [[self fetchColdSignal] subscribeNext:^(id x) {
//        
//    } error:^(NSError *error) {
//        
//    } completed:^{
//        
//    }];

}

- (void)resetClick
{
    [[self fetchUserInfo] subscribeNext:^(id x) {
        NSLog(@"next//%@",x);
    } error:^(NSError *error) {
        NSLog(@"error//%@",@(error.code));
    } completed:^{
        NSLog(@"completed");
    }];
}

- (RACSignal *)fetchUserInfo
{
    RACSubject *subject = [RACSubject subject];
    NSDictionary *params = @{
                             @"token":@"rO0ABXQAMcOWwq5xIiLCmkTAgFVzw7IswqHDhcOaw4lDecKgw7A0wp1Uw4rDpFzDqzE/w7XDkhE="
                             };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"http://test.dx.device.baidao.com/jry-device/dx/ajax/user/getUserByToken" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [subject sendNext:@"1"];
        [subject sendCompleted];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [subject sendError:error];
    }];
    return subject;
}

- (RACSignal *)fetchColdSignal
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendNext:@3];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"/////");
        }];
    }];
    return signal;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - touch id
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
//    if ([identifier isEqualToString:@"touch id push"]) {
//        [self handleTouchId];
//        return NO;
//    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void)handleTouchId
{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version < 8.0) {
        return;
    }
    LAContext *laContent = [[LAContext alloc] init];
    NSError *error;
    if ([laContent canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [laContent evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Touch ID Test" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"sucess//");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"touch id push" sender:self];
                });
            }
            if (error) {
                NSLog(@"error//%@",error);
                switch (error.code) {
                    case LAErrorAppCancel:
                    case LAErrorUserCancel:
                    case LAErrorUserFallback:
                    case LAErrorSystemCancel:
                    case LAErrorInvalidContext:
                    case LAErrorPasscodeNotSet:
                    case LAErrorTouchIDLockout:
                    case LAErrorTouchIDNotEnrolled:
                    case LAErrorTouchIDNotAvailable:
                    case LAErrorAuthenticationFailed:
                        break;
                        
                    default:
                        break;
                }
                
            }
        }];
    } else {
        NSLog(@"error//%@",error);
    }
}


@end
