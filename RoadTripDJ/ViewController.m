//
//  ViewController.m
//  RoadTripDJ
//
//  Created by Brian Wong on 11/12/16.
//  Copyright © 2016 Brian Wong. All rights reserved.
//

#import "ViewController.h"

@import MediaPlayer;

@interface ViewController ()<MPMediaPickerControllerDelegate>

@property (nonatomic, strong) MPMediaItemCollection *playlist;
@property (nonatomic, strong) MPMusicPlayerController *player;
@property (weak, nonatomic) IBOutlet UIToolbar *playerBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.player = [[MPMusicPlayerController alloc]init];
    
}

- (void)togglePlayPause{
    if(self.player.playbackState == MPMusicPlaybackStatePlaying){
        [self.player pause];
    }else{
        [self.player play];
    }
}


#pragma mark - IBActions
- (IBAction)addMusic:(id)sender {
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.prompt = @"Add Music";
    mediaPicker.showsCloudItems = YES;
    mediaPicker.allowsPickingMultipleItems = YES;
    [self presentViewController:mediaPicker animated:nil completion:nil];
}

- (IBAction)playPause:(id)sender {
    [self togglePlayPause];
}

#pragma mark - MPMediaPickerController Delegate methods

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{

    //If this isn't a new item collection, append to our old one
    if(!self.playlist){
        self.playlist = mediaItemCollection;
    }else{
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:self.playlist.count + mediaItemCollection.count];
        [items addObjectsFromArray:self.playlist.items];
        [items addObjectsFromArray:mediaItemCollection.items];
        MPMediaItemCollection *collection = [MPMediaItemCollection collectionWithItems:items];
        self.playlist = collection;
    }
    
    [self.player setQueueWithItemCollection:self.playlist];
    if(self.player.playbackState != MPMusicPlaybackStatePlaying){
        [self.player play];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
