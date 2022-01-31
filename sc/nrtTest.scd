(
var server = Server(\nrt,
    options: ServerOptions.new
    .numOutputBusChannels_(2)
    .numInputBusChannels_(2)
);
​
var fileName = thisProcess.argv[0];
var fileFreq = thisProcess.argv[1];

var path = "./output/" ++ fileName ++ ".wav";


a = Score([
    [0.0, ['/d_recv',
        SynthDef(\NRTsine, { |out, freq = 440|
            Out.ar(out, SinOsc.ar(freq, 0, 0.2).dup)
        }).asBytes
    ]],
    [0.0, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 400])],
    [1.0, x.freeMsg]
]);


​
a.recordNRT(
    outputFilePath: path.standardizePath,
    headerFormat: "wav",
    sampleFormat: "int16",
    options: server.options,
    duration: 1,
    action: { "done".postln }
);
​
server.remove;
)