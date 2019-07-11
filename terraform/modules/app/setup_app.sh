#!/bin/bash
export DATABASE_URL=$1
cd reddit
puma -d