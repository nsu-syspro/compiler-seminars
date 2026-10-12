#!/usr/bin/env bash

clang++ -fPIC -shared PassTemplate.cpp -o PassTemplate.so $(llvm-config --cxxflags --ldflags --system-libs --libs core passes)
opt -load-pass-plugin=./PassTemplate.so -passes=my-pass max.ll -S
