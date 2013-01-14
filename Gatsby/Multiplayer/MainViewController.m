//
//  MainViewController.m
//  Multiplayer
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "MainViewController.h"
#import "TradeViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)setGKSession:(GKSession *)sess gkId:(NSString *)_gkId
			  avatar:(NSString *)me otherPlayers:(NSArray *)peers
{
	server = [sess retain];
	gkId = [_gkId retain];
	avatar = [me retain];
	otherPlayers = [peers retain];
		
	[server setDataReceiveHandler:self withContext:nil];
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {

	NSLog(@"peer %@ %@ is %d", peerID, [session displayNameForPeer:peerID], state);
	
	if ([@"SERVER" isEqualToString:[session displayNameForPeer:peerID]] && state == GKPeerStateDisconnected ) {
		NSLog(@"sunk my battleship");
		[session connectToPeer:peerID withTimeout:5.0];
	}
}

#pragma mark client

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID
		  inSession:(GKSession *)session context:(void *)ctx
{
	JPNSDataReadStream *dstream = [JPNSDataReadStream new];
	dstream.data = data;
	
	char c = [dstream readChar];
	switch (c) {
		case '$':
			[self setMoney:[dstream readInt]];
			break;
			
		case 'C':
			[self setCards:[dstream read]];
			break;
		
		default:
			NSLog(@"recieved unknown command: %c (%d)", c, c);
			break;
	}
}

#pragma mark command handling

- (void)setMoney:(int)value {
	moneyLabel.text = [NSString stringWithFormat:@"$%d", value];
}

- (void)setCards:(NSArray *)_cards {	
	BOOL isAddingCard = cards.count + 1 == _cards.count;
	
	[_cards retain];
	[cards release];
	cards = _cards;
	
	if (isAddingCard) {
		NSIndexPath *index = [NSIndexPath indexPathForRow:cards.count - 1 inSection:0];
		[cardTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:index]
							 withRowAnimation:UITableViewRowAnimationAutomatic];
							 
		[cardTableView scrollToRowAtIndexPath:index
							 atScrollPosition:UITableViewScrollPositionBottom 
							 animated:YES];
	} else {
		[cardTableView reloadSections:[NSIndexSet indexSetWithIndex:0] 
					 withRowAnimation:UITableViewRowAnimationFade];		
	}
}

#pragma mark control

- (void)sendData:(NSData *)data {
	NSError *err = nil;
	NSArray *array = [NSArray arrayWithObject:gkId];
	[server sendData:data toPeers:array withDataMode:GKSendDataReliable error:&err];
	if (err) NSLog(@"%@", err);
}

- (void)writeSelectionToStream:(JPNSDataWriteStream *)stream {
	NSArray *indexPaths = [cardTableView indexPathsForSelectedRows];
	NSMutableArray *indexes = [NSMutableArray array];
	for (NSIndexPath *path in indexPaths) {
		[indexes addObject:[NSNumber numberWithInt:path.row]];
	}
	
	[stream writeNSArray:indexes];
}

- (IBAction)sendSelection:(id)sender {
	JPNSDataWriteStream *stream = [JPNSDataWriteStream new];
	[stream writeChar:'U'];
	[self writeSelectionToStream:stream];
	[self sendData:stream.data];
}

#pragma mark trade

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	TradeViewController *tvc = segue.destinationViewController;
	[tvc setTitles:otherPlayers];
	tvc.tradeHandler = ^(NSString *toWhom, int forPrice) {
		JPNSDataWriteStream *stream = [JPNSDataWriteStream new];
		
		[stream writeChar:'T'];
		[stream writeNSString:toWhom];
		[stream writeInt:forPrice];
		[self writeSelectionToStream:stream];
		
		[self sendData:stream.data];
	};
}

#pragma mark Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return cards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
    }
	
	cell.textLabel.text = [[cards objectAtIndex:indexPath.row] objectForKey:@"text"];
	
	return cell;
}

#pragma mark UIViewController stuff

- (void)viewDidUnload
{
	[moneyLabel release];
	moneyLabel = nil;
	[cardTableView release];
	cardTableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[moneyLabel release];
	[cardTableView release];
	[super dealloc];
}
@end
