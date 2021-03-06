//
//  FileSelectTableView.m
//  PlayMp3
//
//  Created by Dave Albert on 07/08/2012.
//  Copyright (c) 2012 Publicis. All rights reserved.
//

#import "FileSelectTableView.h"

@implementation FileSelectTableView

@synthesize controllerDelegate;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self commonInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    // Initialization code
    [self commonInit];
  }
  return self;
}

- (void)commonInit {
  listOfFiles = [self importableFiles];
}

#pragma mark - User Interaction Methods

- (void)refreshData {
  listOfFiles = [self importableFiles];
  [self reloadData];
}

#pragma mark - Supporting Methods

- (NSMutableArray *)importableFiles {
  NSMutableArray *retval = [NSMutableArray array];

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *publicDocumentsDir = [paths objectAtIndex:0];

  NSError *error;
  NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:publicDocumentsDir error:&error];
  if (files == nil) {
    [[[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    return retval;
  }

  for (NSString *file in files) {
    if ([file.pathExtension compare:@"mp3" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
      NSString *fullPath = [publicDocumentsDir stringByAppendingPathComponent:file];
      [retval addObject:fullPath];
    }
  }

  return retval;
}

- (NSString *)shortName:(NSString *)longName{
  NSArray *split = [longName componentsSeparatedByString:@"/"];
  return [split objectAtIndex:([split count] - 1)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [listOfFiles count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"FlowCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];


  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }

  // Configure the cell...
  [[cell textLabel] setText:[self shortName:[listOfFiles objectAtIndex:indexPath.row]]];
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [[self controllerDelegate] fileSelectTableViewSelectionMade:self withShortName:[self shortName:[listOfFiles objectAtIndex:indexPath.row]] withLongName:[listOfFiles objectAtIndex:indexPath.row]];
}



@end
