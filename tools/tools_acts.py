import os, sys, math, webbrowser, random, re, time
import clipboard
from datetime import datetime
from matplotlib.pyplot import text

from pyautogui import size
if __name__=='__main__':
    sys.path.append(sys.path[0]+'\\..')
from body import GLOBAL
from body.soul import Karma
from body.bone import NetP
from tools import tools_parsers, tools_basic, tools_format
from tools.tools_diags import InputDialog
from PyQt5.QtWebEngineWidgets import QWebEngineView
from PyQt5 import QtWidgets
import logging
# import pandas as pd
try:
    import matlab.engine as mtb
except:
    print('No matlab detected!')
import numpy as np
import pyautogui

import importlib
from life import life_TreeCore
import ctypes


# mtb=None


def operateAll(actions,port):
    # tools_basic.printPtList(actions)
    while len(actions)>0:
        action=actions.pop()
        # print("执行动作:",action.info())
        sbj=action.m_db[0]
        obj=action.m_db[1]
        result=False
        if sbj!=None and sbj.m_dev!=None:
            try:
                result,actions_new=sbj.m_dev.operate(action)
            except:
                pass
        if result==False:
            if action.m_name=='[删除]' or action.m_name=='[del]':
                opDelete(obj)
            elif action.m_name=='[清空历史]' or action.m_name=='[clearHistory]':
                opClearHistory(port)
            elif action.m_name=='[左连]' or action.m_name=='[lt]':
                opConnect(sbj,obj,0)
            elif action.m_name=='[右连]' or action.m_name=='[rt]':
                opConnect(sbj,obj,1)
            elif action.m_name=='[标题]' or action.m_name=='[m_name]':
                opName(sbj,action)
            elif action.m_name=='[修改标题]' or action.m_name=='[writeName]':
                opWriteName(sbj,obj,action)
            elif action.m_name=='[修改内容]' or action.m_name=='[writeText]':
                opWriteText(sbj,obj,action)
            elif action.m_name=='[增加内容]' or action.m_name=='[addToText]':
                opAddToText(sbj,obj,action)
            elif action.m_name=='[增加内容2]' or action.m_name=='[addToText2]':
                opAddToText(sbj,obj,action,2)
            elif action.m_name=='[复制内容]' or action.m_name=='[copyText]':
                opCopyText(obj)
            elif action.m_name=='[粘贴内容]' or action.m_name=='[pasteText]':
                opPasteText(obj)
            # elif action.m_name=='[移动到]' or action.m_name=='[moveTo]':
            #     opMove(sbj,obj)
            # elif action.m_name=='[上面]' or action.m_name=='[up]':
            #     posPoint(sbj,action,0)
            # elif action.m_name=='[下面]' or action.m_name=='[down]':
            #     posPoint(sbj,action,1)
            # elif action.m_name=='[左面]' or action.m_name=='[left]':
            #     posPoint(sbj,action,2)
            # elif action.m_name=='[右面]' or action.m_name=='[right]':
            #     posPoint(sbj,action,3)
            elif action.m_name=='[显示]' or action.m_name=='[print]':
                printPoint(obj,action)
            elif action.m_name=='[全部关联]' or action.m_name=='[AllCons]':
                opAllCons(obj,action)
            #elif action.m_name=='[显示设备]' or action.m_name=='[printDev]':
            #    opPrintDev()
            #elif action.m_name=='[显示因果链]' or action.m_name=='[printKarma]':
            #    opPrintKarma(sbj)
            #elif action.m_name=='[记录因果链]' or action.m_name=='[printKarma]':
            #    opKarmaStr(sbj,obj)
            #elif action.m_name=='[生成因果链]' or action.m_name=='[genKarma]':
            #    opGeneratreKm(sbj,obj,action)
            #elif action.m_name=='[数学运算]' or action.m_name=='[mathOperator]':
            #    opMathOperator(sbj,obj)
            #elif action.m_name=='[数学函数]' or action.m_name=='[mathFunction]':
            #    opMathFunction(sbj,obj)
            #elif action.m_name=='[字符串运算]' or action.m_name=='[strOperator]':
            #    opStrOperator(sbj,obj)
            #elif action.m_name=='[提取字符]' or action.m_name=='[takeChar]':
            #    opStrTakeChar(sbj,obj,action)
            #elif action.m_name=='[提取字符串]' or action.m_name=='[takeString]':
            #    opStrTakeSpan(sbj,obj,action)
            #elif action.m_name=='[剪切字符串]' or action.m_name=='[strCut]':
            #    opStrCutDown(sbj,obj,action)
            #elif action.m_name=='[向前搜索]' or action.m_name=='[strFindForward]':
            #    opStrFindForward(sbj,obj,action)
            #elif action.m_name=='[向后搜索]' or action.m_name=='[strFindBackward]':
            #    opStrFindBackward(sbj,obj,action)
            elif action.m_name=='[打开]' or action.m_name=='[open]':
                opOpen(obj,action)
            elif action.m_name=='[导入]' or action.m_name=='[import]':
                opImport(sbj,obj,action)
            elif action.m_name=='[导入节点]' or action.m_name=='[importPts]':
                opImportPts(sbj,obj,action)
            elif action.m_name=='[导出节点]' or action.m_name=='[importPts]':
                opExportPts(obj,action)
            #elif action.m_name=='[桌面]' or action.m_name=='[desktop]':
            #    opDesktop(action)
            elif action.m_name=='[执行操作]' or action.m_name=='[newAction]':
                opNewAction(sbj,obj,action,port)
            elif action.m_name=='[做]' or action.m_name=='[do]':
                opDo(action,port)
            # karma script
            elif action.m_name=='[运行代码]' or action.m_name=='[runCode]':
                opRunCode(sbj,obj,action)
            #elif action.m_name=='[随机数]' or action.m_name=='[random]':
            #    opRandom(obj)
            elif action.m_name=='[因果结构]' or action.m_name=='[km2Pt]':
                opKm2Pt(sbj,obj,action)
            # elif action.m_name=='[子问题]' or action.m_name=='[subQuestion]':
            #     opSubQuestion(sbj,obj,actions,port)
            # elif action.m_name=='[新猜想]' or action.m_name=='[newAnswer]':
            #     opNewAnswer(sbj,obj,action,actions,port)
            # elif action.m_name=='[回答]' or action.m_name=='[answer]':
            #     opAnswer(sbj,obj,actions,port)
            #elif action.m_name=='[导入模块]' or action.m_name=='[importModule]':
            #    opImportModule(obj)
            #elif action.m_name=='[导入函数]' or action.m_name=='[importFunction]':
            #    opImportFunction(sbj,obj)
            #elif action.m_name=='[导入变量]' or action.m_name=='[importVar]':
            #    opImportVar(obj)
            #elif action.m_name=='[导入代码]' or action.m_name=='[loadCode]':
            #    opLoadCode(obj)
            #elif action.m_name=='[运行函数]' or action.m_name=='[runFunction]':
            #    opRunFunction(obj)
            #elif action.m_name=='[传递变量]' or action.m_name=='[transfer]':
            #    opTransfer(sbj,obj,action)
            #elif action.m_name=='[传递列表]' or action.m_name=='[transferList]':
            #    opTransferList(sbj,obj,action)
            #elif action.m_name=='[记录变量]' or action.m_name=='[recordVar]':
            #    opRecordVar(sbj,obj)
            # elif action.m_name=='[复制]' or action.m_name=='[copy]':
            #     opCopy(obj,action)

            # Stock
            elif action.m_name=='[推入]' or action.m_name=='[push]':
                opPush(sbj,obj,port)
            elif action.m_name=='[弹出]' or action.m_name=='[pop]':
                opPop(sbj,obj)
            elif action.m_name=='[置底]' or action.m_name=='[bottom]':
                opBottom(sbj,obj)
            elif action.m_name=='[置顶]' or action.m_name=='[top]':
                opTop(sbj,obj)
            elif action.m_name=='[倒序]' or action.m_name=='[flip]':
                opFlip(obj)
            
            # python
            elif action.m_name=='[pythonStart]':
                opPythonStart(obj)
            elif action.m_name=='[python]':
                opPython(sbj,obj,action)
            # structure
            # elif action.m_name=='[structureStart]':
            #     opStructureStart(obj)
            elif action.m_name=='[结构语言]' or action.m_name=='[structure]':
                opStructure(sbj,obj,action)
            # elif action.m_name=='[python]':
            #     if sbj==None or sbj.m_var==None:
            #         opPythonOld(sbj,obj,action)
            #     else:
            #         opPython(sbj,obj,action)
            # elif action.m_name=='[pythonQuit]':
            #     opPythonQuit(obj)

            # matlab
            elif action.m_name=='[matlabStart]':
                opMatlabStart(obj)
            # elif action.m_name=='[matlabPath]':
            #     opMatlabPath(sbj,obj,action)
            elif action.m_name=='[matlab]':
                opMatlab(sbj,obj,action)
            elif action.m_name=='[matlabQuit]':
                opMatlabQuit(obj)
            # game
            # elif action.m_name=='[gameStart]':
            #     opGameStart(obj)
            # parsers
            elif action.m_name=='[公式]' or action.m_name=='[formula]':
                opFormula(sbj,obj,action,port)
            elif action.m_name=='[显示算式]' or action.m_name=='[printEqn]':
                opPrintEqn(obj)
            # Table
            elif action.m_name=='[导入表格]' or action.m_name=='[importTable]':
                opImportTable(obj,action,port)
            # time
            elif action.m_name=='[今天]' or action.m_name=='[today]':
                opToday(action)
            # autoCode
            elif action.m_name=='[生成原型]' or action.m_name=='[newWord]':
                opNewWord(sbj,obj,action)
            # fileOperate
            elif action.m_name=='[读文件]' or action.m_name=='[readFile]':
                opReadFile(sbj,obj)
            elif action.m_name=='[写文件]' or action.m_name=='[writeFile]':
                opWriteFile(sbj,obj,action)
            # web
            elif action.m_name=='[网页]' or action.m_name=='[displayWeb]':
                opDisplayWeb(sbj,obj)
            # cmd
            elif action.m_name=='[命令行]' or action.m_name=='[runCmd]':
                opRunCmd(obj,action)
            elif action.m_name=='[目录列表]' or action.m_name=='[listDir]':
                opListDir(sbj,obj,action)
            elif action.m_name=='[进入目录]' or action.m_name=='[chDir]':
                opChDir(obj,action)
            elif action.m_name=='[当前目录]' or action.m_name=='[getCwd]':
                opGetCwd(action)
            # diag
            elif action.m_name=='[设置结构]' or action.m_name=='[setStruct]':
                opSetStruct(obj)
            # star graph
            elif action.m_name=='[总结]' or action.m_name=='summary':
                opSummary(obj,action)
            # tmp
            # elif action.m_name=='[显示LaTeX]' or action.m_name=='[displayLaTeX]':
            #     opDisplayLaTeX(sbj,obj)
            # elif action.m_name=='[显示页面]' or action.m_name=='[displayBrowser]':
            #     opDisplayBrowser(sbj,obj)
            elif action.m_name=='[截屏]' or action.m_name=='[screenShot]':
                opScreenShot(sbj,obj,action)
            elif action.m_name=='[节点数]' or action.m_name=='[len]':
                opLen(obj,action)
            elif action.m_name=='[临时文本]':
                pass
            
            elif action.m_name=='[显示设备]' or action.m_name=='[printDev]':
                opPrintDev(obj)
            elif action.m_name=='[显示权限]' or action.m_name=='[printPer]':
                opPrintPer(obj)
            elif action.m_name=='[重载模块]' or action.m_name=='[reloadModule]':
                opReloadModule(action)
            elif action.m_name=='[创建树心]' or action.m_name=='[treeCore]':
                opTreeCore(obj)
            elif action.m_name=='[消息窗口]' or action.m_name=='[messageBox]':
                opMessageBox(obj,action)
            else:
                # action.print()
                results=port.transfer(action,limit=True)
                # actions+=actions_new
        # (不能删, 要靠+[.]来输入变量)
        if action.m_creator==None:
            action.con(None,None)
            tools_basic.setPointByFormat(port.m_history,'list.append',action)
        # action.con(None,None)
        # tools_basic.setPointByFormat(port.m_history,'list.append',action)


# Old new action. Almost never be used.
# def newAction(sbj,obj):
#     if obj==None:
#         return
#     obj.m_name='['+sbj.m_name+']'
#     obj.m_text=sbj.m_text

def opNewAction(sbj,obj,action,port):
    if sbj==None or obj==None:
        return
    if sbj.m_text=='':
        return
    name=obj.m_name
    creator=obj.m_creator
    needed=obj.m_needed

    obj.m_name='['+obj.m_name+']'
    obj.m_creator=action.m_creator
    obj.m_needed=action.m_needed
    port.transfer(obj,limit=True,form="自定义",pt_ref=sbj)

    obj.m_name=name
    obj.m_creator=creator
    obj.m_needed=needed


def opDo(action,port):
    newAct=None
    con_de=None
    for con in action.m_con:
        if con.m_name=='code' or con.m_name=='[code]':
            if con.m_db[0]==action and con.m_db[1]!=None:
                newAct=con.m_db[1]
                con_de=con
                break
    opDelete(con_de)
    if newAct!=None:
        action.m_name='['+newAct.m_name+']'
        action.m_text=newAct.m_text
    elif action.m_text=='':
        return
    port.transfer(action,limit=True,form="自定义",pt_ref=newAct)


def opDelete(obj):
    if obj==None:
        return
    if obj.m_permission<=1:
        print("Action denied! Try to delete system point:",obj.info())
        return
    cons=obj.m_con.copy()
    for con in cons:
        # if con.m_name=='.[i]' or con.m_name=='的':
        if con.m_name=='的':
            # con.disconnect_i(0)
            # con.delete()
            con.m_permission=4
            opDelete(con)
    obj.delete()
    if obj.m_var!=None:
        try:
            obj.m_var.quit()
        except:
            pass
        obj.m_var=None
    del obj

def opClearHistory(port):
    if port==None:
        return
    try:
        history=port.m_history
        list_pt=tools_basic.getPointByFormat(history,'list')
        for pt in list_pt:
            pt.con(None,None)
            for con in pt.m_con:
                opDelete(con)
    except Exception as e:
        logging.exception(e)

def opPush(sbj,obj,port):
    if obj==None or sbj==None or obj in GLOBAL.LIST_DEV:
        return
    for con in sbj.m_con:
        if con.m_name=='的' and con.m_db[0]==sbj and con.m_db[1]==obj:
            return
    pt=NetP('的').con(sbj,obj)
    port.input([pt])

def opPop(sbj,obj):
    if obj==None or sbj==None:
        return
    list_pt=[]
    for con in sbj.m_con:
        if con.m_name=='的' and con.m_db[0]==sbj and con.m_db[1]==obj:
            list_pt.append(con)
    for pt in list_pt:
        pt.m_permission=4
        opDelete(pt)

def opBottom(sbj,obj):
    if sbj==None or obj==None:
        return
    for con in sbj.m_con:
        if con==obj:
            sbj.m_con.remove(obj)
            sbj.m_con.insert(0,obj)
            return

def opTop(sbj,obj):
    if sbj==None or obj==None:
        return
    for con in sbj.m_con:
        if con==obj:
            sbj.m_con.remove(obj)
            sbj.m_con.append(obj)
            return

def opFlip(obj):
    if obj==None:
        return
    obj.m_con.reverse()
    return

def opConnect(sbj,obj,i):
    if sbj==None or sbj.m_permission==0:
        return
    sbj.disconnect_i(i)
    sbj.connect(obj,i)

def opName(sbj,action):
    if sbj==None:
        return
    action.m_text=sbj.m_name

def opWriteName(sbj,obj,action):
    if obj==None or obj.m_permission<=1:
        return
    if sbj==None and action.m_text=='':
        return
    elif action.m_text=='':
        name=sbj.m_name
    elif sbj==None:
        name=action.m_text
    else:
        pat=action.m_text
        con=sbj.m_name
        try:
            name=pat%(con)
        except:
            name=pat+con

    if name[0]=='[' and name[-1]==']':
        name=name[1:-1]

    if isTitle(name):
        obj.m_name=name
    else:
        print("Error! Invalid name pattern. (name: %s)"%(name))



def isTitle(name):
    if name=='':
        return False
    title=r'^[\w \[\]~#.+=\-^/*\\!<\']*|^\[>=?\]'
    t_name=re.match(title,name).group()
    return t_name==name

def opWriteText(sbj,obj,action):
    if obj==None:
        return
    elif obj.m_permission==0:
        obj.print()
    if sbj==None and action.m_text=='':
        return
    elif action.m_text=='':
        text=sbj.m_text
    elif sbj==None:
        text=action.m_text
    else:
        pat=action.m_text
        con=sbj.m_text
        if "%s" not in pat:
            text=pat+con
        else:
            text=pat.replace("%s",con)
#         try:
#             text=pat%(con)
#         except:
#             text=pat+con
    obj.m_text=text

def opAddToText(sbj,obj,action,type_add=0):
    if obj==None:
        return
    elif obj.m_permission==0:
        obj.print()
    if sbj==None and action.m_text=='':
        return
    elif action.m_text=='':
        text=sbj.m_text
    elif sbj==None:
        text=action.m_text
    else:
        pat=action.m_text
        con=sbj.m_text
        if "%s" not in pat:
            text=pat+con
        else:
            text=pat.replace("%s",con)
#         try:
#             text=pat%(con)
#         except:
#             text=pat+con
    if type_add==0:
        obj.m_text+=text
    else:
        obj.m_text=text+obj.m_text

def opCopyText(obj):
    if obj==None:
        return
    clipboard.copy(obj.m_text)
    
def opPasteText(obj):
    if obj==None:
        return
    obj.m_text=clipboard.paste()

def opMove(sbj,obj):
    if sbj==None or obj==None:
        return
    sbj.m_pos=obj.m_pos.copy()

def posPoint(sbj,pt_self,direction):
    if sbj==None:
        return
    pt_self.m_pos=sbj.m_pos.copy()
    if direction==0:
        pt_self.m_pos[1]-=1
    elif direction==1:
        pt_self.m_pos[1]+=1
    elif direction==2:
        pt_self.m_pos[0]-=1
    else:
        pt_self.m_pos[0]+=1

def printPoint(obj,action):
    if obj==None and action.m_text=='':
        return
    elif action.m_text=='':
        obj.print()
    elif obj==None:
        print(action.m_text)
    else:
        pat=action.m_text
        con=obj.info()
        try:
            text=pat%(con)
        except:
            text=pat+con
        print(text)

def opAllCons(obj,action):
    if obj==None:
        return
    text_left=''
    text_right=''
    for con in obj.m_con:
        if con.m_db[0]==obj:
            text_left+=con.m_name+', '
        if con.m_db[1]==obj:
            text_right+=con.m_name+', '
    text='右关联: {0}\n左关联: {1}'.format(text_left,text_right)
    print(text)
    action.m_text=text


def opOpen(obj,action):
    if action.m_text=='' and obj==None:
        return
    elif obj!=None:
        file_name=obj.m_text
    else:
        file_name=action.m_text
    try:
        if tools_basic.checkPtsRelation(action,'property','[网页]') or tools_basic.checkPtsRelation(action,'property','[url]'):
            command='start Chrome '+file_name
            os.system(command)
            # print(command)
        else:
            os.system('start "" '+file_name)
    except:
        return

def opImport(sbj,obj,action):
    if sbj==None or obj==None:
        return
    try:
        text=tools_basic.readFile(sbj.m_text)
        if tools_basic.checkPtsRelation(action,'property','[内景]'):
            if obj.m_db[1]!=None:
                print('The enter point shouldn\'t connect to any point!')
                return
            list_pt=tools_basic.buildPoints_tokener(text)
            tools_basic.printPtList(list_pt)
            if len(list_pt)>2:
                obj.con(0,list_pt[1])
        else:
            obj.m_text=text
    except:
        print('Import failed!')

def opImportPts_1(obj,action,port):
    if obj==None:
        return
    if tools_basic.checkPtsRelation(action,'property','[运行]'):
        running=True
        print('Will run actions in',obj.info())
    else:
        running=False
    try:
        text=tools_basic.readFile(obj.m_text)
        list_pt=tools_basic.buildPoints_tokener(text)
        pos0=list_pt[0].m_pos.copy()
        list_new=[]
        list_de=[]
        for pt in list_pt:
            # print(pt.info())
            if len(pt.m_name)>1 and pt.m_name[0]=='[' and pt.m_name[-1]==']':
                if running==True:
                    pt.m_needed=1
                    # print(pt.info())
            list_new.append(pt)
            pt.m_pos[0]+=obj.m_pos[0]-pos0[0]+1
            pt.m_pos[1]+=obj.m_pos[1]-pos0[1]+1
            list_de.append(NetP('的').con(obj,pt))
        # for the verb [return to index]/[返回目录]. It will return to the first connection of de.
        list_new+=list_de
        if not tools_basic.checkPtsRelation(action,'property','[只读]'):
            port.input(list_new,keepPos=True)
    except:
        print('Import points failed!')

def opImportPts(sbj,obj,action):
    if obj==None:
        return
    if sbj!=None:
        text=sbj.m_text
    else:
        text=action.m_text
    
    start_pt=None
    list_left=[]
    list_right=[]
    for con in action.m_con:
        if con.m_name=='起点' and con.m_db[0]==action and con.m_db[1]!=None:
            start_pt=con.m_db[1]

    try:
        list_pt=tools_basic.buildPoints_tokener(text)
        if start_pt!=None and len(list_pt)>1:
            for con in list_pt[0].m_con:
                if con.m_db[0]==list_pt[0]:
                    list_left.append(con)
                if con.m_db[1]==list_pt[0]:
                    list_right.append(con)
            for pt_con in list_left:
                pt_con.con(start_pt,0)
            for pt_con in list_right:
                pt_con.con(0,start_pt)
            start_pt.con(list_pt[0].m_db[0],list_pt[0].m_db[1])
            start_pt.m_name=list_pt[0].m_name
            start_pt.m_text=list_pt[0].m_text
            list_pt[0].con(None,None)
            list_pt.pop(0)
        for pt in list_pt:
            NetP('的').con(obj,pt)
    except Exception as e:
        logging.exception(e)
        return


def opExportPts(obj,action):
    if obj==None or obj.m_text=='':
        return
    else:
        fileName=obj.m_text
    cover=False
    list_pt=[]
    for con in action.m_con:
        if con.m_name=='[的]' and con.m_db[0]==action and con.m_db[1]!=None:
            list_pt.append(con.m_db[1])
        elif con.m_name=='[覆盖]' and con.m_db[0]==action:
            cover=True
        elif con.m_name=='[list]' and con.m_db[0]==action:
            pt_list=con.m_db[1]
            list_pt+=tools_basic.getPointByFormat(pt_list,'list')
    if fileName[-5:]=='.ftxt':
        text=tools_basic.genFCode(list_pt)
    else:
        text=tools_basic.writeStdCode([],list_pt)
    tools_basic.writeFile(obj.m_text,text,cover)

def opDesktop(action):
    action.m_text='C:\\Users\\cheng\\Desktop'


def opGeneratreKm(sbj,obj,action):
    symbol=tools_basic.getPoint(obj,'的',None,1)
    if symbol==None:
        symbol=NetP('[]')
    km=Karma(symbol)
    obj.m_var=km

    if sbj==None:
        cause=None
    else:
        cause=sbj.m_var
    km.m_cause=cause

    type_km=tools_basic.ptToDict(obj)
    type_verb=tools_basic.ptToDict(action)
    if '没有' in type_km:
        km.m_no=True
    if '非' in type_km:
        changePtType(symbol,'否定')
    if '新建' in type_km:
        km.m_buildMode=True
    if '引用' in type_km:
        changePtType(symbol,'引用')
    if '从句且' in type_km:
        km.m_clauseAnd=True
    if '从句或' in type_km:
        km.m_clauseAnd=False
    if '真且' in type_km:
        km.m_yesAnd=True
    if '伪且' in type_km:
        km.m_noAnd=True
    if  '真或' in type_km:
        km.m_yesAnd=False
    if '伪或' in type_km:
        km.m_noAnd=False

    if cause==None:
        return
    elif '从句' in type_verb:
        cause.m_clause.append(km)
    elif '否则' in type_verb:
        cause.m_noe.append(km)
    else:
        cause.m_yese.append(km)
    
def opKarmaStr(sbj,obj):
    km=sbj.m_var
    if km==None:
        print('没有找到因果链')
    else:
        print('新的因果链:',km.causeEnd().info_karma())
        obj.m_text=km.info_karma()


def opPrintKarma(obj):
    km=obj.m_var
    if km==None:
        print('没有找到因果链')
    else:
        print(km.causeEnd().info_karma())

    

def changePtType(point,type_pt):
    if type_pt=='否定':
        if len(point.m_name)>=1 and point.m_name[0]=='~':
            point.m_name=point.m_name[1:]
        else:
            point.m_name='~'+point.m_name
    elif type_pt=='引用':
        if len(point.m_name)>1 and point.m_name[0]=='[' and point.m_name[-1]==']':
            return
        point.m_name='['+point.m_name+']'
    


def opMathOperator(operator,output):
    if operator==None:
        return
    if operator.m_name=='+':
        try:
            num1=float(operator.m_db[0].m_text)
            num2=float(operator.m_db[1].m_text)
        except:
            return
        num0=num1+num2
    elif operator.m_name=='-':
        try:
            if operator.m_db[0]==None:
                num1=0
            else:
                num1=float(operator.m_db[0].m_text)
            num2=float(operator.m_db[1].m_text)
        except:
            return
        num0=num1-num2
    elif operator.m_name=='/':
        try:
            num1=float(operator.m_db[0].m_text)
            num2=float(operator.m_db[1].m_text)
        except:
            return
        try:
            num0=num1/num2
        except:
            num0='inf'
    elif operator.m_name=='*':
        try:
            num1=float(operator.m_db[0].m_text)
            num2=float(operator.m_db[1].m_text)
        except:
            return
        num0=num1*num2
    elif operator.m_name=='^':
        try:
            num1=float(operator.m_db[0].m_text)
            num2=float(operator.m_db[1].m_text)
        except:
            return
        num0=num1**num2
    elif operator.m_name=='=':
        try:
            if output==None:
                output=operator.m_db[0]
            if operator.m_db[0]==output:
                num1=float(operator.m_db[1].m_text)
            else:
                num1=float(operator.m_db[0].m_text)
        except:
            return
        num0=num1
    else:
        return
    if output==None:
        operator.m_text=str(num0)
    else:
        output.m_text=str(num0)
    

def opMathFunction(f_math,output):
    if f_math==None:
        return
    pt_var=tools_basic.getPoint(f_math,'的',None,1)
    try:
        num1=float(pt_var.m_text)
        num0=getattr(math,f_math.m_name)(num1)
    except:
        return
    if output==None:
        f_math.m_text=str(num0)
    else:
        output.m_text=str(num0)
"""
def opStrOperator(operator,output):
    if operator==None:
        return
    if operator.m_name=='+':
        text0=operator.m_db[0].m_text+operator.m_db[1].m_text

    if output==None:
        operator.m_text=text0
    else:
        output.m_text=text0
""" 
def opStrTakeChar(ptr,output,action):
    if ptr==None:
        return
    pt_str=ptr.m_db[0]
    try:
        i=int(ptr.m_text)
        char0=pt_str.m_text[i]
    except:
        return
    
    if output==None:
        action.m_text=char0
    else:
        output.m_text=char0

def opStrTakeSpan(ptr,output,action):
    if ptr==None:
        return
    pt_str=ptr.m_db[0]
    ptr_end=ptr.m_db[1]
    try:
        j=int(ptr_end.m_text)
    except:
        j=None
    try:
        i=int(ptr.m_text)
        if j==None:
            span=pt_str.m_text[i:]
        else:
            span=pt_str.m_text[i:j]
    except:
        print('Invalid span token!')
        return

    if output==None:
        action.m_text=span
    else:
        output.m_text=span

def opStrCutDown(ptr,output,action):
    if ptr==None:
        return
    pt_str=ptr.m_db[0]
    try:
        i=int(ptr.m_text)
        str1=pt_str.m_text[0:i]
        str2=pt_str.m_text[i:]
    except:
        print("Invalid string cut down!")
        return
    
    pt_str.m_text=str1
    if output==None:
        action.m_text=str2
    else:
        output.m_text=str2

def opStrFindForward(ptr,output,action):
    if ptr==None:
        return
    pt_sub=tools_basic.getPoint(action,'[搜索字段]',None,1)
    if pt_sub==None:
        return
    try:
        pt_str,i,j=getPtr(ptr)
        i0=pt_str.m_text.rfind(pt_sub.m_text,0,i)
        if i0==-1:
            j0=-1
        else:
            j0=i0+len(pt_sub.m_text)
    except:
        return

    if output==None:
        setPtr(ptr,i0,j0)
    else:
        setPtr(output,i0,j0)


def opStrFindBackward(ptr,output,action):
    if ptr==None:
        return
    pt_sub=tools_basic.getPoint(action,'[搜索字段]',None,1)
    if pt_sub==None:
        return
    try:
        pt_str,i,j=getPtr(ptr)
        if j==None:
            j=i
        i0=pt_str.m_text.find(pt_sub.m_text,j)
        if i0==-1:
            j0=0
            i0=0
        else:
            j0=i0+len(pt_sub.m_text)
    except:
        return

    if output==None:
        setPtr(ptr,i0,j0)
    else:
        setPtr(output,i0,j0)

def setPtr(ptr,i0,i1):
    if i1!=None and ptr.m_db[1]!=None:
        ptr_end=ptr.m_db[1]
        ptr_end.con(ptr.m_db[0],0)
        ptr_end.m_text=str(i1)
    ptr.m_text=str(i0)

def getPtr(ptr):
    pt_str=ptr.m_db[0]
    pt_end=ptr.m_db[1]
    if pt_str==None:
        print('Invaild pointer type! No string point is found.')
        raise Exception()
    try:
        i=int(ptr.m_text)
    except:
        print('Invalid pointer type! The m_text of a ptr point must be a int.')
        raise Exception()
    try:
        j=int(pt_end.m_text)
    except:
        j=None
    return [pt_str,i,j]



# Question operations:
def opRandom(obj):
    if obj==None:
        return
    obj.m_text=str(random.random())

def opSubQuestion(sbj,obj,actions,port):
    if obj==None:
        print('Error! This action must have an object.')
        return
    pt_Q=obj.m_db[0]
    pt_A=obj.m_db[1]
    if pt_A==None or pt_Q==None:
        print('Error! The object must be obj(问题,答案).')
        return
    try:
        list_km=tools_basic.readSubCode_tokener(pt_Q.m_text)
        kmQ=list_km[0]
        list_km=tools_basic.readSubCode_tokener(pt_A.m_text)
        kmA=list_km[0]
    except:
        print('Error! Invalid question or answer.')
        return
    list_effects=kmA.allEffects()
    for effect in list_effects:
        effect.m_no=False
    list_effects[-1].m_yese.append(kmQ)
    kmQ.m_cause=list_effects[-1]

    if sbj==None:
        kmQ.m_no=False
    elif sbj.m_name=='[正]':
        kmQ.m_no=False
        createPointFromAction(sbj,'正',actions,port)
    else:
        kmQ.m_no=True
        sbj.m_name='反'
        createPointFromAction(sbj,'反',actions,port)
    obj.m_text=tools_basic.karmaToStr(kmA)
    createPointFromAction(obj,obj.m_name[1:-1],actions,port)


def opNewAnswer(sbj,obj,action,actions,port):
    if sbj==None or obj==None:
        return
    oldA=obj.m_db[1]
    list_pt=tools_basic.getPointByFormat(sbj,'list')
    if list_pt==[]:
        print('Warning! The list is empty!')
        return
    if oldA!=None:
        try:
            karmas=tools_basic.readSubCode_tokener(oldA.m_text)
            list_effects=karmas[0].allEffects()
            list_ni=[]
            for km in list_effects:
                if km.m_no==True:
                    km.m_no=False
                    list_ni.append(list_effects.index(km))
        except:
            print('Error! Compiling code isn\'t successful')
            return
        result=tools_basic.runKarma(karmas[0],list_pt)
        if result=='dark yellow':
            print('Warning! Last answer isn\'t correct!')
            return
        dict_map={}
        for km in list_effects:
            dict_map.update({km.m_map:km})
            
        list_bound=[]
        for pt in list_pt:
            if pt not in dict_map:
                list_bound.append(pt)
        list_next=[]
        for pt in list_bound:
            if pt.m_db[0] in dict_map or pt.m_db[1] in dict_map:
                list_next.append(pt)
        for pt in dict_map:
            if pt.m_db[0] in list_bound:
                list_next.append(pt.m_db[0])
            if pt.m_db[1] in list_bound:
                list_next.append(pt.m_db[1])
        if list_next==[]:
            return
        else:
            pt_next=list_next[random.randrange(0,len(list_next))]

        pt_new=NetP('').copy(pt_next)
        for pt in dict_map:
            if pt.m_db[0]==pt_next:
                dict_map[pt].m_symbol.con(pt_new,0)
            if pt.m_db[1]==pt_next:
                dict_map[pt].m_symbol.con(0,pt_new)
            if pt_next.m_db[0]==pt:
                pt_new.con(dict_map[pt].m_symbol,0)
            if pt.m_db[0]==pt_next:
                pt_new.con(0,dict_map[pt].m_symbol)

        for ni in list_ni:
            list_effects[ni].m_no=True
        km_new=Karma(pt_new)
        km_new.m_cause=list_effects[-1]
        list_effects[-1].m_yese.append(km_new)
        for con in action.m_con:
            if con.m_name=='[no]' or con.m_name=='[无]':
                km_new.m_no=True
                break
        obj.m_text=tools_basic.karmaToStr(karmas[0])
        # obj.m_text=karmas[0].info_karma(type_info=1)
    else:
        pt_next=list_pt[random.randrange(0,len(list_pt))]
        pt_new=pt_next.copy()
        km_new=Karma(pt_new)
        for con in action.m_con:
            if con.m_name=='[no]' or con.m_name=='[无]':
                km_new.m_no=True
                break
        obj.m_text=tools_basic.karmaToStr(km_new)
        # obj.m_text=km_new.info_karma(type_info=1)
    if obj in actions:
        createPointFromAction(obj,obj.m_name[1:-1],actions,port)


def opAnswer(sbj,obj,actions,port):
    if sbj==None or obj==None or obj.m_db[1]==None:
        return
    qt_Q=obj.m_db[1]
    list_pt=tools_basic.getPointByFormat(sbj,'list')
    if list_pt==[]:
        return
    results,karmas=tools_basic.runCode(qt_Q.m_text,list_pt)
    if results==[]:
        return
    if results[0]=='dark green':
        result='True'
    else:
        result='False'
    obj.m_name=result
    createPointFromAction(obj,result,actions,port)


def createPointFromAction(point,name,actions,port):
    if point not in actions:
        return
    actions.remove(point)
    point.m_needed=None
    point.m_name=name
    port.input([point])


# def opCopy(obj,action=None):
#     if obj!=None:
#         list_pt=tools_basic.getPointByFormat(obj,'list')
#         if list_pt==[]:
#             list_pt=[obj]
#     else:
#         list_pt=[]
#         for con in action.m_con:
#             if con.m_name=='[的]' and con.m_db[0]==action and con.m_db[1]!=None:
#                 list_pt.append(con.m_db[1])
#     if list_pt==[]:
#         return
#     else:
#         try:
#             str_pt=tools_basic.writeStdCode([],list_pt)
#             clipboard.copy(str_pt)
#         except:
#             return


# function operations:
def opImportModule(obj):
    try:
        obj.m_var=__import__(obj.m_text)
    except:
        print('Error! Importing module failed!')

# def opImportFunction(sbj,obj):
#     try:
#         if sbj!=None:
#             obj.m_var=getattr(sbj.m_var,obj.m_text)
#         else:
#             obj.m_var=getattr(builtins,obj.m_text)
#     except:
#         print("Error! Importing functions failed!")

def opImportVar(obj):
    try:
        if obj.m_name=='[bool]' or obj.m_name=='bool':
            obj.m_var=bool(obj.m_text)
        elif obj.m_name=='[int]' or obj.m_name=='int':
            obj.m_var=int(obj.m_text)
        elif obj.m_name=='[float]' or obj.m_name=='float':
            obj.m_var=float(obj.m_text)
        elif obj.m_name=='[vector]' or obj.m_name=='vector':
            obj.m_var=tools_format.str2Vec(obj.m_text)
        else:
            obj.m_var=obj.m_text
    except:
        print('Error! Transfering m_text to m_var failed!')

def opRunFunction(obj):
    if obj==None:
        return
    try:
        if obj.m_db[0]!=None and obj.m_db[1]!=None:
            obj.m_db[1].m_var=obj.m_var(obj.m_db[0].m_var)
        elif obj.m_db[0]!=None:
            obj.m_var(obj.m_db[0].m_var)
        elif obj.m_db[1]!=None:
            obj.m_db[1].m_var=obj.m_var()
        else:
            obj.m_var()
    except:
        print("Error! Running function failed!")


def opLoadCode(obj):
    obj.m_var=codeBlock(obj.m_text)


def codeBlock(code):
    try:
        var={}
        exec(code,{},var)
        return var['result']
    except Exception as e:
        logging.exception(e)
    return None


#new version of function operations:
def opRunCode(sbj,obj,action):
    if sbj==None or sbj.m_dev==None:
        print("Error! [运行代码]的动作中, 没有检测到 编译器")
        return
    else:
        compiler=sbj.m_dev
    if obj==None and action.m_text=="":
        print("Error! [运行代码]的动作中, 没有检测到 代码")
        return
    if obj.m_text!='':
        code=obj.m_text
    else:
        code=action.m_text
    pt_port=None
    pt_result=None
    limit=False
    pt_ptr=None
    for con in action.m_con:
        if con.m_name=='[端口]' and con.m_db[0]==action and con.m_db[1]!=None:
            pt_port=con.m_db[1]
        elif con.m_name=='[结果]' and con.m_db[0]==action and con.m_db[1]!=None:
            pt_result=con.m_db[1]
        elif con.m_name=='[范围]' and con.m_db[0]==action and con.m_db[1]!=None:
            limit=True
            pt_ptr=con.m_db[1]
            # list_pt=tools_basic.getPointByFormat(con.m_db[1],'list')
            # if con.m_db[1] not in list_pt:
            #     list_pt=[con.m_db[1]]+list_pt
    try:
        result=compiler.runCode_shell(code,IO=pt_port,limit=limit,pt_ptr=pt_ptr)
        print("[运行代码]:",result)
        if pt_result!=None:
            pt_result.m_text=str(result)
    except Exception as e:
        logging.exception(e)

def opKm2Pt(sbj,obj,action):
    str_code=''
    if obj==None:
        return
    elif sbj==None and action.m_text=='':
        return
    elif sbj!=None:
        str_code=sbj.m_text
    else:
        str_code=action.m_text
        
    try:
        list_km=tools_basic.readSubCode_tokener(str_code)
    except Exception as e:
        logging.exception(e)
        return

    list_pt=[]
    for km in list_km:
        tools_basic.karma2Pts(km,list_pt)
    for pt in list_pt:
        NetP('的').con(obj,pt)


# """
# def opTransfer(sbj,obj,action):
#     if obj==None or sbj==None:
#         return
#     for con in action.m_con:
#         if con.m_name=="[m_text]":
#             obj.m_var=sbj.m_text
#             return
#     obj.m_var=sbj.m_var
    
# def opTransferList(sbj,obj,action):
#     if obj==None or sbj==None:
#         return
#     list_out=[]
#     type_text=False
#     for con in action.m_con:
#         if con.m_name=="[m_text]":
#             type_text=True
#             break
#     for con in sbj.m_con:
#         if con.m_name=='的' and con.m_db[0]==sbj and con.m_db[1]!=None:
#             if type_text:
#                 list_out.append(con.m_db[1].m_text)
#             else:
#                 list_out.append(con.m_db[1].m_var)
#     obj.m_var=list_out



# def opRecordVar(sbj,obj):
#     if obj==None:
#         return
#     if sbj==None:
#         sbj=obj
#     try:
#         obj.m_text=str(sbj.m_var)
#         return
#     except:
#         try:
#             obj.m_text=tools_format.vec2Str(sbj.m_var)
#             return
#         except:
#             print("Error! The obj.m_var is neither a single variable nor a list of nums. Can't convert it into string.")
# """

# def opPythonOld(sbj,obj,action):
#     pt_code=sbj
#     output=obj
#     if pt_code!=None:
#         code=pt_code.m_text
#     elif action.m_text!='':
#         code=genPythonCode(action.m_text)
#     else:
#         return
#     if output==None:
#         output=action
#     args=[]
#     out_pt=[]
#     for con in action.m_con:
#         if (con.m_name=='.' or con.m_name=='[.]') and con.m_db[0]==action:
#             if con.m_db[1]!=None:
#                 args.append(con.m_db[1].m_text)
#             else:
#                 args.append(con.m_text)
#         elif (con.m_name=='.m_name' or con.m_name=='[.m_name]') and con.m_db[0]==action and con.m_db[1]!=None:
#             args.append(con.m_db[1].m_name)
#         elif (con.m_name=='o' or con.m_name=='[o]') and con.m_db[0]==action and con.m_db[1]!=None:
#             out_pt.append(con.m_db[1])
#     fun=tools_basic.codeBlock(code)
#     state=False
#     # print("args:",args)
#     try:
#         state,fout=fun(*args)
#     except Exception as e:
#         print("Error! Something wrong when running the code!")
#         logging.exception(e)
#         state=False
#         print("The function must end with \"return state,text\".")
#         return
#     if state==True:
#         if isinstance(fout,str):
#             output.m_text=fout
#         elif isinstance(fout,list):
#             for i in range(len(fout)):
#                 if i>=len(out_pt):
#                     print('Warning! Function return more vars(%d) than receiving pts(%d)'%len(fout),len(out_pt))
#                     break
#                 elif not isinstance(fout[i],str):
#                     print('Warning! Only str/list_str return can be received. Check your python program.')
#                     print('RETURN FORMAT: return True,string/[strings]')
#                 out_pt[i].m_text=fout[i]
#         else:
#             print('Warning! Only str/list_str return can be received. Check your python program.')
#             print('RETURN FORMAT: return True,string/[strings]')


# def genPythonCode(funName):
#     i=funName.rfind('.')
#     fileDir=funName[0:i]
#     functionName=funName[i+1:]
#     code='from pt_python import '+fileDir+\
#             '\nresult='+funName
#     # code='result='+funName
#     return code

# Python:
def opPythonStart(obj):
    if obj==None:
        return
    if obj.m_var==None:
        obj.m_var={}

def opPython(sbj,obj,action):
    if sbj!=None:
        if sbj.m_var==None:
            sbj.m_var={}
        elif not isinstance(sbj.m_var,dict):
            return
        eng=sbj.m_var
    else:
        return
    code=action.m_text
    vars_in={}
    vars_out={}
    if action.m_db[1]!=None:
        vars_out.update({'ans':['o',action.m_db[1]]})
    for con in action.m_con:
        # print('?????',con.info())
        if con.m_db[0]==action and con.m_db[1]!=None:
            if  con.m_name=='[code]':
                code=con.m_db[1].m_text
            # 把这个逐渐淘汰掉吧。。。对名字的判断尽量放在结构语言本身的规则中好了
            # elif con.m_name=='[.m_name]':
            #     vars_in.update({con.m_text:con.m_db[1].m_name})
            elif con.m_name=='[o]':
                if con.m_text!='':
                    var=con.m_text
                else:
                    var=con.m_db[1].m_name
                vars_in.update({var:['o',con.m_db[1]]})
                vars_out.update({var:['o',con.m_db[1]]})
            elif con.m_name=='[.]':
                if con.m_text!='':
                    var=con.m_text
                else:
                    var=con.m_db[1].m_name
                vars_in.update({var:['.',con.m_db[1]]})
            elif con.m_name=='[s]':
                if con.m_text!='':
                    var=con.m_text
                else:
                    var=con.m_db[1].m_name
                vars_in.update({var:['s',con.m_db[1]]})
            elif con.m_name=='[v]':
                if con.m_text!='':
                    var=con.m_text
                else:
                    var=con.m_db[1].m_name
                vars_in.update({var:['v',con.m_db[1]]})
                vars_out.update({var:['v',con.m_db[1]]})
    # print('开始执行P代码')
    try:
        pythonCode(eng,code,vars_in,vars_out)
    except Exception as e:
        logging.exception(e)

def opPythonQuit(obj):
    if obj==None:
        return
    elif not isinstance(obj.m_var,dict):
        return
    else:
        obj.m_var.clear()
        obj.m_var=None

# def pythonCode(eng,code,vars_in,vars_out,show_mode=False):
#     for var in vars_in:
#         type_var=vars_in[var][0]
#         pt_var=vars_in[var][1]
#         if pt_var.m_var!=None:
#             vars_in[var]=pt_var.m_var
#         elif type_var=='s':
#             str_var=pt_var.m_text
#             if show_mode:
#                 print(var+'(str):',str_var)
#             vars_in[var]=str_var
#         else:
#             str_var=pt_var.m_text
#             value=tools_format.str2Mat(str_var)
#             if show_mode:
#                 print(var+':',str_var,value,len(value),np.size(value))
#             if np.size(value)!=0:
#                 vars_in[var]=value
#             else:
#                 vars_in[var]=str_var
#     eng.update(vars_in)
#     tools_basic.pythonCodeEval(eng,code)
#     for var in vars_out:
#         value=eng.get(var,'')
#         if show_mode:
#             print('Output variable('+var+') type:',type(value))
#         if isinstance(value,str):
#             vars_out[var].m_text=value
#         elif isinstance(value,list) or isinstance(value,np.ndarray) or isinstance(value,int)\
#          or isinstance(value,float) or isinstance(value,complex):
#             # value=np.array(value)
#             str_var=tools_format.mat2Str(value)
#             vars_out[var].m_text=str_var
#         else:
#             vars_out[var].m_var=value
#     return vars_out

def pythonCode(eng,code,vars_in,vars_out,show_mode=False):
    i=0
    for var in vars_in:
        i=i+1
        type_var=vars_in[var][0]
        pt_var=vars_in[var][1]
        if pt_var.m_var!=None:
            vars_in[var]=pt_var.m_var
        elif type_var=='v':
            vars_in[var]=pt_var.m_var
        elif type_var=='s':
            vars_in[var]=pt_var.m_text
        else:
            str_var=pt_var.m_text
            value=tools_format.str2Vec(str_var)
            # print(value,str_var,pt_var.info())
            # print(444,vars_in)
            if value==[]:
                vars_in[var]=str_var
            else:
                vars_in[var]=value
    eng.update(vars_in)
    try:
        # print('20211128诡异的bug',code)
        tools_basic.pythonCodeEval(eng,code)
        # print(12)
    except Exception() as e:
        logging.exception(e)
        return vars_out
    for var in vars_out:
        type_var=vars_out[var][0]
        pt_var=vars_out[var][1]
        value=eng.get(var,'')
        if type_var=='v':
            pt_var.m_var=value
        else:
            pt_var.m_text=tools_format.vec2Str(value)
    return vars_out

# tools:
def keepAction(action):
    action.m_name=action.m_name[1:-1]
    action.m_needed=None
    action.m_creator=NetP('act')

def replacePt(pt0,pt_remove):
    list_con=pt_remove.m_con
    for con in list_con:
        if con.m_db[0]==pt_remove:
            con.con(pt0,0)
        if con.m_db[1]==pt_remove:
            con.con(0,pt0)

# Matlab:
def opMatlabStart(obj):
    if obj==None:
        return
    if obj.m_var==None:
        obj.m_var=mtb.start_matlab()

def opMatlabPath(sbj,obj,action):
    if not isinstance(sbj.m_var,mtb.MatlabEngine):
        return
    if obj!=None:
        path=obj.m_text
    elif action.m_text!='':
        path=action.m_text
    else:
        return
    try:
        if tools_basic.checkPtsRelation(action,'property','all'):
            sbj.m_var.eval('addpath(genpath('+path+'))')
        else:
            sbj.m_var.eval('addpath('+path+')')
    except Exception as e:
        logging.exception(e)

def opMatlab(sbj,obj,action):
    if sbj!=None:
        if not isinstance(sbj.m_var,mtb.MatlabEngine):
            sbj.m_var=mtb.start_matlab()
        eng=sbj.m_var
    else:
        return
    code=action.m_text
    vars_in={}
    vars_out={}
    for con in action.m_con:
        if con.m_db[0]==action and con.m_db[1]!=None:
            # if  con.m_name=='[code]':
            #     code=con.m_db[1].m_text
            # elif con.m_name=='[.]':
            #     vars_in.update({con.m_text:con.m_db[1].m_text})
            # elif con.m_name=='[o]':
            #     vars_out.update({con.m_text:con.m_db[1]})
            if  con.m_name=='[code]':
                code=con.m_db[1].m_text
            elif con.m_name=='[o]':
                if con.m_text!='':
                    var=con.m_text
                else:
                    var=con.m_db[1].m_name
                vars_in.update({var:['o',con.m_db[1]]})
                vars_out.update({var:['o',con.m_db[1]]})
            elif con.m_name=='[.]':
                if con.m_text!='':
                    var=con.m_text
                else:
                    var=con.m_db[1].m_name
                vars_in.update({var:['.',con.m_db[1]]})
            elif con.m_name=='[s]':
                if con.m_text!='':
                    var=con.m_text
                else:
                    var=con.m_db[1].m_name
                vars_in.update({var:['s',con.m_db[1]]})
            # elif con.m_name=='[.]':
            #     if con.m_text!='':
            #         var=con.m_text
            #     else:
            #         var=con.m_db[1].m_name
            #     vars_in.update({var:con.m_db[1]})
            # elif con.m_name=='[o]':
            #     if con.m_text!='':
            #         var=con.m_text
            #     else:
            #         var=con.m_db[1].m_name
            #     vars_in.update({var:con.m_db[1]})
            #     vars_out.update({var:con.m_db[1]})
    if obj!=None:
        vars_in.update({'ans':['o',obj]})
        vars_out.update({'ans':['o',obj]})
    try:
        matlabCode(eng,code,vars_in,vars_out)
    except Exception as e:
        logging.exception(e)


            





def opMatlabQuit(obj):
    if obj==None:
        return
    elif not isinstance(obj.m_var,mtb.MatlabEngine):
        return
    else:
        obj.m_var.quit()
        obj.m_var=None

def translateString(str_var):
    # string=str_var
    if str_var.find('\n')==-1:
        string="\""+str_var+"\";"
    else:
        string="{\""+str_var.replace('\n','","')+"\"};"
    return string


def matlabCode(eng,code,vars_in,vars_out):
    for var in vars_in:
        type_var=vars_in[var][0]
        pt_var=vars_in[var][1]
        # if pt_var.m_var!=None:
        #     vars_in[var]=pt_var.m_var
        if type_var=='s':
            str_var=translateString(pt_var.m_text)
        else:
            str_var=pt_var.m_text
            value=tools_format.str2Mat(str_var)
            if np.size(value)!=0:
                str_var='['+str_var+'];'
            else:
                str_var=translateString(str_var)
        try:
            eng.workspace[var]=eng.eval(str_var)
        except:
            eng.workspace[var]=eng.eval('[];')
    eng.eval(code,nargout=0)

    for var in vars_out:
        type_var=vars_out[var][0]
        pt_var=vars_out[var][1]
        value=eng.workspace[var]
        print('Output variable('+var+') type:',type(value))
        if isinstance(value,str):
            pt_var.m_text=value
        # elif value.__class__.__doc__=='MATLAB object':
        #     vars_out[var].m_var=NetP('MATLAB object')
        #     vars_out[var].m_var.m_dev=value
        else:
            try:
                value=np.array(value)
                str_var=tools_format.mat2Str(value)
                pt_var.m_text=str_var
            except:
                print('Error! Fail to set output value!')
    return vars_out



def opStructure(sbj,obj,action):
    if sbj==None or sbj.m_dev==None:
        return
    eng=sbj.m_dev
    code=action.m_text
    vars_pt={}
    pt_IO=None
    for con in action.m_con:
        if con.m_db[0]==action and con.m_db[1]!=None:
            if  con.m_name=='[code]':
                code=con.m_db[1].m_text
            elif  con.m_name=='[范围]':
                if con.m_db[1].m_dev!=None:
                    pt_IO=con.m_db[1]
            elif con.m_name=='[o]':
                if con.m_text!='':
                    var=con.m_text
                else:
                    var=con.m_db[1].m_name
                vars_pt.update({var:['o',con.m_db[1]]})
            elif con.m_name=='[.]':
                if con.m_text!='':
                    var=con.m_text
                else:
                    var=con.m_db[1].m_name
                vars_pt.update({var:['.',con.m_db[1]]})
    try:
        results=structureCode(eng,code,vars_pt,obj,pt_IO)
        print(results)
    except Exception as e:
        logging.exception(e)


def structureCode(eng,code,vars_pt,pt_ptr,pt_IO=None):
    pt_names={}
    pt_ptr_ex=True
    if pt_ptr!=None:
        pt_names.update({pt_ptr:pt_ptr.m_name})
        pt_ptr.m_name='自己'
        list_pt=tools_basic.getPointByFormat(pt_ptr,'set')
        if pt_ptr not in list_pt:
            list_pt.append(pt_ptr)
    else:
        pt_ptr_ex=False
        pt_ptr=NetP('自己')
        list_pt=[pt_ptr]
    for var in vars_pt:
#        type_var=vars_pt[var][0]
        pt_var=vars_pt[var][1]
        if pt_var not in list_pt:
            list_pt.insert(0,pt_var)
            pt_names.update({pt_var:pt_var.m_name})
            pt_var.m_name=var
        else:
            print('Warning! The new variable "%s" has existed as "%s". Input failed! '%(var,pt_var.m_name))

    results=eng.runCode_shell_structure(code,list_pt,pt_ptr,pt_IO)
    
    for pt in pt_names:
        pt.m_name=pt_names[pt]
    if not pt_ptr_ex:
        opDelete(pt_ptr)
    return results





# game:
def opGameStart(obj):
    pass
    """
    if obj==None:
        return
    if obj.m_dev==None:
        game=Game(obj)
    elif isinstance(obj.m_dev,Game):
        game=obj.m_dev
    else:
        print("????")
        return
    try:
        game.initialize(obj)
        game.game_start()
    except Exception as e:
        logging.exception(e)
        """


# parsers:
def opPrintEqn(obj):
    if obj==None:
        return
    str_eqn=tools_parsers.struct2Eqn(obj)
    # print(str_eqn)

def opFormula(sbj,obj,action,port):
    if sbj!=None and sbj.m_text!='':
        text=sbj.m_text
    elif action.m_text!='':
        text=action.m_text
    else:
        return
    try:
        list_pt=tools_parsers.eqn2struct(text)
        if obj!=None:
            list_new=[]
            for pt in list_pt:
                if pt.m_name!='的':
                    list_new.append(NetP('的').con(obj,pt))
            list_pt+=list_new
        list_pt.reverse()
        replacePt(list_pt[-1],action)
        port.input(list_pt)
    except Exception as e:
        logging.exception(e)

def opSetStruct(obj):
    if obj==None:
        return
    list_pt=tools_basic.getPointByFormat(obj,'list')
    dialog=InputDialog(list_pt)
    if dialog.exec():
        dialog.getInputs()

# Display formula!
def opDisplayLaTeX(sbj,obj):
    if obj==None or sbj==None or sbj.m_name!='web':
        return
    text_formula=obj.m_text
    pageSource = """
             <html><head>
             <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-AMS-MML_HTMLorMML">                     
             </script></head>
             <body>
             <p><mathjax style="font-size:2.3em">"""+text_formula+"""</mathjax></p>
             </body></html>
             """
    webView=sbj.m_dev
    webView.setHtml(pageSource)
    webView.show()

def opDisplayBrowser(sbj,obj):
    if sbj==None or sbj.m_name!='web':
        return
    if obj!=None:
        sbj.m_text+=obj.m_text
    text_formula=sbj.m_text
    pageSource = """
             <html><head>
             <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-AMS-MML_HTMLorMML">                     
             </script></head>
             <body>
             <p><mathjax style="font-size:2.3em">"""+text_formula+"""</mathjax></p>
             </body></html>
             """
    webView=sbj.m_dev
    webView.setHtml(pageSource)
    webView.show()

# Web
def opDisplayWeb(sbj,obj):
    if sbj==None or sbj.m_dev==None:
        return
    try:
        pageSource=obj.m_text
        webView=sbj.m_dev
        webView.setHtml(pageSource)
        webView.show()
    except Exception() as e:
        logging.exception(e)

# cmd
def opRunCmd(obj,action):
    if obj==None and action.m_text=='':
        return
    elif obj!=None and obj.m_text!='':
        command=obj.m_text
    else:
        command=action.m_text
    try:
        os.system(command)
    except Exception() as e:
        logging.exception(e)
    
def opListDir(sbj,obj,action):
    try:
        if sbj==None and \
            action.m_text=='':
            list_file=os.listdir()
        elif sbj!=None and sbj.m_text!='':
            list_file=os.listdir(sbj.m_text)
        else:
            list_file=os.listdir(action.m_text)
        str_files=':...\n'.join(list_file)
    except Exception as e:
        logging.exception(e)
        return
    if obj!=None:
        obj.m_text+=str_files
    else:
        action.m_text=str_files
    
def opChDir(obj,action):
    try:
        if obj==None and action.m_text=='':
            return
        elif obj!=None and obj.m_text!='':
            os.chdir(obj.m_text)
        else:
            os.chdir(action.m_text)
    except Exception as e:
        logging.exception(e)
    
def opGetCwd(action):
    action.m_text=os.getcwd()
    
    
    

# Table
def opImportTable(obj,action,port):
    pass
    # if obj==None:
    #     if action.m_text=='':
    #         return
    #     else:
    #         address=action.m_text
    # else:
    #     address=obj.m_text
    # table=pd.read_excel(address)
    # list_pt=tools_format.tab2Pt(table,obj)
    # list_pt.reverse()
    # port.input(list_pt)

# date
def opToday(action):
    now=datetime.now()
    str_today=now.strftime("%Y%m%d")
    action.m_name=str_today
    action.m_text=str_today

def opNewWord(sbj,obj,action):
    if sbj==None or obj==None:
        return
    list_pt=[]
    list_name=[]
    i=0
    for con in sbj.m_con:
        if (con.m_name=='的' or con.m_name=='.[i]') and con.m_db[0]==sbj and con.m_db[1]!=None:
            pt=con.m_db[1]
            list_pt.append(pt)
            list_name.append(pt.m_name)
            modifyName(pt,action)
            pt.m_name=pt.m_name+'#'+str(i)
            i+=1
    code=''
    n=0
    # code="+%s"%(sbj.m_name)
    for pt in list_pt:
        if len(pt.m_name)>=6 and pt.m_name[0:6]=="[临时文本]":
            code+=pt.m_text
            continue
        if n==0:
            code+='%s'%(pt.info('不显示位置'))
            n+=1
        elif len(pt.m_text)>4:
            if code[-1]!="\n":
                code+='...'
            code+='\n\n\n...............................................\n'
            code+='->%s'%(pt.info('不显示位置'))
            code+='...\n...............................................\n\n\n'
        else:
            code+='->%s'%(pt.info('不显示位置'))
    for i in range(len(list_pt)):
        pt=list_pt[i]
        pt.m_name=list_name[i]
    # code+="=>[那](,_)=>+的(+%s,_)"%(sbj.m_name)
    # print(code)
    obj.m_text=code

def modifyName(pt,action):
    build=True
    refer=False
    general=False
    for con in pt.m_con:
        if con.m_db[0]==action and con.m_db[1]==pt:
            if con.m_name=='新建' or con.m_name=='[新建]':
                build=True
            elif con.m_name=='匹配' or con.m_name=='[匹配]':
                build=False
            elif con.m_name=='通用' or con.m_name=='[通用]':
                general=True
            elif con.m_name=='引用' or con.m_name=='[引用]':
                refer=True
    if general:
        pt.m_name='_'+pt.m_name
    else:
        if refer:
            pt.m_name='['+pt.m_name+']'
        if build:
            pt.m_name='+'+pt.m_name

# star graph:
def opSummary(obj,action):
    if obj==None:
        return
    list_pt=tools_basic.getPointByFormat(obj,'list')
    pair1=[]
    pair2=[]
    names=[]
    texts=[]
    dict_i={}
    for i in range(len(list_pt)):
        dict_i.update({list_pt[i]:i})
    for i in range(len(list_pt)):
        pt=list_pt[i]
        names.append(pt.m_name)
        texts.append(pt.m_text)
        if pt.m_db[0]!=None:
            i1=dict_i.get(pt.m_db[0])
            if i1!=None:
                pair1.append(i)
                pair1.append(i1)
        if pt.m_db[1]!=None:
            i2=dict_i.get(pt.m_db[1])
            if i2!=None:
                pair2.append(i)
                pair2.append(i2)

    for con in action.m_con:
        if (con.m_name=='的' or con.m_name=='[的]') and con.m_db[0]==action and con.m_db[1]!=None:
            if con.m_db[1].m_name=="左关联" or con.m_db[1].m_name=="[左关联]":
                con.m_db[1].m_text=tools_format.vec2Str(pair1)
                # con.m_db[1].m_text=str(pair1)
            elif con.m_db[1].m_name=="右关联" or con.m_db[1].m_name=="[右关联]":
                con.m_db[1].m_text=tools_format.vec2Str(pair2)
                # con.m_db[1].m_text=str(pair2)
            elif con.m_db[1].m_name=="名字" or con.m_db[1].m_name=="[名字]":
                con.m_db[1].m_text=names2Str(names)
            elif con.m_db[1].m_name=="内容" or con.m_db[1].m_name=="[内容]":
                con.m_db[1].m_text=names2Str(texts)
                

def names2Str(names):
    return '{' + ", ".join('\''+name.replace('\'','\'\'')+'\'' for name in names) + '}'


# file operations:
def opReadFile(sbj,obj):
    if sbj==None or obj==None:
        return
    fileName=sbj.m_text
    try:
        # f=open(fileName,'r')
        # obj.m_text=f.read()
        # f.close()
        text=tools_basic.readFile(fileName)
        obj.m_text=text
    except Exception as e:
        logging.exception(e)
        
def opWriteFile(sbj,obj,action):
    if sbj==None:
        return
    if obj==None:
        text=action.m_text
    else:
        text=obj.m_text
    fileName=sbj.m_text
    tools_basic.writeFile(fileName,text)
    # try:
    #     f=open(fileName,'w+')
    #     f.write(sbj.m_text)
    #     f.close()
    # except Exception as e:
    #     logging.exception(e)


def opScreenShot(sbj,obj,action):
    if obj==None:
        path=action.m_text
    else:
        path=obj.m_text
    area=None
    try:
        if sbj!=None and sbj.m_dev!=None:
            dev=sbj.m_dev
            geom=dev.geometry()
            area=[geom.x(),geom.y(),geom.width(),geom.height()]
        if area==None:
            screen=pyautogui.screenshot()
        else:
            screen=pyautogui.screenshot(region=area)
        screen.save(path)
    except:
        print("Screen shot is unsuccessful!")

def opLen(obj,action):
    if obj==None:
        return
    list_pt=tools_basic.getPointByFormat(obj,'list')
    action.m_text=str(len(list_pt))

def opPrintDev(obj):
    print("DEV:",obj.m_dev)
    
def opPrintPer(obj):
    print("Permission:",obj.m_permission)

def opReloadModule(action):
    if action.m_text=='':
        return
    name=action.m_text
    if name=='树心':
        importlib.reload(life_TreeCore)
        print('树心 重载成功! ')


def opTreeCore(obj):
    if obj==None:
        return
    TreeCore=life_TreeCore.TreeCore
    if obj.m_dev!=None:
        if  isinstance(obj.m_dev,TreeCore):
            print('%s.m_dev has been defined as a tree core. It will be re-defined now. '%(obj.m_name))
        else:
            print('Warning! %s.m_dev has been defined as other instances! '%(obj.m_name))
    tree=TreeCore(obj)
    obj.m_dev=tree
    print(tree)


def opMessageBox(obj,action):
    if obj==None and action.m_text=='':
        return
    elif action.m_text=='':
        name=obj.m_name
        text=obj.m_text
    elif obj==None:
        name="消息"
        text=action.m_text
    else:
        pat=action.m_text
        con=obj.m_text
        try:
            text=pat%(con)
        except:
            text=pat+con
        name=obj.m_name
#    ctypes.windll.user32.MessageBoxW(0,text,name,1)
    qtMsgBox(name,text)

def qtMsgBox(name,text):
    msg=QtWidgets.QMessageBox()
    msg.setStandardButtons(QtWidgets.QMessageBox.Ok|QtWidgets.QMessageBox.Cancel)
    msg.setText(text)
    msg.setWindowTitle(name)
    msg.exec_()


if __name__=='__main__':
    now=datetime.now()
    print(now.strftime("%Y%m%d"))

    print(names2Str(['1','2','3']))

