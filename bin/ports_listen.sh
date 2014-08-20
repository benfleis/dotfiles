#!/bin/sh

lsof -nPi tcp | grep LISTEN
