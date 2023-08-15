import sys
import re
if __name__=='__main__':
    sys.path.append(sys.path[0]+'\\..')
from body.bone import NetP

def dictToList(dict_pt):
    list_pt=[]
    for term in dict_pt:
        list_pt+=dict_pt[term]
    return list_pt

class Karma:
    def __init__(self,symbol):
        self.m_symbol=symbol
        symbol.m_master=self
        self.m_creator=None

        self.m_map=None

        self.m_cause=None
        self.m_yese=[]
        self.m_noe=[]
        self.m_yesAnd=False
        self.m_noAnd=False
        self.m_eoi=0

        self.m_clause=[]
        self.m_clauseAnd=True
        # To reorder actions generated inside a clause. All new points generated in clauses will be stored in
        # m_clauseNew until the whole sentence completes the map.
        # It's a kind of stack.
        self.m_clauseNew=[]
        self.m_clauseCollect=False
        self.m_clauseOut=False
        self.m_clauseIn=False

        self.m_not=False
        self.m_no=False
        
        self.m_buildMode=False

        self.m_listMP=None
        self.m_restricted=False

        self.m_ranger=None
        self.m_rangType=False                               # connecting[self(,ranger)]---True, connected[ranger(,self)]---False

        # one step
        self.m_stage=0
        # self.m_reState='0'
        self.m_reState=''
        self.m_choose=True
        self.m_interp=False

    def stateSelf(self):
        if self.m_interp==True:
            return 'blue'
        if self.m_symbol==None or self.m_map==None:
            return 'yellow'

        # [eq](,) and [is](,) function points
        if self.m_symbol.m_name=='[eq]' or self.m_symbol.m_name=='[同名]':
            return self.stateSelf_eq()
        elif self.m_symbol.m_name=='[is]' or self.m_symbol.m_name=='[是]':
            return self.stateSelf_is()
        elif self.m_symbol.m_name=='[那]':
            return 'green'
        # elif self.isSpaceRelation():
        #     return self.stateSelf_space()

        # _re"^.*"(,) regular expression
        if self.m_symbol.m_name=='_正则表达式' or self.m_symbol.m_name=='_re':
            try:
                pattern=re.compile(self.m_symbol.m_text)
            except:
                print('Invalid regular expression: '+self.m_symbol.m_text+'!')
                return 'red'
            match=self.m_map.m_name
            if pattern.findall(match)!=[]:
                return 'green'
            else:
                return 'red'

        # _word(,) or _[word](,)
        if self.m_symbol.m_name!='' and self.m_symbol.m_name[0]=='_':
            name=self.m_symbol.m_name[1:]
            name_m=self.m_map.m_name
            if len(name)==0:
                return 'green'
            elif name[0]=='[' and name[-1]==']':
                if len(name_m)>=2 and name_m[0]=='[' and name_m[-1]==']':
                    return 'green'
                else:
                    return 'red'
            else:
                return 'green'
                # if len(name_m)<2 or name_m[0]!='[' or name_m[-1]!=']':
                #     return 'green'
                # else:
                #     return 'red'


        # [word](,)/+[word](,)
        if self.m_symbol.m_name!='' and self.m_symbol.m_name[0]=='[' and self.m_symbol.m_name[-1]==']':
            name1=self.m_symbol.m_name[1:-1]
            name2=self.m_symbol.m_name
            if self.m_interp==False and self.m_map.m_creator==None and self.m_buildMode==False:
                return 'red'
            if name1==self.m_map.m_name or name2==self.m_map.m_name:
                return 'green'
            else:
                return 'red'

        # ~word(,)
        if self.m_symbol.m_name!='' and self.m_symbol.m_name[0]=='~':
            name=self.m_symbol.m_name[1:]
            if name==self.m_map.m_name:
                return 'red'
            else: 
                return 'green'
        # word(,)
        else:
            name=self.m_map.m_name
            if name!='' and name[0]=='[' and name[-1]==']':
                name=name[1:-1]
            if name!=self.m_symbol.m_name:
                return 'red'
            elif self.m_symbol.m_text!='' and self.m_symbol.m_text!=self.m_map.m_text:
                return 'red'
            else:
                return 'green'

    def stateSelf_eq(self):
        if self.m_map==None:
            return 'yellow'
        if self.m_symbol.m_db[0]==None or self.m_symbol.m_db[1]==None:
            return 'red'
        
        karmaL=self.m_symbol.m_db[0].m_master
        karmaR=self.m_symbol.m_db[1].m_master
        if karmaL==None or karmaR==None:
            print('Error! [eq] doesn\'t have sbj or obj.')
            print('Sbj:',karmaL)
            print('Obj:',karmaR)
            return 'red'
        if karmaL.m_map==None or karmaR.m_map==None:
            return 'green'
        else:
            nameL=karmaL.m_map.m_name
            nameR=karmaR.m_map.m_name
            # I don't remember why I removed it
            # if len(karmaL.m_map.m_name)>1 and karmaL.m_map.m_name[0]=='[' and karmaL.m_map.m_name[-1]==']':
            #     nameL=karmaL.m_map.m_name[1:-1]
            # if len(karmaR.m_map.m_name)>1 and karmaR.m_map.m_name[0]=='[' and karmaR.m_map.m_name[-1]==']':
            #     nameR=karmaR.m_map.m_name[1:-1]
            
            if len(karmaL.m_map.m_name)>1 and karmaL.m_map.m_name[0]=='[' and karmaL.m_map.m_name[-1]==']':
                nameL=karmaL.m_map.m_name[1:-1]
            if len(karmaR.m_map.m_name)>1 and karmaR.m_map.m_name[0]=='[' and karmaR.m_map.m_name[-1]==']':
                nameR=karmaR.m_map.m_name[1:-1]

            if nameL==nameR:
                return 'green'
            else:
                return 'red'

    def stateSelf_is(self):
        if self.m_map==None:
            return 'yellow'
        if self.m_symbol.m_db[0]==None or self.m_symbol.m_db[1]==None:
            return 'red'
        
        karmaL=self.m_symbol.m_db[0].m_master
        karmaR=self.m_symbol.m_db[1].m_master
        if karmaL.m_map==None or karmaR.m_map==None:
            return 'green'
        else:
            if karmaL.m_map==karmaR.m_map:
                return 'green'
            else:
                return 'red'

    def stateSelf_space(self):
        if self.m_map==None:
            return 'yellow'
        if self.m_symbol.m_db[0]==None or self.m_symbol.m_db[1]==None:
            return 'red'

        km_sbj=self.m_symbol.m_db[0].m_master
        km_obj=self.m_symbol.m_db[1].m_master
        if km_sbj.m_map==None or km_obj.m_map==None:
            return 'green'
        elif km_sbj.m_map==km_obj.m_map:
            return 'red'
        x1=km_sbj.m_map.m_pos[0]
        y1=km_sbj.m_map.m_pos[1]
        x2=km_obj.m_map.m_pos[0]
        y2=km_obj.m_map.m_pos[1]
        name=self.m_symbol.m_name
        if name=='[当地]' or name=='[here]':
            if x1==x2 and y1==y2:
                return 'green'
            else:
                return 'red'
        elif name=='[上面]' or name=='[up]':
            if y1>y2:
                return 'green'
            else:
                return 'red'
        elif name=='[正上面]' or name=='[Up]':
            if x1==x2 and y1>y2:
                return 'green'
            else:
                return 'red'
        elif name=='[下面]' or name=='[down]':
            if y1<y2:
                return 'green'
            else:
                return 'red'
        elif name=='[正下面]' or name=='[Down]':
            if x1==x2 and y1<y2:
                return 'green'
            else:
                return 'red'
        elif name=='[左面]' or name=='[left]':
            if x1>x2:
                return 'green'
            else:
                return 'red'
        elif name=='[正左面]' or name=='[Left]':
            if y1==y2 and x1>x2:
                return 'green'
            else:
                return 'red'
        elif name=='[右面]' or name=='[right]':
            if x1<x2:
                return 'green'
            else:
                return 'red'
        elif name=='[正右面]' or name=='[Right]':
            if y1==y2 and x1<x2:
                return 'green'
            else:
                return 'red'


    
    def stateRelation(self):
        if self.m_map==None or self.m_symbol==None:
            return True
            
        cause=self.m_cause
        while cause!=None:
            if cause.m_symbol==self.m_symbol.m_db[0]:
                if cause.m_map!=self.m_map.m_db[0]:
                    return False
            if cause.m_symbol==self.m_symbol.m_db[1]:
                if cause.m_map!=self.m_map.m_db[1]:
                    return False

            # For a function point, you should check the relation between the point through the function point selfstate()
            if cause.m_symbol.m_db[0]==self.m_symbol:
                if cause.m_map.m_db[0]!=self.m_map or cause.stateSelf()=='red':
                    return False
            if cause.m_symbol.m_db[1]==self.m_symbol:
                if cause.m_map.m_db[1]!=self.m_map or cause.stateSelf()=='red':
                    return False

            cause=cause.m_cause
        
        return True

    # def rangeList(self,pool,areaType,list_new):
    #     # restrict the map pool by m_listMP
    #     if self.m_listMP!=[]:
    #         list_map=self.m_listMP
    #     # self(+ranger,) or others
    #     elif self.m_ranger!=None and (self.m_ranger.buildingNewMap()==False or self.m_rangType==True):
    #         # restrict the map pool by m_cause
    #         # self(+ranger,) or self(ranger,)
    #         if self.m_rangType==True:
    #             if self.m_ranger.m_map==None or self.m_ranger.m_map.m_con==[]:
    #                 list_map=[]
    #             else:
    #                 list_map=self.m_ranger.m_map.m_con.copy()
    #         # ranger(self,)
    #         elif self.m_ranger.m_symbol.m_db[0]==self.m_symbol:
    #             if self.m_ranger.m_map.m_db[0]==None:
    #                 list_map=[]
    #             else:
    #                 list_map=[self.m_ranger.m_map.m_db[0]]
    #         # ranger(,self)
    #         elif self.m_ranger.m_symbol.m_db[1]==self.m_symbol:
    #             if self.m_ranger.m_map.m_db[1]==None:
    #                 list_map=dictToList(pool)
    #             else:
    #                 list_map=[self.m_ranger.m_map.m_db[1]]
    #         else:
    #             print('Warning! Undefined situation.')
    #     # _point(,) or ~point(,)
    #     elif self.selfType()=='实万用链节' or self.selfType()=='实否定链节':                  # '_point' and '' aren't restricted
    #         list_map=dictToList(pool)
    #         if len(self.m_symbol.m_name)>2 and self.m_symbol.m_name[1]=='_':
    #             for mp in list_map:
    #                 if mp in list_new:
    #                     list_map.remove(mp)
    #     # noraml(,)
    #     else:
    #         # list_map=dictToList(pool)
    #         list_map=pool.get(self.m_symbol.m_name,[])
    #         list_map+=pool.get('['+self.m_symbol.m_name+']',[])

    #     return list_map

    def mapListFromRange(self):
        list_map=[]
        if self.m_rangType==True:
            if self.m_ranger.m_map==None:
                list_map=[]
            else:
                list_map=self.m_ranger.m_map.m_con.copy()
        # ranger(self,)
        elif self.m_ranger.m_symbol.m_db[0]==self.m_symbol:
            if self.m_ranger.m_map.m_db[0]==None:
                list_map=[]
            else:
                list_map=[self.m_ranger.m_map.m_db[0]]
        # ranger(,self)
        elif self.m_ranger.m_symbol.m_db[1]==self.m_symbol:
            if self.m_ranger.m_map.m_db[1]==None:
                list_map=[]
            else:
                list_map=[self.m_ranger.m_map.m_db[1]]
        else:
            print('Warning! Undefined situation.')
        return list_map
    
    def mapListFromPool_normal(self,pool):
        name=self.m_symbol.m_name
        # if self.isType('通用') or self.isType('否定'):
        if len(name)>0 and (name[0]=='_' or name[0]=='~'):
            list_have=dictToList(pool)
            list_map=[]
            for point in list_have:
                if point.m_needed==None or (point.m_needed!=None and point.m_creator!=None):
                    list_map.append(point)
        else:
            list_map=pool.get(self.m_symbol.m_name,[])
            # list_map+=pool.get('['+self.m_symbol.m_name+']',[])
        return list_map

    def mapList_is(self,ranger,pool):
        if ranger.m_symbol.m_db[0]==None or ranger.m_symbol.m_db[1]==None:
            return self.mapListFromPool_normal(pool)
        if ranger.m_symbol.m_db[0]==self.m_symbol and ranger.m_map.m_db[1]!=None:
            return [ranger.m_map.m_db[1]]
        if ranger.m_symbol.m_db[1]==self.m_symbol and ranger.m_map.m_db[0]!=None:
            return [ranger.m_map.m_db[0]]
        return self.mapListFromPool_normal(pool)

    def mapList_that(self,ranger):
        list_cause=ranger.allCauses()
        list_map=[]
        for cause in list_cause:
            pt_map=cause.m_map
            if pt_map!=None and pt_map not in list_map:
                list_map.append(pt_map)
        return list_map

    def rangeList(self,pool,areaType,list_new):
        # restrict the map pool by m_listMP
        if self.m_listMP!=None:
            return self.m_listMP
        # elif self.isType('非端点'):
        elif self.m_ranger!=None:
            ranger=self.m_ranger
            # print('范围',ranger.m_symbol.info())
            nameR=self.m_ranger.m_symbol.m_name
            if nameR=='[is]':
                list_map=self.mapList_is(self.m_ranger,pool)
            elif nameR=='[那]':
                list_map=self.mapList_that(self.m_ranger)
            elif self.m_ranger.isType('非回答新建') and self.m_ranger.m_symbol in self.m_symbol.m_con:
                list_map=self.mapListFromPool_normal(pool)
            else:
                list_map=self.mapListFromRange()
            # elif self.m_ranger.isType('回答') or self.m_ranger.isType('非新建'):
            #     list_map=self.mapListFromRange()
            # elif self.m_buildMode==False:
            #     list_map=self.mapListFromPool_normal(pool)
            # else:
            #     list_map=[]
        else:
            list_map=self.mapListFromPool_normal(pool)

        self.m_listMP=list_map

        return list_map


    def newMap(self,pool,areaType,list_new):
        list_map=self.rangeList(pool,areaType,list_new)
        # if self.m_symbol.m_name=='的':
        #     printPtList(list_map)

        if self.m_buildMode==False or areaType==False:
            name=self.m_symbol.m_name
            # [noun]:
            # function points
            # if self.isFunctionPoint()==1:
            # if self.isType('内置'):
            if self.isPreDefined():
                if self.m_map==None:
                    point=NetP(name,self.m_symbol.m_text)
                    point.m_pos=self.m_symbol.m_pos.copy()
                    point.m_needed=self
                    point.m_creator=self
                    self.map(point)
                else:
                    self.m_map.delete()
                    del self.m_map
                    self.map(None)
                return
            elif self.isFunctionPoint()==2:
                # function points [P] don't find map from pool
                if self.m_map==None:
                    point=NetP(name,self.m_symbol.m_text)
                    point.m_pos=self.m_symbol.m_pos.copy()
                    point.m_needed=self
                    self.map(point)
                else:
                    # Mapping again according to [A]'s definition
                    self.map(self.m_map)
                self.m_interp=True
                # else:
                #     self.m_map.delete()
                #     self.m_map.m_needed=None
                #     self.map(None)
                return

            # printPtList(list_map)

            # only take real points when karma is start with _ and ~
            # list_have=[]
            # for point in list_map:
            #     if self.selfType()=='实万用链节' or self.selfType()=='实否定链节':
            #         # if point.m_creator!=None or point.m_needed==None:
            #         if point.m_needed==None or (point.m_needed!=None and point.m_creator!=None):
            #             # point.print()
            #             list_have.append(point)
            #         # else:
            #         #     pass
            #             # print('Erased from map_list:',point.info(),', it should be an imagine point.')
            #     else:
            #         list_have.append(point)
            list_have=list_map
            mp=self.m_map
            self.map(self.nextInlist(mp,list_have))
            # if self.m_map!=None:
            #     print(self.m_symbol.m_name+':',self.m_map.m_name)
            #     printPtList(self.m_map.m_con)
            return
        else:
            name=self.m_symbol.m_name
            # answer questions
            # +word(,)
            if name!='' and (name[0]!='[' or name[-1]!=']'):
                if self.m_map!=None:
                    self.m_map.m_creator=None
                    # ???
                    if self.m_map.m_needed==None:
                        self.m_map.delete()
                        self.map(None)
                        return
                    else:
                        self.m_map.m_name='['+self.m_map.m_name+']'
                        # self.m_map.m_building=False
                list_need=[]
                for point in list_map:
                    if point.m_creator==None and point.m_needed!=None:
                        list_need.append(point)
                point=self.m_map
                # printPtList(list_need)
                # if point==None:
                #     print(self.m_symbol.m_name+":",point,-1)
                # else:
                #     try:
                #         print(self.m_symbol.m_name+":",list_need,point,list_need.index(point))
                #         # print(self.m_symbol.m_name+":",pool)
                #     except:
                #         print(self.m_symbol.m_name+":",list_need,point.info(),-1)
                self.map(self.nextInlist(point,list_need))
                if self.m_map==None:
                    if self.m_restricted==True:
                        self.map(None)
                        return
                    point=NetP(self.m_symbol.m_name,self.m_symbol.m_text)
                    point.m_pos=self.m_symbol.m_pos.copy()
                    point.m_building=True
                    self.map(point)
                else:
                    self.m_map.m_building=True
                    self.m_map.m_name=self.m_map.m_name[1:-1]
                self.m_map.m_creator=self
                return
            # +[word](,)
            else:
                if self.m_map==None:
                    point=NetP(name,self.m_symbol.m_text)
                    point.m_pos=self.m_symbol.m_pos.copy()
                    point.m_building=True
                    point.m_needed=self
                    self.map(point)
                    return
                else:
                    self.m_map.m_needed=None
                    self.m_map.delete()
                    self.map(None)
                    return

        self.map(None)


    def nextInlist(self,point,list_pt):
        if list_pt==[]:
            return None
        if point==None:
            return list_pt[0]
        
        try:
            i=list_pt.index(point)
        except:
            return None
        
        if i+1>=len(list_pt):
            return None
        else:
            return list_pt[i+1]

    def clearAll(self):
        self.m_map=None
        self.m_stage=0
        self.m_interp=False
        self.m_reState=''
        self.m_choose=True
        self.m_eoi=0
        if self.m_restricted==False:
            del self.m_listMP
            self.m_listMP=None
        for clause in self.m_clause:
            clause.clearAll()
        for end in self.m_noe:
            end.clearAll()
        for end in self.m_yese:
            end.clearAll()


    def map(self,point):
        self.clearAll()
        # self.m_stage=0
        # self.m_interp=False
        # self.m_reState=''
        # self.m_choose=True
        # for clause in self.m_clause:
        #     clause.map(None)
        # for end in self.m_noe:
        #     end.map(None)
        # for end in self.m_yese:
        #     end.map(None)

        self.m_map=point
        if self.m_map!=None:
            cause=self.m_cause
            while cause!=None:
                # function relation points
                # print('当前链节:',self.m_symbol.m_name)
                # print('因链节:',cause.m_symbol.m_name)
                if cause.needBuildRelation():
                    # To allow +[a]: +a(,_obj)->_obj, _obj can find map from pool.
                    if cause.m_map.m_needed==None or cause.m_map.m_needed==cause:
                        if cause.m_symbol.m_db[0]==self.m_symbol:
                            cause.m_map.connect(self.m_map,0)
                        if cause.m_symbol.m_db[1]==self.m_symbol:
                            cause.m_map.connect(self.m_map,1)
                if self.needBuildRelation():
                    if self.m_map.m_needed==None or self.m_map.m_needed==self:
                        if self.m_symbol.m_db[0]==cause.m_symbol:
                            self.m_map.connect(cause.m_map,0)
                        if self.m_symbol.m_db[1]==cause.m_symbol:
                            self.m_map.connect(cause.m_map,1)
                cause=cause.m_cause

    def buildingNewMap(self):
        if self.m_map==None:
            return False
        elif self.m_buildMode==False:
            return False
        else:
            # +[a]: +a(,_obj)->_obj
            if self.m_map.m_needed==None:
                return True
            # return True
        return False

    def needBuildRelation(self):
        if self.buildingNewMap():
            return True
        elif self.isFunctionPoint()!=0:
            return True
        return False
    
    def selfType(self):
        name=self.m_symbol.m_name
        if name=='':
            return "实链节"
        elif name[0]=='_':
            return "实万用链节"
        elif name[0]=='~':
            return "实否定链节"
        elif name[0]=='[' and name[-1]==']':
            return "虚链节"
        return "实链节"

    def isVirtual(self):
        name=self.m_symbol.m_name
        if len(name)>1 and name[0]=='[' and name[-1]==']':
            return True
        elif self.isSpaceRelation():
            return True
        else:
            return False

    def isPreDefined(self):
        name=self.m_symbol.m_name
        if name=='[is]' or name=='[eq]' or name=='[那]' or name=='[]':
            return True
        elif self.isSpaceRelation():
            return True
        else:
            return False

    def isSpecialRanger(self):
        name=self.m_symbol.m_name
        if name=='[is]' or name=='[那]':
            return True
        return False


    def isType(self,str_type):
        name=self.m_symbol.m_name
        if infoInStr('引用',str_type):
            if not self.isVirtual() or self.m_buildMode==True:
                return False
        if infoInStr('新建',str_type):
            if infoInStr('非新建',str_type):
                if self.m_buildMode==True:
                    return False
            elif self.m_buildMode==False:
                return False
        if infoInStr('动作',str_type):
            if not self.isVirtual() or self.m_buildMode==False:
                return False
        if infoInStr('内置',str_type):
            if not self.isPreDefined():
                return False
        if infoInStr('特殊范围',str_type):
            if not self.isSpecialRanger():
                return False
        if infoInStr('否定',str_type):
            if name=='' or name[0]!='~':
                return False
        if infoInStr('通用',str_type):
            if name=='' or name[0]!='_':
                return False
        if infoInStr('普通',str_type):
            # if name!='' and (name[0]=='~' or name[0]=='_'):
            #     return False
            if self.isVirtual():
                return False
        if infoInStr('端点',str_type):
            if infoInStr('非端点',str_type):
                if self.m_ranger==None:
                    return False
            elif self.m_ranger!=None:
                return False
        if infoInStr('回答',str_type):
            an_type=True
            if self.m_map==None or self.m_map.m_needed==self or self.m_map.m_needed==None:
                an_type=False
            if infoInStr('非回答',str_type):
                if an_type:
                    return False
            elif not an_type:
                return False
        if infoInStr('限制',str_type):
            if self.m_restricted==False:
                return False
        return True
        


    def isFunctionPoint(self):
        if self.m_symbol.m_name=='':
            return 0
        elif self.m_symbol.m_name=='[eq]' or self.m_symbol.m_name=='[同名]':
            return 1
        elif self.m_symbol.m_name=='[is]' or self.m_symbol.m_name=='[是]':
            return 1
        elif self.m_symbol.m_name=='[那]':
            return 1
        elif self.m_symbol.m_name=='[]':
            return 1
        elif self.isSpaceRelation():
            return 1
        elif self.m_symbol.m_name[0]=='[' and self.m_symbol.m_name[-1]==']':
            return 2
        return 0

    def isSpaceRelation(self):
        if self.m_buildMode==True:
            return False
        name=self.m_symbol.m_name
        if name=='[上面]' or name=='[下面]' or name=='[左面]' or name=='[右面]':
            return True
        elif name=='[正上面]' or name=='[正下面]' or name=='[正左面]' or name=='[正右面]':
            return True
        elif name=='[当地]':
            return True
        elif name=='[up]' or name=='[down]' or name=='[left]' or name=='[right]':
            return True
        elif name=='[Up]' or name=='[Down]' or name=='[Left]' or name=='[Right]':
            return True
        elif name=='[here]':
            return True
        return False

                
    def Reason_iterative(self,pool,list_new=None):
        if list_new==None:
            list_new=[]
        while True:
            [change,list_pt]=self.Reason_oneStep(pool)
            if self.m_stage==2:
                for clause in self.m_clause:
                    clause.Reason_iterative(pool)
            elif self.m_stage==3:
                for end in self.m_noe:
                    end.Reason_iterative(pool)
                for end in self.m_yese:
                    end.Reason_iterative(pool)
            elif self.m_stage==5:
                break
        return [self.m_reState,list_new]



    def isChosen(self):
        if self.m_cause==None:
            return False
        if self.m_cause.m_choose==False:
            return self in self.m_cause.m_noe
        else:
            return self in self.m_cause.m_yese

    def Reason_oneStep(self,pool):
        list_new=[]
        areaType=self.areaType()
        change=False
        
        if self.m_stage==0:
            if self.m_cause!=None:
                if self in self.m_cause.m_clause:
                    if self.m_cause.m_stage==2:
                        self.m_stage=1
                        change=True
                # else:
                #     if self.m_cause.m_stage==3 and self.isChosen():
                #         self.m_stage=1
                #         change=True
                #         # print(self.m_symbol.info(),'start!','The choose of the cause is:',self.m_cause.m_choose)

        if self.m_stage==1:
            while True:
                if self.stateSelf()!='blue':
                    self.newMap(pool,areaType,list_new)
                else:
                    self.m_interp=False
                # if self.m_map!=None:
                #     print('Map:',self.m_map.info(),self.stateSelf())
                change=True
                if self.stateRelation()==False:
                    continue
                elif self.stateSelf()=='red':
                    continue
                elif self.stateSelf()=='yellow':
                    self.m_stage=5
                    if self.m_no==False:
                        self.m_reState='dark yellow'
                        return [change,list_new]
                    else:
                        self.m_reState='dark green'
                        return [change,list_new]
                elif self.stateSelf()=='blue':
                    self.m_stage=1
                    return [change,list_new]
                else:
                    self.m_stage=2
                    break

        if self.m_stage==2:
            if self.m_clause==[]:
                self.m_choose=True
                self.m_stage=3
                change=True
            else:
                self.m_choose=self.m_clauseAnd
                keep=False
            for clause in self.m_clause:
                if self.m_clauseAnd==True:
                    if clause.m_reState=='dark yellow':
                        self.m_choose=False
                        self.m_stage=3
                        change=True
                        self.m_clauseOut=True
                        break
                    elif clause.m_reState=='':
                        keep=True
                else:
                    if clause.m_reState=='dark green':
                        self.m_choose=True
                        self.m_stage=3
                        change=True
                        self.m_clauseOut=True
                        break
                    elif clause.m_reState=='':
                        keep=True
            if self.m_clause!=[] and keep==False:
                self.m_stage=3
                change=True
                self.m_clauseOut=True

        if self.m_stage==3:
            # print(self.m_symbol.info(),'End type:',self.m_yesAnd)
            if self.m_choose==False:
                if self.m_noe==[]:
                    self.m_stage=1
                    change=True
                    return [change,list_new]

                i=self.m_eoi
                end=self.m_noe[i]
                if end.m_stage==0:
                    end.m_stage=1
                    change=True
                elif end.m_reState=='dark yellow':
                    if self.m_noAnd==True:
                        self.m_stage=1
                        change=True
                    else:
                        i+=1
                        change=True
                        if i==len(self.m_noe):
                            self.m_stage=1
                            self.m_eoi=0
                        else:
                            self.m_eoi=i
                elif end.m_reState=='dark green':
                    if self.m_noAnd!=True:
                        self.m_stage=4
                        change=True
                    else:
                        i+=1
                        change=True
                        if i==len(self.m_noe):
                            self.m_stage=4
                            self.m_eoi=0
                        else:
                            self.m_eoi=i


                # keep=False
                # for end in self.m_noe:
                #     if end.m_reState=='':
                #         keep=True
                #     elif self.m_noAnd==True:
                #         if end.m_reState=='dark yellow':
                #             self.m_stage=1
                #             change=True
                #             return [change,list_new]
                #     else:
                #         if end.m_reState=='dark green':
                #             self.m_stage=4
                #             change=True
                #             break
                # if self.m_stage==3 and keep==False:
                #     if self.m_noAnd==True:
                #         self.m_stage=4
                #         change=True
                #     else:
                #         self.m_stage=1
                #         change=True
                #         return [change,list_new]
            else:
                if self.m_yese==[] and self.m_noe==[]:
                    self.m_stage=4
                    change=True
                elif self.m_yese==[]:
                    self.m_stage=1
                    change=True
                    return [change,list_new]
                else:
                    i=self.m_eoi
                    end=self.m_yese[i]
                    if end.m_stage==0:
                        end.m_stage=1
                        change=True
                    elif end.m_reState=='dark yellow':
                        if self.m_yesAnd==True:
                            self.m_stage=1
                            change=True
                        else:
                            i+=1
                            change=True
                            if i==len(self.m_yese):
                                self.m_stage=1
                                self.m_eoi=0
                            else:
                                self.m_eoi=i
                    elif end.m_reState=='dark green':
                        if self.m_yesAnd!=True:
                            self.m_stage=4
                            change=True
                        else:
                            i+=1
                            change=True
                            if i==len(self.m_yese):
                                self.m_stage=4
                                self.m_eoi=0
                            else:
                                self.m_eoi=i


                    # keep=False
                    # for end in self.m_yese:
                    #     if end.m_reState=='':
                    #         keep=True
                    #     elif self.m_yesAnd==True:
                    #         if end.m_reState=='dark yellow':
                    #             self.m_stage=1
                    #             change=True
                    #             return [change,list_new]
                    #     else:
                    #         if end.m_reState=='dark green':
                    #             self.m_stage=4
                    #             change=True
                    #             break
                    # if keep==False and self.m_stage==3:
                    #     if self.m_yesAnd:
                    #         self.m_stage=4
                    #         change=True
                    #     else:
                    #         self.m_stage=1
                    #         change=True
                    #         return [change,list_new]

        if self.m_stage==4:
            # If clause isn't empty, collect them first
            if self.m_clauseNew!=[] or self.m_clauseOut==True:
                self.m_clauseCollect=True
            # the function points are collected, because they will be deleted after running as tmp points
            if (self.m_buildMode==True or self.isFunctionPoint()==1) and self.m_map!=None and self.m_map not in list_new:
                list_new.append(self.m_map)
            self.m_stage=5
            if self.m_no==True:
                self.m_reState='dark yellow'
                change=True
                return [change,list_new]
            else:
                self.m_reState='dark green'
                change=True
                return [change,list_new]

        return [change,list_new]




    def areaType(self):
        aType=True
        cause=self
        while True:
            if cause.m_no==True:
                aType=not aType
            if cause.m_cause==None:
                return aType
            else:
                cause=cause.m_cause
        


    # def Reason_oneStep(self,pool):
    #     list_new=[]
    #     areaType=self.areaType()
    #     change=False
        
    #     if self.m_stage==0:
    #         if self.m_cause!=None:
    #             if self in self.m_cause.m_clause:
    #                 if self.m_cause.m_stage==2:
    #                     self.m_stage=1
    #                     change=True
    #             else:
    #                 if self.m_cause.m_stage==3 and self.isChosen():
    #                     self.m_stage=1
    #                     change=True
    #                     # print(self.m_symbol.info(),'start!','The choose of the cause is:',self.m_cause.m_choose)

    #     if self.m_stage==1:
    #         while True:
    #             if self.stateSelf()!='blue':
    #                 self.newMap(pool,areaType,list_new)
    #             else:
    #                 self.m_interp=False
    #             # if self.m_map!=None:
    #             #     print('Map:',self.m_map.info(),self.stateSelf())
    #             change=True
    #             if self.stateRelation()==False:
    #                 continue
    #             elif self.stateSelf()=='red':
    #                 continue
    #             elif self.stateSelf()=='yellow':
    #                 self.m_stage=5
    #                 if self.m_no==False:
    #                     self.m_reState='dark yellow'
    #                     return [change,list_new]
    #                 else:
    #                     self.m_reState='dark green'
    #                     return [change,list_new]
    #             elif self.stateSelf()=='blue':
    #                 self.m_stage=1
    #                 return [change,list_new]
    #             else:
    #                 self.m_stage=2
    #                 break

    #     if self.m_stage==2:
    #         if self.m_clause==[]:
    #             self.m_choose=True
    #             self.m_stage=3
    #             change=True
    #         else:
    #             self.m_choose=self.m_clauseAnd
    #             keep=False
    #         for clause in self.m_clause:
    #             if self.m_clauseAnd==True:
    #                 if clause.m_reState=='dark yellow':
    #                     self.m_choose=False
    #                     self.m_stage=3
    #                     change=True
    #                     self.m_clauseOut=True
    #                     break
    #                 elif clause.m_reState=='':
    #                     keep=True
    #             else:
    #                 if clause.m_reState=='dark green':
    #                     self.m_choose=True
    #                     self.m_stage=3
    #                     change=True
    #                     self.m_clauseOut=True
    #                     break
    #                 elif clause.m_reState=='':
    #                     keep=True
    #         if self.m_clause!=[] and keep==False:
    #             self.m_stage=3
    #             change=True
    #             self.m_clauseOut=True

    #     if self.m_stage==3:
    #         # print(self.m_symbol.info(),'End type:',self.m_yesAnd)
    #         if self.m_choose==False:
    #             if self.m_noe==[]:
    #                 self.m_stage=1
    #                 change=True
    #                 return [change,list_new]
    #             keep=False
    #             for end in self.m_noe:
    #                 if end.m_reState=='':
    #                     keep=True
    #                 elif self.m_noAnd==True:
    #                     if end.m_reState=='dark yellow':
    #                         self.m_stage=1
    #                         change=True
    #                         return [change,list_new]
    #                 else:
    #                     if end.m_reState=='dark green':
    #                         self.m_stage=4
    #                         change=True
    #                         break
    #             if self.m_stage==3 and keep==False:
    #                 if self.m_noAnd==True:
    #                     self.m_stage==4
    #                     change=True
    #                 else:
    #                     self.m_stage=1
    #                     change=True
    #                     return [change,list_new]
    #         else:
    #             if self.m_yese==[] and self.m_noe==[]:
    #                 self.m_stage=4
    #                 change=True
    #             elif self.m_yese==[]:
    #                 self.m_stage=1
    #                 change=True
    #                 return [change,list_new]
    #             else:
    #                 keep=False
    #                 for end in self.m_yese:
    #                     if end.m_reState=='':
    #                         keep=True
    #                     elif self.m_yesAnd==True:
    #                         if end.m_reState=='dark yellow':
    #                             self.m_stage=1
    #                             change=True
    #                             return [change,list_new]
    #                     else:
    #                         if end.m_reState=='dark green':
    #                             self.m_stage=4
    #                             change=True
    #                             break
    #                 if keep==False and self.m_stage==3:
    #                     if self.m_yesAnd:
    #                         self.m_stage=4
    #                         change=True
    #                     else:
    #                         self.m_stage=1
    #                         change=True
    #                         return [change,list_new]

    #     if self.m_stage==4:
    #         # If clause isn't empty, collect them first
    #         if self.m_clauseNew!=[] or self.m_clauseOut==True:
    #             self.m_clauseCollect=True
    #         # the function points are collected, because they will be deleted after running as tmp points
    #         if (self.m_buildMode==True or self.isFunctionPoint()==1) and self.m_map!=None:
    #             list_new.append(self.m_map)
    #         self.m_stage=5
    #         if self.m_no==True:
    #             self.m_reState='dark yellow'
    #             change=True
    #             return [change,list_new]
    #         else:
    #             self.m_reState='dark green'
    #             change=True
    #             return [change,list_new]

    #     return [change,list_new]


        



    def build(self,code,points):
        wait_list=[]
        last=self
        connection=None
        exp='(->>|=>>|->|=>|{[ \t\n]*|[ \t\n]*}|,[ \t\n]*|;[ \t\n]*|:[ \t\n]*)'
        units=re.split(exp,code)
        for unit in units:
            if unit=='':
                continue
            elif unit=='->' or unit=='=>' or unit=='->>' or unit=='=>>':
                connection=unit
            elif unit[0]=='{':
                wait_list.append(['clause_splitting',last])
            elif unit[0]==':':
                wait_list.append(['end_splitting',last])
            elif unit[0]==',':
                last=wait_list[-1][1]
            elif unit[0]==';':
                if wait_list[-1][0]=='end_splitting':
                    wait_list.pop()
                if wait_list!=[]:
                    last=wait_list[-1][1]
            elif unit[-1]=='}':
                last=wait_list[-1][1]
                wait_list.pop()
            else:
                current=Karma(points[int(unit)])
                current.m_cause=last
                if connection=='->':
                    current.m_no=False
                    last.m_yese.append(current)
                elif connection=='->>':
                    current.m_no=False
                    last.m_noe.append(current)
                elif connection=='=>':
                    current.m_no=True
                    last.m_yese.append(current)
                elif connection=='=>>':
                    current.m_no=True
                    last.m_noe.append(current)
                else:
                    last.m_clause.append(current)
                connection=''
                last=current
            # print(wait_list)

    def info_cause(self):
        info=''
        karma=self
        while True:
            if karma.m_symbol!=None:
                info=karma.m_symbol.m_name+info
            if karma.m_cause==None:
                break
            if karma in karma.m_cause.m_yese:
                if karma.m_no==True:
                    info='=>'+info
                else:
                    info='->'+info
            elif karma in karma.m_cause.m_noe:
                if karma.m_no==True:
                    info='=>>'+info
                else:
                    info='->>'+info
            elif karma in karma.m_cause.m_clause:
                info='=='+info
            karma=karma.m_cause
        print(info)
        return info

    def allEffects(self):
        list_effects=[self]
        for karma in self.m_clause:
            list_effects+=karma.allEffects()
        for karma in self.m_noe:
            list_effects+=karma.allEffects()
        for karma in self.m_yese:
            list_effects+=karma.allEffects()
        # list_effects.append(self)
        return list_effects

    # def setAllBuildMode(self,mode,list_km):
    #     self.m_buildMode=mode
    #     for point in self.m_symbol.m_con:
    #         for karma in list_km:
    #             if karma.m_symbol==point:
    #                 karma.setAllBuildMode(mode,list_km)

    # one of causes provides map pool for this karma
    def setRangers(self,causes=None):
        connecting=None
        connected=None
        caseNo=100
        if causes==None:
            causes=[]
        # # word(,)
        # elif self.m_buildMode!=True and self.isFunctionPoint()==0:
        #     for cause in causes:
        #         # [pt]->word
        #         if cause.isFunctionPoint()!=0:
        #             # [pt]->word([pt],)
        #             # Why?
        #             if self.m_symbol.m_db[0]==cause.m_symbol or self.m_symbol.m_db[1]==cause.m_symbol:
        #                 connecting=cause
        #                 connected=None
        #                 break
        #             # elif cause.m_symbol.m_db[0]==self.m_symbol or cause.m_symbol.m_db[1]==self.m_symbol:
        #             #     connected=cause
        #             #     break
        #         elif cause.m_buildMode==True and order<1:
        #             # +cause(,self)->self(,)
        #             if cause.m_symbol.m_db[0]==self.m_symbol or cause.m_symbol.m_db[1]==self.m_symbol:
        #                 connected=cause
        #                 order=1
        #             # +cause(,)->self(,+cause)
        #             elif self.m_symbol.m_db[0]==cause.m_symbol or self.m_symbol.m_db[1]==cause.m_symbol:
        #                 connecting=cause
        #         # cause->self
        #         elif order<2:
        #             # cause(,self)
        #             if cause.m_symbol.m_db[0]==self.m_symbol or cause.m_symbol.m_db[1]==self.m_symbol:
        #                 connected=cause
        #                 order=2
        #             # self(,cause)
        #             elif self.m_symbol.m_db[0]==cause.m_symbol or self.m_symbol.m_db[1]==cause.m_symbol:
        #                 connecting=cause
        # word(,)
        elif self.isType('非新建普通链节'):
            for cause in causes:
                # cause(,self)
                if cause.m_symbol.m_db[0]==self.m_symbol or cause.m_symbol.m_db[1]==self.m_symbol:
                    if cause.isType('特殊范围'):
                        connected=cause
                        break
                    elif cause.isType('普通非新建') and caseNo>3:
                        connected=cause
                        caseNo=3
                    elif cause.isType('新建') and caseNo>5:
                        connected=cause
                        caseNo=5
                # self(cause,)
                elif self.m_symbol.m_db[0]==cause.m_symbol or self.m_symbol.m_db[1]==cause.m_symbol:
                    if cause.isType('引用') and caseNo>2:
                        connecting=cause
                        caseNo=2
                    elif cause.isType('普通非新建') and caseNo>4:
                        connecting=cause
                        caseNo=4
                    elif cause.isType('新建') and caseNo>6:
                        connecting=cause
                        caseNo=6
            if connected!=None:
                self.m_ranger=connected
            elif connecting!=None:
                self.m_ranger=connecting
                self.m_rangType=True
        
        # set next one except for [eq], and buildMode==True
        # if self.m_buildMode!=True and self.m_symbol.m_name!='' and self.m_symbol.m_name!='[eq]' and self.m_symbol.m_name!='[同名]':
        # if self.isFunctionPoint()==0 and self.m_buildMode!=True:
        # if self.isFunctionPoint()==0:                                       # a building point can be a ranger of an another point(Why?)(May because of new point can be a answer point)
        causes=causes[:]+[self]

        for con in self.m_clause:
            # for cause in causes:
            #     cause.m_symbol.print()
            con.setRangers(causes)
        for end in self.m_yese:
            end.setRangers(causes)
        for end in self.m_noe:
            end.setRangers(causes)

    def causeEnd(self):
        cause=self
        while cause.m_cause!=None:
            cause=cause.m_cause
        return cause

    def allCauses(self):
        cause=self
        list_km=[]
        while cause.m_cause!=None:
            cause=cause.m_cause
            list_km.append(cause)
        return list_km

    def addKarma(self,karma,con_type='肯定'):
        while karma.m_cause!=None:
            karma=karma.m_cause
        if con_type=="clause" or con_type=="从句":
            self.m_clause.append(karma)
        elif con_type=="no" or con_type=="否定":
            self.m_noe.append(karma)
        else:
            self.m_yese.append(karma)
        karma.m_cause=self

    def __str__(self) -> str:
        return self.info_karma()

    def info_karma(self,info='',head=0,type_info=0):
        if info=='' and self.m_no==True:
            info='[]=>'
        if self.m_ranger!=None and type_info==0:
            ranger=self.m_ranger.m_symbol.info("不显示位置不显示内容")
            info+='['+ranger+']'
            head+=len(ranger)+2
        # if self.m_buildMode==True:
        #     info+='+'
        #     head+=1
            
        info+=self.m_symbol.info("不显示位置不显示内容")
        head+=len(self.m_symbol.info("不显示位置不显示内容"))

        if self.m_clause!=[]:
            info+='{'
            head+=1
            for clause in self.m_clause:
                info+='\n'+''.rjust(head)
                info=clause.info_karma(info,head,type_info)
                if clause!=self.m_clause[-1]:
                    info+=','
            info+='\n'+'}'.rjust(head-1)
        n=0
        if len(self.m_noe)+len(self.m_yese)>1:
            info+=':'
        for end in self.m_yese:
            if n==0:
                if end.m_no==False:
                    info+='->'
                else:
                    info+='=>'
                info=end.info_karma(info,head+2,type_info)
                n+=1
            else:
                if end.m_no==False:
                    info+='\n'+'->'.rjust(head+2)
                else:
                    info+='\n'+'=>'.rjust(head+2)
                info=end.info_karma(info,head,type_info)
            if end!=self.m_yese[-1] or self.m_noe!=[]:
                info+=','
        for end in self.m_noe:
            if n==0:
                if end.m_no==False:
                    info+='->>'
                else:
                    info+='=>>'
                info=end.info_karma(info,head+3,type_info)
                n+=1
            else:
                if end.m_no==False:
                    info+='\n'+'->>'.rjust(head+3)
                else:
                    info+='\n'+'=>>'.rjust(head+3)
                info=end.info_karma(info,head,type_info)
            if end!=self.m_noe[-1]:
                info+=','

        return info
                

        
        
def printPtList(list_pt):
    info_pt='['
    for pt in list_pt:
        info_pt+=pt.info(show_info='不显示文本')
        if pt!=list_pt[-1]:
            info_pt+=', '
        else:
            info_pt+=';'
    info_pt+=']'
    print(info_pt)




def infoInStr(string,str_info):
    a=str_info.find(string)
    return a!=-1




if __name__=='__main__':
    result=infoInStr('新建','新建')
    print(result)