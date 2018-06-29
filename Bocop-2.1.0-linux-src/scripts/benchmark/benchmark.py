#!/usr/bin/python
# -*- coding: utf-8 -*-
# BOCOP - Test script
# Author: Pierre Martinon, Olivier Tissot, Jinyan Liu
# Inria Saclay and CMAP Ecole Polytechnique
# 2013-2017
# NB. this script is NOT compliant with Python 3 syntax !

# Call: python benchmark.py [benchmark_list_prefix]
# default prefix is 'benchmark' and will use data from benchmark.list.csv

#------------------------------------------------------------------------
#------------------------------------------------------------------------
# Imports
import sys
import os
import shutil
import subprocess
import platform
import csv

#------------------------------------------------------------------------
#------------------------------------------------------------------------
# Functions


#------------------------------------------------------------------------
# Function for reading a simulation.log file and extract summary
#------------------------------------------------------------------------
def readresultfile(filename):

  status = -1
  objective = '0.0'
  constraint = '0.0'
  iterations = '0'
  cpuipopt = '0.0'
  cpunl = '0.0'

  with open(filename,'r') as resultfile:
    for line in resultfile:
      if 'EXIT: Optimal Solution Found' in line:
        status = 0
      elif 'EXIT: Solved To Acceptable Level' in line:
        status = 1
      elif 'EXIT: Maximum Number Of Iterations' in line:
        status = 6
      elif 'Number of Iterations....' in line:
        iterations = line.split()[-1]
      elif 'Objective...............' in line:
        objective = line.split()[-1]
      elif 'Constraint violation....' in line:
        constraint = line.split()[-1]
      elif 'Total CPU secs in IPOPT' in line:
        cpuipopt = line.split()[-1]
      elif 'Total CPU secs in NLP' in line:
        cpunl = line.split()[-1]

  return status, objective, constraint, iterations, cpuipopt, cpunl

#end of function readresultfile


#------------------------------------------------------------------------
# Function to check (build and run) a specific problem
#------------------------------------------------------------------------
def checkproblem(path):

  status = -1
  objective = '0.0'
  constraint = '0.0'
  iterations = '0'
  cpuipopt = '0.0'
  cpunl = '0.0'
  cpu = 0.0

  # set paths
  pwd = os.getcwd()
  problem = path.split('/').pop()
  fnull = open(os.devnull, 'w')
  outfile = 'result.out'

  # build current problem
  print 'Testing example:', path
  if os.path.exists('build'):
    shutil.rmtree('build', ignore_errors=True)
  os.mkdir('build')
  os.chdir('build')
  if platform.system() == 'Windows':
    execfile = '../../'+path+'/bocop.exe'
    if os.path.exists(execfile):
      os.remove(execfile)
    subprocess.call('cmake -G \"MSYS Makefiles\" -DPROBLEM_DIR:PATH='+pwd+'/../../'+path+' ../../..',shell=True,stdout=fnull)
  else:
    execfile = '../../'+path+'/bocop'
    if os.path.exists(execfile):
      os.remove(execfile)
    subprocess.call('cmake -DPROBLEM_DIR='+pwd+'/../../'+path+' -DCMAKE_BUILD_TYPE=Release ../../..',shell=True,stdout=fnull)
  ret = subprocess.call('make -j',shell=True,stdout=fnull)

  if ret != 0:
    status = -2
    print '*** Building FAILED for example: ', path, '!'
  else:
    # run current problem
    os.chdir('../../../'+path)
    if os.path.exists(outfile):
      os.remove(outfile)

    if platform.system() == 'Windows':
      subprocess.call('bocop.exe | grep -v buffer',shell=True,stdout=fnull)
    else:
      subprocess.call('./bocop | grep -v buffer',shell=True,stdout=fnull)

    # read results
    if os.path.exists(outfile):
      status, objective, constraint, iterations, cpuipopt, cpunl = readresultfile(outfile)
      cpu = float(cpunl) + float(cpuipopt)
      print '> Objective:', objective,'Constraints:', constraint,'Iterations', iterations,'CPU time:',cpu,'Status',status
    else:
      status = -3
      print '*** Execution FAILED for example', problem, '!'

  os.chdir(pwd)
  return status, objective, constraint, iterations, cpuipopt, cpunl, cpu

#end of function checkproblem


#------------------------------------------------------------------------
# read data from reference / benchmark summary file
#------------------------------------------------------------------------
def readfile(filename) :

  status = []
  objective = []
  iterations = []
  problem = []

  with open(filename,'r') as f:
    cr = csv.reader(f, delimiter=",")
    next(cr) #skip header
    for row in cr:
      if row[0][0] != '#':
        problem.append(row[0])
        objective.append(row[1])
        iterations.append(row[2])
        status.append(row[5])

  return status, objective, iterations, problem

#end of function readreference


#------------------------------------------------------------------------
#------------------------------------------------------------------------
# Main script

# number of failed problems
failed = 0

# set input / ouptut filenames prefix (default 'benchmark')
if len(sys.argv) == 1:
  prefix = 'benchmark'
else:
  prefix = sys.argv[1]

# reset log file and test all problems in list
with open(prefix+'.results.csv','w') as logfile:
  logfile.write('Problem  Objective  Constraints  Iterations  Cpu(IPOPT/NL) Status\n')

  # test all problems in list (ignoring comments starting by #)
  statusref, objectiveref, iteref, problemref = readfile(prefix+'.list.csv')
  for problem in problemref:
    path = problem.rstrip(' \n\r')
    if not path[0] == '#':
      sta, obj, con, ite, cpui, cpunl, cpu = checkproblem(path)
      result = path+','+obj+','+con+','+ite+','+str(cpu)+'('+cpui+'/'+cpunl+'),'+str(sta)
      logfile.write(result+'\n')

# read log file and compare results with reference solutions
statussol, objectivesol, itesol, problemsol = readfile(prefix+'.results.csv')
for problem in problemsol :
  i = problemsol.index(problem)
  if problem in problemref :
    j = problemref.index(problem)
    obj_err = abs(float(objectivesol[i]) - float(objectiveref[j]));
    if obj_err <= 0.01 * abs(float(objectiveref[j])):
      print 'Problem '+problem+': '+'PASSED'
    else :
      print 'Problem '+problem+': '+'FAILED: STATUS '+str(statussol[i])+' Objective:'+str(objectivesol[i])+' vs '+str(objectiveref[j])
      failed = failed + 1
  else :
    print 'Problem '+problem+': '+'MISSING REFERENCE DATA'

# return number of failed problems as exit code (thus 0 == SUCCESS)
sys.exit(failed)

