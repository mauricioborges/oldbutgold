FROM buildpack-deps:jessie

run apt-get update
run apt-get install -y open-cobol gcc
