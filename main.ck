// ----------------------------------------------------------------------------
// NOTES:
// ...
// CLASS USED: dac, SndBuf, Pan2
//
//
// TODO: [] chroot so me.dir() is not needed for finding samples.
// TODO: [] Connect each channel to a Pan2 object
// TODO: [] Declare a sequence array for each channel.
// TODO: [] Generate notes using individual functions returning True/False.
// TODO: [] Assign each channel a measure on/off arrangement?
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// Audio Routing Controls:
// This section configures the audio routing. Create master channels for
// left, center, and right. Connect these to the DAC.
// Declare soundbuffers and pans for each audio channel.
// ----------------------------------------------------------------------------

// Define array of master Gains for left, center, right
Gain master[3];
master[0] => dac.left;
master[1] => dac;
master[2] => dac.right;

// Declare Channels (with panning).
// For each sound buffer, send the audio to a Pan2 object.
// Example for panning: Math.random2f(-1.0,1.0) => arpPan.pan;
// This statement randomly pans the channel.
// ----------------------------------------------------------------------------
SndBuf kick => Pan2 kickPan;
kickPan.chan(0) => master[0];
kickPan.chan(1) => master[2];

SndBuf snare => Pan2 snarePan;
snarePan.chan(0) => master[0];
snarePan.chan(1) => master[2];

SndBuf hihat => Pan2 hihatPan;
hihatPan.chan(0) => master[0];
hihatPan.chan(1) => master[2];

SndBuf pulse => Pan2 pulsePan;
pulsePan.chan(0) => master[0];
pulsePan.chan(1) => master[2];

SndBuf arp => Pan2 arpPan;
arpPan.chan(0) => master[0];
arpPan.chan(1) => master[2];


// ----------------------------------------------------------------------------
// Panning Settings:
// Set the base pan settings and jitter amounts.
// ----------------------------------------------------------------------------
0.0 => float kickPanCenter;
0.4 => float kickPanJitterR;
-0.4 => float kickPanJitterL;

0.4 => float snarePanCenter;
0.3 => float snarePanJitterR;
-0.2 => float snarePanJitterL;

0.0 => float pulsePanCenter;
0.9 => float pulsePanJitterR;
-0.9 => float pulsePanJitterL;

-0.3 => float hihatPanCenter;
0.6 => float hihatPanJitterR;
-0.1 => float hihatPanJitterL;

0.7 => float arpPanCenter;
0.1 => float arpPanJitterR;
-1.1 => float arpPanJitterL;

// ----------------------------------------------------------------------------
// Gain Settings:
// Set the amount of gain jitter, as well as the baseline volume.
// Note, the baseline value , and the random value minimum/maximum are
// all independent! Be creative :)
// ----------------------------------------------------------------------------
0.6 => float kickGainBaseline;
-0.4 => float kickGainRandMin;
0.3 => float kickGainRandMax;

0.8 => float snareGainBaseline;
-0.2 => float snareGainRandMin;
0.0 => float snareGainRandMax;

0.3 => float hihatGainBaseline;
-0.2 => float hihatGainRandMin;
0.0 => float hihatGainRandMax;

0.8 => float pulseGainBaseline;
-0.5 => float pulseGainRandMin;
0.0 => float pulseGainRandMax;

0.2 => float arpGainBaseline;
-0.1 => float arpGainRandMin;
0.7 => float arpGainRandMax;

// ----------------------------------------------------------------------------
// Audio Samples:
// Load the audio samples that are used in this project. Audio samples
// are stored in the sounds/ directory within this project.
// ----------------------------------------------------------------------------

me.dir()+"/sounds/kick.wav" => kick.read;
me.dir()+"/sounds/snare.wav" => snare.read;
me.dir()+"/sounds/hihat.wav" => hihat.read;
me.dir()+"/sounds/pulse.wav" => pulse.read;
me.dir()+"/sounds/arp.wav" => arp.read;


// ----------------------------------------------------------------------------
// Sequence Arrays:
// These arrays control when notes are played in a measure for each channel.
// ----------------------------------------------------------------------------

// Channel patterns.
[1,1,0,1, 1,0,1,0, 1,0,0,0, 0,1,1,1,
 1,1,0,1, 1,0,1,0, 1,1,1,1, 1,1,1,1] @=> int kickSequence[];

[0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
0,0,0,0, 1,0,0,0, 0,0,0,0, 1,1,1,1] @=> int snareSequence[];

[1,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
 1,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,1,1] @=> int hihatSequence[];

[1,0,1,0, 1,0,0,1, 0,1,0,1, 0,1,1,1,
 1,0,1,0, 1,0,0,1, 0,1,0,1, 0,1,1,1] @=> int pulseSequence[];

[1,1,0,0, 1,1,0,0, 0,1,0,1, 0,1,1,1,
 1,1,0,0, 1,1,0,0, 0,1,0,1, 0,1,1,1] @=> int arpSequence[];

// Declare integers representing the length of each sequence.
kickSequence.cap() => int kickSequenceLength;
snareSequence.cap() => int snareSequenceLength;
hihatSequence.cap() => int hihatSequenceLength;
pulseSequence.cap() => int pulseSequenceLength;
arpSequence.cap() => int arpSequenceLength;


// ----------------------------------------------------------------------------
// Start offsets:
// These integers control how many measures should pass before a channel
// begins to play.
// ----------------------------------------------------------------------------
0 => int kickStart;
0 => int snareStart;
0 => int hihatStart;
0 => int pulseStart;
0 => int arpStart;



// ----------------------------------------------------------------------------
// Time Signature:
// Declare the variables that control the global time signature.
// ----------------------------------------------------------------------------

// controls the overall length of our "measures"
32 => int MAX_BEAT;

// modulo number for controlling kick and snare
4 => int MOD;  // Constant for MOD operator--
               // You'll use this to control
               // kick and snare drum hits.

// Beat and measure counters.
0 => int beat;
0 => int measure;


// ----------------------------------------------------------------------------
// Tempo Control:
// Declare the variables that control the global tempo.
// NOTE: This duration is the tempo between beats.
// ----------------------------------------------------------------------------
0.10 :: second => dur tempo;


// ----------------------------------------------------------------------------
// Main loop
// ----------------------------------------------------------------------------
while (true)
{
    // Kick Control:
    // ----------------------------------------------------------------------
    if (measure >= kickStart) {
      if (kickSequence[beat % kickSequenceLength]) {
          kickGainBaseline + Math.random2f(
            kickGainRandMin, kickGainRandMax) => kick.gain;
          kickPanCenter + Math.random2f(
            kickPanJitterL, kickPanJitterR) => kickPan.pan;
          0 => kick.pos;
      }
    }
    // ----------------------------------------------------------------------

    // Snare Control:
    // ----------------------------------------------------------------------
    if (measure >= snareStart) {
      if (snareSequence[beat % snareSequenceLength]) {
          snareGainBaseline + Math.random2f(
            snareGainRandMin, snareGainRandMax) => snare.gain;
          snarePanCenter + Math.random2f(
            snarePanJitterL, snarePanJitterR) => snarePan.pan;
          0 => snare.pos;
      }
    }
    // ----------------------------------------------------------------------

    // Pulse Control:
    // ----------------------------------------------------------------------
    if (measure >= pulseStart) {
      if (pulseSequence[beat % pulseSequenceLength]) {
          pulseGainBaseline + Math.random2f(
            pulseGainRandMin, pulseGainRandMax) => pulse.gain;
          pulsePanCenter + Math.random2f(
            pulsePanJitterL, pulsePanJitterR) => pulsePan.pan;
          0 => pulse.pos;
      }
    }
    // ----------------------------------------------------------------------


    // Hihat Control:
    // ----------------------------------------------------------------------
    if (measure >= hihatStart) {
      if (hihatSequence[beat % hihatSequenceLength]) {
          hihatGainBaseline + Math.random2f(
            hihatGainRandMin, hihatGainRandMax) => hihat.gain;
          hihatPanCenter + Math.random2f(
            hihatPanJitterL, hihatPanJitterR) => hihatPan.pan;
          0 => hihat.pos;
      }
    }
    // ----------------------------------------------------------------------

    // Hihat Control:
    // ----------------------------------------------------------------------
    if (measure >= arpStart) {
      if (arpSequence[beat % arpSequenceLength]) {
          arpGainBaseline + Math.random2f(
            arpGainRandMin, arpGainRandMax) => arp.gain;
          arpPanCenter + Math.random2f(
            arpPanJitterL, arpPanJitterR) => arpPan.pan;
          0 => arp.pos;
      }
    }
    // ----------------------------------------------------------------------



    // Global Control:
    // ----------------------------------------------------------------------
    // This section updates the global time, and updates
    // the beat/measure counter using the modulo operator.
    // ----------------------------------------------------------------------
    tempo => now;

    (beat + 1) % MAX_BEAT => beat;
    if (beat==0)
    {
        measure++;
    }
}



// ---------------------------------------------------------------------------
// NOTE: This drum machine was built using Chapter 4.12 of the book
// included with Chuck in the share/ directory.
//
// NOTE: The goal of this is to eventually transition from a simple
// binary on/off operation for each note in a sequence to a probability
// model.
// ---------------------------------------------------------------------------
