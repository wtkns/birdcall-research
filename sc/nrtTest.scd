(
  var server = Server(\nrt,
      options: ServerOptions.new
      .numOutputBusChannels_(2));​
 
  var fileName = thisProcess.argv[0];
  var fileFreq = thisProcess.argv[1].asFloat;
  var fileDur = thisProcess.argv[2].asFloat;

  var path = "./output/" ++ fileName ++ ".wav";

  var myDef = SynthDef(\NRTsine, { |out, freq = 440|
              Out.ar(out, SinOsc.ar(freq, 0, 0.2).dup)}).asBytes;

  var myScore = Score(
    [[0.0, ['/d_recv', myDef ]],
    [0.0, (x = Synth.basicNew(\NRTsine, server, fileFreq)).newMsg(args: [freq: fileFreq])],
    [fileDur, x.freeMsg]
  ]);
​
  r = Routine.new({
    var cond = Condition.new;
    
    myScore.recordNRT(
      outputFilePath:path.standardizePath,
      headerFormat: "WAV",
      sampleFormat: "int16",
      options: server.options,
      action: { cond.unhang }
    );

    cond.hang;	
    "done".postln;	
    0.exit;
    
  }); // end Routine r

  r.play;  // 'play' is a shortcut for scheduling the routine on a clock
)