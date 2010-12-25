#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>	//For NSWorkspace
#import "TextScript.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSURL *exeLocation = [[NSURL fileURLWithPath:[NSString stringWithUTF8String:argv[0]]] URLByDeletingLastPathComponent];
	[[NSWorkspace sharedWorkspace] launchApplication:@"Ignore"];
	
	NSArray *books = [NSArray arrayWithObjects:
					  @"Books/Book I.script",
					  @"Books/Book II.script",
					  @"Books/Book III.script",
					  @"Books/Book IV.script",
					  @"Books/Book V.script",
					  @"Books/Book VI.script",
					  @"Books/Book VII.script",
					  @"Books/Book VIII.script",
					  @"Books/Book IX.script",
					  nil];
	
	for (NSString *bookLocation in books) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

		NSURL *scriptLocation = [exeLocation URLByAppendingPathComponent:bookLocation];
		
		NSError *e;
		NSString *script = [NSString stringWithContentsOfFile:scriptLocation.path encoding:NSUTF8StringEncoding error:&e];
		if (!script) {
			printf("\nDear Mr. Roundy:\nThe 'Book' folder does not appear "
				   "to be in the same folder as the app, please rectify "
				   "this or email me at jpochtar@gmail.com to get a new copy.\n");
		}
		
		[script runAsTextScriptWithFirstScene:@"start" output:^(NSString *s){
			printf("\n%s\n", [s UTF8String]);
		} reactionGet:^NSString*{
			printf("\n");
			NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
			NSData *inputData = [input availableData];
			return [[[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding] autorelease];
		}];
		[pool release];
	}
	
	[pool drain];
    return 0;
}
