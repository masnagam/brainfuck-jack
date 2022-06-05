set -eu

PROGNAME=$(basename $0)

DELAY=5

INTERVAL=100
NUM_CELLS=32
PROGRAM_BF=

help() {
  cat <<EOF >&2
Transfer a Brainfuck program into the interpreter running on the VM Emulator.

USAGE:
  $PROGNAME -h | --help
  $PROGNAME [--interval <interval>] [--num-cells <num-cells>] [<program-bf>]

OPTIONS:
  -i, --interval [default: $INTERVAL]
    The interval time in milli-seconds for each evaluation of an instruction
    in the Brainfuck program.

  -n, --num-cells [default: $NUM_CELLS]
    The number of cells allocated.

ARGUMENTS:
  <program-bf>
    Path to the Brainfuck program to be transfered.

    Transfer the well-known "Hello, World!" program if no program file is
    specified.

NOTES:
  The current transfer speed of this program is 200 characters per second.
EOF
  exit 0
}

log() {
  echo "$1" >&2
}

vlog() {
  if [ $VERBOSE -ge $1 ]
  then
    log "LOG($1): $2"
  fi
}

error() {
  log "ERROR: $1"
  exit 1
}

while [ $# -gt 0 ]
do
  case "$1" in
    '-h' | '--help')
      help
      ;;
    '-i' | '--interval')
      INTERVAL=$2
      shift 2
      ;;
    '-n' | '--num-cells')
      NUM_CELLS=$2
      shift 2
      ;;
    *)
      break
      ;;
  esac
done

if [ $# -gt 0 ]
then
  PROGRAM_BF="$1"
fi

if [ "$NUM_CELLS" -gt 80 ]
then
  error "Too many cells, must be less than or equal to 80."
fi

if [ -n "$PROGRAM_BF" ]
then
  # Remove lines starting with '#', which are treated as comments in the
  # program.
  #
  # The well-known way to write comments in a Brainfuck program is like below:
  #
  #   [This is a comment.
  #
  #    The contents inside brackets are just ignored if the value of the current
  #    cell is equal to 0 at the start bracket.  Normally, comments are written
  #    at the beginning of the program because all cells have been filled with 0
  #    before the interpreter evaluates the first instruction.
  #   ]
  #
  # We introduce the new syntax for comments in order to reduce the size of the
  # program.  Our interpreter cannot load a program longer than 512 characters.
  CODE=$(cat "$PROGRAM_BF" | sed '/^#/d')
else
  # The well-known "Hello, World!" program, took from:
  # https://esolangs.org/wiki/Brainfuck.
  #
  # The total steps is 986.
  CODE='++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.'
fi

BYTES=$(echo -n "$CODE" | wc -c)

xdotool search 'Virtual Machine Emulator' windowactivate --sync
xdotool type --delay=$DELAY $INTERVAL
xdotool key --delay=$DELAY Return
xdotool type --delay=$DELAY $NUM_CELLS
xdotool key --delay=$DELAY Return
xdotool type --delay=$DELAY $BYTES
xdotool key --delay=$DELAY Return
xdotool type --delay=$DELAY "$CODE"
