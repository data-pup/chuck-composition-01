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

// Declare SndBufs for lots of drums, hook them up to pan positions.
SndBuf kick => master[1];  // Connects kick drum SndBuf to center master gain.
SndBuf snare => master[1]; // Connects snare drum to center also.
SndBuf hihat => master[2]; // Connects hihat to right master gain.
SndBuf pulse => master[0]; // Connects pulse SndBuf to left master gain.

// Use a Pan2 for the hand claps, we'll use random panning later.
SndBuf arp => Pan2 claPan; // Connects clap SndBuf to a Pan2 object.
claPan.chan(0) => master[0]; // Connects the left (0) channel of the Pan2 to master gain left.
claPan.chan(1) => master[2]; // Connects the right (1) channel of the Pan2 to master gain right.


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

[0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,1,1,
 0,0,0,1, 0,0,0,1, 0,0,0,1, 1,1,1,1] @=> int snareSequence[];

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
1 => int kickStart;
2 => int snareStart;
2 => int hihatStart;
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
0.15 :: second => dur tempo;


// ----------------------------------------------------------------------------
// Main loop
// ----------------------------------------------------------------------------
while (true)
{
    // Kick Control:
    // ----------------------------------------------------------------------
    if (measure >= kickStart) {
      if (kickSequence[beat % kickSequenceLength]) {
          0 => kick.pos;
      }
    }
    // ----------------------------------------------------------------------

    // Snare Control:
    // ----------------------------------------------------------------------
    if (measure >= snareStart) {
      if (snareSequence[beat % snareSequenceLength]) {
          0 => snare.pos;
      }
    }
    // ----------------------------------------------------------------------

    // Pulse Control:
    // ----------------------------------------------------------------------
    if (measure >= pulseStart) {
        if (pulseSequence[beat % pulseSequenceLength]) {
            0 => pulse.pos;
        }
    }
    // ----------------------------------------------------------------------

    // HiHat Control:
    // ----------------------------------------------------------------------
    if (measure >= hihatStart) {
      if (hihatSequence[beat % hihatSequenceLength]) {
              Math.random2f(0.0,1.0) => hihat.gain;
              0 => hihat.pos;
      }
    }
    // ----------------------------------------------------------------------

    // Arp Control:
    // ----------------------------------------------------------------------
    if (measure >= arpStart) {
      if (arpSequence[beat % arpSequenceLength]) {
          Math.random2f(-1.0,1.0) => claPan.pan;
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
