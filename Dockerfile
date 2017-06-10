FROM buildpack-deps:jessie

run apt-get update
run apt-get install -y gcc libgmp-dev libltdl-dev libdb-dev
run wget https://downloads.sourceforge.net/project/open-cobol/gnu-cobol/2.0/gnu-cobol-2.0_rc-2.tar.gz && tar -xvf gnu-cobol-2.0_rc-2.tar.gz && cd gnu-cobo* && ./configure && make && make install && ldconfig
