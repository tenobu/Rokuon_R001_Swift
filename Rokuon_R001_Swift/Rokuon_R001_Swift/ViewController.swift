//
//  ViewController.swift
//  Rokuon_R001_Swift
//
//  Created by 寺内 信夫 on 2015/11/21.
//  Copyright © 2015年 寺内 信夫. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITableViewDelegate { //, UITableViewDataSource {

	var session:	AVAudioSession?
	var recorder:	AVAudioRecorder?
	var player:		AVAudioPlayer?
	
	var url:		NSURL?
	
	var playSounds : [String : AnyObject] = Dictionary()
	//var foundationDictionary = NSMutableDictionary(dictionary: dictionary)
	
	var playTitles : [String] = Array() //NSMutableArray()

	@IBOutlet weak var label_SoundTitle_Front:	UILabel!
	@IBOutlet weak var label_SoundTitle_Back:	UILabel!
	
	@IBOutlet weak var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
		// 近接センサオン
		//[UIDevice currentDevice].proximityMonitoringEnabled = YES;
		UIDevice.currentDevice().proximityMonitoringEnabled = true;
		
		// 近接センサ監視
		/*[[NSNotificationCenter defaultCenter] addObserver:self
			selector:@selector(proximitySensorStateDidChange:)
		name:UIDeviceProximityStateDidChangeNotification
		object:nil];*/
		NSNotificationCenter.defaultCenter().addObserver(
			self, selector: "proximitySensorStateDidChange:", name: UIDeviceProximityStateDidChangeNotification, object: nil)

		//tableView.dataSource = self;
		tableView.delegate = self;
		
		//playSounds = [[NSMutableDictionary alloc] init];
		playSounds.removeAll()
		playTitles.removeAll()
		
		resetPlaySounds()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewDidDisappear( animated: Bool ) {
		super.viewDidDisappear(animated)

		// 近接センサオフ
		//[UIDevice currentDevice].proximityMonitoringEnabled = NO;
		UIDevice.currentDevice().proximityMonitoringEnabled = false
		
		// 近接センサ監視解除
		/*[[NSNotificationCenter defaultCenter] removeObserver:self
			name:UIDeviceProximityStateDidChangeNotification
			object:nil];*/
		NSNotificationCenter.defaultCenter().removeObserver(
			self, name: UIDeviceProximityStateDidChangeNotification, object: nil)
	}
	
	func proximitySensorStateDidChange(notification: NSNotification) {

		let on_off: Bool = UIDevice.currentDevice().proximityState;
		
		switch (on_off) {
			// off
		case false:
			// Wave Off
			//[self stopRecord];
			//stopRecord()
			
			//[self resetPlaySounds];
			resetPlaySounds()
			
			//[tableView reloadData];
			tableView.reloadData()
			
			//[self playRecord];
			//playRecord()
			
			break
			
			// on
		case true:
			// Wave On
			//[self recordFile];
			//recordFile()
			
			break
		}
	}
	
	func resetPlaySounds() {

		//NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
		let dir = NSHomeDirectory().stringByAppendingString("/Documents")

		//NSDateFormatter *df = [[NSDateFormatter alloc] init];
		//var df: NSDateFormatter = NSDateFormatter()
		//[df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
		let df = NSDateFormatter()
		df.locale = NSLocale(localeIdentifier: "ja_JP")

		//NSFileManager *fileManager = [NSFileManager defaultManager];
		let fileManager = NSFileManager.defaultManager()
		
		//NSError *error;
		//NSArray *list = [fileManager contentsOfDirectoryAtPath:dir error:&error];
		if let list = try? fileManager.contentsOfDirectoryAtPath(dir) {

			// ファイルやディレクトリの一覧を表示する
			//for (NSString *name in list) {
			for name in list {
				//NSString *path = [NSString stringWithFormat:@"%@/%@", dir, name];
				let path = String().stringByAppendingFormat("%@/%@", dir, name)

				//url = [NSURL fileURLWithPath:path];
				let url = NSURL.fileURLWithPath(path)

				//NSDictionary *attribute = [fileManager attributesOfItemAtPath:path error:nil];
				if let attr = try? fileManager.attributesOfItemAtPath(path) {
				
					//NSDate *creationDate = [attribute objectForKey:NSFileCreationDate];
					let cre_date = attr[NSFileCreationDate]
				
					//NSDate *modificationDate = [attribute objectForKey:NSFileModificationDate];
					let mod_date = attr[NSFileModificationDate]
					
					//NSNumber *fileSize = [attribute objectForKey:NSFileSize];
					let filesize = attr[NSFileSize]
				
					//NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
					let data: [String : AnyObject] = [
						"name"		: name		,
						"url"		: url		,
						"cre date"	: cre_date!	,
						"mod date"	: mod_date!	,
						"size"		: filesize!	]
				
					//[playSounds setObject:data forKey:path];
					playSounds[path] = data
				}
			}

			/*playTitles = [playSounds.allKeys sortedArrayUsingComparator:^(id obj1, id obj2) {
			return [obj2 compare:obj1];
			}];*/
			/*playTitles = playSounds.allKeys.sort(isOrderBefore: obj1: id, obj2: id) {
				return obj2*/
		}
		
		playTitles.forEach({ (String) -> () in
			playSounds.keys
		})
		
		playTitles.sortInPlace()
		
		NSLog("\(playTitles)")
		
		
		
		//df.dateFormat = "yyyy/MM/dd HH:mm:ss"
		//print("Result:\(outputFormat.stringFromDate(date))")
		
		
	// ファイルやディレクトリの一覧を表示する
	
	}
	
	//- (NSURL*)getURL {
	func getURL() -> (NSURL) {
		
		// File Path
		//NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
		let dir = NSHomeDirectory().stringByAppendingString("/Documents")
		
		//NSDateFormatter *df = [[NSDateFormatter alloc] init];
		let df = NSDateFormatter()
		df.locale = NSLocale(localeIdentifier: "ja_JP")
		
		// 日付(NSDate) => 文字列(NSString)に変換
		//NSDate *now = [NSDate date];
		let now: NSDate = NSDate()
		//int intMillSec = (int) floor(([now timeIntervalSince1970] - floor([now timeIntervalSince1970]))*1000);
		let intMillSec: Int = floor((now.timeIntervalSince1970 - floor(now.timeIntervalSince1970)) * 1000) as Int

		// 日付(NSDate) => 文字列(NSString)に変換
		//NSString* strNow = [NSString stringWithFormat: @"%@%03d", [df stringFromDate: now], intMillSec];
		let strNow:String = String(format: "%@%03d", df.stringFromDate(now), intMillSec)
		
		//NSString *filePath = [dir stringByAppendingFormat: @"/%@.caf", strNow];
		let filepath: String = dir.stringByAppendingFormat("/%@.caf", strNow)

		//url = [NSURL fileURLWithPath: filePath];
		url = NSURL.fileURLWithPath(filepath)
		
		return url
	}
	
	/*- (NSMutableDictionary *)setAudioRecorder
	{
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
	[settings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[settings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
	[settings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
	[settings setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	[settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
	
	return settings;
	}
	
	//
	// recordFile
	//
	- (void)recordFile
	{
	NSLog(@"Record");
	
	// Prepare recording(Audio session)
	NSError *error = nil;
	
	session = [AVAudioSession sharedInstance];
	
	if ( session.inputAvailable )   // for iOS6 [session inputIsAvailable]  iOS5
	{
	[session setCategory:AVAudioSessionCategoryPlayAndRecord
	error:&error];
	}
	
	if ( error != nil )
	{
	NSLog(@"Error when preparing audio session :%@", [error localizedDescription]);
	return;
	}
	
	[session setActive:YES
	error:&error];
	if ( error != nil )
	{
	NSLog(@"Error when enabling audio session :%@", [error localizedDescription]);
	return;
	}
	
	recorder = [[AVAudioRecorder alloc] initWithURL:[self getURL]
	settings:[self setAudioRecorder]
	error:&error];
	
	//recorder.meteringEnabled = YES;
	if ( error != nil )
	{
	NSLog(@"Error when preparing audio recorder :%@", [error localizedDescription]);
	return;
	}
	
	[recorder record];
	}
	
	//
	// stopRecord
	//
	- (void)stopRecord
	{
	NSLog(@"Stop");
	
	if ( recorder != nil && recorder.isRecording )
	{
	[recorder stop];
	
	recorder = nil;
	}
	}
	
	//
	// playRecord
	//
	- (void)playRecord
	{
	NSLog(@"Play");
	
	NSError *error = nil;
	
	if ( [[NSFileManager defaultManager] fileExistsAtPath:[url path]] )
	{
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	
	if ( error != nil )
	{
	NSLog(@"Error %@", [error localizedDescription]);
	}
	[player prepareToPlay];
	[player play];
	}
	}
	
	//
	//
	//
	- (void)toCommand:(NSString *)command
	{
	if ([command isEqualToString:@"toPlay"]) {
	
	} else if ([command isEqualToString:@"toRec"]) {
	
	} else if ([command isEqualToString:@"toPause"]) {
	
	}
	}
	
	//
	//
	//
	- (void)drawTitle:(NSString *)title
	{
	switch (title) {
	case
	<#statements#>
	break;
	
	default:
	break;
	}
	}
	
	- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
	{
	return 1;
	}
	
	- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
	{
	return playSounds.count;
	}
	
	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
	{
	UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	// cellデータが無い場合、UITableViewCellを生成して、"cell"というkeyでキャッシュする
	if (!cell) {
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
	}
	
	cell.textLabel.text = [playTitles objectAtIndex:indexPath.row];
	
	return cell;
	}*/

}