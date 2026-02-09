# SF2Converter

The converter is now embedded in the editor itself. Just hit F10 in the editor
and load the MOD, SNG and CT files from there.

It converts from 4-channel "Amiga" MOD files, SNG files from GoatTracker 2, and
and CT files from CheeseCutter.

About MOD conversions:

- You can optionally specify a switch for selecting the channel to leave out
     when converting from 4 to 3 channels.

- It converts arpeggio, slides, portamento (to tienote), vibrato, volume (as
     note-focus ADSR commands), and break/jump cuts the sequences short.

- Tempo changes are not currently supported, but the first tempo command set
     will be used to define the general speed in the tempo table.

- All instruments will point to a simple triangle waveform so you can hear
     something immediately after loading.

- The top command #00 is used to halt a slide in its tracks, and command #01
     is used to break many effects (not just portamento).

- Slide and vibrato speeds will differ greatly depending on the samples they
     were originally designed for. You will almost definitely have to adjust.

- Many oldskool MOD composers loved adding feeling to vibrato by chaining a
     few commands with increased amplitude. This doesn't work all that well in
     SF2 and will probably benefit a lot from being simplified.

- Another thing that will probably help a lot right after loading is to bump
     the order list transpositions of some sequences an octave or two up or
     down. Basslines often need to go down and chords up a notch.

About SNG (GoatTracker 2) conversions:

- It's easy to overwhelm the converter making it give up. GT2 still allows
     for more instruments and patterns than SF2 does. If you really want to
     import a big one, edit it first in GT2 and cut down some stuff.

- Delay and pattern commands in the wave table are not supported. Neither
     are multiple sub tunes, instrument vibrato, pulse index command, the funk
     and normal tempo change commands (the first tempo command is set in the
     SF2 tempo table) and a few more. The converter will tell you about it.

About CT (CheeseCutter) conversions.

- If the CT source file you are converting from have multiple sub tunes, only
     one of them will be converted. It will be the one you had in focus when you
     saved in CheeseCutter. This, way you can choose which one to convert.

- The A, D, S and R sequence commands are not converted. If you still want it
     on the selected notes, you have to add ADSR commands in SF2 yourself.

- The arpeggio speed nibble in the instrument is brought over to the chords
     in SF2 to match the right speed, but unfortunately this is not possible to
     match for standard wave tables too. These will always run at full speed.

- Delay commands are expanded too, but you may want to check the loop index
     marker after expanded wave table clusters to see if they are correct.
