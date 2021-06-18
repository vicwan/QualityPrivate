//
//  ZegoQualityViewController.m
//  go_class
//
//  Created by Vic on 2021/6/10.
//  Copyright © 2021 zego. All rights reserved.
//

#import "ZegoQualityViewController.h"
#import <WebKit/WebKit.h>
#import "ZegoQualityLogWebBridge.h"
#import "ZGModel.h"

@interface ZegoQualityViewController ()<WKScriptMessageHandler, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) ZegoQualityVCConfig *config;
@property (nonatomic, strong) ZegoQualityLogWebBridge *webBridge;

@end

@implementation ZegoQualityViewController

- (instancetype)initWithConfig:(ZegoQualityVCConfig *)config {
  if (self = [super init]) {
    _config = config;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setupUI];
  [self loadWebResources];
}

- (void)viewWillLayoutSubviews {
  [self.webView setFrame:self.view.bounds];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  if (self.delegate && [self.delegate respondsToSelector:@selector(viewForQualityViewControllerWillDisappear:)]) {
    [self.delegate viewForQualityViewControllerWillDisappear:self];
  }
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  if (self.delegate && [self.delegate respondsToSelector:@selector(viewForQualityViewControllerDidDisappear:)]) {
    [self.delegate viewForQualityViewControllerDidDisappear:self];
  }
}

- (void)setupUI {
  self.view.backgroundColor = UIColor.whiteColor;
  [self setupWebView];
}

#pragma mark - WebView Setup
- (void)setupWebView {
  WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
  [config.userContentController addScriptMessageHandler:self name:@"search"];
  [config.userContentController addScriptMessageHandler:self name:@"closePage"];
  
  WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
  webView.scrollView.bounces = NO;
  webView.scrollView.showsVerticalScrollIndicator = NO;
  [self.view addSubview:webView];
  self.webView = webView;
}

- (void)loadWebResources {
#if DEBUG
  NSURL *requestURL = [self requestLANTestURL];
#else
  NSURL *requestURL = [self requestBundleResourceURL];
#endif
  NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
  [self.webView loadRequest:request];
}

- (NSURL *)requestLANTestURL {
  NSString *language = @"zh";
  if (self.config.languageType == ZegoQualityLanguageTypeEnglish) {
    language = @"en";
  }
  
  NSURL *baseURL = [NSURL URLWithString:@"https://doc-appdemo-report.zego.im/"];
  NSString * path = @"/#/scoring/";
  NSString *params = [NSString stringWithFormat:
                      @"?platform=4"
                      "&room_id=%@"
                      "&uid=%@"
                      "&name=%@"
                      "&product=%@"
                      "&app_version_string=%@"
                      "&lang=%@",
                      self.config.roomID,
                      self.config.userID,
                      self.config.userName,
                      self.config.productName,
                      self.config.appVersion,
                      language];
  
  
  params = [params stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
  path = [path stringByAppendingString:params];
  
  NSURL *requestURL = [NSURL URLWithString:path relativeToURL:baseURL];
  return requestURL;
}

- (NSURL *)requestBundleResourceURL {
  NSBundle *bundle = [NSBundle bundleForClass:self.class];
  NSURL *baseURL = [bundle URLForResource:@"index" withExtension:@"html" subdirectory:@"dist"];
  
  NSString *language = @"zh";
  if (self.config.languageType == ZegoQualityLanguageTypeEnglish) {
    language = @"en";
  }
  
  NSString *params = [NSString stringWithFormat:
                      @"?platform=4"
                      "&room_id=%@"
                      "&uid=%@"
                      "&name=%@"
                      "&product=%@"
                      "&app_version_string=%@"
                      "&lang=%@",
                      self.config.roomID,
                      self.config.userID,
                      self.config.userName,
                      self.config.productName,
                      self.config.appVersion,
                      language];
  
  params = [params stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
  params = [params stringByAppendingString:@"#scoring"];
  NSURL *requestURL = [NSURL URLWithString:params relativeToURL:baseURL];
  return requestURL;
}

#pragma mark - JS Action
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
  if ([message.name isEqualToString:@"search"]) {
    NSDictionary *dict = message.body;
    [self searchWithDict:dict];
  }else if ([message.name isEqualToString:@"closePage"]) {
    [self closePage];
  }
}

- (void)searchWithDict:(NSDictionary *)dict {
  ZegoQualityLogWebQueryRequestModel *webRqstModel = [[ZegoQualityLogWebQueryRequestModel alloc] init];
  webRqstModel.seq = dict[@"seq"];
  webRqstModel.querySqlString = dict[@"sql"];
  webRqstModel.queryTableName = dict[@"table_name"];
  [self.webBridge execQueryWithModel:webRqstModel complete:^(ZegoQualityLogWebQueryResponseModel * _Nonnull rsp) {
    [self jsQueryResult:rsp];
  }];
}

- (void)jsQueryResult:(ZegoQualityLogWebQueryResponseModel *)rsp {
  NSInteger seq = rsp.seq.integerValue;
  NSString *dataJson = [rsp.dataModel zego_modelToJSONString];
  NSString *js = [NSString stringWithFormat:@"quality_callback(%ld, %@)", (long)seq, dataJson];
  [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    //回调结果
//    ZegoQualityLog(@"js result: %@", error);
  }];
}

- (void)closePage {
  if (self.navigationController != nil) {
    [self.navigationController popViewControllerAnimated:YES];
  }else {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

#pragma mark - Orientation
- (BOOL)shouldAutorotate {
  return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
  return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Lazy
- (ZegoQualityLogWebBridge *)webBridge {
  if (!_webBridge) {
    _webBridge = [[ZegoQualityLogWebBridge alloc] init];
  }
  return _webBridge;
}

@end
