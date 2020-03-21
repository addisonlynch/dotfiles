#! /usr/bin/python
#
# COPYRIGHT 2018 ADDISON LYNCH
#
# Clones a git repository (optional branch argument)
#
import os
import sys
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-b", "--branch", help="branch", type=str)
parser.add_argument("user", help='github username', type=str)
parser.add_argument("repo", help='repository name', type=str)
args = parser.parse_args()

branch = ("-b " + args.branch) if args.branch else ''

CMD = 'git clone {} https://github.com/{}/{}'.format(branch, args.user, args.repo)

os.system(CMD)
