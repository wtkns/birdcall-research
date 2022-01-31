/*
hansm-bird-control.pd
http://obiwannabe.co.uk/tutorials/html/tutorial_birds.html
SC port by redFrik 080430
*/
s.boot;


(
SynthDef(\birdCall, {|
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
}).add;
f= {|freq, atk, dcy, fmod1, atkf1, dcyf1, fmod2, atkf2, dcyf2, amod1, atka1, dcya1, amod2, atka2, dcya2|
  Synth(\birdCall, [\freq, freq, \atk, atk, \dcy, dcy,
    \fmod1, fmod1, \atkf1, atkf1, \dcyf1, dcyf1,
    \fmod2, fmod2, \atkf2, atkf2, \dcyf2, dcyf2,
    \amod1, amod1, \atka1, atka1, \dcya1, dcya1,
    \amod2, amod2, \atka2, atka2, \dcya2, dcya2]);
};
)


(
//triple-tailed-tree-troubler
f.value(0.387755, 0.0204082, 0.204082,
  0.367347, 0.571429, 0.734694,
  0.918367, 1, 0.77551,
  0.571429, 0.367347, 0.22449,
  0.0204082, 0.183673, 0.44898);
)

(
//speckled-throated-spew
f.value(0.183673, 0.591837, 0.387755,
  0.0104082, 0.530612, 0.346939,
  0.244898, 0.55102, 0.122449,
  0.387755, 1, 0.612245,
  0.346939, 0.816327, 0.653061);
)
(
//lesser-spotted-grinchwarbler
f.value(0.55102, 0.591837, 0.387755,
  0.0716327, 0.0204082, 0.346939,
  0.0204082, 0.55102, 0.122449,
  0.632653, 1, 0.612245,
  0.346939, 0.816327, 0.653061);
)
(
//long-toed-mudhopper
f.value(0.163265, 0.22449, 0.183673,
  0.00306122, 0.122449, 1,
  0.0612245, 1, 0.77551,
  0.979592, 0.204082, 0.734694,
  1, 0.142857, 0.612245);
)
(
//yellow-yiffled-yaffle
f.value(0.0204082, 0.367347, 0.183673,
  0.0612245, 0, 1,
  0.285714, 0.22449, 0.489796,
  0.367347, 0.387755, 0.734694,
  0.204082, 0.428571, 0.142857);
)
(
//pointy-beaked-beetlefiend
f.value(0.428571, 0.204082, 0.489796,
  0.0204082, 0.795918, 0.591837,
  0.285714, 0.22449, 0.489796,
  0.204082, 0.836735, 0.734694,
  0.77551, 0.428571, 0.142857);
)
(
//african-boojuboolubala
f.value(0.306122, 0.959184, 0.0408163,
  1, 0, 0.591837,
  0.285714, 0.22449, 0.489796,
  0.204082, 0.836735, 0.734694,
  0.77551, 0.428571, 0.142857
);
)
(
//common-muckoink
f.value(0.0204082, 0.8, 0.0816327,
  0.0204082, 0.001, 0.99,
  0.0204082, 0.01, 1,
  1, 0.142857, 0.734694,
  1, 0.0612245, 0.530612);
)