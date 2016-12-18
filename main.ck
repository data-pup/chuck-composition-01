// ----------------------------------------------------------------------------
// NOTES:
// ...
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// Audio Routing Controls:
// This section configures the audio routing. Create master channels for
// left, center, and right. Connect these to the DAC.
// Declare soundbuffers for each audio channel.
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

// (1) Array to control pulse strikes.
// [1,0,1,0, 1,0,0,1, 0,1,0,1, 0,1,1,1] @=> int pulseSequence[];
[1,0,1,0, 1,0,0,1, 0,1,0,1, 0,1,1,1] @=> int pulseSequence[];

// controls the overall length of our "measures"
// .cap() determines the maximum number of beats in your measure.
pulseSequence.cap() => int MAX_BEAT; // define using all caps, remember?

// modulo number for controlling kick and snare
4 => int MOD;  // Constant for MOD operator--
               // You'll use this to control
               // kick and snare drum hits.

// overall speed control     // Master speed control (tempo)--
0.35 :: second => dur tempo;

// counters: beat within measures, and measure
0 => int beat;    // Two counters, one for beat
0 => int measure; // and one for measure number.


// ----------------------------------------------------------------------------
// Main loop
// ----------------------------------------------------------------------------

// Main infinite drum loop
while (true)
{
    // Kick Control:
    if (beat % 4 == 0)
    {
        0 => kick.pos;
    }

    // Snare Control:
    if (beat % 4 == 2 && measure %2 == 1)
    {
        0 => snare.pos;
    }

    // TODO: Pulse, HiHat Control: (Separate this into two fields.)
    if (measure > 1) {
        if (pulseSequence[beat])
        {
            0 => pulse.pos;
        }
        else
        {
            Math.random2f(0.0,1.0) => hihat.gain;
            0 => hihat.pos;
        }
    }

    // Arp Control:
    if (beat > 11 && measure > 3)
    {
        Math.random2f(-1.0,1.0) => claPan.pan;
        0 => arp.pos;
    }


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
