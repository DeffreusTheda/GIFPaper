#!/bin/sh

clang -fobjc-arc BTHBackgroundWindow.m BTHAppDelegate.m main.m -o GIFPaperAgent -framework Foundation -framework AppKit
