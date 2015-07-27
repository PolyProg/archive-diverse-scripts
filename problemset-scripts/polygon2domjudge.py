#!/usr/bin/env python

import os
import argparse
import logging

from colors import colors_dict
from problem import Problem

problems = list()
args = None

lastPage=1
lastProbId=""
polygonContestPath = "contest-0"
domjudgeContestId = 1

def setPolygonContestId(id):
  global polygonContestPath, args
  polygonContestPath = "contest-" + str(id)
  if args.unzip:
    os.system("rm -rf "+polygonContestPath)
    os.system("unzip "+polygonContestPath+".zip -d "+polygonContestPath)
    os.system("sed \"s/mpost/echo mpost/\" -i "+polygonContestPath+"/statements/*/doall.sh")
    os.system("(cd "+polygonContestPath+"; find . -name \"*.sh\" -exec chmod a+x {} \; ; bash doall.sh)")

def setDomjudgeContestId(id):
  global domjudgeContestId
  domjudgeContestId = str(id)

def addProblem(folder, probid, depends, color, compare="", run="", offline=None, runtime=0, special_runtime=""):
  global lastPage, lastProbId, polygonContestPath, domjudgeContestId, args
  htmlcolor = colors_dict[color]
  if depends:
    dependency = lastProbId
  else:
    dependency = ""
  p = Problem(folder, probid, domjudgeContestId, polygonContestPath, dependency, htmlcolor, compare, run, offline, runtime, special_runtime)
  problems.append(p)
  if args.latex:
    p.compileLatex()
  lastProbId = probid


def parseArguments():
    parser = argparse.ArgumentParser()
    parser.add_argument('--unzip', action='store_true', help='Unzip and prepare polygon package')
    parser.add_argument('--latex', action='store_true', help='Compile files individually')
    parser.add_argument('--solutions', action='store_true', help='Add solutions to Domjudge file')
    parser.add_argument('--checkers', action='store_true', help='Copy checkers to Domjudge folder')
    global args
    args = parser.parse_args()

def main():
  global args
  parseArguments()
  execfile("config.py")
  os.system("mkdir -p djConfig")
  for p in problems:
    p.package(args)
    print p


if __name__ == "__main__":
  main()
