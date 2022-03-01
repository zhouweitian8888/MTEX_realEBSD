# -*- coding: cp936 -*-
import matlab
import matlab.engine
import os
import sys
import Tkinter as tk
import tkFileDialog
eng=matlab.engine.start_matlab()
'''打开选择文件夹对话框'''
root = tk.Tk()
root.withdraw()

#folderpath = tkFileDialog.askdirectory() #获得选择好的文件夹
folderpath=r"E:\Master\Data\multiPara_EBSD\20210409EBSD\新建文件夹"
if folderpath=="":
    filepath = tkFileDialog.askopenfilename()#获得选择好的文件
    name_full=os.path.split(filepath)
    if os.path.exists(name_full[0]+r"/polefig")==True:
        pname_out_polefig=name_full[0]+r"/polefig/"+name_full[1]+".jpg"
        pname_out_grainfig=name_full[0]+r"/grainfig/"+name_full[1]+".jpg"
        pname_in=name_full[0]+"/"
        fname_in=name_full[1]
  
        output=eng.plotebsd_realdata(pname_in,fname_in,pname_out_polefig,pname_out_grainfig,nargout=1)
        print(fname_in)
    else:
        os.mkdir(name_full[0]+r"/polefig")
        os.mkdir(name_full[0]+r"/grainfig")
        pname_out_polefig=name_full[0]+r"/polefig/"+name_full[1]+".jpg"
        pname_out_grainfig=name_full[0]+r"/grainfig/"+name_full[1]+".jpg"
        pname_in=name_full[0]+"/"
        fname_in=name_full[1]
  
        output=eng.plotebsd_realdata(pname_in,fname_in,pname_out_polefig,pname_out_grainfig,nargout=1)
        print(fname_in)
else:
    filepath=''
    all_file_name=os.listdir(folderpath)
    cpr_file_list=[]
    for i in all_file_name:
        if i.endswith(".cpr")==True:
            cpr_file_list.append(i)
            if os.path.exists(folderpath+r"/polefig")==True:
                pname_out_polefig=folderpath+r"/polefig/"+i+".jpg"
                pname_out_grainfig=folderpath+r"/grainfig/"+i+".jpg"
                pname_in=folderpath
                fname_in="/"+i
  
                output=eng.plotebsd_realdata(pname_in,fname_in,pname_out_polefig,pname_out_grainfig,nargout=1)
                print(fname_in)
            else:
                os.mkdir(folderpath+r"/polefig")
                os.mkdir(folderpath+r"/grainfig")
                pname_out_polefig=folderpath+r"/polefig/"+i+".jpg"
                pname_out_grainfig=folderpath+r"/grainfig/"+i+".jpg"
                pname_in=folderpath
                fname_in="/"+i
                    
                output=eng.plotebsd_realdata(pname_in,fname_in,pname_out_polefig,pname_out_grainfig,nargout=1)
                print(fname_in)
        
        else:
            pass


