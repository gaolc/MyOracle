#!/usr/bin/python
import os
rlist=[]
line_sum=0
file_sum=0
def check_file(path):
    global rlsit
    for dir,folder,file in os.walk(path):
        for i in file:
            t="%s/%s"%(dir,i)
            rlist.append(t)

def main():
    with open('listall') as f:
        for pa in f.read().splitlines():
            check_file(pa)
if __name__=='__main__':
    main()
    for file in rlist:
        file_sum+=1
        with open(file) as ft:
            lines=len(ft.read().splitlines())
        line_sum+=lines
    print ('Lines: {0} Files: {1} '.format(line_sum,file_sum))