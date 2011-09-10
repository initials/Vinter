//
//  ViBridge.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <tr1/functional>
#import <objc/message.h>
#import <Foundation/Foundation.h>

namespace vi
{
    namespace common
    {
        /**
         * @brief Forwards C++ method invocations to an Objective-C target
         *
         * objCBridge instances take a target and a selector that is invoked when one of the member functions is invoked, passing down all parameters
         * to the Objective-C target. 
         * @remark Don't forget to typecast the template parameter when binding with std::tr1::bind()!
         * @remark The target won't be retained!
         *
         * @sa ViCppBridge
         **/
        class objCBridge
        {
        public:
            /**
             * Constructor
             **/
            objCBridge(id ttarget=nil, SEL tselector=NULL);
            
            id target; /**< The target to which the methods are forwarded*/
            SEL selector; /**< The selector invoked on the target */
            
            /**
             * Invokes the selector on the target without passing a parameter.<br />
             * The signature of the receiving method should look like: - (void)foo
             **/
            void parameter0Action()
            {
                objc_msgSend(target, selector);
            }
            
            /**
             * Invokes the selector on the target passing all given parameters.<br />
             * The signature of the receiving method should look like: - (void)foo:(T)param
             **/
            template <class T>
            void parameter1Action(T value)
            {
                objc_msgSend(target, selector, value);
            }
            
            /**
             * Invokes the selector on the target passing all given parameters.<br />
             * The signature of the receiving method should look like: - (void)foo:(T1)param1 :(T2)param2
             **/
            template <class T1, class T2>
            void parameter2Action(T1 value1, T2 value2)
            {
                objc_msgSend(target, selector, value1, value2);
            }
            
            /**
             * Invokes the selector on the target passing all given parameters.<br />
             * The signature of the receiving method should look like: - (void)foo:(T1)param1 :(T2)param2 :(T3)param3
             **/
            template <class T1, class T2, class T3>
            void parameter3Action(T1 value1, T2 value2, T3 value3){
                objc_msgSend(target, selector, value1, value2, value3);
            }
        };
    }
}


/**
 * @brief Forwards Objective-C invocations to a C++ target
 * 
 * ViCppBridge instances forward Objective-C method invocations to a C++ target bound using std::tr1::bind(). There are several methods you can invoke
 * on this class which will then invoke the corresponding C++ function if available or, if the function isn't set, ditching parameters and trying to invoke
 * the next function.
 **/
@interface ViCppBridge : NSObject
{
}

/**
 * A function without a parameter, invoked when parameter0Action is invoked.
 **/
@property (nonatomic, assign) std::tr1::function<void ()> function0;
/**
 * A function without a parameter, invoked when parameter1Action is invoked.
 **/
@property (nonatomic, assign) std::tr1::function<void (void *)> function1;
/**
 * A function without a parameter, invoked when parameter2Action is invoked.
 **/
@property (nonatomic, assign) std::tr1::function<void (void *, void *)> function2;
/**
 * A function without a parameter, invoked when parameter3Action is invoked.
 **/
@property (nonatomic, assign) std::tr1::function<void (void *, void *, void *)> function3;

/**
 * Invokes function0 if set, otherwise nothing will happen.
 **/
- (void)parameter0Action;
/**
 * Invokes function1 or if its not set it will invoke parameter0Action, ditching the parameter.
 **/
- (void)parameter1Action:(void *)value;
/**
 * Invokes function2 or if its not set it will invoke parameter1Action, ditching the last parameter.
 **/
- (void)parameter2Action:(void *)value1 :(void *)value2;
/**
 * Invokes function3 or if its not set it will invoke parameter2Action, ditching the last parameter.
 **/
- (void)parameter3Action:(void *)value1 :(void *)value2 :(void *)value3;

@end
