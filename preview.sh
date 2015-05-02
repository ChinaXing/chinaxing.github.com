#!/usr/bin/env bash
(sleep 1 ; open http://localhost:8080) &
 cd wintersmith && node_modules/wintersmith/bin/wintersmith preview 
