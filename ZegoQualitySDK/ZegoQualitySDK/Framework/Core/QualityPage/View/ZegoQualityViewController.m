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

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation ZegoQualityViewController

- (instancetype)initWithConfig:(ZegoQualityVCConfig *)config {
  if (self = [super init]) {
    _config = config;
  }
  return self;
}

- (ZegoQualityLogWebBridge *)webBridge {
  if (!_webBridge) {
    _webBridge = [[ZegoQualityLogWebBridge alloc] init];
  }
  return _webBridge;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setupUI];
  [self loadWebResources];
}

- (void)setupUI {
  [self setupWebView];
  self.view.backgroundColor = UIColor.whiteColor;
  if ([self isBeingPresented]) {
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    UIImage *xmark = [UIImage imageNamed:@"quality_web_back"];
    [closeBtn setImage:xmark forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
    self.closeBtn = closeBtn;
  }
}

- (void)close {
  if (self.navigationController != nil) {
    [self.navigationController popViewControllerAnimated:YES];
  }else {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
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

- (void)viewWillLayoutSubviews {
  CGRect webViewFrame = CGRectMake(0, 50, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 50);
  [self.webView setFrame:webViewFrame];

  CGRect btnFrame = CGRectMake(10, 10, 44, 44);
  [self.closeBtn setFrame:btnFrame];
}

- (void)setupWebView {
  WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
  [config.userContentController addScriptMessageHandler:self name:@"search"];
  [config.userContentController addScriptMessageHandler:self name:@"closePage"];
  
  WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
  [self.view addSubview:webView];
  self.webView = webView;
}

- (void)loadWebResources {
//  NSBundle *bundle = [NSBundle bundleForClass:self.class];
//  NSURL *baseURL = [bundle URLForResource:@"index" withExtension:@"html" subdirectory:@"dist"];

  NSString *language = @"zh";
  if (self.config.languageType == ZegoQualityLanguageTypeEnglish) {
    language = @"en";
  }

  NSURL *baseURL = [NSURL URLWithString:@"http://192.168.6.180:8080/"];
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
  NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
  [self.webView loadRequest:request];
}

//- (void)loadWebResources {
//  NSBundle *bundle = [NSBundle bundleForClass:self.class];
//  NSURL *baseURL = [bundle URLForResource:@"index" withExtension:@"html" subdirectory:@"dist"];
//
//  NSString *language = @"zh";
//  if (self.config.languageType == ZegoQualityLanguageTypeEnglish) {
//    language = @"en";
//  }
//
//  NSString *params = [NSString stringWithFormat:
//                      @"?platform=4"
//                      "&room_id=%@"
//                      "&uid=%@"
//                      "&name=%@"
//                      "&product=%@"
//                      "&app_version_string=%@"
//                      "&lang=%@",
//                      self.config.roomID,
//                      self.config.userID,
//                      self.config.userName,
//                      self.config.productName,
//                      self.config.appVersion,
//                      language];
//
//  params = [params stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
//  params = [params stringByAppendingString:@"#scoring"];
//  NSURL *requestURL = [NSURL URLWithString:params relativeToURL:baseURL];
//  NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
//  [self.webView loadRequest:request];
//}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
  if ([message.name isEqualToString:@"search"]) {
    NSDictionary *dict = message.body;
    [self searchWithDict:dict];
  }else if ([message.name isEqualToString:@"closePage"]) {
    [self close];
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
//    NSLog(@"js result: %@", error);
  }];
}

- (BOOL)shouldAutorotate {
  return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
  return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}

@end
