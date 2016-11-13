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
@property (nonatomic, weak) IBOutlet UIToolbar *playerBar;
@property (nonatomic, strong) UIBarButtonItem *playButton;

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
    
    [self setPlayButtonForPlaybackState:self.player.playbackState];
}

- (UIBarButtonItem *)playButtonItemForPlaybackState:(MPMusicPlaybackState)state{
    UIBarButtonSystemItem systemItem;
    if(state == MPMusicPlaybackStatePlaying){
        systemItem = UIBarButtonSystemItemPause;
    }else{
        systemItem = UIBarButtonSystemItemPlay;
    }
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:systemItem target:self action:@selector(playPause:)];
    
    return buttonItem;
}

- (void)setPlayButtonForPlaybackState:(MPMusicPlaybackState)playbackState{
    NSMutableArray *barButtonItems = [self.playerBar.items mutableCopy];
    NSUInteger index = [barButtonItems indexOfObjectIdenticalTo:self.playButton];
    [barButtonItems removeObjectAtIndex:index];
    [barButtonItems insertObject:[self playButtonItemForPlaybackState:playbackState]  atIndex:index];
    
    [self.playerBar setItems:barButtonItems];
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
    self.playButton = sender;
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
