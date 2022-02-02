/*
hansm-bird-control.pd
http://obiwannabe.co.uk/tutorials/html/tutorial_birds.html
SC port by redFrik 080430
*/

var server = Server(\nrt,
    options: ServerOptions.new
    .numOutputBusChannels_(2)
);

var myPath = "./output/" ++ thisProcess.argv[0] ++ ".wav";

//var myPath = "./output/nrtsongtest.wav";
// var freq =0.387755;
// var atk=0.0204082;
// var dcy=0.204082;
// var fmod1=0.367347;
// var atkf1=0.571429;
// var dcyf1=0.734694;
// var fmod2=0.918367;
// var atkf2=1;
// var dcyf2=0.77551;
// var amod1=0.571429; 
// var atka1=0.367347; 
// var dcya1=0.22449;
// var amod2=0.0204082; 
// var atka2=0.183673; 
// var dcya2=0.44898;

var freq = thisProcess.argv[1];
var atk = thisProcess.argv[2];
var dcy = thisProcess.argv[3];
var fmod1 = thisProcess.argv[4];
var atkf1 = thisProcess.argv[5];
var dcyf1 = thisProcess.argv[6];
var fmod2 = thisProcess.argv[7];
var atkf2 = thisProcess.argv[8];
var dcyf2 = thisProcess.argv[9];
var amod1 = thisProcess.argv[10];
var atka1 = thisProcess.argv[11];
var dcya1 = thisProcess.argv[12];
var amod2 = thisProcess.argv[13];
var atka2 = thisProcess.argv[14];
var dcya2 = thisProcess.argv[15];


var birdsynth = SynthDef(\birdCall, {|
			out= 0, pan= 0, gate= 1, freq= 0, amp= 0.5, atk= 0.5, dcy= 0.5,
			fmod1= 1, atkf1= 0.5, dcyf1= 0.5,
			fmod2= 1, atkf2= 0.5, dcyf2= 0.5,
			amod1= 1, atka1= 0.5, dcya1= 0.5,
			amod2= 1, atka2= 0.5, dcya2= 0.5|

			var env, freq1, freq2, amp1, amp2, fmod, amod, z;
			env= EnvGen.ar(Env([0, amp, 0], [atk, dcy], -4), gate, timeScale:0.9, doneAction:2);
			freq1= EnvGen.ar(Env([0, fmod1, 0], [atkf1, dcyf1], -4), 1, 3000, 0, 0.9);
			freq2= EnvGen.ar(Env([0, fmod2, 0], [atkf2, dcyf2], -4), 1, 3000, 0, 0.9);
			amp1= EnvGen.ar(Env([0, amod1, 0], [atka1, dcya1], -4), 1, 1, 0, 0.9);
			amp2= EnvGen.ar(Env([0, amod2, 0], [atka2, dcya2], -4), 1, 1, 0, 0.9);
			fmod= SinOsc.ar(freq1, 0, amp1, 1);
			amod= 1-SinOsc.ar(freq2, 0, amp2);
			z= SinOsc.ar(freq*7000+300*fmod, 0, amod);
			Out.ar(out, Pan2.ar(z, pan, env));
		});

a = Score([
    [0.0, ['/d_recv',birdsynth.asBytes]],
    [0.0, (x = Synth.basicNew(\birdCall, server, 1000)).newMsg(args: 
	[\freq, freq, \atk, atk, \dcy, dcy,
    \fmod1, fmod1, \atkf1, atkf1, \dcyf1, dcyf1,
    \fmod2, fmod2, \atkf2, atkf2, \dcyf2, dcyf2,
    \amod1, amod1, \atka1, atka1, \dcya1, dcya1,
    \amod2, amod2, \atka2, atka2, \dcya2, dcya2]
	
	)],
    [1.0, x.freeMsg]
]);



a.recordNRT(
    outputFilePath: myPath.standardizePath,
    headerFormat: "wav",
    sampleFormat: "int16",
    options: server.options,
    duration: 1,
    action: { "done".postln }
);
​
server.remove;

