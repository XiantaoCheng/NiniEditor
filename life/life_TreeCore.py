"""
+[返回目录](,life_TreeCore)
地址::life/life_TreeCore.py
+[保存文本](,life_TreeCore)

测试场景(P函数):...
+[新建阅读窗口](,测试场景)

"""

import sys
if __name__=='__main__':
    sys.path.append(sys.path[0]+'\\..')
from body.bone import NetP
from body.soul import Karma
from tools import tools_basic
import logging


class TreeCore():
    def __init__(self,point=None):
        super().__init__()
        self.m_self=point
        
        self.m_port=None
        self.m_compiler=None

        self.m_input=None
        self.m_terms=None
        self.m_search=None

        self.initialize(point)


    def initialize(self,point):
        if point==None:
            point=NetP('editor')
        self.m_self=point
        point.m_dev=self

        self.m_input=tools_basic.getVarFromPt(point,'m_input')
        self.m_terms=tools_basic.getVarFromPt(point,'m_terms')
        self.m_search=tools_basic.getVarFromPt(point,'m_search')

        self.m_port=tools_basic.getVarFromPt(point,'m_port')
        self.m_compiler=tools_basic.getVarFromPt(point,'m_compiler')


    def operate(self,action):
        result=False
        obj=action.m_db[1]
        if action.m_name=='[设置编译器]' or action.m_name=='[setCompiler]':
            self.opSetCompiler(obj)
            result=True
        elif action.m_name=='[设置端口]' or action.m_name=='[setPort]':
            self.opSetPort(obj)
            result=True
        elif action.m_name=='[输入]' or action.m_name=='[input]':
            self.opInput(obj)
            result=True
        return result,[]

    def opSetCompiler(self,obj):
        self.m_compiler.con(0,obj)

    def opSetPort(self,obj):
        self.m_port.con(0,obj)

    def opInput(self,obj):
        if obj==None:
            pt_input=self.m_input.m_db[1]
        else:
            pt_input=obj

        try:
            compiler=self.m_compiler.m_db[1].m_dev
            pt_port=self.m_port.m_db[1]
    
            pt_search=self.m_search.m_db[1]
    
            pt_terms=self.m_terms.m_db[1]
            list_terms=tools_basic.getPointByFormat(pt_terms,'list')
    
            con_de=NetP("的").con(pt_input,pt_search)
            for term in list_terms:
                con_de1=NetP("的").con(pt_input,term)
                result=compiler.runCode_shell(term.m_text,IO=pt_port,limit=True,pt_ptr=pt_input)
                con_de1.delete()
                print(term.m_name,result)
            print("搜索:",pt_search.m_text)
            con_de.delete()
    
        except Exception as e:
            logging.exception(e)





"""
+[保存文本](,life_TreeCore)
测试场景(P函数):...

"""