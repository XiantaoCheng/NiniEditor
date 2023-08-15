import sys, re, math
if __name__=='__main__':
    sys.path.append(sys.path[0]+'\\..')
from body.bone import NetP
from body.soul import Karma
from tools import tools_basic
import numpy as np
import pandas as pd



def str2Vec(string,type_num='float'):
    if len(string)>2 and string[0]=='[' and string[-1]==']':
        string=string[1:-1]
    try:
        if type_num=='float':
            vec=[float(s) for s in re.split(',\s*',string)]
        elif type_num=='int':
            vec=[int(s) for s in re.split(',\s*',string)]
        elif type_num=='complex':
            vec=[complex(s) for s in re.split(',\s*',string)]
    except:
        vec=[]
    return vec

def vec2Str(list_num):
    try:
        if isinstance(list_num,str):
            return list_num
        elif isinstance(list_num,list):
            return ", ".join(str(n) for n in list_num)
        else:
            return str(list_num)
    except:
        return ''

def units2Pixel(l,unit):
    if unit=='pixel':
        return l
    elif unit=='cm':
        return l*56
    elif unit=='mm':
        return l*56/10
    elif unit=='inch':
        return l*56*2.54
    else:
        return l*56

class Rect():
    def __init__(self,point=None):
        if point==None:
            self.m_name='Rect'
        else:
            self.m_name=point.m_name
        self.m_pos=[0,0]
        self.m_size=[1,1]
        self.m_angle=0
        self.m_unit='cm'
        self.m_lineWidth=2
        self.m_lineColor='white'
        self.m_lineType='SolidLine'
        self.m_faceColor='black'

def NetP2Rect(point):
    pt_name=tools_basic.getPoint(point,'m_name','rect')
    pt_pos=tools_basic.getPoint(point,'m_pos',None)
    pt_size=tools_basic.getPoint(point,'m_size',None)
    pt_angle=tools_basic.getPoint(point,'m_angle',None)
    pt_unit=tools_basic.getPoint(point,'m_unit',None)
    pt_lineWidth=tools_basic.getPoint(point,'m_lineWidth',None)
    pt_lineColor=tools_basic.getPoint(point,'m_lineColor',None)
    pt_lineType=tools_basic.getPoint(point,'m_lineType',None)
    pt_faceColor=tools_basic.getPoint(point,'m_faceColor',None)

    rect=Rect(pt_name)

    try:
        rect.m_pos=str2Vec(pt_pos.m_text)
        rect.m_size=str2Vec(pt_size.m_text)
        rect.m_angle=float(pt_angle.m_text)
        rect.m_unit=pt_unit.m_text
        rect.m_lineWidth=float(pt_lineWidth.m_text)
        rect.m_lineType=pt_lineType.m_text
        color=str2Vec(pt_lineColor.m_text)
        if color!=[]:
            rect.m_lineColor=color
        else:
            rect.m_lineColor=pt_lineColor.m_text
        color=str2Vec(pt_faceColor.m_text)
        if color!=[]:
            rect.m_faceColor=color
        else:
            rect.m_faceColor=pt_faceColor.m_text
    except:
        return rect
    return rect

class Line():
    def __init__(self,point=None):
        if point==None:
            self.m_name='Line'
        else:
            self.m_name=point.m_name
        self.m_x=[0,1]
        self.m_y=[0,0]
        self.m_unit='cm'
        self.m_lineWidth=1
        self.m_lineColor='black'
        self.m_lineType='SolidLine'

def NetP2Line(point):
    pt_name=tools_basic.getPoint(point,'m_name','rect')
    pt_x=tools_basic.getPoint(point,'m_x',None)
    pt_y=tools_basic.getPoint(point,'m_y',None)
    pt_unit=tools_basic.getPoint(point,'m_unit',None)
    pt_lineWidth=tools_basic.getPoint(point,'m_lineWidth',None)
    pt_lineColor=tools_basic.getPoint(point,'m_lineColor',None)
    pt_lineType=tools_basic.getPoint(point,'m_lineType',None)

    line=Line(pt_name)

    try:
        line.m_x=str2Vec(pt_x.m_text)
        line.m_y=str2Vec(pt_y.m_text)
        line.m_unit=pt_unit.m_text
        line.m_lineWidth=float(pt_lineWidth.m_text)
        line.m_lineType=pt_lineType.m_text
        color=str2Vec(pt_lineColor.m_text)
        if color!=[]:
            line.m_lineColor=color
        else:
            line.m_lineColor=pt_lineColor.m_text
    except:
        return line
    return line


def mat2Str(ma):
    # ma=setZ(ma)
    try:
        string=";\n".join(", ".join(str(num) for num in row) for row in ma)
    except:
        try:
            string=", ".join(str(num) for num in ma)
        except:
            try:
                string=str(ma)
            except:
                string='nan'
    return string

def num2Str(num):
    if isinstance(num,complex):
        num.real=setZ(num.real)
        num.imag=setZ(num.imag)
        return "%f+%fj"%(num.real,num.imag)
    try:
        num=setZ(num)
        return str(num)
    except:
        return "nan"



def setZ(num):
    try:
        num[abs(num)<1e-85]=0
    except:
        if abs(num)<1e-85:
            return 0.
    return num
    
def str2Mat(str_ma):
    str_ma=re.sub('[()]','',str_ma)
    list_row=re.split(';[ \n\t]*',str_ma)
    ma1=np.array([np.fromstring(row,sep=',') for row in list_row])
    ma2=np.array([np.fromstring(row,sep=' ') for row in list_row])
    if np.size(ma1)==0 and np.size(ma2)==0:
        ma=[]
    elif np.size(ma1)>np.size(ma2):
        ma=ma1
    else:
        ma=ma2
    # ma=np.array(np.matrix(str_ma))
    return ma




def tab2Pt(table,head=None):
    if head!=None:
        list_pt=[head]
    else:
        list_pt=[NetP('表格')]
    mat_row=[]
    mat_col=[]

    for term in table:
        pt_ele=NetP('元素',term)
        col=[pt_ele]
        table_col=table[term]
        if len(mat_row)==0:
            mat_row.append([])
        mat_row[0].append(pt_ele)
        for i in range(len(table_col)):
            text=table_col[i]
            if not isinstance(text,str):
                text=num2Str(text)
            pt_ele=NetP('元素',text)
            col.append(pt_ele)
            if len(mat_row)<=i+1:
                mat_row.append([])
            mat_row[i+1].append(pt_ele)
        mat_col.append(col)

    head_row=NetP('行组').con(list_pt[0],None)
    head_col=NetP('列组').con(list_pt[0],None)
    list_pt.append(head_row)
    list_pt.append(head_col)
    for row in mat_row:
        pt_row=NetP('行')
        pt_con=NetP('的').con(head_row,pt_row)
        list_pt.append(pt_row)
        list_pt.append(pt_con)
        for pt in row:
            pt_con=NetP('的').con(pt_row,pt)
            list_pt.append(pt_con)

    for col in mat_col:
        pt_col=NetP('列')
        pt_con=NetP('的').con(head_col,pt_col)
        list_pt.append(pt_col)
        list_pt.append(pt_con)
        for pt in col:
            pt_con=NetP('的').con(pt_col,pt)
            list_pt.append(pt_con)
            list_pt.append(pt)

    return list_pt



if __name__=='__main__':
    # t=pd.read_excel('C:\\Users\\cheng\\Desktop\\physics\\Current_MidIR\\opticalElements.xlsx')
    # list_pt=tab2Pt(t)
    # tools_basic.printPtList(list_pt)
    print(complex('1e-60j'))
    print(float('1e-60'))
    print(str2Vec('什么'))
    print(vec2Str('什么'))