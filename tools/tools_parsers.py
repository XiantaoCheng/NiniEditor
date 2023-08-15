import sys,re
if __name__=='__main__':
    sys.path.append(sys.path[0]+'\\..')
from body.bone import NetP

def str2struct(string):
    list_pt=[]
    this=None
    for letter in string:
        this=NetP(letter)
        if list_pt!=[]:
            list_pt[-1].connect(this,1)
        list_pt.append(this)
    return list_pt

def struct2str(list_pt):
    string=''
    head=None
    for point in list_pt:
        if point.m_con==[]:
            head=point
            break
    if head==None:
        return string
    while True:
        string+=head.m_name
        if head.m_db[1]!=None:
            head=head.m_db[1]
        else:
            break
    return string


###################################  Formula Parser  ######################################
def equationToken(string,list_pt=None):
    sign=None
    equation=None
    equal=None
    if list_pt==None:
        list_pt=[]
    [formula,string,list_pt]=sumToken(string,list_pt)
    equation=formula
    if string=='':
        return [equation,string,list_pt]
    elif string[0]=='=':
        equal=NetP('=')
        list_pt.append(equal)
        string=string[1:]
        [point,string,list_pt]=equationToken(string,list_pt)
        equal.con(equation,point)
        if string=='':
            return [equation,string,list_pt]
    raise Exception('Error! Un-recognized operator: "'+string+'"')

def sumToken(string,list_pt):
    [formula,string,list_pt]=multiToken(string,list_pt)
    if string=='':
        return [formula,string,list_pt]
    elif string[0]=='+' or string[0]=='-':
        relation=NetP(string[0])
        list_pt.append(relation)
        string=string[1:]
        [point,string,list_pt]=sumToken(string,list_pt)
        relation.con(formula,point)

    return [formula,string,list_pt]

def multiToken(string,list_pt):
    [multi,string,list_pt]=powerToken(string,list_pt)
    if string=='':
        return [multi,string,list_pt]
    elif string[0]=='*' or string[0]=='/':
        relation=NetP(string[0])
        list_pt.append(relation)
        string=string[1:]
        [point,string,list_pt]=multiToken(string,list_pt)
        relation.con(multi,point)

    return [multi,string,list_pt]

def powerToken(string,list_pt):
    [power,string,list_pt]=unitToken(string,list_pt)
    if string=='':
        return [power,string,list_pt]
    elif string[0]=='^':
        relation=NetP(string[0])
        list_pt.append(relation)
        string=string[1:]
        [point,string,list_pt]=powerToken(string,list_pt)
        relation.con(power,point)

    return [power,string,list_pt]

def unitToken(string,list_pt):
    if string=='':
        raise Exception('Error! Must take an unit after an operator')
    elif string[0]=='-':
        pt_min=NetP('-')
        string=string[1:]
    elif string[0]=='+':
        pt_min=None
        string=string[1:]
    else:
        pt_min=None
    if string[0]=='(':
        string=string[1:]
        pt_unit=NetP('括号')
        pt_con=NetP('的')
        list_pt.append(pt_unit)
        list_pt.append(pt_con)
        [formula,string,list_pt]=sumToken(string,list_pt)
        pt_con.con(pt_unit,formula)
        if string=='' or string[0]!=')':
            raise Exception('Error! Unbalanced brakect: "'+string+'"')
        string=string[1:]
    else:
        [pt_unit,string,list_pt]=variableToken(string,list_pt)
    if pt_min!=None:
        list_pt.append(pt_min)
        pt_min.con(None,pt_unit)
    return [pt_unit,string,list_pt]

def variableToken(string,list_pt):
    pat_var=r'^-?[a-zA-Z0-9.\\_]+'
    str_var=re.match(pat_var,string).group()
    string=re.sub(pat_var,'',string)
    if str_var=='':
        raise Exception('Error! Must have a variable in this place: "'+string+'"')
    elif str_var=='frac':
        return fracToken(string,list_pt)
    elif str_var=='int':
        return intToken(string,list_pt)
    elif str_var=='dif':
        return difToken(string,list_pt)
    elif str_var=='partial':
        return partialToken(string,list_pt)
    else:
        pt_var=NetP(str_var)
        list_pt.append(pt_var)
        if string=='':
            return [pt_var,string,list_pt]
        # elif string[0]=='_':
        #     string=string[1:]
        #     str_dwn=re.match(pat_var,string).group()
        #     string=re.sub(pat_var,'',string)
        #     if len(str_dwn)==1:
        #         pt_var.m_name+='_'+str_dwn
        #     elif len(str_dwn)>1:
        #         pt_dwn=NetP(str_dwn)
        #         pt_con=NetP('下标').con(pt_var,pt_dwn)
        #         list_pt.append(pt_con)
        #         list_pt.append(pt_dwn)

        if string=='':
            return [pt_var,string,list_pt]
        if string[0]=='(':
            string=string[1:]
            [pt_inputs,string,list_pt]=inputToken(string,list_pt)
            pt_inputs.con(pt_var,0)
            if string=='' or string[0]!=')':
                raise Exception("Error! Unbalanced brakect: \""+string+'"')
            string=string[1:]
    
    return [pt_var,string,list_pt]

def inputToken(string,list_pt):
    pt_input=NetP('输入')
    list_pt.append(pt_input)

    string=re.sub(' *','',string)
    if string[0]==')':
        return [pt_input,string,list_pt]
    if string[0]!=',':
        pt_in=NetP('的')
        list_pt.append(pt_in)
        [formula,string,list_pt]=sumToken(string,list_pt)
        pt_in.con(pt_input,formula)
        string=re.sub(' *','',string)

    if string=='':
        return [pt_input,string,list_pt]
    elif string[0]==',':
        string=string[1:]
        pt_con=NetP('后面')
        list_pt.append(pt_con)
        [pt_next,string,list_pt]=inputToken(string,list_pt)
        pt_con.con(pt_input,pt_next)
    
    return [pt_input,string,list_pt]


# special token
def fracToken(string,list_pt):
    pt_frac=NetP('分式')
    list_pt.append(pt_frac)
    pt_con1=NetP('分子').con(pt_frac,None)
    pt_con2=NetP('分母').con(pt_frac,None)
    pt_in1=NetP('的')
    pt_in2=NetP('的')
    list_pt.append(pt_con1)
    list_pt.append(pt_con2)
    list_pt.append(pt_in1)
    list_pt.append(pt_in2)

    if string=='' or string[0]!='(':
        raise Exception('Error! A frac must be frac(a,b): "'+string+'"')
    string=string[1:]
    [pt_num,string,list_pt]=sumToken(string,list_pt)
    if string=='' or string[0]!=',':
        raise Exception('Error! A frac must be frac(a,b): "'+string+'"')
    string=string[1:]
    string=re.sub(' *','',string)
    [pt_den,string,list_pt]=sumToken(string,list_pt)
    if string=='' or string[0]!=')':
        raise Exception('Error! A frac must be frac(a,b): "'+string+'"')
    string=string[1:]

    pt_in1.con(pt_con1,pt_num)
    pt_in2.con(pt_con2,pt_den)
    return [pt_frac,string,list_pt]

    
def intToken(string,list_pt):
    pt_int=NetP('积分')
    list_pt.append(pt_int)
    index=len(list_pt)

    if string=='' or string[0]!='(':
        raise Exception('Error! A frac must be int(a,b,c,d): "'+string+'"')
    string=string[1:]
    try:
        [pt_up,string,list_pt]=sumToken(string,list_pt)
    except:
        pt_up=None
    if string=='' or string[0]!=',':
        raise Exception('Error! A frac must be int(a,b,c,d): "'+string+'"')
    string=string[1:]
    string=re.sub(' *','',string)
    try:
        [pt_dwn,string,list_pt]=sumToken(string,list_pt)
    except:
        pt_dwn=None
    if string=='' or string[0]!=',':
        raise Exception('Error! A frac must be int(a,b,c,d): "'+string+'"')
    string=string[1:]
    string=re.sub(' *','',string)
    [pt_var,string,list_pt]=sumToken(string,list_pt)
    if string=='' or string[0]!=',':
        raise Exception('Error! A frac must be int(a,b,c,d): "'+string+'"')
    string=string[1:]
    string=re.sub(' *','',string)
    [pt_f,string,list_pt]=sumToken(string,list_pt)
    if string=='' or string[0]!=')':
        raise Exception('Error! A frac must be frac(a,b,c,d): "'+string+'"')
    string=string[1:]

    if pt_up!=None:
        pt_con=NetP('下限').con(pt_int,None)
        pt_in=NetP('的').con(pt_con,pt_up)
        list_pt.insert(index,pt_in)
        list_pt.insert(index,pt_con)
    if pt_dwn!=None:
        pt_con=NetP('上限').con(pt_int,None)
        pt_in=NetP('的').con(pt_con,pt_dwn)
        list_pt.insert(index,pt_in)
        list_pt.insert(index,pt_con)
    pt_con=NetP('变量').con(pt_int,None)
    pt_in=NetP('的').con(pt_con,pt_var)
    list_pt.insert(index,pt_in)
    list_pt.insert(index,pt_con)
    pt_con=NetP('函数').con(pt_int,None)
    pt_in=NetP('的').con(pt_con,pt_f)
    list_pt.insert(index,pt_in)
    list_pt.insert(index,pt_con)

    return [pt_int,string,list_pt]

def difToken(string,list_pt):
    pt_dif=NetP('微分')
    list_pt.append(pt_dif)
    index=len(list_pt)

    if string=='' or string[0]!='(':
        raise Exception('Error! A frac must be dif(n,x,f): "'+string+'"')
    string=string[1:]
    try:
        [pt_n,string,list_pt]=sumToken(string,list_pt)
    except:
        pt_n=None
    if string=='' or string[0]!=',':
        raise Exception('Error! A frac must be dif(n,x,f): "'+string+'"')
    string=string[1:]
    string=re.sub(' *','',string)
    [pt_x,string,list_pt]=sumToken(string,list_pt)
    if string=='' or string[0]!=',':
        raise Exception('Error! A frac must be dif(n,x,f): "'+string+'"')
    string=string[1:]
    string=re.sub(' *','',string)
    [pt_f,string,list_pt]=sumToken(string,list_pt)
    if string=='' or string[0]!=')':
        raise Exception('Error! A frac must be dif(n,x,f): "'+string+'"')
    string=string[1:]

    if pt_n!=None or pt_n.m_name!='1':
        pt_con=NetP('阶').con(pt_n,pt_dif)
        list_pt.insert(index,pt_con)
    pt_con=NetP('变量').con(pt_dif,None)
    pt_in=NetP('的').con(pt_con,pt_x)
    list_pt.insert(index,pt_in)
    list_pt.insert(index,pt_con)
    pt_con=NetP('函数').con(pt_dif,None)
    pt_in=NetP('的').con(pt_con,pt_f)
    list_pt.insert(index,pt_in)
    list_pt.insert(index,pt_con)

    return [pt_dif,string,list_pt]

def partialToken(string,list_pt):
    pt_dif=NetP('偏微分')
    list_pt.append(pt_dif)
    index=len(list_pt)

    if string=='' or string[0]!='(':
        raise Exception('Error! A frac must be partial(n,x,f): "'+string+'"')
    string=string[1:]
    try:
        [pt_n,string,list_pt]=sumToken(string,list_pt)
    except:
        pt_n=None
    if string=='' or string[0]!=',':
        raise Exception('Error! A frac must be partial(n,x,f): "'+string+'"')
    string=string[1:]
    string=re.sub(' *','',string)
    [pt_x,string,list_pt]=sumToken(string,list_pt)
    if string=='' or string[0]!=',':
        raise Exception('Error! A frac must be partial(n,x,f): "'+string+'"')
    string=string[1:]
    string=re.sub(' *','',string)
    [pt_f,string,list_pt]=sumToken(string,list_pt)
    if string=='' or string[0]!=')':
        raise Exception('Error! A frac must be partial(n,x,f): "'+string+'"')
    string=string[1:]

    if pt_n!=None or pt_n.m_name!='1':
        pt_con=NetP('阶').con(pt_n,pt_dif)
        list_pt.insert(index,pt_con)
    pt_con=NetP('变量').con(pt_dif,None)
    pt_in=NetP('的').con(pt_con,pt_x)
    list_pt.insert(index,pt_in)
    list_pt.insert(index,pt_con)
    pt_con=NetP('函数').con(pt_dif,None)
    pt_in=NetP('的').con(pt_con,pt_f)
    list_pt.insert(index,pt_in)
    list_pt.insert(index,pt_con)

    return [pt_dif,string,list_pt]


def eqn2struct(string):
    string=string.replace(" ","")
    point,string,list_pt=equationToken(string)
    return list_pt

########################################################################################

def nextPoints(point,key):
    list_pt=[]
    for pt in point.m_con:
        if pt.m_name==key and pt.m_db[0]==point and pt.m_db[1]!=None:
            list_pt.append(pt.m_db[1])
    return list_pt

def struct2Eqn(point):
    eqn=''
    name=point.m_name
    
    if name=='和式':
        addPts=nextPoints(point,'+')
        minPts=nextPoints(point,'-')
        for pt in addPts:
            if eqn!='':
                eqn+='+'
            eqn+=struct2Eqn(pt)
        for pt in minPts:
            eqn+='-'+struct2Eqn(pt)
    elif name=='乘式':
        mulPts=nextPoints(point,'*')
        devPts=nextPoints(point,'/')
        for pt in mulPts:
            if eqn!='':
                eqn+='*'
            eqn+=struct2Eqn(pt)
        for pt in devPts:
            if eqn=='':
                eqn+='1'
            eqn+='/'+struct2Eqn(pt)
    else:
        if name=='括号':
            eqn+='('
            contain=nextPoints(point,'in')
            for pt in contain:
                eqn+=struct2Eqn(pt)
            eqn+=')'
        else:
            eqn+=name
        pwrPts=nextPoints(point,'^')
        for pt in pwrPts:
            eqn+='^'+struct2Eqn(pt)
    eqlPts=nextPoints(point,'=')
    for pt in eqlPts:
        eqn+='='+struct2Eqn(pt)
    return eqn



###################################  Smilei parser  ####################################
def Smilei2struct(title):
    try:
        f=open(title)
    except:
        print('No such file exits!')
        return []
    code=f.read()
    [code,list_pt]=SmileiToken(code,title)
    return list_pt

def SmileiToken(code,title,list_pt=None):
    if list_pt==None:
        list_pt=[]
    point=NetP('smilei')
    point.m_text=title
    list_pt.append(point)
    code=re.sub(r'[ \t]','',code)
    code=re.sub(r'#.*\n','',code)
    while code!='':
        code=re.sub(r'^\n*','',code)
        if code=='':
            break
        else:
            [code,line_pt]=lineSmToken(code,list_pt)
            con=NetP('in')
            list_pt.append(con)
            con.con(point,line_pt)
    return [code,list_pt]

def lineSmToken(code,list_pt):
    nameFormat=r'^[\w\.]+'
    name=re.match(nameFormat,code).group()
    if name=='':
        raise Exception('Error! Invalid name of function or variable!')
    code=re.sub(nameFormat,'',code)
    line_pt=NetP(name)
    list_pt.append(line_pt)
    if code!='' and code[0]=='=':
        code=code[1:]
        [code,content]=conSmToken(code)
        if content=='':
            raise Exception('Error! Invalid assignment value!')
        line_pt.m_text=content
    elif code!='' and code[0]=='(':
        code=code[1:]
        code=re.sub(r'^\n*','',code)
        [code,var]=varSmToken(code,list_pt)
        con=NetP('in')
        list_pt.append(con)
        con.con(line_pt,var)
        while True:
            if code!='' and code[0]==',':
                code=code[1:]
            else:
                break
            code=re.sub(r'^\n*','',code)
            if code!='' and code[0]==')':
                break
            [code,var]=varSmToken(code,list_pt)
            con=NetP('in')
            list_pt.append(con)
            con.con(line_pt,var)
        code=re.sub(r'^\n*','',code)
        if code=='' or code[0]!=')':
            raise Exception('Error! Unbalanced bracket!')
        code=code[1:]
    return [code,line_pt]

def varSmToken(code,list_pt):
    nameFormat=r'^[\w\.]+'
    name=re.match(nameFormat,code).group()
    if name=='':
        raise Exception('Error! Invalid name!')
    code=re.sub(nameFormat,'',code)
    if code=='' or code[0]!='=':
        raise Exception('Error! Every variable must be assigned by some values.')
    code=code[1:]
    [code,content]=conSmToken(code)
    var=NetP(name)
    list_pt.append(var)
    var.m_text=content
    return [code,var]

def conSmToken(code):
    content=''
    if code=='':
        raise Exception('Error! Value can\'t be empty!')
    if code[0]=='[':
        content+=code[0]
        code=code[1:]
        code=re.sub(r'^\n*','',code)
        [code,con]=listSmToken(code)
        content+=con
        code=re.sub(r'^\n*','',code)
        if code=='' or code[0]!=']':
            raise Exception('Error! Unbalanced list bracket!')
        code=code[1:]
        content+=']'
    else:
        stack1=0
        stack2=0
        while code!='':
            if code[0]=='\n':
                break
            elif code[0]==',' and stack1==0 and stack2==0:
                break
            elif code[0]=='(':
                stack1+=1
            elif code[0]=='[':
                stack2+=1
            elif code[0]==')':
                stack1-=1
            elif code[0]==']':
                stack2-=1
            if stack1<0 or stack2<0:
                break
            content+=code[0]
            code=code[1:]
        if content=='':
            raise Exception('Error! Value can\'t be empty!')
    return [code,content]

def listSmToken(code):
    content=''
    if code=='' or code[0]==']':
        return [code,content]
    [code,con]=conSmToken(code)
    content+=con
    while True:
        if code=='' or code[0]!=',':
            break
        content+=','
        code=code[1:]
        code=re.sub(r'^\n*','',code)
        if code=='' or code[0]==']':
            break
        [code,con]=conSmToken(code)
        content+=con
    return [code,content]
    




########################################################################################

if __name__=='__main__':
    list_pt=eqn2struct('x^2-(x-y)/(x+y ) + 1*f(x+1, y)=2')
    print(list_pt)
    for point in list_pt:
        point.print()

    # f=open('files\smilei_sample.py')
    # [code,point,list_pt]=SmileiToken(f.read(),'test')
    list_pt=Smilei2struct('files\smilei_sample.py')
    for point in list_pt:
        point.print()

