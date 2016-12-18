// ----------------------------------------------------------------------------
// Drum Machine, version 4.0
// by block-rockin programmer, Jan 1, 2099
// Changes made by other programmer, Dec 17 2096
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// Routing Controls:
// This section configures the audio routing. Create master channels,
// and soundbuffers for each audio channel.
// ----------------------------------------------------------------------------

// Here we'll use Modulo % and random to play drums
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

// Loads all the sound files.
me.dir()+"/sounds/kick.wav" => kick.read;
me.dir()+"/sounds/snare.wav" => snare.read;
me.dir()+"/sounds/hihat.wav" => hihat.read;
me.dir()+"/sounds/pulse.wav" => pulse.read;
me.dir()+"/sounds/arp.wav" => arp.read;


// Setting up variables for your big drum machine

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
    // play kick drum on all main beats (0, 4, ...)
    if (beat % 4 == 0)     // (1) Uses MOD 4 to play
    {                      //     kick drum every fourth beat
        0 => kick.pos;
    }

    // after a time, play snare on off beats (2, 6, ...)
    if (beat % 4 == 2 && measure %2 == 1) // (2) Plays snare only on specific beats
    {
        0 => snare.pos;
    }

    // After a time, randomly play hihat or pulse
    if (measure > 1) {    //  (3) Plays pulse and hihat only after measure 1
        if (pulseSequence[beat])   // (4) Plays pulse, controlled by array
        {
            0 => pulse.pos;
        }
        else              // (5) If not pulse, then hi-hat
        {
            Math.random2f(0.0,1.0) => hihat.gain;  // (6) Hi-hat has random gain
            0 => hihat.pos;
        }
    }

    // after a time, play randomly spaced arp at end of measure
    if (beat > 11 && measure > 3)  // (7) Plays arp only on certain measures and beats
    {
        Math.random2f(-1.0,1.0) => claPan.pan; // (8) arp have random pan
        0 => arp.pos;
    }

    tempo => now;               // (9) Waits for one beat...

    (beat + 1) % MAX_BEAT => beat; // (10) ...and then updates beat counter (MOD MAX)
    if (beat==0)
    {            // (11) Increments measure counter at each new measure
        measure++;
    }
}
