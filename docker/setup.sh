NAND2TETRIS_URL='https://drive.google.com/u/0/uc?id=1xZzcMIUETv3u3sdpM_oTJSTetpVee3KZ&export=download'

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends ca-certificates curl unzip
apt-get install -y --no-install-recommends default-jre

ARCHIVE=$(mktemp)
trap "rm $ARCHIVE" EXIT

curl -L -o "$ARCHIVE" "$NAND2TETRIS_URL"
unzip "$ARCHIVE"

# Prevent to create background jobs.
for SCRIPT in $(ls -1 /nand2tetris/tools/*.sh)
do
  sed -i 's/&$//' $SCRIPT
done

# Specify LANG at runtime.
apt-get install -y --no-install-recommends locales
locale-gen 'en_US.UTF-8'

# Specify TZ at runtime.
apt-get install -y --no-install-recommends tzdata

apt-get install -y --no-install-recommends gosu sudo

# cleanup
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /var/tmp/*
