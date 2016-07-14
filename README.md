#DebugPanel
[blog 说明地址](http://www.flywithme.top/2016/07/14/debugpanel/)
## 初衷 
 
 移动端开发的时候总会遇到需要切换设备环境,或者切换服务器环境,或者查看一些测试 Log的时候。   这个时候免不了需要调取一下设备信息,所以就想做一个固定在状态栏上的的  
 Debug 功能控件,之前公司也有一个旧的类似控件。  但是里面牵连业务非常多,而且扩展也不友好,所以我就想趁着有新项目需求的时候写一个顶部的控件壳子，
 而且可以很方便的扩展方法,当然,需要的测试方法依然需要开发者手动添加,这个控件并不侵入业务,以后如果有需要可以做一些设备基础功能的公用方法。  
 暂时这个工具只有一个非常简单的工具壳,使用起来应该也不算麻烦.下面是使用方法
 
  效果如下图:  
  ![01](https://github.com/brasbug/DebugPanel/blob/master/Source/01.gif)
 
## 使用方法
 
 **Podfile**  
   To integrate DebugPanel into your Xcode project using CocoaPods, specify it in your Podfile:
     
     source 'https://github.com/CocoaPods/Specs.git'
     platform :ios, '7.0'
     target 'TargetName' do
     pod 'DebugPanel'  , :git =>'https://github.com/brasbug/DebugPanel.git'
     end
   then ,runthe following command:   
   
    pod install
    
## 参数说明及使用:
   ```MTADebugModel```
    
     /**
      *  @author Jack, 16-07-14 12:07:12
      *
      *  title: 显示名称
      *  selectorProperty: 调用的方法签名
      *  etc: 额外参数
      */
      @property (nonatomic, strong) NSString *title;
      @property (nonatomic, strong) NSDictionary *etc;
      @property (nonatomic, strong) NSString *selectorProperty;
 
   ```MTADebugMethodBridge```  使用者需要把MTADebugModel中命名的 
     
    //在方法调用的时候根据传入的参数生成相应的 selector 
    - (BOOL)handleSelectorProperty:(MTADebugModel *)modelProperty
    {
        if (modelProperty && modelProperty.title && modelProperty.selectorProperty.length) {
            SEL selector = [self selectorForMethod:modelProperty.selectorProperty];
            if (!selector || ![self respondsToSelector:selector]) {
                return NO;
            }
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:selector withObject:modelProperty];
            NSLog(@"%@",modelProperty);
    #pragma clang diagnostic pop
            return YES;
        }
        return NO;
    }
    //生成相应的方法
    - (SEL)selectorForMethod:(NSString *)method {
        if ([method length] == 0) return nil;
        NSString *objcMethod = [[@"debugapi_" stringByAppendingString:method] stringByAppendingString:@":"];
        return NSSelectorFromString(objcMethod);
    }
 



## Usage  
  如果需要在```didFinishLaunchingWithOptions```或者是 rootiew 中启动,
  一定要使用```performSelector``方法延迟调用启动 debug 按钮
   
   
   
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        // Override point for customization after application launch.
        [self performSelector:@selector(doJobsAfterFinishLaunching) withObject:nil afterDelay:0];
        return YES;
    }
    
    - (void)doJobsAfterFinishLaunching
    {
        NSMutableArray *arrlist = [NSMutableArray array];
        
        MTADebugModel *item = [[MTADebugModel alloc]init];
        item.title = @"一键线上";
        item.selectorProperty = @"changeOnlineServer";
        item.etc = @{@"host":@"http://www.baidu.com"};
        [arrlist addObject:item];
        
        item = [[MTADebugModel alloc]init];
        item.title = @"一键测试";
        item.selectorProperty = @"changeTestServer";
        item.etc = @{@"host":@"http://www.sohu.com"};
        [arrlist addObject:item];
        
        item = [[MTADebugModel alloc]init];
        item.title = @"调试面板";
        item.selectorProperty = @"showDebugPanel";
        //    item.etc = @{@"a":@"b"};
        [arrlist addObject:item];
        
        item = [[MTADebugModel alloc]init];
        item.title = @"打开 URL";
        item.selectorProperty = @"OpenSchemeURL";
        //    item.etc = @{@"c":@"d"};
        [arrlist addObject:item];
        
        [[MTADebugpanel shareInstance]startDebugBar:YES methodModels:arrlist error:^(NSString *errMsg) {
            NSLog(@"%@",errMsg);
        }];
    }
  
##  这一步很重要 
   创建```MTADebugMethodBridge```的 ```category``` 实现你在 ```MTADebugModel``` 中的```selectorProperty``` 参数方法,
   需要加上 ```debugapi_```的签名前缀   
   
    - (void)debugapi_changeOnlineServer:(MTADebugModel *)parameters{
    // TODO  Do Your Job
    }
    
    
    - (void)debugapi_OpenSchemeURL:(MTADebugModel *)parameters{
        // TODO  Do Your Job
    }
