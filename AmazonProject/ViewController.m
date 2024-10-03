//
//  ViewController.m
//  AmazonProject
//
//  Created by Nicolas Rios on 10/2/24.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController () <UIScrollViewDelegate, WKNavigationDelegate, UITabBarDelegate>

@property (strong, nonatomic) UIView *searchBarView;
@property (strong, nonatomic) UIScrollView *linkScrollView;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UITabBar *tabBar;
@property (strong, nonatomic) NSDictionary *linkURLs;
@property (assign, nonatomic) CGFloat lastContentOffsetY;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupLinkURLs];
    [self setupSearchBarView];
    [self setupLinkBar];
    [self setupWebView];
    [self setupTabBar];
}

#pragma mark - Setup Link URLs

- (void)setupLinkURLs {
    self.linkURLs = @{
        @"46530": @"https://www.amazon.com/gp/help/customer/display.html?nodeId=202063460",
        @"Whole Foods": @"https://www.amazon.com/gp/help/customer/display.html?nodeId=202111220",
        @"Medical Care": @"https://www.amazon.com/gp/help/customer/display.html?nodeId=202166830",
        @"Pharmacy": @"https://www.amazon.com/gp/help/customer/display.html?nodeId=202033900",
        @"Grocery": @"https://www.amazon.com/gp/help/customer/display.html?nodeId=202112510",
        @"Electronics": @"https://www.amazon.com/gp/help/customer/display.html?nodeId=202112420",
        @"Books": @"https://www.amazon.com/gp/help/customer/display.html?nodeId=202056920"
    };
}

#pragma mark - Setup UI

- (void)setupSearchBarView {
    self.searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 60)];
    self.searchBarView.backgroundColor = [UIColor clearColor];

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 40)];
    searchBar.placeholder = @"Search or ask a question";
    searchBar.layer.cornerRadius = 20;
    searchBar.layer.masksToBounds = YES;

    [self.searchBarView addSubview:searchBar];
    [self.view addSubview:self.searchBarView];
}

- (void)setupLinkBar {
    self.linkScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBarView.frame), self.view.frame.size.width, 44)];
    self.linkScrollView.showsHorizontalScrollIndicator = YES;
    self.linkScrollView.showsVerticalScrollIndicator = NO;
    self.linkScrollView.scrollEnabled = YES;
    self.linkScrollView.bounces = YES;

    NSArray *linkTitles = @[@"46530", @"Whole Foods", @"Medical Care", @"Pharmacy", @"Grocery", @"Electronics", @"Books"];
    CGFloat buttonX = 10;

    for (NSString *title in linkTitles) {
        UIButton *linkButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [linkButton setTitle:title forState:UIControlStateNormal];
        [linkButton sizeToFit];

        CGRect buttonFrame = linkButton.frame;
        buttonFrame.origin.x = buttonX;
        buttonFrame.origin.y = 2;
        linkButton.frame = buttonFrame;

        [linkButton addTarget:self action:@selector(linkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        [self.linkScrollView addSubview:linkButton];
        buttonX += buttonFrame.size.width + 15;
    }

    self.linkScrollView.contentSize = CGSizeMake(buttonX, self.linkScrollView.frame.size.height);
    [self.view addSubview:self.linkScrollView];
}

- (void)setupWebView {
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.linkScrollView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.linkScrollView.frame) - 70)];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];

    NSURL *url = [NSURL URLWithString:@"https://www.amazon.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)setupTabBar {
    CGFloat tabBarHeight = 70;
    self.tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - tabBarHeight, self.view.frame.size.width, tabBarHeight)];
    self.tabBar.delegate = self;

    UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
    appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffsetMake(0, -5);
    appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffsetMake(0, -5);

    self.tabBar.standardAppearance = appearance;
    if (@available(iOS 15.0, *)) {
        self.tabBar.scrollEdgeAppearance = appearance;
    }

    UITabBarItem *homeTab = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage systemImageNamed:@"house"] tag:0];
    UITabBarItem *cartTab = [[UITabBarItem alloc] initWithTitle:@"Cart" image:[UIImage systemImageNamed:@"cart"] tag:1];
    self.tabBar.items = @[homeTab, cartTab];

    [self.view addSubview:self.tabBar];
}

#pragma mark - Link Button Tapped

- (void)linkButtonTapped:(UIButton *)sender {
    NSString *buttonTitle = sender.titleLabel.text;
    NSString *urlString = self.linkURLs[buttonTitle];  // Get the URL directly from the dictionary

    if (urlString) {
        [self loadWebPageWithURL:urlString];  // Load the URL in the web view
    }
}

#pragma mark - Scroll Behavior for Hiding/Showing Link Bar and Tab Bar

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    // Scroll up: hide link bar and tab bar completely off the screen
    if (offsetY > self.lastContentOffsetY) {
        [UIView animateWithDuration:0.3 animations:^{
            self.linkScrollView.frame = CGRectMake(0, -self.linkScrollView.frame.size.height, self.view.frame.size.width, self.linkScrollView.frame.size.height);
            self.tabBar.frame = CGRectMake(0, self.view.frame.size.height + self.tabBar.frame.size.height, self.view.frame.size.width, self.tabBar.frame.size.height);  // Move tab bar fully off the screen
        }];
    }
    // Scroll down: bring link bar and tab bar back into view
    else if (offsetY < self.lastContentOffsetY) {
        [UIView animateWithDuration:0.3 animations:^{
            self.linkScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.searchBarView.frame), self.view.frame.size.width, self.linkScrollView.frame.size.height);
            self.tabBar.frame = CGRectMake(0, self.view.frame.size.height - self.tabBar.frame.size.height, self.view.frame.size.width, self.tabBar.frame.size.height);  // Bring tab bar back into view
        }];
    }

    self.lastContentOffsetY = offsetY;
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0) {
        [self loadWebPageWithURL:@"https://www.amazon.com"];
    } else if (item.tag == 1) {
        [self loadWebPageWithURL:@"https://www.amazon.com/cart"];
    }
}

#pragma mark - Web Page Loading

- (void)loadWebPageWithURL:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

@end
