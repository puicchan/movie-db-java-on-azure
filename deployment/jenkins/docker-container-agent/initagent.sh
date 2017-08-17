#!/usr/bin/env bash
dockerd &
jenkins-slave $1 $2 $3 $4
