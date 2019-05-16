#!/usr/bin/env python
# coding:utf-8

import subprocess

__author__ = 'catchance'

BRANCH_NAME = 'feature-hugo'

subprocess.call('git fetch origin', shell=True)
subprocess.call('git checkout {0}'.format(BRANCH_NAME), shell=True)
subprocess.call('git reset --hard origin/{0}'.format(BRANCH_NAME), shell=True)
subprocess.call('git clean -fdx', shell=True)
subprocess.call('git submodule init', shell=True)
subprocess.call('git submodule update', shell=True)
subprocess.call('git submodule foreach git pull --rebase origin master', shell=True)
subprocess.call('supervisorctl restart hugo', shell=True)
