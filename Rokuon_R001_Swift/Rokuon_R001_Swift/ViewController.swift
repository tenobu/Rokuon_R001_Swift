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

	/*let setAudioRecorder : [String : AnyObject?] = [
		AVFormatIDKey				: NSNumber(kAudioFormatLinearPCM)	,
		AVSampleRateKey				: NSNumber(44100.0)					,
		AVNumberOfChannelsKey		: NSNumber(2)						,
		AVLinearPCMBitDepthKey		: NSNumber(16)						,
		AVLinearPCMIsBigEndianKey	: NSNumber(false)					,
		AVLinearPCMIsFloatKey		: NSNumber(false)
	]*/

	@IBOutlet weak var imageView: UIImageView!
	
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
	
	func getURL() -> (NSURL?) {
		
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
		let intMillSec: Int = Int(  floor(   (now.timeIntervalSince1970 - floor(now.timeIntervalSince1970)) * 1000   )  )

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
		//NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
		//[settings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
		//[settings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
		//[settings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
		//[settings setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
		//[settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
		//[settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
	}*/
	func setAudioRecorder() -> Dictionary <String, NSNumber> {
		
		var setting1 = Dictionary <String, NSNumber> ()
		
		setting1[AVFormatIDKey]				= NSNumber(unsignedInt: kAudioFormatLinearPCM)
		setting1[AVSampleRateKey]			= NSNumber(double: 44100.0)
		setting1[AVNumberOfChannelsKey]		= NSNumber(int: 2)
		setting1[AVLinearPCMBitDepthKey]	= NSNumber(int: 16)
		setting1[AVLinearPCMIsBigEndianKey]	= NSNumber(bool: false)
		setting1[AVLinearPCMIsFloatKey]		= NSNumber(bool: false)

		/*var setting2 = Dictionary <String, NSNumber> ()[

			AVFormatIDKey				: NSNumber(unsignedInt:kAudioFormatLinearPCM)	,
			AVSampleRateKey				: NSNumber(double:44100.0)						,
			AVNumberOfChannelsKey		: NSNumber(int:2)								,
			AVLinearPCMBitDepthKey		: NSNumber(int:16)								,
			AVLinearPCMIsBigEndianKey	: NSNumber(bool: false)							,
			AVLinearPCMIsFloatKey		: NSNumber(bool: false)								]*/
		
		return setting1
	}
	
	//
	// recordFile
	//
	//- (void)recordFile
	func recordFile() {

		//NSLog(@"Record");
		NSLog("Record")

		do {
			// Prepare recording(Audio session)
			//NSError *error = nil;
	
			//session = [AVAudioSession sharedInstance];
			session = AVAudioSession.sharedInstance()
	
			//if ( session.inputAvailable )   // for iOS6 [session inputIsAvailable]  iOS5
			session!.inputAvailable

			//[session setCategory:AVAudioSessionCategoryPlayAndRecord
			//	error:&error];
			try session!.setCategory(AVAudioSessionCategoryPlayAndRecord)
			
			//[session setActive:YES error:&error];
			try session!.setActive(true)
			
			//recorder = [[AVAudioRecorder alloc] initWithURL:[self getURL]
			//	settings:[self setAudioRecorder]
			//	error:&error];
			
			let _url = getURL()
			try recorder = AVAudioRecorder.init(URL: _url!, settings: setAudioRecorder())
			
			//recorder.meteringEnabled = YES;
			
			//[recorder record];
			recorder!.record()
		} catch {
			//NSLog(@"Error when preparing audio session :%@", [error localizedDescription]);
			//NSLog("Error when preparing audio session :%", error)
			print(error)
			return
		}
		
	}
	
	//
	// stopRecord
	//
	//- (void)stopRecord
	func stopRecord() {

		NSLog("Stop")
	
		//if ( recorder != nil && recorder.isRecording )
		if recorder != nil && recorder!.recording {
			//[recorder stop];
			recorder!.stop()
	
			recorder = nil;
		}
	}
	
	//
	// playRecord
	//
	//- (void)playRecord
	func playRecord() {

		NSLog("Play")
	
		//NSError *error = nil;

		do {
			
			let fileManager = NSFileManager.defaultManager()
			
			let path: String? = url?.path
			
			//if ( [[NSFileManager defaultManager] fileExistsAtPath:[url path]] )
			if fileManager.fileExistsAtPath(path!) {

				//player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
				try player = AVAudioPlayer.init(contentsOfURL: url!)
				
				//[player prepareToPlay];
				player?.prepareToPlay()

				//[player play];
				player?.play()
			}

		} catch {
			print(error)
		}

	}
	
	//
	//
	//
	//- (void)toCommand:(NSString *)command
	func toCommand(command: String) {
		
		//if ([command isEqualToString: @"toPlay"]) {
		switch command {
			
			case "toPlay":
			
				//imageView.image = [UIImage imageNamed: @"Play.png"];
				imageView.image = UIImage.init(named: "Play.png")
				
				//[self playRecord];
				playRecord()
		
			case "toRec":
				
				//imageView.image = [UIImage imageNamed: @"Rec.png"];
				imageView.image = UIImage.init(named: "Rec.png")
			
				//[self recordFile];
				recordFile()

			case "toPause":
				
				//imageView.image = [UIImage imageNamed: @"Pause.png"];
				imageView.image = UIImage.init(named: "Pause.png")
			
				//[self stopRecord];
				stopRecord()
			
		}
		
		label_SoundTitle_Front.text	 = title;
		label_SoundTitle_Back.text	 = title;

	}
	
	//
	//
	//
	//- (void)drawTitle:(NSString *)title
	func drawTitle(title: String) {

		/*switch (title) {

			case

		}*/
	}
	
	//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
	func numberOfRowsInSection(section: Int) -> Int {

		return 1;
	
	}
	
	/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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