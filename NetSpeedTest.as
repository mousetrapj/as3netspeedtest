package
{
  /*
     Test Net Speed from Multi server to client  and  give a order of the servers 
     
     create the class instance by pass site_array and test_file_array params
     
     add a data event listener on it
     
     then call do_test function
     
     after test finished will reveive a order of the servers
  */

	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	public class NetSpeedTest extends EventDispatcher
	{
		private var timeout_timer:Timer = new Timer(1000,5);
		private var test_loader:URLLoader = new URLLoader();
		private var test_time:Number = 0;
		private var site_array:Array = new Array();
		private var test_file_array:Array = new Array();
		private var site_current:int = 0;
		private var test_file_current:int = 0;
		private var order_array:Array = new Array();
		private var site_time_array:Array = new Array();
		private var output_str:String = "";
		
		
		
		public function NetSpeedTest(_site_array:Array,_test_file_array:Array):void
		{
			site_array = _site_array;
			test_file_array = _test_file_array;
			timeout_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimeout);
			test_loader.addEventListener(Event.COMPLETE,onTestComplete);
			test_loader.addEventListener(Event.OPEN,onTestOpen);
		}
		
		public function do_test():void{
			var site:String = site_array[site_current];
			var url:String = test_file_array[test_file_current];
			trace(site+url);
			test_loader.load(new URLRequest(site+url));
			timeout_timer.reset();
			timeout_timer.start();
			test_time = (new Date()).time;
		}
		
		protected function onTimeout(event:TimerEvent):void
		{
			test_loader.close();
			site_time_array.push((new Date()).time - test_time + timeout_timer.currentCount*1000000);
			if(test_file_current +1 < test_file_array.length){
				test_file_current++;
				do_test();
			}else{
				if(site_current + 1 < site_array.length){
					order_array.push({'site':[site_array[site_current]] , 'time':Math.floor(array_sum(site_time_array)/3)});
					site_time_array = new Array();
					site_current++;
					test_file_current = 0;
					do_test();
				}else{
					order_array.push({'site':[site_array[site_current]] , 'time':Math.floor(array_sum(site_time_array)/3)});
					order_array = order_array.sortOn('time',Array.NUMERIC);
					var output_str:String = "";
					for (var i:int = 0; i < order_array.length; ++i){
						if(i+1 < order_array.length){
							output_str += order_array[i].site+":"+order_array[i].time+";";
						}else{
							output_str += order_array[i].site+":"+order_array[i].time;
						}
					}
					this.dispatchEvent(new DataEvent(DataEvent.DATA,false,false,output_str));
				}
			}
		}
		
		protected function onTestComplete(event:Event):void
		{
			timeout_timer.stop();
			site_time_array.push((new Date()).time - test_time);
			if(test_file_current +1 < test_file_array.length){
				test_file_current++;
				do_test();
			}else{
				if(site_current + 1 < site_array.length){
					order_array.push({'site':[site_array[site_current]] , 'time':Math.floor(array_sum(site_time_array)/3)});
					site_time_array = new Array();
					site_current++;
					test_file_current = 0;
					do_test();
				}else{
					order_array.push({'site':[site_array[site_current]] , 'time':Math.floor(array_sum(site_time_array)/3)});
					order_array = order_array.sortOn('time',Array.NUMERIC);
					var output_str:String = "";
					for (var i:int = 0; i < order_array.length; ++i){
						if(i+1 < order_array.length){
							output_str += order_array[i].site+":"+order_array[i].time+";";
						}else{
							output_str += order_array[i].site+":"+order_array[i].time;
						}
					}
					this.dispatchEvent(new DataEvent(DataEvent.DATA,false,false,output_str));
				}
			}
		}
		
		
		protected function onTestOpen(event:Event):void
		{
			timeout_timer.stop();
		}
		
		private function array_sum(arr:Array):Number{
			var sum:Number = 0;
			for(var i:int = 0 ; i < arr.length ; i++){
				sum += arr[i];
			}
			return sum;
		}
	}
}
