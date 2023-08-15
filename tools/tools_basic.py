import sys, re, logging
if __name__=='__main__':
    sys.path.append(sys.path[0]+'\\..')
from body.bone import NetP
from body.soul import Karma
import platform

# from pt_python import CBS,chirp,EMSolver,formulas,opticalPath,optics,physicalConstants,physicalPlot,plot2D,plot3D


def printNList(list_pt):
    string=''
    n=0
    print(list_pt)
    for point in list_pt:
        string=string+str(n)+'.'+point.info()+'\n'
        n=n+1
    print(string)
        

def writeStdCode(karmas,list_pt):
    code=''
    i=0
    for point in list_pt:
        point.m_name+='#'+str(i)
        i=i+1
    for point in list_pt:
        code+=point.info_saving()+'\n'
    for karma in karmas:
        code+='\n_____________________________\n'
        [text,list_pt]=writeStdCode_karma(karma,list_pt)
        code+=text
    for point in list_pt:
        point.m_name=re.sub(r'#.*$',"",point.m_name)
    return code

def writeStdCode_karma(karma,list_pt):
    karma_code=''

    if karma==None:
        return [karma_code,list_pt]
    
    if karma.m_symbol not in list_pt:
        list_pt.append(karma.m_symbol)
    if karma.m_buildMode==True:
        karma_code+='+'
    karma_code+=str(list_pt.index(karma.m_symbol))

    if karma.m_clause!=[]:
        if karma.m_clauseAnd==False:
            karma_code+='|'
        karma_code+='{'
        for clause in karma.m_clause:
            [text,list_pt]=writeStdCode_karma(clause,list_pt)
            karma_code+=text
            if clause!=karma.m_clause[-1]:
                karma_code+=','
        karma_code+='}'

    if len(karma.m_yese)+len(karma.m_noe)>1:
        if karma.m_yesAnd==True:
            karma_code+='&'
        karma_code+=':'
    for end in karma.m_yese:
        if end.m_no==False:
            karma_code+='->'
        else:
            karma_code+='=>'
        [text,list_pt]=writeStdCode_karma(end,list_pt)
        karma_code+=text
        if end!=karma.m_yese[-1]:
            karma_code+=','
    for end in karma.m_noe:
        if end.m_no==False:
            karma_code+='->>'
        else:
            karma_code+='=>>'
        [text,list_pt]=writeStdCode_karma(end,list_pt)
        karma_code+=text
        if end!=karma.m_noe[-1]:
            karma_code+=','
    if len(karma.m_yese)+len(karma.m_noe)>1:
        karma_code+=';'

    return [karma_code,list_pt]


# def listToDict(list_pt):
#     dict_pt={}
#     for point in list_pt:
#         name=point.m_name
#         term=dict_pt.get(name,[])
#         term.append(point)
#         dict_pt.update({name:term})
#     return dict_pt


def listToDict(list_pt):
    dict_pt={}
    for point in list_pt:
        name=point.m_name
        if len(name)>2 and name[0]=='[' and name[-1]==']':
            name=name[1:-1]
        term=dict_pt.get(name,[])
        term.append(point)
        dict_pt.update({name:term})
    return dict_pt
    
def listToKeyDict(list_pt):
    dict_pt={}
    for point in list_pt:
        dict_pt.update({point.m_name:point})
    return dict_pt

def dictToList(dict_pt):
    list_pt=[]
    for term in dict_pt:
        list_pt+=dict_pt[term]
    return list_pt

def ptToDict(point):
    dict_con={}
    for con in point.m_con:
        if con.m_db[0]==point:
            dict_con.update({con.m_name:con})
    return dict_con

def ptDeToDict(point):
    dict_de={}
    for con in point.m_con:
        if con.m_name=='的' and con.m_db[0]==point and con.m_db[1]!=None:
            dict_de.update({con.m_db[1].m_name:con.m_db[1]})
    return dict_de

            
def runKarmaByOneStep(karma,pool,n=1):
    head=karma
    list_km=karma.allEffects()
    if karma.m_stage==0:
        karma.m_stage=1
    for i in range(n):
        for km in list_km:
            change,list_new=km.Reason_oneStep(pool)
            if change:
                break
        showKarmaState(karma)
        print('__________')

def showKarmaState(karma):
    list_km=karma.allEffects()
    for km in list_km:
        print(km.m_symbol.m_name,km.m_stage)

def pointsInChain(karma):
    list_km=karma.allEffects()
    list_pt=[]
    for km in list_km:
        list_pt.append(km.m_symbol)
    return list_pt

class empty: pass
# translate from pt to variable
def pt2Var(point,device=None):
    if point.m_name=='list':
        device=getPointByFormat(point,'list')
        point.m_dev=device
        return device
    for con in point.m_con:
        if con.m_db[0]!=point or con.m_db[1]==None:
            continue
        elif con.m_name[0:2]=='m_':
            if device==None:
                device=empty()
                device.m_self=point
            dev_next=pt2Var(con.m_db[1],con.m_db[1].m_dev)
            if dev_next==None:
                setattr(device,con.m_name,con.m_db[1])
            else:
                setattr(device,con.m_name,dev_next)
        elif con.m_db[1].m_name=='function':
            eng={}
            pythonCodeEval(eng,con.m_db[1].m_text)
            f=eng.get(con.m_name,None)
            if f==None:
                continue
            if device==None:
                device=empty()
                device.m_self=point
            setattr(device,con.m_name,f)
    point.m_dev=device
    return device


def getAllSystemPt(point,list_pt=None):
    if list_pt==None:
        list_pt=[]
    list_pt+=[point]
    for con in point.m_con:
        if con.m_permission==0 and con.m_db[0]==point:
            list_pt.append(con)
            if con.m_db[1]!=None and con.m_db[1] not in list_pt:
                if con.m_db[1].m_permission==0:
                    getAllSystemPt(con.m_db[1],list_pt)
                else:
                    list_pt+=[con.m_db[1]]
            # if con.m_db[1].m_permission==0:
            #     list_pt+=getAllSystemPt(con.m_db[1])
    return list_pt

def getPoint(point,key,default='',con_permission=0,pt_permission=-1):
    dict_pt=ptToDict(point)
    con=dict_pt.get(key,None)
    if con==None:
        if default!=None:
            con=NetP(key).con(point,NetP(default))
        else:
            return None
    con.m_permission=con_permission
    pt=con.m_db[1]
    if pt_permission==-1:
        pass
    else:
        pt.m_permission=pt_permission
    return pt

def getVarFromPt(point,key,list_pt=None):
    dict_pt=ptDeToDict(point)
    con=dict_pt.get(key,None)
    if con==None:
        de=NetP('的').con(point,NetP(key))
        con=de.m_db[1]
        de.m_permission=0
        con.m_permission=0
        if list_pt!=None:
            list_pt.append(de)
            list_pt.append(con)
    return con


def setPoint(point,key,value):
    for con in point.m_con:
        if con.m_db[0]==point and con.m_name==key:
            if value!=0:
                con.con(point,value)
            else:
                con.delete()
                del con
            return
    if value!=0:
        connect=NetP(key).con(point,value)
        connect.m_permission=0

def getPointByFormat(point,type_pt):
    list_pt=[]
    set_pt=set()
    if point==None:
        return list_pt
    if type_pt=='list':
        for con in point.m_con:
            if con.m_name=='的' and con.m_db[0]==point:
                if  con.m_db[1]!=None:
                    list_pt.append(con.m_db[1])
                    # con.m_permission=0
                else:
                    con.delete()
    elif type_pt=='set':
        for con in point.m_con:
            if con.m_name=='的' and con.m_db[0]==point:
                if  con.m_db[1]!=None:
                    set_pt.update([con.m_db[1]])
                    # con.m_permission=0
                else:
                    con.delete()
        list_pt=list(set_pt)
    return list_pt

def setPointByFormat(point,type_pt,value=None):
    if type_pt=='list.append':
        con=NetP('的').con(point,value)
        con.m_permission=0
    elif type_pt=='list.insertHead':
        con=NetP('的').con(point,value)
        con.m_permission=0
        point.m_con.remove(con)
        point.m_con.insert(0,con)
    elif type_pt=='list.+=':
        for pt in value:
            con=NetP('的').con(point,pt)
            con.m_permission=0
    elif type_pt=='list.clear':
        list_del=[]
        for con in point.m_con:
            if con.m_name=='的' and con.m_db[0]==point and con.m_db[1]!=None:
                list_del.append(con)
        for pt in list_del:
            pt.delete()
        del list_del[:]
    elif type_pt=='list.pop':
        list_pt=getPointByFormat(point,'list')
        pt=list_pt[-1]
        for con in pt.m_con:
            if con.m_name=='的' and con.m_db[0]==point and con .m_db[1]==pt:
                con.delete()
                del con
        del pt
    elif type_pt=='list.remove':
        list_pt=getPointByFormat(point,'list')
        if value in list_pt:
            for con in value.m_con:
                if con.m_name=='的' and con.m_db[0]==point and con .m_db[1]==value:
                    con.delete()
                    del con
    elif type_pt=='list.removeByName':
        list_pt=getPointByFormat(point,'list')
        for pt in list_pt:
            if pt.m_name==value:
                setPointByFormat(point,'list.remove',pt)
                break
    elif type_pt=='list.replace':
        list_pt=getPointByFormat(point,'list')
        for pt in list_pt:
            if pt.m_name==value.m_name:
                setPointByFormat(point,'list.remove',pt)
                break
        setPointByFormat(point,'list.append',value)

def checkPointByFormat(point,type_pt,value=None):
    if type_pt=='list.isempty':
        list_pt=getPointByFormat(point,'list')
        return list_pt==[]
    elif type_pt=='list.in':
        list_pt=getPointByFormat(point,'list')
        return value in list_pt
    return True

def checkPtsRelation(pt,relationship,value):
    dict_pt=ptToDict(pt)
    if relationship=='property':
        return value in dict_pt
    

def printPointByFormat(point,type_pt):
    if type_pt=='list':
        list_pt=getPointByFormat(point,type_pt)
        print([pt.info() for pt in list_pt])

def printPoint(point):
    print(point.info(),'{')
    for con in point.m_con:
        if con.m_db[0]==point:
            print(con.m_name+':',con.m_db[1].info())
    print('}')

def printPtList(list_pt):
    info_pt='['
    for pt in list_pt:
        info_pt+=pt.info("不显示文本")
        if pt!=list_pt[-1]:
            info_pt+=', '
    info_pt+=']'
    print(info_pt)

def readFile(fileName):
    if platform.uname()[0]=='Linux':
        fileName=fileName.replace('\\','/')
    f=open(fileName,encoding='utf-8')
    try:
        textUtf=f.read()
        f.close()
        if platform.uname()[0]=='Linux':
            textUtf=textUtf.replace('\r\n','\n')
        return textUtf
    except:
        f.close()
    f=open(fileName,encoding='gbk')
    try:
        textGbk=f.read()
        f.close()
        if platform.uname()[0]=='Linux':
            textGbk=textGbk.replace('\r\n','\n')
        return textGbk
    except:
        f.close()
        return ''

def writeFile(fileName,text,cover=True):
    if fileName==None:
        return
    if platform.uname()[0]=='Linux':
        fileName=fileName.replace('\\','/')
    try:
        # f=open(fileName,'r')
        # text_old=f.read()
        # f.close()
        text_old=readFile(fileName)
    except Exception as e:
        logging.exception(e)
        text_old=''
    try:
        if cover:
            f=open(fileName,'w',encoding='utf-8')
        else:
            f=open(fileName,'a',encoding='utf-8')
    except:
        print('Error! Invalid file address!')
        return
    try:
        if platform.uname()[0]=='Linux':
            text=text.replace('\n','\r\n')
        f.write(text)
    except Exception as e:
        f.write(text_old)
        print("Save failed!")
        logging.exception(e)
    f.close()


def copyKarma(karma):
    list_km=karma.allEffects()
    i=0
    for km in list_km:
        km.m_symbol.m_name+='#'+str(i)
        i+=1
    info_str=karma.info_karma(type_info=1)
    for km in list_km:
        j=km.m_symbol.m_name.rfind('#')
        km.m_symbol.m_name=km.m_symbol.m_name[0:j]
    karmas_copy=readSubCode_tokener(info_str)
    return karmas_copy[0]

def karmaToStr(karma):
    list_km=karma.allEffects()
    i=0
    for km in list_km:
        km.m_symbol.m_name+='#'+str(i)
        i+=1
        if km.m_buildMode==True:
            km.m_symbol.m_name='+'+km.m_symbol.m_name
    info_str=karma.info_karma(type_info=1)
    for km in list_km:
        j=km.m_symbol.m_name.rfind('#')
        km.m_symbol.m_name=km.m_symbol.m_name[0:j]
        if km.m_buildMode==True:
            km.m_symbol.m_name=km.m_symbol.m_name[1:]
    return info_str


def newKarmaOnPts(list_pt,type_new=False):
    list_km=[]
    for pt in list_pt:
        km=Karma(pt)
        if list_km!=[]:
            list_km[-1].m_yese.append(km)
            km.m_cause=list_km[-1]
        list_km.append(km)
        km.m_buildMode=type_new
    return list_km

def insertPtIntotKarma_back(km0,netP):
    km_new=Karma(netP)
    if len(netP.m_name)>1 and netP.m_name[0]=='+':
        netP.m_name=netP.m_name[1:]
        km_new.m_buildMode=True
    for km in km0.m_clause:
        km.m_cause=km_new
    for km in km0.m_yese:
        km.m_cause=km_new
    for km in km0.m_noe:
        km.m_cause=km_new
    km_new.m_clause=km0.m_clause
    km_new.m_yese=km0.m_yese
    km_new.m_noe=km0.m_noe
    km0.m_yese=[km_new]
    km0.m_noe=[]
    km_new.m_cause=km0

def insertPtIntotKarma_front(km0,netP):
    km_new=Karma(netP)
    if len(netP.m_name)>1 and netP.m_name[0]=='+':
        netP.m_name=netP.m_name[1:]
        km_new.m_buildMode=True
    if km0.m_cause!=None:
        cause=km0.m_cause
        km_new.m_cause=cause
        if km0 in cause.m_clause:
            cause.m_clause.remove(km0)
            cause.m_clause.append(km_new)
        elif km0 in cause.m_yese:
            cause.m_yese.remove(km0)
            cause.m_yese.append(km_new)
        elif km0 in cause.m_noe:
            cause.m_noe.remove(km0)
            cause.m_noe.append(km_new)
        else:
            print("Warning! The karma:"+km0.m_symbol.info()+", has a weird cause karma.")
    km0.m_cause=km_new
    km_new.m_yese=[km0]
    if km0.m_no==True:
        km0.m_no=False
        km_new.m_no=True
    
def insertPtIntotKarma(km0,netP):
    if km0.m_symbol.m_db[0]==netP:
        otherP=km0.m_symbol.m_db[1]
    elif km0.m_symbol.m_db[1]==netP:
        otherP=km0.m_symbol.m_db[0]
    else:
        return
    if km0.isType('新建') or km0.m_symbol.m_name=='[那]':
        insertPtIntotKarma_back(km0,netP)
    elif km0.isType('普通非新建') or km0.m_symbol.m_name=='[is]':
        if otherP==None or otherP.m_master==None:
            insertPtIntotKarma_back(km0,netP)
        elif otherP.m_master in km0.allCauses():
            insertPtIntotKarma_back(km0,netP)
        else:
            insertPtIntotKarma_front(km0,netP)
    elif km0.isType('引用'):
        insertPtIntotKarma_front(km0,netP)
    




def runCode(code,list_pt):
    try:
        karmas=readSubCode_tokener(code)
    except:
        return []
    pool=listToDict(list_pt)
    results=[]
    for karma in karmas:
        karma.m_stage=1
        result,list_new=karma.Reason_iterative(pool)
        results.append(result)
    return [results,karmas]
    
def runKarma(karma,list_pt):
    pool=listToDict(list_pt)
    karma.m_stage=1
    result,list_new=karma.Reason_iterative(pool)
    return result


def codeBlock(code):
    try:
        print(code)
        var={}
        exec(code,{},var)
        return var['result']
    except Exception as e:
        print("Error! Something is wrong when compiling the code.")
        logging.exception(e)
    return None

def pythonCodeEval(eng,code):
    try:
        # exec(code,globals(),eng)
        exec(code,eng)
    except Exception as e:
        logging.exception(e)
        return False
    return True


####################################################################################

def karma2Pts(karma,list_pt):
    pt_km=NetP('链节')
    list_pt.append(pt_km)
    km=karma
    pt_con=NetP('m_symbol').con(pt_km,km.m_symbol)
    list_pt.append(pt_con)
    list_pt.append(km.m_symbol)
    for clause in km.m_clause:
        pt_cla=karma2Pts(clause,list_pt)
        pt_con1=NetP('从句').con(pt_km,pt_cla)
        list_pt.append(pt_con1)
    list_end=km.m_yese+km.m_noe
    for end in list_end:
        pt_end=karma2Pts(end,list_pt)
        pt_con2=NetP('因果').con(pt_km,pt_end)
        list_pt.append(pt_con2)
    return pt_km

    



############################### grammar of karma ###################################
class NetPStack:
    def __init__(self):
        self.m_builtStack=[{}]
        self.m_undefinedStack=[{}]

    def popBuilt(self):
        return self.m_builtStack.pop()

    def popUndefined(self):
        return self.m_undefinedStack.pop()

    def pushBuilt(self,built):
        self.m_builtStack.append(built)

    def pushUndefined(self,undefined):
        self.m_undefinedStack.append(undefined)

    def enterClause(self):
        self.m_builtStack.append(self.m_builtStack[-1].copy())
        self.m_undefinedStack.append(self.m_undefinedStack[-1].copy())

    def leaveClause(self):
        if len(self.m_undefinedStack)==1:
            if self.m_undefinedStack[-1]!={}:
                # print('\n\n\nWarning! Undefined net point in the main karma.\nUndefined stack:',self.m_undefinedStack[-1])
                for term in self.m_undefinedStack[-1]:
                    pt=self.m_undefinedStack[-1][term]
                    if pt.m_master==None:
                        km_head=pt.m_con[0].m_master
                        insertPtIntotKarma(km_head,pt)
        elif len(self.m_undefinedStack[-1])>len(self.m_undefinedStack[-2]):
            # print('\n\n\nWarning! Undefined net point in some clauses.\nUndefined stack:',self.m_undefinedStack[-1])
            for term in self.m_undefinedStack[-1]:
                if term not in self.m_undefinedStack[-2]:
                    pt=self.m_undefinedStack[-1][term]
                    if pt.m_master==None:
                        km_head=pt.m_con[0].m_master
                        insertPtIntotKarma(km_head,pt)
        self.m_builtStack.pop()
        self.m_undefinedStack.pop()

    def popUndefinedName(self,name):
        for stack in self.m_undefinedStack:
            stack.pop(name)

    def buildNetP(self,name,con0_name='',con1_name=''):
        recent=self.m_builtStack[-1]
        undefined=self.m_undefinedStack[-1]

        point=undefined.get(name,None)
        if point==None:
            point=NetP(re.sub(r'#.*$','',name))
            recent.update({name:point})
        else:
            # self.popUndefinedName(name)
            undefined.pop(name)

        if con1_name!='':
            con1=recent.get(con1_name,None)
            if con1==None:
                con1=NetP(re.sub(r'#.*$','',con1_name))
                recent.update({con1_name:con1})
                undefined.update({con1_name:con1})
            point.connect(con1,1)
        if con0_name!='':
            con0=recent.get(con0_name,None)
            if con0==None:
                con0=NetP(re.sub(r'#.*$','',con0_name))
                recent.update({con0_name:con0})
                undefined.update({con0_name:con0})
            point.connect(con0,0)
        return point

# def removeComment(code):
#     while True:
#         if len(code)==0:
#             return code,False
#         elif code[0]=='#':
#             code=re.sub(r'^#.*','',code)
#         elif code[0:3]=='"""':
#             code=code[3:]
#             while True:
#                 if len(code)<3:
#                     code=''
#                     break
#                 elif code[0:3]=='"""':
#                     break
#                 else:
#                     code=re.sub(r'^.*\n?','',code)
#             code=code[3:]
#         else:
#             return code,False
#     return code,True

def removeComment(code):
    if len(code)==0:
        return code,False
    elif code[0]=='#':
        code=re.sub(r'^#.*','',code)
    elif code[0:3]=='"""':
        code=code[3:]
        while True:
            if len(code)<3:
                code=''
                break
            elif code[0:3]=='"""':
                break
            else:
                code=re.sub(r'^.*\n?','',code)
        code=code[3:]
    else:
        return code,False
    return code,True


# Quick build point:
# Only use for building totally ordered pool(TOP)
# If there is a point dev#notNum(,), then it's not a TOP.
# If there is a point pt#num(pt2#notNum,), then the point is invalid and will be deleted. 
def buildPoints_quick(code):
    list_pt=[]
    dict_con={}
    list_del=[]

    code=re.sub(r'^[ \t\n]*','',code)
    L=len(code)
    progress=0
    N=0
    while code!='':
        code,netP,n0,n1,del_flag=netPToken_quick(code)
        list_pt.append(netP)
        progress=(L-len(code))/L*100
        if progress >= N:
            print("进度: %.2f"%(progress)+"%")
            N+=10
        code=re.sub(r'^[ \t\n;]*','',code)
        if n0!=None or n1!=None:
            dict_con.update({netP:[n0,n1]})
        if del_flag:
            list_del.append(len(list_pt)-1)
    
    for pt in dict_con:
        n0,n1=dict_con[pt]
        if n0!=None:
            pt0=list_pt[n0]
            pt.con(pt0,0)
        if n1!=None:
            pt1=list_pt[n1]
            pt.con(0,pt1)

    if len(list_del)>0:
        print('There are %d invalid points!'%(len(list_del)))
        list_del.reverse()
        for i in list_del:
            print('Deleting %s...'%(list_pt[i].info()))
            list_pt.pop(i)
    return list_pt


def netPToken_quick(code):
    title=r'^[\w \[\]~#.+=\-^/*\\!<\']*|^\[>=?\]'
    order=r'#.*$'

    name=re.match(title,code).group()
    code=re.sub(title,'',code)
    if name=='':
        print('\n\n\nError! Invalid name.\nCode:',code)
        raise Exception('Error! Invalid name.')
    if name[-1]=='=' or name[-1]=='-':
        if len(code)>0 and code[0]=='>':
            code=name[-1]+code
            name=name[0:-1]
    con0_name=''
    con1_name=''
    text=''
    if code!='' and code[0]=='\"':
        code=code[1:]
        [code,text]=textToken(code)
        if code=='' or code[0]!='\"':
            print(code)
            raise Exception('Error! Unbalanced quote!')
        code=code[1:]
    if code!='' and code[0]=='(':
        code=code[1:]
        con0_name=re.match(title,code).group()
        code=re.sub(title,'',code)
        if code=='' or code[0]!=',':
            print(code)
            raise Exception('Error! Ilegal net point format. A net point must be title"text"(title,title)')
        code=code[1:]
        con1_name=re.match(title,code).group()
        code=re.sub(title,'',code)
        if code=='' or code[0]!=')':
            raise Exception('Error! Unbalanced bracket in a net point format!')
        code=code[1:]
    if name=='':
        # 为什么不能直接用下面这句话? 
        # raise Exception('Error! There is a point without a name!')
        print('Warning! There is a point without a name!')
    
    # If there is a point dev#notNum(,), then it's not a TOP.
    n=re.search(order,name)
    if n==None:
        raise Exception('Error! It\'s not a TOP.')
    else:
        n=n.group()[1:]
        int(n)

    name=re.sub(order,'',name)
    netP=NetP(name,text)

    posFormat=r'^\[(-?\d+), *(-?\d+)\]'
    pos=re.findall(posFormat,code)
    if pos!=[]:
        x=int(pos[0][0])
        y=int(pos[0][1])
        netP.m_pos=[x,y]
        code=re.sub(r'^\[-?\d+, *-?\d+\]','',code)

    del_flag=False

    n0=None
    try:
        if con0_name!='':
            str_n0=re.search(order,con0_name).group()
            if len(str_n0)>1:
                n0=int(str_n0[1:])
    except:
        print('Warning! The %s(%s,%s) connects an invalid point'%(name,con0_name,con1_name))
        del_flag=True

    n1=None
    try:
        if con1_name!='':
            str_n1=re.search(order,con1_name).group()
            if len(str_n1)>1:
                n1=int(str_n1[1:])
    except:
        print('Warning! The %s(%s,%s) connects an invalid point'%(name,con0_name,con1_name))
        del_flag=True

    return [code,netP,n0,n1,del_flag]



# User api:
def readSubCode_tokener(code):
    list_karma=[]
    # new comment
    # code=re.sub(r'^\n*"""(.*\n?)*"""','',code)
    # WARNING! This is a very bad and wrong way to make comment.
    # For example: point"\n%". It will make the file crash.
    # Never use it!
    # code=re.sub(r'\n%.*\n','\n',code)
    while code!='':
        code=re.sub(r'^[ \t\n]*','',code)
        if code=='':
            break
        code,result=removeComment(code)
        if result==True:
            continue
        else:
            [code,karma,pointStack]=chainToken(code)
            pointStack.leaveClause()
            karma=karma.causeEnd()
            karma.setRangers()
            list_karma.append(karma)
            if code!='' and code[0]==';':
                code=code[1:]
    return list_karma

def buildPoints_tokener(code):
    list_pt=[]
    # WARNING! This is a very bad and wrong way to make comment.
    # For example: point"\n%". It will make the file crash.
    # Never use it!
    # code=re.sub(r'\n%.*\n','\n\n',code)
    code=re.sub(r'^[ \t\n]*','',code)
    pointStack=NetPStack()
    L=len(code)
    progress=0
    N=0
    while code!='':
        code,netP,pointStack=netPToken(code,pointStack)
        list_pt.append(netP)
        progress=(L-len(code))/L*100
        if progress >= N:
            print("进度: %.2f"%(progress)+"%")
            N+=10
        code=re.sub(r'^[ \t\n;]*','',code)
    return list_pt

def divideSents_tokener(code):
    list_sent=[]
    while code!='':
        code=re.sub(r'^[ \t\n]*','',code)
        if code=='':
            break
        code,result=removeComment(code)
        if result==True:
            continue
        
        code_keep=code
        [code,karma,pointStack]=chainToken(code)
        si=code_keep.rfind(code)
        text=code_keep[0:si]
        if code!='' and code[0]==';':
            code=code[1:]
        sent=NetP(karma.m_symbol.m_name,text)
        list_sent.append(sent)
    return list_sent

########

def chainToken(code,pointStack=None):
    if pointStack==None:
        pointStack=NetPStack()
    [code,karma,pointStack]=karmaToken(code,pointStack)
    if code=='' or code[0]==';' or code[0]=='\n' or code[0]=='}':
        return [code,karma,pointStack]
    elif code[0]==',':
        # pointStack.leaveClause()
        return [code,karma,pointStack]
    elif code[0]==':':
        code=code[1:]
        # pointStack.enterClause()
        [code,karma,pointStack]=splitToken(code,karma,pointStack)
    elif code[0]=='|' or code[0]=='&':
        typeSub=code[0]
        code=code[1:]
        if code!='' and code[0]==':':
            # pointStack.enterClause()
            if typeSub=='|':
                karma.m_noAnd=False
                karma.m_yesAnd=False
            else:
                karma.m_noAnd=True
                karma.m_yesAnd=True
            code=code[1:]
            [code,karma,pointStack]=splitToken(code,karma,pointStack)
    else:
        [code,typeCon]=conToken(code)
        [code,effect,pointStack]=chainToken(code,pointStack)
        buildRelation(karma,typeCon,effect)
    return [code,karma,pointStack]


def conToken(code):
    while len(code)>3 and code[0:3]=='...':
        code=re.sub(r'^\.\.\..*[\n\t ]*','',code)
        # code,result=removeComment(code)
        # code=re.sub(r'^[\n\t ]*','',code)
    code=re.sub(r'^[ \t]*','',code)
    if len(code)>2 and code[0:3]=='->>':
        typeCon=code[0:3]
        code=code[3:]
    elif len(code)>2 and code[0:3]=='=>>':
        typeCon=code[0:3]
        code=code[3:]
    elif len(code)>1 and code[0:2]=='->':
        typeCon=code[0:2]
        code=code[2:]
    elif len(code)>1 and code[0:2]=='=>':
        typeCon=code[0:2]
        code=code[2:]
    else:
        print('\n\n\nIllegal connection symbol!\nCode:',code)
        raise Exception('Illegal connection symbol!')
    code=re.sub(r'^[ \t]*','',code)
    return [code,typeCon]

def clauseToken(code,karma,pointStack):
    pointStack.enterClause()
    while True:
        code=re.sub(r'^[ \t\n]*','',code)
        if code=='':
            raise Exception('Error! Unbalanced bracket!')
        elif code[0]=='}':
            break
        else:
            [code,clause,pointStack]=chainToken(code,pointStack)
            karma.m_clause.append(clause)
            clause.m_cause=karma
            if code!='' and code[0]!=',':
                break
            elif code!='':
                code=code[1:]
    pointStack.leaveClause()
    return [code,karma,pointStack]

def splitToken(code,karma,pointStack):
    while True:
        code=re.sub(r'^[ \t\n]*','',code)
        [code,typeCon]=conToken(code)
        [code,effect,pointStack]=chainToken(code,pointStack)
        buildRelation(karma,typeCon,effect)
        code=re.sub(r'^[ \t\n]*','',code)
        if code=='' or code[0]==';' or code[0]=='}':
            break
        elif code[0]!=',':
            print('\n\n\n\nError! Ilegal splitting type!\nCode:',code)
            raise Exception('Error! Ilegal splitting type!')
        else:
            code=code[1:]
    return [code,karma,pointStack]

def karmaToken(code,pointStack):
    if code=='':
        raise Exception('Error! Invalid karma detected!')
    buildType=False
    karma=None
    if code[0]=='+':
        buildType=True
    [code,netP,pointStack]=netPToken(code,pointStack)
    karma=Karma(netP)
    if buildType==True and netP.m_name!='+':
        netP.m_name=netP.m_name[1:]
        karma.m_buildMode=True
    if code!='' and code[0]=='{':
        code=code[1:]
        [code,karma,pointStack]=clauseToken(code,karma,pointStack)
        code=re.sub(r'^[\n\t ]*','',code)
        if code=='' or code[0]!='}':
            print('\n\n\nError! Unbalanced bracket.\nCode:',code)
            raise Exception('Error! Unbalanced bracket.')
        else:
            code=code[1:]
    elif code!='' and (code[0]=='|' or code[0]=='&'):
        typeSub=code[0]
        code=code[1:]
        if code!='' and code[0]=='{':
            if typeSub=='|':
                karma.m_clauseAnd=False
            else:
                karma.m_clauseAnd=True
            code=code[1:]
            [code,karma,pointStack]=clauseToken(code,karma,pointStack)
            code=re.sub(r'^[\n\t ]*','',code)
            if code=='' or code[0]!='}':
                raise Exception('Error! Unbalanced bracket.')
            else:
                code=code[1:]
        # ??????
        else:
            code=typeSub+code
    return [code,karma,pointStack]

def netPToken(code,pointStack):
    title=r'^[\w \[\]~#.+=\-^/*\\!<\']*|^\[>=?\]'
    name=re.match(title,code).group()
    code=re.sub(title,'',code)
    if name=='':
        print('\n\n\nError! Invalid name.\nCode:',code)
        raise Exception('Error! Invalid name.')
    if name[-1]=='=' or name[-1]=='-':
        if len(code)>0 and code[0]=='>':
            code=name[-1]+code
            name=name[0:-1]
    con0_name=''
    con1_name=''
    text=''
    if code!='' and code[0]=='\"':
        code=code[1:]
        [code,text]=textToken(code)
        if code=='' or code[0]!='\"':
            print(code)
            raise Exception('Error! Unbalanced quote!')
        code=code[1:]
    if code!='' and code[0]=='(':
        code=code[1:]
        con0_name=re.match(title,code).group()
        code=re.sub(title,'',code)
        if code=='' or code[0]!=',':
            print(code)
            raise Exception('Error! Ilegal net point format. A net point must be title"text"(title,title)')
        code=code[1:]
        con1_name=re.match(title,code).group()
        code=re.sub(title,'',code)
        if code=='' or code[0]!=')':
            raise Exception('Error! Unbalanced bracket in a net point format!')
        code=code[1:]
    if name=='':
        # 为什么不能直接用下面这句话? 
        # raise Exception('Error! There is a point without a name!')
        print('Warning! There is a point without a name!')
    netP=pointStack.buildNetP(name,con0_name,con1_name)
    posFormat=r'^\[(-?\d+), *(-?\d+)\]'
    pos=re.findall(posFormat,code)
    if pos!=[]:
        x=int(pos[0][0])
        y=int(pos[0][1])
        netP.m_pos=[x,y]
        code=re.sub(r'^\[-?\d+, *-?\d+\]','',code)
    netP.m_text=text
    return [code,netP,pointStack]

def textToken(code):
    text=''
    preEnd=True
    while True:
        if code=='':
            break
        elif len(code)>1 and code[0:2]=='\\"':
            preEnd=False
        elif code[0]=='\"' and preEnd==True:
            break
        else:
            text+=code[0]
            preEnd=True
        code=code[1:]
    return [code,text]

def buildRelation(karma,typeCon,effect):
    if typeCon=='->':
        karma.m_yese.append(effect)
    elif typeCon=='->>':
        karma.m_noe.append(effect)
    elif typeCon=='=>':
        karma.m_yese.append(effect)
        effect.m_no=True
    elif typeCon=='=>>':
        karma.m_noe.append(effect)
        effect.m_no=True
    else:
        raise Exception('Error! Ilegal connection type!')
    effect.m_cause=karma
##############################################################################





##### fast code
def genFCode(list_pt):
    fcode_pt="### 节点\n"
    fcode_con="### 关联\n"
    fcode_text="### 内容\n"

    i=0
    for pt in list_pt:
        fcode_pt+=pt.m_name+", "
        pt.m_name+="#%d"%(i)
        length=len(pt.m_text)
        if length!=0:
            fcode_text+="#%d, %d:\n%s\n## end\n"%(i,length,pt.m_text)
        i+=1

    for pt in list_pt:
        con1=""
        if pt.m_db[0]!=None:
            i=pt.m_db[0].m_name.rfind('#')
            if i!=-1:
                con1=pt.m_db[0].m_name[i+1:]
            else:
                con1="del"

        con2="#"
        if pt.m_db[1]!=None:
            i=pt.m_db[1].m_name.rfind('#')
            if i!=-1:
                con2=pt.m_db[1].m_name[i:]
            else:
                con2="#del"
        
        fcode_con+="%s%s, "%(con1,con2)

    for pt in list_pt:
        i=pt.m_name.find('#')
        pt.m_name=pt.m_name[0:i]

    fcode=fcode_pt+"\n"+fcode_con+"\n"+fcode_text+"### 结束"
    return fcode


def loadFCode(fcode):
    list_pt=[]
    list_del=[]

    code=fcode
    if code[0:7]!="### 节点\n":
        raise("错误! 没有检测到节点段落. ")
    code=code[7:]

    print("开始输入节点... ")
    i=-2
    while True:
        code=code[i+2:]
        if code=='':
            break
        elif code[0]=='\n':
            code=code[1:]
            break
        i=code.find(", ")
        if i==-1:
            raise("错误! 节点段落没有恰当地终止! ")
        list_pt.append(NetP(code[0:i]))

    print("完成节点输入! ")
    print("开始构建关联... ")

    if code[0:7]!="### 关联\n":
        raise("错误! 没有检测到关联段落. ")
    code=code[7:]

    i=-2
    n=-1
    while True:
        n+=1
        code=code[i+2:]
        if code=='':
            break
        elif code[0]=='\n':
            code=code[1:]
            break
        i=code.find(", ")
        if i==-1:
            raise("错误! 关联段落没有恰当地终止! ")
        con=code[:i]
        j=con.find('#')
        if j==-1:
            print("警告! 第%d个节点关联的格式有误, 该节点将被删除! "%(n))
            list_del.append(n)
            continue
        num0=con[0:j]
        num1=con[j+1:]
        if num0=="del" or num1=="del":
            list_del.append(n)
            continue

        con0=None
        if num0!='':
            try:
                con0=list_pt[int(num0)]
            except:
                list_del.append(n)
                continue
        con1=None
        if num1!='':
            try:
                con1=list_pt[int(num1)]
            except:
                list_del.append(n)
                continue
        list_pt[n].con(con0,con1)

        
    print("构建关联完成! ")
    print("开始读取内容... ")

    if code[0:7]!="### 内容\n":
        raise("错误! 没有检测到内容段落. ")
    code=code[7:]

    while True:
        result=re.match(r'#([\d]*), ([\d]*):\n',code)
        if result==None:
            if code!='' and code=="### 结束":
                break
            else:
                raise("错误! 内容的格式不正确. ")
        n=int(result.group(1))
        length=int(result.group(2))
        i=result.span()[1]
        code=code[i:]
        text=code[0:length]
        list_pt[n].m_text=text

        code=code[length:]
        if code[0:8]!='\n## end\n':
            raise("错误! 内容的格式不正确")
        code=code[8:]

    print("内容读取完成! ")
        
    if len(list_del)>0:
        print('There are %d invalid points!'%(len(list_del)))
        list_del.reverse()
        for i in list_del:
            print('Deleting %s...'%(list_pt[i].info()))
            list_pt.pop(i)

    return list_pt




##############




if __name__=='__main__':
    list_km=readSubCode_tokener('test(,_a)->_a')
    karma=list_km[0].causeEnd()
    karma.setRangers()
    list_km[0].m_symbol.print()
    print(karma.info_karma())
