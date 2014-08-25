//
//  ClubsViewController.m
//  AggiesLand
//
//  Created by Neegbeah Reeves on 1/10/14.
//  Copyright (c) 2014 Neegbeah Reeves. All rights reserved.
//

#import "ClubsViewController.h"
#import "ClubCustomCell.h"
#import "Clubs.h"
#import "ClubDetailsViewController.h"
#import "SWRevealViewController.h"

@interface ClubsViewController ()


@end

@implementation ClubsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(PFQuery *)queryForTable{
    PFQuery*query =[PFQuery queryWithClassName:@"Clubs"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork; // Save Data from Parse Cloud to Device to avoid reconnection from the internet to retrieve data again
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}



- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.color = [UIColor colorWithRed:0.22 green:0.15 blue:0.70 alpha:0.90];

    hud.labelText = @"Loading";
    [hud hide:YES afterDelay:3.0];
    
	// Do any additional setup after loading the view.
    
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // Specify the ad unit ID.
    bannerView_.adUnitID = @"ca-app-pub-2971437863634496/4990882568";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];
    
    
    
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    

}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"Cell";
    ClubCustomCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [[ClubCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    

    
    NSString *eventNameLabel =[object objectForKey:@"Title"];
    NSString *clubNameLabel =[object objectForKey:@"ClubName"];
    NSString *LocationLabel =[object objectForKey:@"Address"];
    NSString *priceLabel =[object objectForKey:@"Price"];
    NSString *dateLabel = [object objectForKey:@"Date"];
    NSString *inlabel = [object objectForKey:@"Details"];
    
    PFFile *thumbnail =[object objectForKey:@"imageFile"];
    cell.imageViewFile.image = [UIImage imageNamed:@"placeholder.png"];
    cell.imageViewFile.file = thumbnail;
    [cell.imageViewFile loadInBackground];

    
    [cell.name setText:[NSString stringWithFormat:@"%@",eventNameLabel]];
    [cell.clubName setText:[NSString stringWithFormat:@"%@", clubNameLabel]];
    [cell.location setText:[NSString stringWithFormat:@"%@", LocationLabel]];
    [cell.price setText:[NSString stringWithFormat:@"%@", priceLabel]];
    [cell.date setText:[NSString stringWithFormat:@"%@",dateLabel]];
    [cell.instructions setText:[NSString stringWithFormat:@"%@", inlabel]];
    
    
    
    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    // Configure cell
    
    // cell.textLabel.text = [object objectForKey:@"EventName"];
    //  cell.detailTextLabel.text = [object objectForKey:@"Location"];
    
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showClubDetail"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ClubDetailsViewController *destViewController = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        Clubs *clubs = [[Clubs alloc] init];
        clubs.name = [object objectForKey:@"Title"];
        clubs.date = [object objectForKey:@"Date"];
        clubs.clubName = [object objectForKey:@"ClubName"];
        clubs.instructions = [object objectForKey:@"Details"];
        clubs.location =[object objectForKey:@"Address"];
        clubs.price = [object objectForKey:@"Price"];
        clubs.file = [object objectForKey:@"imageFile"];
        
        
        destViewController.clubs = clubs;
        
    }
}





#pragma mark - DZEmptyView

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"No Club Events...Yet";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"Come back later. We will notify you when the events are updated... Or check your internet connection.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIColor whiteColor];
}

#pragma mark - DZEmptyView Delegate


- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    
    return YES;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView {
    
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



@end
