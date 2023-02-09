Flame
=====

Flame: creates mp3 audio files from list in stdin.

## Options

Flame is [lame](https://lame.sourceforge.io/) wrapper, so it will accept all the options lame does:

    # all flac files in current directory:
    # encode with fixed bit rate jstereo 128kbs encoding
    find . -maxdepth 1 -type f -iname "*.flac" | flame -b 128

    # all waw files in current directory:
    # encode with fixed bit rate jstereo 128 kbps encoding, highest quality
    find . -maxdepth 1 -type f -iname "*.wav" | flame -q 0 -b 128

    # all audio files in /home directory, recursively:
    # encode with the standard preset to /tmp directory
    find /home -type f | flame --preset standard --out-dir /tmp

## Install

    sudo wget https://raw.githubusercontent.com/fffilo/flame/master/src/flame.sh -O /usr/local/bin/flame
    sudo chmod +x /usr/local/bin/flame

## Uninstall

    sudo rm /usr/local/bin/flame
