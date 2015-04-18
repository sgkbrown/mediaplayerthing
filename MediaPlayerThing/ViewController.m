//
//  ViewController.m
//  MediaPlayerThing
//
//  Created by Nutech Systems on 11/12/14.
//  Copyright (c) 2014 NuTech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *pickSongButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) MPMediaItemCollection *songs;
@property (weak, nonatomic) MPMusicPlayerController *player;
@property (strong, nonatomic) UIImage *playImage;
@property (strong, nonatomic) UIImage *pauseImage;
@property (weak, nonatomic) IBOutlet UIButton *nextSongButton;
@property (weak, nonatomic) IBOutlet UIButton *prevSongButton;
//@property (nonatomic) BOOL test;

@end

@implementation ViewController
- (IBAction)prevSong:(id)sender {
    NSLog(@"Previous Song");
    if (_songs.count > 1) {
        [_player skipToPreviousItem];

    }
}

- (IBAction)nextSong:(id)sender {
    NSLog(@"Next Song");
    if (_songs.count > 1) {
        [_player skipToNextItem];
    }

}

- (IBAction)play:(id)sender {
    if (_player.playbackState == MPMusicPlaybackStatePlaying){
        [_player pause];
    } else {
        if (_songs.count > 0) {
            [_player play];
        }
    }
//    [self changePlayButton];
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    [_player setQueueWithItemCollection:mediaItemCollection];
    _songs = mediaItemCollection;
    [self play:nil];
}

- (IBAction)pickSong:(id)sender {
    MPMediaPickerController *mpc = [[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeMusic];
    [mpc setDelegate:self];
    mpc.allowsPickingMultipleItems = YES;
    
    [self presentViewController:mpc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _player = [MPMusicPlayerController applicationMusicPlayer];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSNotificationCenter *cent = [[NSNotificationCenter alloc]init];
    [cent addObserver:self selector:@selector(changePlayButton) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
               object:self];
    [cent addObserver:self selector:@selector(changePlayButton) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.masksToBounds = YES;
    gradientLayer.frame = _pickSongButton.layer.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor whiteColor].CGColor,
                            (id)[UIColor grayColor].CGColor,
                            (id)[UIColor whiteColor].CGColor,
                            nil];
    gradientLayer.cornerRadius = _pickSongButton.layer.cornerRadius;
    [_pickSongButton.layer addSublayer:gradientLayer];
    
    [self createButtonLayers];
    
    [self changePlayButton];
    
    CAGradientLayer *gradientLayer3 = [CAGradientLayer layer];
    gradientLayer3.masksToBounds = YES;
    gradientLayer3.frame = self.view.layer.bounds;
    gradientLayer3.colors = [NSArray arrayWithObjects:
                             (id)[UIColor blueColor].CGColor,
                             (id)[UIColor cyanColor].CGColor,
                             (id)[UIColor blueColor].CGColor,
                             nil];
    
    [self.view.layer insertSublayer:gradientLayer3 atIndex:0];
}

-(void)changePlayButton{
    if (_player.playbackState == MPMusicPlaybackStatePlaying) {
        NSLog(@"Now Playing");
        [_playButton setImage:_pauseImage forState:UIControlStateNormal];
    } else {
        NSLog(@"Paused");
        [_playButton setImage:_playImage forState:UIControlStateNormal];
    }

}

-(void)createButtonLayers
{
    UIImage *playImage = [UIImage imageNamed:@"playbutton.png"];
    UIImageView *playview = [[UIImageView alloc] initWithImage:playImage];
    playview.frame = _playButton.layer.bounds;
    CALayer * playLayerMask = playview.layer;
    
    UIImage *pauseImage = [UIImage imageNamed:@"pausebutton.png"];
    UIImageView *pauseview = [[UIImageView alloc] initWithImage:pauseImage];
    pauseview.frame = _playButton.layer.bounds;
    CALayer * pauseLayerMask = pauseview.layer;

    UIImage *nextImage = [UIImage imageNamed:@"nextbutton.png"];
    UIImageView *nextview = [[UIImageView alloc] initWithImage:nextImage];
    nextview.frame = _nextSongButton.layer.bounds;
    CALayer * nextLayerMask = nextview.layer;

    UIImage *prevImage = [UIImage imageNamed:@"prevbutton.png"];
    UIImageView *prevview = [[UIImageView alloc] initWithImage:prevImage];
    prevview.frame = _prevSongButton.layer.bounds;
    CALayer * prevLayerMask = prevview.layer;

    CAGradientLayer *gradientLayer1 = [self createButtonGradient];
    gradientLayer1.frame = _playButton.layer.bounds;

    CAGradientLayer *gradientLayer2 = [self createButtonGradient];
    gradientLayer2.frame = _playButton.layer.bounds;

    CAGradientLayer *gradientLayer3 = [self createButtonGradient];
    gradientLayer3.frame = _nextSongButton.layer.bounds;
    
    CAGradientLayer *gradientLayer4 = [self createButtonGradient];
    gradientLayer4.frame = _prevSongButton.layer.bounds;
    
    CALayer *playLayer = gradientLayer1;
    playLayer.mask = playLayerMask;
    
    _playImage = [self imageFromLayer:playLayer];
    
    CALayer *pauseLayer = gradientLayer2;
    pauseLayer.mask = pauseLayerMask;
    
    _pauseImage = [self imageFromLayer:pauseLayer];
    
    gradientLayer3.mask = nextLayerMask;
    gradientLayer4.mask = prevLayerMask;
    
    nextImage = [self imageFromLayer:gradientLayer3];
    [_nextSongButton setImage:nextImage forState:UIControlStateNormal];
    
    prevImage = [self imageFromLayer:gradientLayer4];
    [_prevSongButton setImage:prevImage forState:UIControlStateNormal];
}

-(CAGradientLayer *)createButtonGradient
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.masksToBounds = YES;
    gradient.colors = [NSArray arrayWithObjects:
                             (id)[UIColor blackColor].CGColor,
                             (id)[UIColor grayColor].CGColor,
                             (id)[UIColor blackColor].CGColor,
                             nil];
    return gradient;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIImage *)imageFromLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContext([layer frame].size);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}



@end
