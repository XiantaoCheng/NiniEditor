import sys, re, time
if __name__=='__main__':
    sys.path.append(sys.path[0]+'\\..')
from body.bone import NetP
from body.soul import Karma
from body import GLOBAL
from tools import tools_basic
from body.body_compiler import Compiler
import logging

class Library:
    def __init__(self,point=None):
        self.m_self=None
        self.m_lib=[]
        self.m_terms=[]
        self.m_compiler=None

        self.m_running=None
        self.m_history=None

        self.initialize(point)

    def initialize(self,point):
        if point==None:
            point=NetP('library')
        self.m_self=point
        point.m_dev=self
        point.m_permission=0

        list_pt=GLOBAL.LIST_PT
        self.m_compiler=tools_basic.getVarFromPt(point,'m_compiler',list_pt)
        self.m_terms=tools_basic.getVarFromPt(point,'m_terms',list_pt)
        self.m_running=tools_basic.getVarFromPt(point,'m_running',list_pt)
        self.m_history=tools_basic.getVarFromPt(point,'m_history',list_pt)

        if self.m_terms.m_db[1]==None:
            self.m_terms.con(0,NetP('词条'))
        if self.m_compiler.m_db[1]==None:
            raise Exception('No compiler!')
        if self.m_running.m_db[1]==None:
            self.m_running.con(0,NetP("list"))
        if self.m_history.m_db[1]==None:
            self.m_history.con(0,NetP("list"))
        # self.m_terms.m_db[1].m_permission=1
        # self.m_compiler.m_db[1].m_permission=1

        # self.m_compiler=pt_compiler.m_dev
        # self.m_terms=tools_basic.getPointByFormat(pt_terms,'list')

        # print(self.info())

    def operate(self,action):
        obj=action.m_db[1]
        result=False
        if action.m_name=='[增加词库]' or action.m_name=='[addLib]':
            self.opAddLib(obj)
            result=True
        # if action.m_name=='[导入词条]' or action.m_name=='[opLoadTerm]':
        #     self.opLoadTerm(obj)
        #     result=True
        # elif action.m_name=='[清空词条]' or action.m_name=='[opClearTerm]':
        #     self.opClearTerm()
        #     result=True
        # elif action.m_name=='[删除词条]' or action.m_name=='[opDeleteTerm]':
        #     self.opDeleteTerm(obj)
        #     result=True
        # elif action.m_name=='[显示]' or action.m_name=='[print]':
        #     self.print()
        #     result=True
        return result,[]

    def opAddLib(self,obj):
        if obj==None:
            return
        pt_terms=self.m_terms.m_db[1]
        for con in pt_terms.m_con:
            if con.m_name=='和' and con.m_db[0]==pt_terms and con.m_db[1]==obj:
                return
        NetP('和').con(pt_terms,obj)

    # def updateCompiler(self):
    #     pt_compiler=tools_basic.getVarFromPt(self.m_self,'m_compiler','compiler')
    #     self.m_compiler=pt_compiler.m_dev

    def opLoadTerm(self,pt_code):
        if pt_code==None:
            return
        # code=pt_code.m_text
        # try:
        #     sents=tools_basic.divideSents_tokener(code)
        # except Exception as e:
        #     logging.exception(e)
        # if pt_code in self.m_terms:
        #     self.opDeleteTerm(pt_code)
        # self.m_terms.insert(0,pt_code)
        # pt_terms=tools_basic.getVarFromPt(self.m_self,'m_terms','list')
        pt_terms=self.m_terms.m_db[1]
        tools_basic.setPointByFormat(pt_terms,'list.insertHead',pt_code)


    def opClearTerm(self):
        pt_terms=self.m_terms.m_db[1]
        tools_basic.setPointByFormat(pt_terms,'list.clear')
        
    def opDeleteTerm(self,pt_term):
        if pt_term==None:
            return
        pt_terms=self.m_terms.m_db[1]
        try:
            tools_basic.setPointByFormat(pt_terms,'list.remove',pt_term)
        except:
            print("Make sure the term point is one in the list.\n",pt_term.info())

    def compile(self,code):
        list_km=[]
        try:
            list_km=tools_basic.readSubCode_tokener(code)
        except Exception as e:
            logging.exception(e)
        return list_km

    def getTerms(self):
        list_pt=[]
        pt_terms=self.m_terms.m_db[1]
        list_pt=tools_basic.getPointByFormat(pt_terms,'list')
        for con in pt_terms.m_con:
            if con.m_name=='和':
                if con.m_db[0]==pt_terms and con.m_db[1]!=None:
                    list_pt+=tools_basic.getPointByFormat(con.m_db[1],'list')
                elif con.m_db[1]==pt_terms and con.m_db[0]!=None:
                    list_pt+=tools_basic.getPointByFormat(con.m_db[0],'list')
        return list_pt


    def transfer(self,question,pt_port=None,limit=False,form=None,pt_ref=None):
        if question==None:
            return None
        compiler=self.m_compiler.m_db[1].m_dev
        terms=self.getTerms()
        # pt_terms=self.m_terms.m_db[1]
        # terms=tools_basic.getPointByFormat(pt_terms,'list')

        # print('请问怎么做'+question.m_name+'的动作?('+question.info(show_info="不显示位置不显示文本")+')')
        result=[]
        
        if pt_port==None:
            pt_port=tools_basic.getPoint(question,'[.端口]',None)

        t0=time.perf_counter()
        self.recordRunPt(question)

        if form=='自定义':
            # if pt_ref!=None:
            #     result=compiler.runCode(question.m_text,question,pt_port,limit=limit,list_pt=[pt_ref])
            # else:
            #     result=compiler.runCode(question.m_text,question,pt_port,limit=limit,list_pt=[])
            # # if question.m_creator!=None:
            # return result
            try:
                if pt_ref!=None:
                    list_sent=tools_basic.divideSents_tokener(pt_ref.m_text)
                else:
                    list_sent=tools_basic.divideSents_tokener(question.m_text)
            except:
                list_sent=[]
            for sent in list_sent:
                if pt_ref!=None:
                    # result=compiler.runCode(question.m_text,question,pt_port,limit=limit,list_pt=[pt_ref])
                    result=compiler.runCode(pt_ref.m_text,question,pt_port,limit=limit,list_pt=[pt_ref])
                else:
                    result=compiler.runCode(question.m_text,question,pt_port,limit=limit,list_pt=[])
                if question.m_creator==None:
                    continue
                else:
                    self.recordHisPt(question,time.perf_counter()-t0)
                    return result
            # if question.m_creator!=None:
            return result
        for term in terms:
            if question.m_name[1:-1]!=term.m_name:
                continue
            try:
                list_sent=tools_basic.divideSents_tokener(term.m_text)
            except:
                list_sent=[]
            for sent in list_sent:
                result=compiler.runCode(sent.m_text,question,pt_port,limit=True,list_pt=[term])
                if question.m_creator==None:
                    continue
                else:
                    self.recordHisPt(question,time.perf_counter()-t0)
                    return result
        # print("没有找到"+question.m_name+"的词条。。。")
        self.recordHisPt(question,time.perf_counter()-t0)
        return result

    def recordRunPt(self,pt):
        pt_r=self.m_running.m_db[1]
        tools_basic.setPointByFormat(pt_r,'list.append',pt)

    def recordHisPt(self,pt,t):
        pt_r=self.m_running.m_db[1]
        pt_h=self.m_history.m_db[1]
        tools_basic.setPointByFormat(pt_r,'list.remove',pt)
        tools_basic.setPointByFormat(pt_h,'list.append',pt)
        text="%.2f ms"%(t*1000)
        pt_time=NetP('用时',text)
        pt_time.con(None,pt)
        # print('Record verb:',pt.m_name, text)

    # def info(self):
    #     information='+++++++ LIBRARY ++++++\nName: '+self.m_self.m_name+'\nLibrary: \n'
    #     # for dirc in self.m_lib:
    #     #     information+=dirc+';\n'
    #     information+='Terms:\n'
    #     for term in self.m_terms:
    #         information+=term.m_name+' '
    #     return information
    
    # def print(self):
    #     print(self.info())

