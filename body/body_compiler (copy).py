"""
地址::body/body_compiler.py
+[保存文本](,body_compiler)

版本1.2.1:...

termBuiltin

"""

import sys, re, logging
from tracemalloc import start
if __name__=='__main__':
    sys.path.append(sys.path[0]+'\\..')
sys.path.append(sys.path[0]+'\\..')
from body.bone import NetP
from body.soul import Karma
from body import GLOBAL
from tools import tools_basic, tools_parsers, tools_format
import numpy as np
try:
    import matlab.engine as mtb
except:
    print('No matlab detected!')
import logging

class Compiler:
    def __init__(self,point=None):
        self.m_self=None
        self.m_source=None
        # self.m_lib=[]
        
        self.m_mapDict={}
        self.m_questions=[]
        self.m_karmas=[]
        self.m_running=[]

        self.m_formal=True

        self.m_source=None
        self.m_terms=[]
        # Limit the range list. For verbs.
        self.m_limit=False
        self.m_range=[]
        self.m_outputs=[]
        # Both of lists are listing tmp points generated in the process.
        self.m_tmpNew=[]
        self.m_answers=[]

        self.initialize(point)

    def initialize(self,point):
        if point==None:
            point=NetP('compiler')
        self.m_self=point
        point.m_dev=self
        point.m_permission=0

        list_pt=GLOBAL.LIST_PT
        self.m_source=tools_basic.getVarFromPt(point,'m_source',list_pt)
        self.m_terms=tools_basic.getVarFromPt(point,'m_terms',list_pt)

        if self.m_source.m_db[1]==None:
            self.m_source.con(0,NetP('空'))
        if self.m_terms.m_db[1]==None:
            self.m_terms.con(0,NetP('词条'))

        # if pt_source.m_dev!=None:
        # self.m_source=pt_source
        # self.m_terms=tools_basic.getVarFromPtByFormat(pt_terms,'list')
        
        # pt_terms.m_permission=0
        # for term in self.m_terms:
        #     term.m_permission=0

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
        # elif action.m_name=='[删除词条]' or action.m_name=='[opDelTerm]':
        #     self.opDelTerm(obj)
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


    def opSetSource(self,obj):
        if obj==None:
            return
        self.m_terms.con(0,obj)


    def getInputs(self):
        if self.m_formal==True:
            port=self.m_source.m_db[1].m_dev
            inputs=GLOBAL.LIST_DEV.copy()
            try:
                if self.m_limit==False:
                    inputs+=port.enters()
                elif self.m_range!=None:
                    inputs+=self.m_range
                    # inputs+=tools_basic.getPointByFormat(self.m_range,'list')
            except:
                print("Error! Compiler's source isn't a valid pool.")
                inputs=[]
        else:
            inputs=self.m_source
            print('Warning! Error may exist. Check compiler now.')
        return inputs

    def genPool(self,sent=None):
        if sent==None:
            return self.getInputs()
        else:
            return self.getInputs()+self.m_mapDict[sent]

    def reset(self):
        for sent in self.m_karmas:
            self.retrive(sent)
        self.clearTmpPts()

        self.m_mapDict.clear()
        self.m_karmas.clear()
        self.m_outputs.clear()
        self.m_running.clear()
        self.m_questions.clear()

    def loadCode(self,list_km):
        for karma in self.m_karmas:
            self.m_mapDict.pop(karma)
        self.m_karmas=list_km
        for karma in self.m_karmas:
            self.m_mapDict.update({karma:[]})

    # def loadLib(self,direct):
    #     if direct in self.m_lib:
    #         return
    #     try:
    #         f=open(direct,encoding='gbk')
    #     except:
    #         print(direct+" doesn't exist!")
    #         return
    #     try:
    #         code=f.read()
    #     except:
    #         f.close()
    #         f=open(direct,encoding='utf-8')
    #         code=f.read()
    #     self.opLoadTerm(code)
    #     self.m_lib.append(direct)

    def opLoadTerm(self,pt_code):
        if pt_code==None or pt_code.m_text=='':
            return
        # code=pt_code.m_text
        # try:
        #     sents=tools_basic.divideSents_tokener(code)
        # except Exception as e:
        #     logging.exception(e)
        # if pt_code in self.m_terms:
        #     self.opDelTerm(pt_code)
        # self.m_terms.insert(0,pt_code)
        # pt_terms=tools_basic.getVarFromPt(self.m_self,'m_terms','list')
        pt_terms=self.m_terms.m_db[1]
        tools_basic.setPointByFormat(pt_terms,'list.insertHead',pt_code)
        # pt_code.m_permission=0
    
    def opClearTerm(self):
        pt_terms=self.m_terms.m_db[1]
        tools_basic.setPointByFormat(pt_terms,'list.clear')

    def opDelTerm(self,pt_term):
        if pt_term==None:
            return
        
        try:
            pt_terms=self.m_terms.m_db[1]
            tools_basic.setPointByFormat(pt_terms,'list.remove',pt_term)
        except:
            print("Make sure the term point is one in the list.\n",pt_term.info())

    def compile(self,code):
        karmas=[]
        try:
            karmas=tools_basic.readSubCode_tokener(code)
            # print(karmas[0].info_karma())
        except Exception as e:
            logging.exception(e)
        return karmas


    def retrive(self,sent):
        list_map=self.m_mapDict.get(sent,[])
        # print("complier::retrive")
        # print(self.m_mapDict)
        for amap in list_map:
            if amap in self.m_tmpNew:
                self.m_tmpNew.remove(amap)
            if amap in self.m_outputs:
                self.m_outputs.remove(amap)
            amap.delete()
            del amap
        sent.map(None)
        if list_map!=[]:
            del list_map[:]
            list_map.clear()

    def runAll(self):
        for karma in self.m_mapDict:
            self.retrive(karma)
        results=[]
        for karma in self.m_karmas:
            # print(karma.info_karma())
            karma.m_stage=1
            result,km_max=self.run(-1,karma)
            if karma.m_reState=='dark yellow':
                self.retrive(karma)
                results.append([False,km_max])
            elif karma.m_reState=='dark green':
                self.m_mapDict[karma].clear()
                results.append(True)
                self.clearTmpPts()
        return results

    def updateTmpNew(self,list_new,sent=None):
        if sent!=None:
            list_map=self.m_mapDict.get(sent,[])
            list_map+=list_new
        for pt in list_new:
            if pt not in self.m_tmpNew:
                self.m_tmpNew.append(pt)
        return self.m_tmpNew

    def updateOutputs(self,list_new,sent):
        list_map=self.m_mapDict.get(sent,[])
        list_map+=list_new
        for point in list_new:
            if point not in self.m_outputs:
                self.m_outputs.append(point)
            # if point in self.m_tmpNew:
            #     self.m_tmpNew.remove(point)
        return self.m_outputs

    def updateAnswers(self,list_new):
        for point in list_new:
            if point in self.m_questions and point.m_creator!=None:
                point.m_creator.map(None)
                self.m_questions.remove(point)
                self.m_answers.append(point)
        return self.m_answers

    def updateOutPool(self,list_new,sent,karma_type):
        if karma_type!=1 and sent in self.m_karmas:
            self.updateOutputs(list_new,sent)
        else:
            self.updateTmpNew(list_new,sent)
        return self.genPool()

    def clearTmpPts(self):
        for pt in self.m_answers:
            pt.delete()
            del pt
        for pt in self.m_tmpNew:
            pt.delete()
            del pt
        self.m_answers.clear()
        self.m_tmpNew.clear()

    def printKarmaState(self,karma):
        if karma.m_map!=None:
            print(karma.m_symbol.info(),karma.stateSelf(),str(karma.m_stage)+'(Stage)')
            karma.m_map.print("全部关联")
            # print(karma.m_map.info(),karma.m_map.m_needed!=None,karma.m_map.m_creator!=None)
        else:
            print(karma.m_symbol.info(),karma.stateSelf(),str(karma.m_stage)+'(Stage)')
            print(karma.m_map)

    def run(self,n=1,sent=None,show=False):
        if sent==None:
            if self.m_running==[]:
                print("Error! Nothing can run.")
                return False
            else:
                sent=self.m_running[-1]
        else:
            self.m_running.append(sent)
        if sent.m_stage==0:
            sent.m_stage=1
        i=0
        outPool=self.genPool(sent)
        list_map=self.m_mapDict[sent]
        running=sent.allEffects()
        run_max=-1
        # print(running)
        while i!=n:
            i+=1
            change=False
            # print('<----------------------------->')
            # j=0
            for karma in running:
                # j+=1
                # print(karma.m_listMP)
                step_change,list_new=karma.Reason_oneStep(tools_basic.listToDict(outPool))
                # if step_change:
                #     print(j,karma.m_symbol.m_name,karma.m_stage,karma.m_reState)
                #     if karma.m_map!=None:
                #         print(karma.m_map.m_name)
                if karma.m_interp==True: 
                    # self.m_questions.append(karma.m_map)                          # why to collect questions?
                    # print(karma.m_map.m_db[0].info())
                    if not self.callLib(karma.m_map):
                        karma.m_map=None
                if step_change:
                    # print(karma.m_symbol.info(),karma.m_stage,karma.m_reState,karma.stateSelf(),step_change)
                    if n!=-1:
                        self.printKarmaState(karma)
                    if show==True:
                        if karma.m_map!=None:
                            print(karma.m_symbol.m_name+':',karma.m_map.m_name)
                        else:
                            print(karma.m_symbol.m_name+': None')
                    change=True
                    self.updateAnswers(list_new)
                    self.updateOutPool(list_new,sent,karma.isFunctionPoint())
                    if karma.m_stage==2 and karma.m_clause!=[]:
                        list_tmp=karma.m_clauseNew
                        karma.m_clauseNew=self.m_outputs
                        self.m_outputs=list_tmp
                    if karma.m_clauseOut==True:
                        karma.m_clauseOut=False
                        list_tmp=karma.m_clauseNew
                        karma.m_clauseNew=self.m_outputs
                        self.m_outputs=list_tmp
                    if karma.m_clauseCollect==True:
                        karma.m_clauseCollect=False
                        self.m_outputs+=karma.m_clauseNew
                        karma.m_clauseNew=[]
                    if karma.m_reState=='dark yellow':
                        if running.index(karma)>run_max:
                            run_max=running.index(karma)
                    outPool=self.getInputs()+self.m_tmpNew+self.m_outputs
                    break
            # print('Running Stack:',[karma.m_symbol.info() for karma in self.m_running])
            # print('Change State:',change)
            if change==False:
                self.m_running.pop()
                break
            # else:
            #     print('m_answers:')
            #     tools_basic.printPtList(self.m_answers)
            #     print('m_questions:')
            #     tools_basic.printPtList(self.m_questions)
            #     print('m_tmpNew:')
            #     tools_basic.printPtList(self.m_tmpNew)
        if run_max==-1:
            km_max=None
        else:
            km_max=running[run_max].m_symbol.info()
        return True,km_max

    def callLib(self,question,n=-1):
        # defined=False
        if question==None:
            return False
        # else:
        #     print('请问什么是'+question.m_name+'?('+question.info()+')')


        # if question.m_text!='' and question.m_name!='[问]' and question.m_name!='[公式]' and question.m_name!='[python]':
        #     karmas=self.compile(question.m_text)
        #     for karma in karmas:
        #         defined=True
        #         karma=karmas[0]
        #         karma.m_stage=1
        #         karma.m_restricted=True
        #         karma.m_listMP=[question]
        #         self.m_mapDict.update({karma:[]})
        #         self.run(n,karma,True)
        #         if question.m_creator==None:
        #             self.retrive(karma)
        #             del self.m_mapDict[karma]
        #         else:
        #             return True
        #     if defined==True:
        #         print(question.m_text)


        # pt_terms=self.m_terms.m_db[1]
        # terms=tools_basic.getPointByFormat(pt_terms,'list')

        # for term in terms:
        #     if question.m_name[1:-1]!=term.m_name:
        #         continue
        #     # defined=True
        #     karmas=self.compile(term.m_text)
        #     for karma in karmas:
        #         karma.m_stage=1
        #         karma.m_restricted=True
        #         karma.m_listMP=[question]
        #         self.m_mapDict.update({karma:[]})
        #         self.run(n,karma)
        #         if question.m_creator==None:
        #             self.retrive(karma)
        #             del self.m_mapDict[karma]
        #         else:
        #             return True
        
        if self.isNotAnswered(question):
            name=question.m_name[1:-1]
            result=self.nextAnsInTerm(name,question)
            if result==True:
                return True
        elif question.m_creator!=None and isinstance(question.m_creator,Karma):
            name=question.m_name
            pt_ans=question.m_creator.m_creator
            result=self.continueMap(question.m_creator)
            if result==True:
                return True
            elif name!='想':
                question.m_creator=None
                question.m_name='['+name+']'
                result=self.nextAnsInTerm(name,question,pt_ans)
                if result==True:
                    return True
            else:
                return False
        return self.termBuiltin(question)

    def continueMap(self,karma):
        cause=karma.causeEnd()
        while True:
            cause.m_stage=3
            cause.m_reState=''

            i=cause.m_eoi

            # num_end=len(cause.m_noe)+len(cause.m_yese)
            # if num_end!=1:
            #     cause.m_stage=1
            #     break

            if cause.m_choose==True:
                if len(cause.m_yese)==0 or cause.m_yese[i].m_no==True:
                    cause.m_stage=1
                    break
                else:
                    cause=cause.m_yese[i]
            else:
                if len(cause.m_noe)==0 or cause.m_noe[i].m_no==True:
                    cause.m_stage=1
                    break
                else:
                    cause=cause.m_noe[i]

        pt_A=karma.m_creator
        tmp=self.m_limit
        self.m_limit=True
        tmp_r=self.m_range
        self.m_range=tools_basic.getPointByFormat(pt_A,'list')
        self.run(-1,karma)
        self.m_limit=tmp
        self.m_range=tmp_r

        # print(karma.m_reState)
        if karma.m_reState=="dark green":
            return True
        else:
            return False





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



    def nextAnsInTerm(self,name,question,pt_mark=None):
        # pt_terms=self.m_terms.m_db[1]
        # terms=tools_basic.getPointByFormat(pt_terms,'list')
        terms=self.getTerms()
        if pt_mark==None:
            pt_term=None
            pt_sent=None
            flag_term=False
            flag_sent=False
        else:
            pt_term=pt_mark.m_db[0]
            pt_sent=pt_mark
            flag_term=True
            flag_sent=True
            # pt_mark.print()
            # pt_term.print()

        for term in terms:
            if flag_term and pt_term==term:
                flag_term=False
            if name!=term.m_name or flag_term:
                continue
            # defined=True
            try:
                list_sent=tools_basic.divideSents_tokener(term.m_text)
            except Exception as e:
                logging.exception(e)
                list_sent=[]

            for pt_ans in list_sent:
                if flag_sent and pt_ans.m_text==pt_sent.m_text:
                    flag_sent=False
                    continue
                if flag_sent:
                    continue
                pt_ans.con(term,None)
                tools_basic.setPointByFormat(pt_ans,'list.append',term)
                result=self.matchQA(question,pt_ans)
                if result==True:
                    return True
                else:
                    tools_basic.setPointByFormat(pt_ans,'list.clear')
                    pt_ans.delete()
        return False

    def matchQA(self,pt_Q,pt_A):
        karmas=self.compile(pt_A.m_text)
        karma=karmas[0]
        karma.m_creator=pt_A
        karma.m_stage=1
        karma.m_restricted=True
        karma.m_listMP=[pt_Q]
        self.m_mapDict.update({karma:[]})

        tmp=self.m_limit
        self.m_limit=True
        tmp_r=self.m_range
        self.m_range=tools_basic.getPointByFormat(pt_A,'list')
        if pt_A not in self.m_range:
            self.m_range.append(pt_A)
        self.run(-1,karma)
        self.m_limit=tmp
        self.m_range=tmp_r

        if pt_Q.m_creator==None:
            self.retrive(karma)
            del self.m_mapDict[karma]
            return False
        else:
            return True


            
    def termBuiltin(self,question):
        sbj=question.m_db[0]
        obj=question.m_db[1]
        # isAns=self.isAnswer(question)

        if question.m_name=='[__]':
            return self.tmpWord(question)
        # elif question.m_name=='[公式]':
        #     return self.tpFormula(question)
        elif question.m_name=='[问]':
            return self.ask(question)
        elif question.m_name=='[说]':
            return self.say(obj,question)
        elif question.m_name=='[想]':
            return self.think(question)
        elif question.m_name=='[激活]':
            return self.hasFocus(sbj,question)
        elif question.m_name=='[下一个]':
            return self.next(sbj,obj,question)
        elif question.m_name=='下一个':
            return self.next2(sbj,question)
        elif question.m_name=='[上一个]':
            return self.previous(sbj,obj,question)
        elif question.m_name=='上一个':
            return self.previous2(sbj,question)
        elif question.m_name=='[前]':
            return self.before(sbj,obj,question)
        elif question.m_name=='[后]':
            return self.after(sbj,obj,question)
        elif question.m_name=='[==]':
            return self.equal(sbj,obj,question)
        elif question.m_name=='[记录结构]':
            return self.tpRecall(sbj,question)
        elif question.m_name=='[m_text]':
            return self.tpText(question)
        elif question.m_name=='[m_name]':
            return self.tpName(question)
        elif question.m_name=='[标题]':
            return self.tpNameOf(sbj,question)
        elif question.m_name=='[全部关联]':
            return self.tpAllCons(obj,question)
        elif question.m_name=='[python]':
            return self.tpPython(sbj,obj,question)
        elif question.m_name=='[matlab]':
            return self.tpMatlab(sbj,obj,question)
        elif question.m_name=='python' and obj!=None and (obj.m_name=='不终止' or obj.m_name=='[不终止]'):
            return self.tpPython(sbj,obj,question)
        # elif not defined:
        #     self.answerQuestion(question)
        else:
            return False

    def tpRecall(self,sbj,question):
        if sbj==None:
            return False
        start_pt=None
        for con in sbj.m_con:
            if (con.m_name=='起点' or con.m_name=='[起点]') and con.m_db[0]==sbj and con.m_db[1]!=None:
                start_pt=con.m_db[1]

        list_pt0=tools_basic.getPointByFormat(sbj,'list')
        if start_pt==None:
            list_pt=[]
        else:
            list_pt=[start_pt]
        for pt in list_pt0:
            if pt not in list_pt:
                list_pt.append(pt)

        question.m_text=tools_basic.writeStdCode([],list_pt)
        self.answerQuestion(question)
        return True


    def tpText(self,question):
        if question.m_db[1]==None:
            return False
        text=""
        if question.m_db[0]==None and question.m_text=="":
            return False
        elif question.m_text=="":
            text=question.m_db[0].m_text
        elif question.m_db[0]==None:
            text=question.m_text
        else:
            pat=question.m_text
            con=question.m_db[0].m_text
            try:
                text=pat%(con)
            except:
                text=pat+con
        if question.m_db[1].m_building==True:
            question.m_db[1].m_text=text
        else:
            print("Error! [m_text] can only set a new point's m_text.",question.m_db[1].info(),"isn't a new point.")
        self.answerQuestion(question)
        return True

    def tpName(self,question):
        if question.m_db[0]==None or question.m_db[1]==None:
            return False
        name=question.m_db[0].m_name

        if name[0]=='[' and name[-1]==']':
            name=name[1:-1]
        if name=='':
            print('Error! Name can\'t be empty')
            return False

        if question.m_db[1].m_building==True:
            question.m_db[1].m_name=name
        else:
            print("Error! [m_name] can only set a new point's m_name.",question.m_db[1].info(),"isn't a new point.")
        self.answerQuestion(question)
        return True

    def tpNameOf(self,sbj,question):
        if sbj==None:
            return False
        question.m_text=sbj.m_name
        self.answerQuestion(question)
        return True
        
    def tpAllCons(self,obj,question):
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
        question.m_text=text
        self.answerQuestion(question)
        return True


    def tmpWord(self,question):
        for con in question.m_con:
            if con.m_name=='.' and con.m_db[1]==question and con.m_db[0]!=None:
                question.m_name='['+con.m_db[0].m_name+']'
                question.m_text=con.m_db[0].m_text
                result=self.callLib(question)
                break
        question.m_name='__'
        return result

    def tpFormula(self,question):
        # [公式]"a*b*c"(,a)
        # if question.m_db[1]==None:
        #     return
        # else:
        #     obj=question.m_db[1]
        try:
            list_pt=tools_parsers.eqn2struct(question.m_text)
        except Exception as e:
            logging.exception(e)
            return False

        list_new=[]
        pt_act=NetP('问题').con(None,list_pt[0])
        for pt in list_pt:
            pt_new=NetP("的").con(pt_act,pt)
            list_new.append(pt_new)
        list_pt.insert(0,pt_act)
        list_km0=tools_basic.newKarmaOnPts(list_pt)
        list_km0[0].m_buildMode=True
        list_km1=tools_basic.newKarmaOnPts(list_new,True)
        list_km0[-1].m_yese.append(list_km1[0])
        list_km1[0].m_cause=list_km0[-1]
        code=tools_basic.karmaToStr(list_km0[0])

        question.m_name='[问题]'
        question.m_text=code
        result=self.callLib(question)
        if question.m_name=='[问题]':
            question.m_name='[公式]'
        else:
            question.m_name='公式'
        return result


    def ask(self,question):
        A=input(question.m_text)
        if A=='Yes':
            self.answerQuestion(question)
            return True
        return False
            
    def say(self,obj,question):
        if obj==None and question.m_text=='':
            self.answerQuestion(question)
            return True
        elif question.m_text=='':
            obj.print()
        elif obj==None:
            print(question.m_text)
        else:
            pat=question.m_text
            con=obj.info()
            try:
                text=pat%(con)
            except:
                text=pat+con
            print(text)
        self.answerQuestion(question)
        return True
            
    def think(self,question):
        pt_A=question
        for con in question.m_con:
            if con.m_name=='code' or con.m_name=='[code]':
                if con.m_db[0]==question and con.m_db[1]!=None:
                    pt_A=con.m_db[1]
        question.m_name='[%s]'%(pt_A.m_name)
        try:
            # result=self.matchQA(question,pt_A)
            result=self.think_matchQA(question,pt_A)
        except:
            result=False
        question.m_name='想'
        return result

    def think_matchQA(self,question,pt_A):
        if question.m_creator!=None and isinstance(question.m_creator,Karma):
            result=self.continueMap(question.m_creator)
        else:
            result=self.matchQA(question,pt_A)
        return result

    # def think2(self,obj):
    #     if obj==None:
    #         return False
    #     self.think(obj)
    #     pt_A=question
    #     for con in question.m_con:
    #         if con.m_name=='code' or con.m_name=='[code]':
    #             if con.m_db[0]==question and con.m_db[1]!=None:
    #                 pt_A=con.m_db[1]
    #     question.m_name='[%s]'%(pt_A.m_name)
    #     try:
    #         result=self.matchQA(question,pt_A)
    #     except:
    #         result=False
    #     question.m_name='想'
    #     return result


    def hasFocus(self,sbj,question):
        print('检测是否激活...')
        if sbj==None or sbj.m_dev==None:
            return False
        try:
            result=sbj.m_dev.hasFocus()
            if result==True:
                self.answerQuestion(question)
            return result
        except:
            return False

    def next(self,sbj,obj,question):
        list_pt=tools_basic.getPointByFormat(sbj,'list')
        for i in range(len(list_pt)):
            if list_pt[i]==obj:
                if i+1<len(list_pt):
                    NetP('是').con(question,list_pt[i+1])
                    self.answerQuestion(question)
                    return True
                else:
                    return False
        return False

    def next2(self,sbj,question):
        pt0=None
        pt_is=None
        for con in question.m_con:
            if con.m_db[0]==question and con.m_db[1]!=None and con.m_name=='是':
                pt0=con.m_db[1]
                pt_is=con
                break
        if pt0==None or pt_is==None:
            return False

        list_pt=tools_basic.getPointByFormat(sbj,'list')
        for i in range(len(list_pt)):
            if list_pt[i]==pt0:
                if i+1<len(list_pt):
                    pt_is.con(0,list_pt[i+1])
                    self.answerQuestion(question)
                    return True
                else:
                    return False
        return False

    def previous(self,sbj,obj,question):
        list_pt=tools_basic.getPointByFormat(sbj,'list')
        for i in range(len(list_pt)):
            if list_pt[i]==obj:
                if i>0:
                    NetP('是').con(question,list_pt[i-1])
                    self.answerQuestion(question)
                    return True
                else:
                    return False
        return False

    def previous2(self,sbj,question):
        pt0=None
        pt_is=None
        for con in question.m_con:
            if con.m_db[0]==question and con.m_db[1]!=None and con.m_name=='是':
                pt0=con.m_db[1]
                pt_is=con
                break
        if pt0==None or pt_is==None:
            return False

        list_pt=tools_basic.getPointByFormat(sbj,'list')
        for i in range(len(list_pt)):
            if list_pt[i]==pt0:
                if i>0:
                    pt_is.con(question,list_pt[i-1])
                    self.answerQuestion(question)
                    return True
                else:
                    return False
        return False



    def before(self,sbj,obj,question):
        pt0=None
        for con in question.m_con:
            if con.m_db[0]==question and con.m_db[1]!=None and (con.m_name=='的' or con.m_name=='[的]'):
                pt0=con.m_db[1]
                break
        if pt0==None or sbj==None or obj==None:
            return False
        list_pt=tools_basic.getPointByFormat(pt0,'list')
        try:
            if list_pt.index(sbj)<list_pt.index(obj):
                self.answerQuestion(question)
                return True
        except:
            pass
        return False

    def after(self,sbj,obj,question):
        pt0=None
        for con in question.m_con:
            if con.m_db[0]==question and con.m_db[1]!=None and (con.m_name=='的' or con.m_name=='[的]'):
                pt0=con.m_db[1]
        if pt0==None or sbj==None or obj==None:
            return False

        try:
            list_pt=tools_basic.getPointByFormat(pt0,'list')
            if list_pt.index(sbj)>list_pt.index(obj):
                self.answerQuestion(question)
                return True
        except:
            pass
        return False

    def equal(self,sbj,obj,question):
        if obj==None:
            return False
        if sbj==None:
            if obj.m_text==question.m_text:
                self.answerQuestion(question)
                return True
        elif obj.m_text==sbj.m_text:
            self.answerQuestion(question)
            return True
        return False
      
    def answerQuestion(self,question):
        if len(question.m_name)<2:
            return
        if question.m_name[0]=='[' and question.m_name[-1]==']':
            question.m_name=question.m_name[1:-1]
            question.m_creator=self.m_self
        if question in self.m_questions:
            self.m_questions.remove(question)
            self.m_answers.append(question)
        self.updateTmpNew([question])

    def isNotAnswered(self,question):
        if question==None:
            return False
        if len(question.m_name)<2:
            return False
        if question.m_name[0]=='[' and question.m_name[-1]==']':
            return True
        return False


    def tpPython(self,sbj,obj,question):
        if sbj!=None:
            if sbj.m_var==None:
                sbj.m_var={}
            elif not isinstance(sbj.m_var,dict):
                return False
            eng=sbj.m_var
        else:
            return False
        code=question.m_text
        vars_in={}
        vars_out={}
        if question.m_db[1]!=None:
            vars_out.update({'ans':['o',question.m_db[1]]})
        for con in question.m_con:
            if con.m_db[0]==question and con.m_db[1]!=None:
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
        try:
            self.pythonCode(eng,code,vars_in,vars_out,False)
        except Exception as e:
            logging.exception(e)
            return False
        result=eng.get('state',None)
        if result==True:
            self.answerQuestion(question)
            return True
        elif result==False:
            return False
        else:
            print('The state of the [python] should be written in a var: state=True or False')
            return False



    def pythonCode(self,eng,code,vars_in,vars_out,show_mode=False):
        # print(vars_in)
        for var in vars_in:
            type_var=vars_in[var][0]
            pt_var=vars_in[var][1]
            if pt_var.m_var!=None:
                vars_in[var]=pt_var.m_var
            elif type_var=='v':
                vars_in[var]=pt_var.m_var
            else:
                str_var=pt_var.m_text
                value=tools_format.str2Vec(str_var)
                if value==[] or type_var=='s':
                    vars_in[var]=str_var
                else:
                    vars_in[var]=value
        eng.update(vars_in)
        result=tools_basic.pythonCodeEval(eng,code)
        if result==False:
            eng.update({'state':False})
        for var in vars_out:
            type_var=vars_out[var][0]
            pt_var=vars_out[var][1]
            value=eng.get(var,'')
            if type_var=='v':
                pt_var.m_var=value
                continue
            elif pt_var.m_building!=True:
                print('Can\'t change the m_text of an existed NetP.')
                continue
            else:
                pt_var.m_text=tools_format.vec2Str(value)
        return vars_out






    def tpMatlab(self,sbj,obj,question):
        if sbj!=None:
            if not isinstance(sbj.m_var,mtb.MatlabEngine):
                sbj.m_var=mtb.start_matlab()
            eng=sbj.m_var
        else:
            return False
        code=question.m_text
        vars_in={}
        vars_out={}
        if question.m_db[1]!=None:
            vars_out.update({'ans':['o',question.m_db[1]]})
        for con in question.m_con:
            if con.m_db[0]==question and con.m_db[1]!=None:
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
        try:
            self.matlabCode(eng,code,vars_in,vars_out,False)
        except Exception as e:
            logging.exception(e)
            return False
        try:
            result=eng.workspace['state']
            if result==1:
                self.answerQuestion(question)
                return True
            else:
                return False
        except:
            print('The state of the [matlab] should be written in a var: state=True or False')
            return False


    def matlabCode(self,eng,code,vars_in,vars_out,show_mode=False):
        for var in vars_in:
            type_var=vars_in[var][0]
            pt_var=vars_in[var][1]
            if type_var=='s':
                str_var=translateString(pt_var.m_text)
            else:
                str_var=pt_var.m_text
                value=tools_format.str2Mat(str_var)
                if np.size(value)!=0:
                    str_var='['+str_var+'];'
                else:
                    str_var=translateString(str_var)
            eng.workspace[var]=eng.eval(str_var)
        try:
            eng.eval(code,nargout=0)
            result=True
        except:
            result=False
            
        if result==False:
            eng.workspace['state']=eng.eval('0;')
        for var in vars_out:
            type_var=vars_out[var][0]
            pt_var=vars_out[var][1]
            if pt_var.m_building!=True:
                print('Can\'t change the m_text of an existed NetP.')
                continue
            value=eng.workspace[var]
            print('Output variable('+var+') type:',type(value))
            if isinstance(value,str):
                pt_var.m_text=value
            else:
                try:
                    value=np.array(value)
                    str_var=tools_format.mat2Str(value)
                    pt_var.m_text=str_var
                except:
                    print('Error! Fail to set output value!')
        return vars_out


       

    
    def getNumFromText(self,text):
        try:
            num=float(text)
        except:
            num=None
        return num


    def output(self):
        list_out=self.m_outputs
        return list_out

    # make a shell of runCode
    def runCode_shell(self,code,question=None,IO=None,limit=False,pt_ptr=None):
        try:
            list_sent=tools_basic.divideSents_tokener(code)
        except Exception as e:
            logging.exception(e)
            return []
        results=[]
        if pt_ptr==None:
            list_pt=[]
        else:
            # list_pt=tools_basic.getPointByFormat(pt_ptr,'list')
            list_pt=tools_basic.getPointByFormat(pt_ptr,'set')
            if pt_ptr not in list_pt:
                list_pt.append(pt_ptr)
        for sent in list_sent:
            results+=self.runCode(sent.m_text,question,IO,limit,list_pt,pt_ptr=pt_ptr)
        return results


    # make a shell of runCode for [structureCode]
    def runCode_shell_structure(self,code,list_pt,pt_ptr,pt_IO=None):
        try:
            list_sent=tools_basic.divideSents_tokener(code)
        except Exception as e:
            logging.exception(e)
            return []
        results=[]
        
        for sent in list_sent:
            results+=self.runCode(sent.m_text,question=None,IO=pt_IO,limit=True,list_pt=list_pt,pt_ptr=pt_ptr)
        return results


    def runCode(self,code,question=None,IO=None,limit=False,list_pt=None,pt_ptr=None):
        tmp=None
        tmp_r=None
        source=None

        if IO!=None:
            source=self.m_source.m_db[1]
            self.m_source.con(0,IO)
        self.reset()
        list_km=self.compile(code)
        self.loadCode(list_km)
        if question!=None and self.m_karmas!=[]:
            self.m_karmas[0].m_listMP=[question]
            self.m_karmas[0].m_restricted=True
            # question.m_name='['+self.m_karmas[0].m_symbol.m_name+']'
        if limit:
            tmp=self.m_limit
            self.m_limit=limit
            tmp_r=self.m_range
            self.m_range=list_pt
        results=self.runAll()
        if limit:
            self.m_limit=tmp
            self.m_range=tmp_r
            list_pt+=self.output()
        port=self.m_source.m_db[1]

        # tools_basic.printPtList(list_pt)

        # only used by runCode_shell
        if pt_ptr!=None:
            list_de=[]
            pt_act,pt_obj=port.m_dev.divPts(self.output())
            for pt in pt_obj:
                pt_de=NetP("的").con(pt_ptr,pt)
                list_de.append(pt_de)
                port.m_dev.input(list_de,mode=0)

        if port.m_dev!=None:
            port.m_dev.input(self.output())

        if IO!=None:
            self.m_source.con(0,source)
        return results

    def answerCode(self,code,scene=None):
        if scene!=None:
            formal=self.m_formal
            inputs=self.m_source
            self.m_source=scene
            self.m_formal=False
        self.reset()
        list_km=self.compile(code)
        self.loadCode(list_km)
        result=self.runAll()
        if scene!=None:
            self.m_source=inputs
            self.m_formal=formal
        return result[0]

    def runKarma(self,list_km,scene=None):
        if scene!=None:
            formal=self.m_formal
            inputs=self.m_source
            self.m_source=scene
            self.m_formal=False
        self.reset()
        self.loadCode(list_km)
        self.runAll()
        if scene!=None:
            self.m_source=inputs
            self.m_formal=formal
        return self.output()

    # def info(self):
    #     information='+++++++ COMPILER ++++++\nName: '+self.m_self.m_name+'\nLibrary: '
    #     for dirc in self.m_lib:
    #         information+=dirc+';\n'
    #     information+='\nterms: '
    #     for term in self.m_terms:
    #         information+=term.m_name
    #         if term!=self.m_terms[-1]:
    #             information+=', '
    #     information+='\nMaps: '
    #     for sent in self.m_mapDict:
    #         information+=sent.m_symbol.m_name+'('
    #         for map in self.m_mapDict[sent]:
    #             information+=map.m_name
    #             if map!=self.m_mapDict[sent][-1]:
    #                 information+=', '
    #         information+=') '
    #     information+='\n'
    #     return information
    
    # def print(self):
    #     print(self.info())

def translateString(str_var):
    # string=str_var
    if str_var.find('\n')==-1:
        string="\""+str_var+"\";"
    else:
        string="{\""+str_var.replace('\n','","')+"\"};"
    return string




if __name__=='__main__':
    test=Compiler(None)
    # pool=NetP('').build('a(,);b(a,);c(d,b);d(,)')
    # test.m_source.m_db[1].m_dev=pool
    list_new=test.runCode('a(,)->+c(,a)')
    # for point in list_new:
    #     point.print()