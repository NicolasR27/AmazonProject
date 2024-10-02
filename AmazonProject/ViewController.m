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
@property (assign, nonatomic) CGFloat lastContentOffsetY;  // Track last scroll position

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Setup the search bar view (Top Bar)
    [self setupSearchBarView];

    // Setup the link bar (Horizontal Scrollable Links)
    [self setupLinkBar];

    // Setup the web view
    [self setupWebView];

    // Setup the tab bar
    [self setupTabBar];
}

#pragma mark - Setup UI

// Set up search bar view
- (void)setupSearchBarView {
    self.searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 60)];
    self.searchBarView.backgroundColor = [UIColor clearColor];

    // Search bar setup
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 40)];
    searchBar.placeholder = @"Search or ask a question";
    searchBar.layer.cornerRadius = 20;
    searchBar.layer.masksToBounds = YES;

    [self.searchBarView addSubview:searchBar];
    [self.view addSubview:self.searchBarView];
}

// Set up horizontal link bar
- (void)setupLinkBar {
    self.linkScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBarView.frame), self.view.frame.size.width, 44)];
    self.linkScrollView.showsHorizontalScrollIndicator = YES;
    self.linkScrollView.showsVerticalScrollIndicator = NO;
    self.linkScrollView.scrollEnabled = YES;
    self.linkScrollView.bounces = YES;

    // Add buttons inside the scroll view
    NSArray *linkTitles = @[@"46530", @"Whole Foods", @"Medical Care", @"Pharmacy", @"Grocery", @"Electronics", @"Books"];
    CGFloat buttonX = 10;  // Starting x position for the buttons

    for (NSString *title in linkTitles) {
        UIButton *linkButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [linkButton setTitle:title forState:UIControlStateNormal];
        [linkButton sizeToFit];

        CGRect buttonFrame = linkButton.frame;
        buttonFrame.origin.x = buttonX;
        buttonFrame.origin.y = 2;  // Vertically center the buttons within the scroll view
        linkButton.frame = buttonFrame;

        [self.linkScrollView addSubview:linkButton];
        buttonX += buttonFrame.size.width + 15;  // Add some space between buttons
    }

    self.linkScrollView.contentSize = CGSizeMake(buttonX, self.linkScrollView.frame.size.height);
    [self.view addSubview:self.linkScrollView];
}

// Set up web view
- (void)setupWebView {
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.linkScrollView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.linkScrollView.frame) - 49)];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.delegate = self;  // Set the scroll view delegate to self
    [self.view addSubview:self.webView];

    // Load a test page
    NSURL *url = [NSURL URLWithString:@"https://www.amazon.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

// Set up tab bar
- (void)setupTabBar {
    self.tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    self.tabBar.delegate = self;

    UITabBarItem *homeTab = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage systemImageNamed:@"house"] tag:0];
    UITabBarItem *cartTab = [[UITabBarItem alloc] initWithTitle:@"Cart" image:[UIImage systemImageNamed:@"cart"] tag:1];

    self.tabBar.items = @[homeTab, cartTab];
    [self.view addSubview:self.tabBar];
}

#pragma mark - Scroll View Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    // Scroll down (show bars)
    if (offsetY < self.lastContentOffsetY && self.linkScrollView.frame.origin.y < CGRectGetMaxY(self.searchBarView.frame)) {
        [UIView animateWithDuration:0.3 animations:^{
            self.linkScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.searchBarView.frame), self.view.frame.size.width, 44);
            self.tabBar.frame = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49);
        }];
    }
    // Scroll up (hide bars)
    else if (offsetY > self.lastContentOffsetY && self.linkScrollView.frame.origin.y >= CGRectGetMaxY(self.searchBarView.frame)) {
        [UIView animateWithDuration:0.3 animations:^{
            self.linkScrollView.frame = CGRectMake(0, -self.linkScrollView.frame.size.height, self.view.frame.size.width, 44);
            self.tabBar.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 49);
        }];
    }

    // Update the last content offset for the next comparison
    self.lastContentOffsetY = offsetY;
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0) {
        [self loadWebPageWithURL:@"https://www.amazon.com"];  // Home tab loads Amazon home page
    } else if (item.tag == 1) {
        [self loadWebPageWithURL:@"https://www.amazon.com/cart"];  // Cart tab loads Amazon cart page
    }
}

#pragma mark - Web Page Loading

- (void)loadWebPageWithURL:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

@end
