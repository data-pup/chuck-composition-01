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
0.4 => float arpGainRandMax;

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

// ----------------------------------------------------------------------------
// Channel patterns.
// Conceptual Overview: Each channel has a set of 4 arrays of 32 numbers,
// where each value is a floating point number representing the
// likelihood of an individual note occurring.
//
// For each note, generate a random value between 0 and 1, and only play
// the note if the random value is less than the likelihood value.
// NOTE: 1 means note always occurs, 0 means never.
//
// As a group, select one of the four sequences by either following the
// state of others, or incrementing/decrementing, or generating a purely
// random new state. Each of these 4 states are assumed to be progressively
// more "busy", and the likelihood that a channel stays in position when
// a new state is generated can also be controlled.
// ----------------------------------------------------------------------------

[1,1,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
 1,1,0,1, 0,0,1,0, 0,0,0,0, 0,1,1,1] @=> int kickSequence00[];
[1,1,0,1, 0,0,1,0, 0,0,0,0, 0,1,1,1,
 1,1,0,1, 0,0,1,0, 1,1,0,0, 0,1,1,1] @=> int kickSequence01[];
[1,1,0,1, 1,0,1,0, 1,0,0,0, 0,1,1,1,
 1,1,0,1, 1,0,1,0, 0,0,1,1, 1,1,1,1] @=> int kickSequence02[];
[1,1,0,1, 1,0,1,0, 1,0,0,0, 0,1,1,1,
 1,1,0,1, 1,0,1,0, 1,1,1,1, 1,1,1,1] @=> int kickSequence03[];

0.8 => float kickSequence00Flux;
0.6 => float kickSequence01Flux;
0.4 => float kickSequence02Flux;
0.1 => float kickSequence03Flux;

[kickSequence00,kickSequence01,
kickSequence02,kickSequence03] @=> int kickSequences[][];

[kickSequence00Flux, kickSequence01Flux,
kickSequence02Flux, kickSequence03Flux] @=> float kickSequenceFluxes[];

[0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
0,0,0,0, 1,0,0,0, 0,0,0,0, 1,1,1,1] @=> int snareSequence00[];
[0,0,0,0, 1,0,0,1, 0,0,1,0, 1,0,0,0,
0,0,0,0, 1,0,0,1, 0,0,0,0, 1,1,1,1] @=> int snareSequence01[];
[0,0,0,0, 1,0,0,1, 0,0,1,0, 1,0,0,0,
0,0,0,0, 1,0,0,0, 0,0,1,1, 1,1,1,1] @=> int snareSequence02[];
[0,0,0,0, 1,0,1,0, 1,0,0,0, 1,0,0,0,
0,0,0,0, 1,0,0,0, 0,0,0,0, 1,1,1,1] @=> int snareSequence03[];

0.1 => float snareSequence00Flux;
0.3 => float snareSequence01Flux;
0.3 => float snareSequence02Flux;
0.1 => float snareSequence03Flux;

[snareSequence00,snareSequence01,
snareSequence02,snareSequence03] @=> int snareSequences[][];

[snareSequence00Flux, snareSequence01Flux,
snareSequence02Flux, snareSequence03Flux] @=> float snareSequenceFluxes[];


[1,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
 1,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,1,1] @=> int hihatSequence00[];
[1,1,1,1, 0,0,0,0, 1,0,1,0, 0,0,1,0,
 1,1,1,1, 0,0,0,0, 1,0,1,0, 0,0,1,1] @=> int hihatSequence01[];
[1,1,1,1, 0,0,0,0, 1,0,0,1, 0,1,0,0,
 1,1,1,1, 0,0,0,0, 0,0,0,0, 1,1,1,1] @=> int hihatSequence02[];
[1,1,1,1, 0,0,0,1, 0,1,0,1, 0,0,0,0,
 1,1,1,1, 0,0,0,0, 0,1,0,1, 0,0,1,1] @=> int hihatSequence03[];

0.4 => float hihatSequence00Flux;
0.4 => float hihatSequence01Flux;
0.4 => float hihatSequence02Flux;
0.4 => float hihatSequence03Flux;

[hihatSequence00,hihatSequence01,
hihatSequence02,hihatSequence03] @=> int hihatSequences[][];

[hihatSequence00Flux, hihatSequence01Flux,
hihatSequence02Flux, hihatSequence03Flux] @=> float hihatSequenceFluxes[];


[1,0,1,0, 1,0,0,1, 0,1,0,1, 0,1,1,1,
 1,0,1,0, 1,0,0,1, 0,1,0,1, 0,1,1,1] @=> int pulseSequence00[];
[1,1,1,0, 1,0,0,1, 0,1,0,1, 0,1,1,1,
 1,0,1,0, 1,0,0,1, 0,1,1,1, 0,1,1,1] @=> int pulseSequence01[];
[1,0,1,0, 1,0,0,1, 0,1,1,1, 0,1,1,1,
 1,1,1,0, 1,0,0,1, 0,1,0,1, 0,1,1,1] @=> int pulseSequence02[];
[1,1,1,0, 1,0,0,1, 0,1,1,1, 0,1,1,1,
 1,1,1,0, 1,0,0,1, 0,1,1,1, 0,1,1,1] @=> int pulseSequence03[];

0.1 => float pulseSequence00Flux;
0.1 => float pulseSequence01Flux;
0.1 => float pulseSequence02Flux;
0.1 => float pulseSequence03Flux;

[pulseSequence00,pulseSequence01,
pulseSequence02,pulseSequence03] @=> int pulseSequences[][];

[pulseSequence00Flux, pulseSequence01Flux,
pulseSequence02Flux, pulseSequence03Flux] @=> float pulseSequenceFluxes[];


[1,1,0,0, 1,1,0,0, 0,0,0,0, 0,1,1,1,
 0,0,0,0, 1,1,0,0, 0,1,0,1, 0,1,1,1] @=> int arpSequence00[];
[1,1,0,0, 1,1,0,0, 0,1,0,1, 0,1,1,1,
 1,1,0,0, 1,1,0,0, 0,1,0,1, 0,1,1,1] @=> int arpSequence01[];
[1,1,0,0, 1,1,0,0, 0,1,0,1, 0,1,1,1,
 1,1,0,0, 1,1,0,0, 0,1,0,1, 0,1,1,1] @=> int arpSequence02[];
[1,1,0,0, 1,1,0,0, 0,1,0,1, 0,1,1,1,
 1,1,0,0, 1,1,0,0, 0,1,0,1, 0,1,1,1] @=> int arpSequence03[];

0.1 => float arpSequence00Flux;
0.1 => float arpSequence01Flux;
0.1 => float arpSequence02Flux;
0.1 => float arpSequence03Flux;

[arpSequence00,arpSequence01,
arpSequence02,arpSequence03] @=> int arpSequences[][];

[arpSequence00Flux, arpSequence01Flux,
arpSequence02Flux, arpSequence03Flux] @=> float arpSequenceFluxes[];


// ----------------------------------------------------------------------------
// Start offsets:
// These integers control how many measures should pass before a channel
// begins to play.
// ----------------------------------------------------------------------------
12 => int kickStart;
16 => int snareStart;
10 => int hihatStart;
0 => int pulseStart;
6 => int arpStart;


// ----------------------------------------------------------------------------
// State Variables:
// Holds the index pointing to the channel's current state.
// ----------------------------------------------------------------------------
0 => int kickState;
0 => int snareState;
0 => int hihatState;
0 => int pulseState;
0 => int arpState;


// ----------------------------------------------------------------------------
// Initialize integers representing the length of each sequence.
// ----------------------------------------------------------------------------
kickSequences[kickState].cap() => int kickSequenceLength;
snareSequences[snareState].cap() => int snareSequenceLength;
hihatSequences[hihatState].cap() => int hihatSequenceLength;
pulseSequences[pulseState].cap() => int pulseSequenceLength;
arpSequences[arpState].cap() => int arpSequenceLength;


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
0.15 :: second => dur tempo;
0.012 :: second => dur swing;


// ----------------------------------------------------------------------------
// Main loop
// ----------------------------------------------------------------------------
while (true)
{
    // Kick Control:
    // ----------------------------------------------------------------------
    if (measure >= kickStart) {
      if (kickSequences[kickState][beat % kickSequenceLength]) {
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
      if (snareSequences[snareState][beat % snareSequenceLength]) {
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
      if (pulseSequences[pulseState][beat % pulseSequenceLength]) {
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
      if (hihatSequences[hihatState][beat % hihatSequenceLength]) {
          hihatGainBaseline + Math.random2f(
            hihatGainRandMin, hihatGainRandMax) => hihat.gain;
          hihatPanCenter + Math.random2f(
            hihatPanJitterL, hihatPanJitterR) => hihatPan.pan;
          0 => hihat.pos;
      }
    }
    // ----------------------------------------------------------------------

    // Arp Control:
    // ----------------------------------------------------------------------
    if (measure >= arpStart) {
      if (arpSequences[arpState][beat % arpSequenceLength]) {
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
    if (beat % 2 == 0) {tempo - swing => now;}
    else {tempo + swing => now;}

    (beat + 1) % MAX_BEAT => beat;
    if (beat==0)
    {
        measure++;
        // NOTE: If the measure % 4, slant towards *some change*,
        // and if the measure is % 8, slant towards more change.

        // Generate the change value. For each channel, see if it meets
        // the threshold value for the channel to be assigned a new state.
        0.4 => float change_bias;
        if (measure % 4 == 0) {
          change_bias + 0.2 => change_bias;
        }
        if (measure % 8 == 0) {
          change_bias + 0.5 => change_bias;
        }
        Math.random2f(0.0,change_bias) => float change_value;

        // Kick State Increment:
        if (change_value > kickSequenceFluxes[kickState]) {
          Math.random2f(0.0,1.0) => float kickBranchValue;
          if (kickBranchValue < 0.3) {
            if(kickState > 0) {
              kickState - 1 => kickState;
            }
          }
          else {
            if(kickState < 3) {
              kickState + 1 => kickState;
            }
          }
        }

        // Snare State Increment:
        if (change_value > snareSequenceFluxes[snareState]) {
          Math.random2f(0.0,1.0) => float snareBranchValue;
          if (snareBranchValue < 0.5) {
            if(snareState > 0) {
              snareState - 1 => snareState;
            }
          }
          else {
            if(snareState < 3) {
              snareState + 1 => snareState;
            }
          }
        }

        // Hihat State Increment:
        if (change_value > hihatSequenceFluxes[hihatState]) {
          Math.random2f(0.0,1.0) => float hihatBranchValue;
          if (hihatBranchValue < 0.5) {
            if(hihatState > 0) {
              hihatState - 1 => hihatState;
            }
          }
          else {
            if(hihatState < 3) {
              hihatState + 1 => hihatState;
            }
          }
        }

        // Pulse State Increment:
        if (change_value > pulseSequenceFluxes[pulseState]) {
          Math.random2f(0.0,1.0) => float pulseBranchValue;
          if (pulseBranchValue < 0.4) {
            if(pulseState > 0) {
              pulseState - 1 => pulseState;
            }
          }
          else {
            if(pulseState < 3) {
              pulseState + 1 => pulseState;
            }
          }
        }

        // Arp State Increment:
        if (change_value > arpSequenceFluxes[arpState]) {
          Math.random2f(0.0,1.0) => float arpBranchValue;
          if (arpBranchValue < 0.3) {
            if(arpState > 0) {
              arpState - 1 => arpState;
            }
          }
          else {
            if(arpState < 3) {
              arpState + 1 => arpState;
            }
          }
        }


        // "Break" check: If the global average is above 2.5, on a measure
        // with a % of 16 == 0, drop back globally to initial state 50%.
        // XXX TODO

        // Declare integers representing the length of each sequence.
        kickSequences[kickState].cap() => int kickSequenceLength;
        snareSequences[snareState].cap() => int snareSequenceLength;
        hihatSequences[hihatState].cap() => int hihatSequenceLength;
        pulseSequences[pulseState].cap() => int pulseSequenceLength;
        arpSequences[arpState].cap() => int arpSequenceLength;
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
