as3netspeedtest
===============

Test Net Speed in actionscripnt 3.0

Test Net Speed from Multi server to client  and  give a order of the servers 
     
create the class instance by pass site_array and test_file_array params

add a data event listener on it

then call do_test function

after test finished will reveive a order of the servers


Sample
===============

var nst:NetSpeedTest = new NetSpeedTest();
nst.addEventListener(DataEvent.Data,onTestComplete);
nst.do_test();

function onTestComplete(event:DataEvent):void{
  trace(event.data);
  //sitename:cost_time;sitename2:cost_time;....
}
