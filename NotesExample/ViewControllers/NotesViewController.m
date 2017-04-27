//
//  NotesViewController.m
//  NotesExample
//
//  Created by Raphael Araújo on 4/6/17.
//  Copyright © 2017 araujoraphael. All rights reserved.
//

#import "NotesViewController.h"
#import "NoteTableViewCell.h"
#import "NoteViewController.h"
#import "Note.h"
#import "DataManager.h"
@interface NotesViewController()<NoteViewControllerDelegate>
@end

@implementation NotesViewController
NSMutableArray *notes;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTapped:)];

    [self.tableView registerNib:[UINib nibWithNibName:@"NoteTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoteTableViewCell"];

    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    [[DataManager sharedManager] getNotesList:^(BOOL error, NSString *message, NSArray *array) {
        if(!error) {
            notes = [[NSMutableArray alloc] initWithArray:array];
            [self.tableView reloadData];
        }
    }];
}

- (void)addTapped:(id)sender {
    Note *note = [[Note alloc] init];
    note.noteId = -1;
    note.date = [NSDate date];
    [notes addObject:note];
    [self performSegueWithIdentifier:@"noteDetailSegue" sender:note];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [notes count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"NoteTableViewCell"];
    if (!cell) {
        cell = (NoteTableViewCell *)[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RAIconTableViewCell"];
    }
    
    cell.note = notes[indexPath.row];
    
    return cell;
}
#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"noteDetailSegue" sender:notes[indexPath.row]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"noteDetailSegue"]) {
        NoteViewController *noteVC = segue.destinationViewController;
        noteVC.note = (Note *)sender;
        noteVC.delegate = self;
    }
}
#pragma mark - NoteViewControllerDelegate methods
- (void)didCreateNote:(Note *)note {
    [self.tableView reloadData];
}

- (void)didDeleteNote:(Note *)note {
    [notes removeObject:note];
    [self.tableView reloadData];
}

@end
