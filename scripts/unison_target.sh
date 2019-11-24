wget https://www.seas.upenn.edu/~bcpierce/unison/download/releases/stable/unison-2.48.4.tar.gz
tar xvfz unison-2.48.4.tar.gz
cd src
yum install ocaml ocaml-camlp4-devel ctags ctags-etags
make
cp -v unison /usr/local/sbin/
cp -v unison /usr/bin
cd ~
curl -L -o unison-fsmonitor https://github.com/TentativeConvert/Syndicator/raw/master/unison-binaries/unison-fsmonitor
cp unison-fsmonitor /usr/local/sbin/
cp unison-fsmonitor /usr/bin/
chmod +x /usr/bin/unison-fsmonitor
chmod +x /usr/local/sbin/unison-fsmonitor
