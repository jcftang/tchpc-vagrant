#!/bin/sh

p=http://proxy.tchpc.tcd.ie:8080
export http_proxy=$p
export https_proxy=$p
export ftp_proxy=$p

export HTTP_PROXY=$p
export HTTPS_PROXY=$p
export FTP_PROXY=$p

export rvm_proxy=$p
