# -*- coding: cp936 -*-
import matlab
import matlab.engine
import os
import sys
import Tkinter as tk
import tkFileDialog


eng=matlab.engine.start_matlab()
'''��ѡ���ļ��жԻ���'''
root = tk.Tk()
root.withdraw()

#folderpath = tkFileDialog.askdirectory() #���ѡ��õ��ļ���
folderpath=r"E:\Master\Data\multiPara_EBSD\�½��ļ���\15-16"
if folderpath=="":
    filepath = tkFileDialog.askopenfilename()#���ѡ��õ��ļ�
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


