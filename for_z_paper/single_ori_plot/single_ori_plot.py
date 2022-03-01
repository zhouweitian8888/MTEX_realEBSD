# -*- coding: cp936 -*-
import xlsxwriter
import math
import os
import time
import sys
import matlab
import matlab.engine

def angle(state_in):
    N_angle=49   #it may change rapidly,note all.py
    Pi=3.141592654
    angle_per=[0,0,0]
    dim_number=[0,0,0]
    Euler=[0,0,0]
    angle_per[0]=1.0*Pi/N_angle
    angle_per[1]=1.0*Pi/N_angle
    angle_per[2]=1.0*Pi/N_angle
    
    state_num_per=state_in-600 
    if state_num_per%((N_angle+1)*(N_angle+1))==0:
        dim_number[0]=N_angle+1
        dim_number[1]=N_angle+1
        dim_number[2]=state_num_per//((N_angle+1)*(N_angle+1))-1
    else:
        dim_number[0]=state_num_per%((N_angle+1)*(N_angle+1))%(N_angle+1)-1
        dim_number[1]=state_num_per%((N_angle+1)*(N_angle+1))//(N_angle+1)
        dim_number[2]=state_num_per//((N_angle+1)*(N_angle+1))
      
    
    Euler[0]=dim_number[0]*angle_per[0]
    Euler[1]=dim_number[1]*angle_per[1]
    Euler[2]=dim_number[2]*angle_per[2]
    return Euler

state_in=float(input("please input state=="))
euler_1=angle(state_in)[0]
euler_2=angle(state_in)[1]
euler_3=angle(state_in)[2]
print(math.degrees(euler_1),math.degrees(euler_2),math.degrees(euler_3))
"""
euler_1=float(input("please input euler1=="))
euler_2=float(input("please input euler2=="))
euler_3=float(input("please input euler3=="))
"""
#euler_1=293.24
#euler_2=95.40
#euler_3=85.14


workbook_path=str(r"C:\Users\zhouweitian\Desktop\test\for_z_paper\single_ori_plot\xlsx"+r"\euler_1"+'.xlsx')
workbook = xlsxwriter.Workbook(workbook_path)
worksheet1=workbook.add_worksheet("test")
style = workbook.add_format({
    'border': 1, 
    'align': 'center', 
    'valign': 'vcenter', 
    'bold': False,
    'font': u'宋体', 
    'fg_color': 'white', 
    'color': 'black' 
})
worksheet1.write(0,0,"Euler1",style)
worksheet1.write(0,1,"Euler2",style)
worksheet1.write(0,2,"Euler3",style)
worksheet1.write(0,3,"Phase",style)
worksheet1.write(0,4,"x",style)
worksheet1.write(0,5,"y",style)
worksheet1.write(0,6,"index",style)
worksheet1.write(0,7,"state",style)
with open(r"C:\Users\zhouweitian\Desktop\test\for_z_paper\single_ori_plot\slice_009_60.0.okc") as f:  # 打开文件
    data = f.read()  # 读取文件
    i=0
    i_line=0
    while i_line<9:
        i_line_test=data[i]
        if ord(i_line_test)==10:
            i_line=i_line+1
        i=i+1
    i_line_xlsx=1

    #for test
    #print(data[i:i+91])
    #print(data[i+92:i+183])
    #print(data[i+92])
    #for test

    while i<len(data):
        x=round((float(data[i:i+22]))*math.pow(10,6))/math.pow(10,6)
        y=round((float(data[i+23:i+45]))*math.pow(10,6))/math.pow(10,6)
        
        #y=float(data[i+23:i+45])
        state=int(float(data[i+69:i+91]))
        euler_angle=[euler_1,euler_2,euler_3]
        #if 160<(x*math.pow(10,6))<318)&(82<(y*math.pow(10,6))<318):#20%-80%
    
        worksheet1.write(i_line_xlsx,4,x,style)
        worksheet1.write(i_line_xlsx,5,y,style)
        worksheet1.write(i_line_xlsx,0,euler_angle[0],style)
        worksheet1.write(i_line_xlsx,1,euler_angle[1],style)
        worksheet1.write(i_line_xlsx,2,euler_angle[2],style)
        if state>=550:
            worksheet1.write(i_line_xlsx,3,1,style)
            worksheet1.write(i_line_xlsx,6,"Indexed",style)
        else:
            worksheet1.write(i_line_xlsx,3,0,style)
            worksheet1.write(i_line_xlsx,6,"notIndexed",style)
        worksheet1.write(i_line_xlsx,7,state,style)
        i_line_xlsx=i_line_xlsx+1
        #print(1)
        i=i+92
        #print(i_line_xlsx,(x*math.pow(10,6)),(y*math.pow(10,6)))
        #print(data[i+69:i+90],state)
    print(str(workbook_path+'.xlsx')+" "+"end")
workbook.close()



eng=matlab.engine.start_matlab()
pname_in=str(r"C:\Users\zhouweitian\Desktop\test\for_z_paper\single_ori_plot\xlsx")
xlsx_file_all=os.listdir(pname_in)
file_count=0
while file_count<len(xlsx_file_all):
    fname_in=str(xlsx_file_all[file_count])
    print(fname_in)
    time.sleep(1)
    pname_out_polefig=str(r"C:\Users\zhouweitian\Desktop\test\for_z_paper\single_ori_plot\polefig\\"+"p_"+xlsx_file_all[file_count][:-5]+".jpg")
    pname_out_grainfig=str(r"C:\Users\zhouweitian\Desktop\test\for_z_paper\single_ori_plot\\"+"g_"+xlsx_file_all[file_count][:-5]+".jpg")
    output=eng.plotebsd_for_single_ori_plot(pname_in,fname_in,pname_out_polefig,pname_out_grainfig,nargout=1)
    file_count=file_count+1
    print("2")
    