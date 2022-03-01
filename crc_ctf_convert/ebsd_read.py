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
folderpath=r"E:\Master\Data\multiPara_EBSD\新建文件夹\15-16"
if folderpath=="":
    filepath = tkFileDialog.askopenfilename()#获得选择好的文件
    name_full=os.path.split(filepath)
    pname_out=name_full[0]+name_full[1]+".ctf"
    pname_in=name_full[0]+"/"
    fname_in=name_full[1]

    output=eng.crc2ctf_convert(pname_in,fname_in,nargout=1)
    print(output)
else:
    filepath=''
    all_file_name=os.listdir(folderpath)
    cpr_file_list=[]
    for i in all_file_name:
        if i.endswith(".crc")==True:
            cpr_file_list.append(i)
            pname_out=folderpath+r"//"+i+".ctf"
            pname_in=folderpath
            fname_in="\\"+i
                
            output=eng.crc2ctf_convert(pname_in,fname_in,nargout=1)
            print(output)
        else:
            pass


