import sys, re
from datetime import datetime
if __name__=='__main__':
    sys.path.append(sys.path[0]+'/..')
from body.bone import NetP
from body.soul import Karma
from body.body_compiler import Compiler
from body.body_lib import Library
from body.body_port import Port
from body.body_viewer import Viewer
from body.body_draw import Draw
from body.body_debugger import Debugger
from body.body_textEditor import Editor
from body import GLOBAL
from tools import tools_basic, tools_format
from PyQt5.QtWidgets import QApplication
from PyQt5.QtWebEngineWidgets import QWebEngineView
import logging


import numpy as np

class Kernel:
    def __init__(self,point=None):
        self.m_self=None

        self.m_lib=None
        self.m_compiler=None
        self.m_event=None

        self.m_files=None
        self.m_devs=None

        self.m_memory=None
        self.m_date=None
        self.m_python=None

        self.initialize(point)

    def initialize(self,point):
        if point==None:
            point=NetP('kernel')
        self.m_self=point
        point.m_dev=self
        point.m_permission=0

        list_pt=GLOBAL.LIST_PT
        self.m_lib=tools_basic.getVarFromPt(point,'m_lib',list_pt)
        self.m_compiler=tools_basic.getVarFromPt(point,'m_compiler',list_pt)
        self.m_event=tools_basic.getVarFromPt(point,'m_event',list_pt)

        self.m_files=tools_basic.getVarFromPt(point,'m_files',list_pt)
        self.m_devs=tools_basic.getVarFromPt(point,'m_devs',list_pt)

        self.m_memory=tools_basic.getVarFromPt(point,'m_memory',list_pt)
        self.m_date=tools_basic.getVarFromPt(point,'m_date')
        if self.m_memory.m_db[1]==None:
            self.m_memory.con(0,NetP("记忆"))
        memory=self.m_memory.m_db[1]
        GLOBAL.LIST_DEV.append(memory)

        now=datetime.now()
        str_today=now.strftime("%Y%m%d")
        self.m_date.con(0,NetP(str_today,str_today))

        if self.m_compiler.m_db[1]==None:
            self.startupSetting()


        if self.m_compiler.m_db[1]==None:
            self.m_compiler.con(0,NetP('compiler'))
        pt_compiler=self.m_compiler.m_db[1]
        Compiler(pt_compiler)
        GLOBAL.LIST_DEV.append(pt_compiler)
        # tools_basic.setPointByFormat(memory,'list.append',pt_compiler)

        if self.m_lib.m_db[1]==None:
            self.m_lib.con(0,NetP('library'))
        pt_lib=self.m_lib.m_db[1]
        Library(pt_lib)
        # tools_basic.setPointByFormat(memory,'list.append',pt_lib)

        if self.m_event.m_db[1]==None:
            self.m_event.con(0,NetP('event'))
        pt_event=self.m_event.m_db[1]
        Library(pt_event)

        list_file=tools_basic.getPointByFormat(self.m_files.m_db[1],'list')
        for pt_file in list_file:
            self.opOpenFile(pt_file)

        list_dev=tools_basic.getPointByFormat(self.m_devs.m_db[1],'list')
        for dev in list_dev:
            # tools_basic.setPointByFormat(memory,'list.append',dev)
            if labeled(dev,'port'):
                Port(dev)
            elif labeled(dev,'editor'):
                Editor(dev)
            elif labeled(dev,'viewer'):
                Viewer(dev)
            elif labeled(dev,'compiler'):
                Compiler(dev)
            elif labeled(dev,'library'):
                Library(dev)
            elif dev.m_name=='web':
                dev.m_dev=QWebEngineView()
                GLOBAL.LIST_DEV.append(dev)
            elif dev.m_name=='Matlab':
                GLOBAL.LIST_DEV.append(dev)
            elif dev.m_name=='Python':
                dev.m_var={'np':np, 'tools_format':tools_format}
                GLOBAL.LIST_DEV.append(dev)
                self.m_python=dev
                
        



    def startupSetting(self):
        if self.m_compiler.m_db[1]==None:
            pt_compiler=NetP('compiler')
            self.m_compiler.con(0,pt_compiler)
        if self.m_lib.m_db[1]==None:
            pt_lib=NetP('library')
            self.m_lib.con(0,pt_lib)

        if self.m_files.m_db[1]==None:
            pt_files=NetP('files')
            self.m_files.con(0,pt_files)
        if self.m_devs.m_db[1]==None:
            pt_devs=NetP('devs')
            self.m_devs.con(0,pt_devs)
        # +的(pt_lib,+m_compiler)->+m_compiler(,pt_compiler)
        m_compiler=NetP("m_compiler").con(0,pt_compiler)
        NetP("的").con(pt_lib,m_compiler)
        # +的(pt_files,+pt_cache)
        pt_cache=NetP("cache","缓存.txt")
        NetP("的").con(pt_files,pt_cache)
        # +的(pt_devs,+pt_Matlab)
        pt_Matlab=NetP("Matlab")
        NetP("的").con(pt_devs,pt_Matlab)
        # +的(pt_devs,+pt_Python)
        pt_Python=NetP("Python")
        NetP("的").con(pt_devs,pt_Python)
        # +的(pt_devs,+pt_port)->+port(,+pt_port)->+的(+pt_port,+m_pool)->+的(+pt_port,+m_lib)->+m_pool(,pt_cache)->+m_lib(,pt_lib)
        pt_port=NetP("port")
        NetP("的").con(pt_devs,pt_port)
        NetP("port").con(0,pt_port)
        m_pool=NetP("m_pool").con(0,pt_cache)
        m_lib=NetP("m_lib").con(0,pt_lib)
        NetP("的").con(pt_port,m_pool)
        NetP("的").con(pt_port,m_lib)
        # +的(pt_devs,+pt_viewer)->+viewer(,+pt_viewer)->+的(+pt_viewer,+m_detect)->+m_detect(,pt_port)
        pt_viewer=NetP("viewer")
        NetP("的").con(pt_devs,pt_viewer)
        NetP("viewer").con(0,pt_viewer)
        m_detect=NetP("m_detect").con(0,pt_port)
        NetP("的").con(pt_viewer,m_detect)
        # +的(pt_devs,+pt_editor)->+editor(,+pt_editor)...
        # ->+的(+pt_editor,+m_port)->+的(+pt_editor,+m_compiler)...
        # ->+m_port(,pt_port)->+m_compiler(,pt_compiler)
        pt_editor=NetP("editor").con(pt_cache,0)
        NetP("的").con(pt_devs,pt_editor)
        NetP("editor").con(0,pt_editor)
        m_port=NetP("m_port").con(0,pt_port)
        NetP("的").con(pt_editor,m_port)
        m_compiler=NetP("m_compiler").con(0,pt_compiler)
        NetP("的").con(pt_editor,m_compiler)
        # +的(pt_files,+pt_verb)->+的(pt_lib,+m_terms)->+m_terms(,pt_verb)
        pt_verb=NetP("动词","动词.txt")
        m_terms=NetP("m_terms").con(0,pt_verb)
        NetP("的").con(pt_lib,m_terms)
        NetP("的").con(pt_files,pt_verb)
        # +的(pt_files,+pt_noun)->+的(pt_compiler,+m_terms)->+m_terms(,pt_noun)
        pt_noun=NetP("名词","名词.txt")
        m_terms=NetP("m_terms").con(0,pt_noun)
        NetP("的").con(pt_compiler,m_terms)
        NetP("的").con(pt_files,pt_noun)


    def opOpenFile(self,obj):
        if obj==None:
            return
        pt_files=self.m_files.m_db[1]
        print("打开:",obj.m_text)
        try:
            text=tools_basic.readFile(obj.m_text)
        except Exception as e:
            logging.exception(e)
            print('Error! File wasn\'t read successfully!')
            text=""
        print("内容已读")
        try:
            print("开始解码...")
            if obj.m_text[-5:]!='.ftxt':
                try:
                    print("快速构造开始...")
                    list_pt=tools_basic.buildPoints_quick(text)
                except Exception as e:
                    print("快速构造失败")
                    logging.exception(e)
                    print("切换为一般构造...")
                    list_pt=tools_basic.buildPoints_tokener(text)
                print("解码完成!")
                # pos0=list_pt[0].m_pos.copy()
            else:
                list_pt=tools_basic.loadFCode(text)
            for pt in list_pt:
                NetP('的').con(obj,pt)
            print(obj.m_text,"的节点数:",len(list_pt))
        except Exception as e:
            print('Import points failed!')
            logging.exception(e)

    def saveText(self,obj):
        list_pt=tools_basic.getPointByFormat(obj,'list')
        return tools_basic.writeStdCode([],list_pt)
        
    def operate(self,action):
        result=False
        obj=action.m_db[1]
        if action.m_name=='[读取文件]' or action.m_name=='[openFile]':
            self.opOpenFile(obj)
            result=True
        elif action.m_name=='[新建端口]' or action.m_name=='[newPort]':
            self.opNewPort(obj,action)
            result=True
        elif action.m_name=='[新建编辑器]' or action.m_name=='[newEditor]':
            self.opNewEditor(obj,action)
            result=True
        elif action.m_name=='[新建显示器]' or action.m_name=='[newViewer]':
            self.opNewViewer(obj,action)
            result=True
        elif action.m_name=='[新建画图]' or action.m_name=='[newDraw]':
            self.opNewDraw(obj,action)
            result=True
        return result,[]

    def opNewPort(self,obj,action):
        if obj==None or obj.m_dev!=None:
            return
        pt_file=None
        for con in action.m_con:
            if con.m_name=="[文件]" and con.m_db[0]==action and con.m_db[1]!=None:
                pt_file=con.m_db[1]
                break
        if pt_file==None:
            return
        pt_lib=self.m_lib.m_db[1]
        obj.m_permission=0
        NetP('port').con(0,obj)
        m_lib=NetP('m_lib').con(0,pt_lib)
        m_pool=NetP('m_pool').con(0,pt_file)
        NetP('的').con(obj,m_lib)
        NetP('的').con(obj,m_pool)
        pt_devs=self.m_devs.m_db[1]
        NetP('的').con(pt_devs,obj)
        Port(obj)

    def opNewEditor(self,obj,action):
        if obj==None or obj.m_dev!=None:
            return
        pt_port=None
        for con in action.m_con:
            if con.m_name=="[端口]" and con.m_db[0]==action and con.m_db[1]!=None:
                pt_port=con.m_db[1]
                break
        if pt_port==None:
            return
        obj.m_permission=0
        pt_com=self.m_compiler.m_db[1]
        pt_event=self.m_event.m_db[1]
        NetP('editor').con(0,obj)
        m_compiler=NetP('m_compiler').con(0,pt_com)
        m_port=NetP('m_port').con(0,pt_port)
        m_event=NetP('m_event').con(0,pt_event)
        NetP('的').con(obj,m_compiler)
        NetP('的').con(obj,m_port)
        NetP('的').con(obj,m_event)
        pt_devs=self.m_devs.m_db[1]
        NetP('的').con(pt_devs,obj)
        Editor(obj)

    def opNewViewer(self,obj,action):
        if obj==None or obj.m_dev!=None:
            return
        pt_port=None
        for con in action.m_con:
            if con.m_name=="[端口]" and con.m_db[0]==action and con.m_db[1]!=None:
                pt_port=con.m_db[1]
                break
        if pt_port==None:
            return
        obj.m_permission=0
        pt_event=self.m_event.m_db[1]
        NetP('viewer').con(0,obj)
        m_port=NetP('m_detect').con(0,pt_port)
        m_event=NetP('m_event').con(0,pt_event)
        NetP('的').con(obj,m_port)
        NetP('的').con(obj,m_event)
        pt_devs=self.m_devs.m_db[1]
        NetP('的').con(pt_devs,obj)
        Viewer(obj)

    def opNewDraw(self,obj,action):
        if obj==None or obj.m_dev!=None:
            return
        pt_port=None
        pt_scene=None
        for con in action.m_con:
            if con.m_name=="[端口]" and con.m_db[0]==action and con.m_db[1]!=None:
                pt_port=con.m_db[1]
                # break
            elif con.m_name=="[场景]" and con.m_db[0]==action and con.m_db[1]!=None:
                pt_scene=con.m_db[1]
                # break
            if pt_scene!=None and pt_port!=None:
                break
        if pt_port==None:
            return
        obj.m_permission=0
        pt_event=self.m_event.m_db[1]
        NetP('draw').con(0,obj)
        m_port=NetP('m_port').con(0,pt_port)
        m_scene=NetP('m_scene').con(0,pt_scene)
        m_event=NetP('m_event').con(0,pt_event)
        NetP('的').con(obj,m_port)
        NetP('的').con(obj,m_scene)
        NetP('的').con(obj,m_event)
        pt_devs=self.m_devs.m_db[1]
        NetP('的').con(pt_devs,obj)
        Draw(obj,self.m_python)


def labeled(pt,name,db=0):
    for con in pt.m_con:
        if con.m_db[1]==pt and con.m_name==name:
            return True
    return False


if __name__=='__main__':
    app=QApplication(sys.argv)
    kernel=Kernel()
    sys.exit(app.exec_())
