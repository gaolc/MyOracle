#!/usr/bin/python 
# -*- coding:utf-8 -*-
import os
import sys 
import time
import datetime
import platform
MAX_LINE_NUM=0
#set change line position 
LINE_POSITION=2000
CONNECTOR="'\n||'"
CHANGE=0
def count_time(func):
    def wrapper(*args,**kwargs):
        starTime=time.time()
        func(*args,**kwargs)
        endTime=time.time()
        spend_time=int(endTime-starTime)
        print ('{0} INFO : The time of spend is {1} seconds .'.format(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),spend_time))
    return wrapper
def getMaxLineNum(filename):
    global MAX_LINE_NUM
    if platform.system()=='Linux':
        r=os.popen('wc -l '+filename).readlines()
        MAX_LINE_NUM=int(r[0].split(" ")[0])
    elif platform.system()=='Windows':
        with open(filename) as f:
            text=f.read()
        MAX_LINE_NUM=len(text.splitlines())           
    else:
        print ("Warning : Please user Linux or Windows !")
    return MAX_LINE_NUM
     
def init():
    time_now=datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    if os.path.isfile(sys.argv[1]+'-new'):
        print ('{0} INFO : File {1}-new exits ,need to delete !'.format(time_now,sys.argv[1]))
        os.remove(sys.argv[1]+'-new')
    else : 
        print ("{0} INFO : File {1}-new not exits ,don't need to delete !".format(time_now,sys.argv[1]))

class CHANGE_LINE():
    def __init__(self,data_file):
        self.data_file=data_file
    @count_time
    def alterLine(self,callback=object):
        self.curr_line_num=0
        trigger_bar_update=MAX_LINE_NUM/70
        if trigger_bar_update == 0 :
            trigger_bar_update=1        
        t1=int(time.time())
        with open(self.data_file,'r') as file :
            for line in file :
                self.curr_line_num+=1
                line=line.strip('\n')
                if len(line) > LINE_POSITION :
                    global CHANGE
                    CHANGE+=1
                    c_time=len(line)/LINE_POSITION
                    y=len(line)%LINE_POSITION
                    message=''
                    if c_time == 1 and y != 0:
                        message+=line[0:LINE_POSITION]+CONNECTOR+line[LINE_POSITION:]
                    elif c_time>1 and y == 0 :     
                        for i in range(0,c_time): 
                            if i < c_time-1 :
                                message+=line[i*LINE_POSITION:(i+1)*LINE_POSITION]+CONNECTOR
                            else :
                                message+=line[i*LINE_POSITION:(i+1)*LINE_POSITION] 
                    elif c_time>1 and y != 0 :
                        for i in range(0,c_time): 
                            if i < c_time - 1 :
                                message+=line[i*LINE_POSITION:(i+1)*LINE_POSITION]+CONNECTOR
                            else :
                                message+=line[i*LINE_POSITION:(i+1)*LINE_POSITION]+CONNECTOR+line[(i+1)*LINE_POSITION:]                        
                    with open(self.data_file+'-new','a') as temp_f:
                        print >> temp_f,(message)
                else :
                    with open(self.data_file+'-new','a') as temp_f:
                        print >> temp_f,(line)
                if self.curr_line_num % trigger_bar_update ==0 or self.curr_line_num == MAX_LINE_NUM:
                    callback(current_step=self.curr_line_num)     
                                     
class PrcgressBar():
    max_arrow=70
    def __init__(self,max_step):
        self.max_step=max_step
        self.curret_step=1        
    def updateBar(self,current_step=None):
        if current_step is not None :
            self.current_step=current_step
        num_arrow=int(self.current_step*self.max_arrow / self.max_step)
        num_line=self.max_arrow - num_arrow
        percent=self.current_step * 100.0 / self.max_step
        progress_bar='[' + '>' * num_arrow + '-' * num_line + ']' +'%.2f' %percent + '%' + '\r'
        progress_bar_n='[' + '>' * num_arrow + '-' * num_line + ']' +'%.2f' %percent + '%' + '\n'
        if  current_step<self.max_step :
            sys.stdout.write(progress_bar)
        else :
            sys.stdout.write(progress_bar_n)
        sys.stdout.flush()
       
if __name__=='__main__':
    if len(sys.argv[:]) != 2:
       print ('Usage : python {0} <filename> '.format(sys.argv[0]))
       sys.exit(1)
    else :
       file_name=sys.argv[1]
    init()
    MAX_LINE_NUM=getMaxLineNum(file_name)
    print ('{0} INFO : {1} has {2} lines .'.format(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),file_name,MAX_LINE_NUM))
    barObj=PrcgressBar(MAX_LINE_NUM)
    chgLine=CHANGE_LINE(file_name)
    chgLine.alterLine(callback=barObj.updateBar)
    print ('{0} INFO : This time has changed {1} lines .'.format(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),CHANGE)) 
    