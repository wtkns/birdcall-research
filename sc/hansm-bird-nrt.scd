(
/*
hansm-bird-control.pd
http://obiwannabe.co.uk/tutorials/html/tutorial_birds.html
SC port by redFrik 080430
*/

  var myPath = "./output/" ++ thisProcess.argv[0] ++ ".wav";
  var argfreq = thisProcess.argv[1].asFloat;
  var argatk = thisProcess.argv[2].asFloat;
  var argdcy = thisProcess.argv[3].asFloat;
  var argfmod1 = thisProcess.argv[4].asFloat;
  var argatkf1 = thisProcess.argv[5].asFloat;
  var argdcyf1 = thisProcess.argv[6].asFloat;
  var argfmod2 = thisProcess.argv[7].asFloat;
  var argatkf2 = thisProcess.argv[8].asFloat;
  var argdcyf2 = thisProcess.argv[9].asFloat;
  var argamod1 = thisProcess.argv[10].asFloat;
  var argatka1 = thisProcess.argv[11].asFloat;
  var argdcya1 = thisProcess.argv[12].asFloat;
  var argamod2 = thisProcess.argv[13].asFloat;
  var argatka2 = thisProcess.argv[14].asFloat;
  var argdcya2 = thisProcess.argv[15].asFloat;

  var server = Server(\nrt,
      options: ServerOptions.new
      .numOutputBusChannels_(2)
  );

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

  var myScore = Score([
      [0.0, ['/d_recv',birdsynth.asBytes]],
      [0.0, (x = Synth.basicNew(\birdCall, server)).newMsg(
      args: [freq: argfreq, atk: argatk, dcy: argdcy,
      fmod1: argfmod1, atkf1: argatkf1, dcyf1: argdcyf1,
      fmod2: argfmod2, atkf2: argatkf2, dcyf2: argdcyf2,
      amod1: argamod1, atka1: argatka1, dcya1: argdcya1,
      amod2: argamod2, atka2: argatka2, dcya2: argdcya2]
      )],
      [1.0, x.freeMsg]
  ]);

  var myRoutine = Routine.new({
      var cond = Condition.new;
      
      myScore.recordNRT(
        outputFilePath:myPath.standardizePath,
        headerFormat: "WAV",
        sampleFormat: "int16",
        options: server.options,
        action: { cond.unhang }
      );

      cond.hang;	
      "done".postln;	
      0.exit;
      
  }); // end Routine

  myRoutine.play;  // 'play' is a shortcut for scheduling the routine on a clock

)