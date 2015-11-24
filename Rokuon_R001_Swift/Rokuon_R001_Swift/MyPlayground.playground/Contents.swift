//: Playground - noun: a place where people can play

import UIKit

var playSounds = NSMutableDictionary()
//var foundationDictionary = NSMutableDictionary(dictionary: dictionary)

var playTitles = NSMutableArray()

//NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
var dir = NSHomeDirectory().stringByAppendingString("/Documents")

//NSDateFormatter *df = [[NSDateFormatter alloc] init];
//var df: NSDateFormatter = NSDateFormatter()
//[df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
let df = NSDateFormatter()
df.locale = NSLocale(localeIdentifier: "ja_JP")

//NSFileManager *fileManager = [NSFileManager defaultManager];
let fileManager = NSFileManager.defaultManager()

//NSError *error;
//NSArray *list = [fileManager contentsOfDirectoryAtPath:dir error:&error];
let list = try? fileManager.contentsOfDirectoryAtPath(dir)
if list != nil {
	
	//for (NSString *path in list) {
	for var path in list! {
		//url = [NSURL fileURLWithPath:path];
		let url: NSURL = NSURL.fileURLWithPath(path)
		
		//NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:@"url", url, nil];
		let data: Dictionary<NSURL, String> = [url: "url"]
		
		//[playSounds setObject:data forKey:path];
		playSounds.setObject(data, forKey: path)
	}
	
	/*playTitles = [playSounds.allKeys sortedArrayUsingComparator:^(id obj1, id obj2) {
	return [obj2 compare:obj1];
	}];*/
	playTitles = [playSounds.allKeys, "aaa"]
	playTitles.sort() { (a:String, b:String) -> Bool in
		if a.x == b.x {
			if a.y == b.y {
				return a.z < b.z
			} else {
				return a.y < b.y
			}
		} else {
			return a.x < b.x
		}
}
