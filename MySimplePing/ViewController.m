//
//  ViewController.m
//  MySimplePing
//
//  Created by shiguang on 2017/10/24.
//  Copyright © 2017年 shiguang. All rights reserved.
//

#import "ViewController.h"
#include "SimplePing.h"

@interface ViewController ()<SimplePingDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startstopBtn;
@property (nonatomic, strong, readwrite, nullable) SimplePing * pinger;
@property (nonatomic, strong, readwrite, nullable) NSTimer *    sendTimer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)start:(id)sender {
    
    SimplePing *pinger = [[SimplePing alloc]initWithHostName:@"https://www.baidu.com"];
    self.pinger = pinger;
    
    pinger.delegate = self;
    [pinger start];
}
- (void)pingerWillStart{
    self.startstopBtn.titleLabel.text = @"Stop…";
}

- (void)pingerDidStop{
    self.startstopBtn.titleLabel.text = @"Start…";
}
- (void)sendPing{
    [self.pinger sendPingWithData:nil];
}
- (void)stop{
    NSLog(@"stop");
    [self.pinger stop];
    self.pinger = nil;
    
    [self.sendTimer invalidate];
    self.sendTimer = nil;
    
    [self pingerDidStop];
}
- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address{
//    NSLog("pinging %@", MainViewController.displayAddressForAddress(address))
    
    // Send the first ping straight away.
    
    [self sendPing];
    
    // And start a timer to send the subsequent pings.
    
//    assert(self.sendTimer == nil)
    self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendPing) userInfo:nil repeats:YES];

}
- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error{
    NSLog(@"failed: %@",error);
    
    [self stop];
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber{
    NSLog(@"#%u sent", sequenceNumber);

}
- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error{
    NSLog(@"#%u send failed: %@", sequenceNumber, error);
}
- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber{
    NSLog(@"#%u received, size=%zu", sequenceNumber, packet.length);
}
- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet{
    NSLog(@"unexpected packet, size=%zu", packet.length);
}

@end
