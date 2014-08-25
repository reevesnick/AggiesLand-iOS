//
//  AnnonCustomCell.h
//  AggiesLand
//
//  Created by Neegbeah Reeves on 10/20/13.
//  Copyright (c) 2013 Neegbeah Reeves. All rights reserved.
//

#import <Parse/Parse.h>

@interface AnnonCustomCell : PFTableViewCell

@property (weak,nonatomic) IBOutlet UILabel *title;
@property (weak,nonatomic) IBOutlet UILabel *body;
@property (weak,nonatomic) IBOutlet UILabel *date;
@property (weak,nonatomic) IBOutlet UILabel *postedBy;
@property (strong,nonatomic) IBOutlet PFImageView *imageViewFile;

@end
