//
//  ViewController.swift
//  Rokuon_R001_Swift
//
//  Created by 寺内 信夫 on 2015/11/21.
//  Copyright © 2015年 寺内 信夫. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITableViewDelegate {//, UITableViewDataSource {

	var session:	AVAudioSession
	var recorder:	AVAudioRecorder
	var player:		AVAudioPlayer
	
	var url:		NSURL
	
	var playSounds = NSMutableDictionary()
	//var foundationDictionary = NSMutableDictionary(dictionary: dictionary)
	var playTitles:	NSArray

	//__weak IBOutlet UILabel *label_SoundTitle_Front;
	//__weak IBOutlet UILabel *label_SoundTitle_Back;
	
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
		
		//[self resetPlaySounds];
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

