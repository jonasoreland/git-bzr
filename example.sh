#!/bin/sh

set -e
set -x 

which git-bzr || true

root=`pwd`
bzr init-repository test-bzr
cd test-bzr && bzr init b1 && cd b1
cat > kalle.txt <<EOF
int a;
int b;
int c;
EOF
bzr add kalle.txt
bzr commit -m"init"

cd $root/test-bzr
bzr branch $root/test-bzr/b1 b2 && cd b2
cat >> kalle.txt <<EOF
int d;
EOF
bzr commit -m"add d"

cd $root/test-bzr/b1
cat > kalle.txt <<EOF
int a;
int b=0;
int c;
EOF
bzr commit -m"b=0"

cd $root
mkdir test-git && cd test-git
git init
git bzr add b1 ../test-bzr/b1
git bzr add b2 ../test-bzr/b2
git bzr fetch b1 
git bzr fetch b2
git branch b1 bzr/b1
git branch b2 bzr/b2
git checkout -f b2
git merge b1

git bzr push b2
cd $root/test-bzr/b2 
bzr update
bzr missing $root/test-bzr/b1 || true
bzr pull $root/test-bzr/b1

cd $root
rm -rf test-git test-bzr
