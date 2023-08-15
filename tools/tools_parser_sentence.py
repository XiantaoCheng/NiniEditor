"""
+[P函数](,tools_parser_sentence)
地址::tools\tools_parser_sentence.py
+[保存文本](,tools_parser_sentence)

测试:...

"""


import sys,re
if __name__=='__main__':
    sys.path.append(sys.path[0]+'\\..')



from body.bone import NetP
from body.soul import Karma
from tools import tools_basic



dict_助词={}
dict_连词={}
dict_代词={}
dict_介词={}
dict_副词={}
dict_数量词={}
dict_形容词={}
dict_动词={}
dict_名词={}




def fun_助词(code):
    if code=="":
        return code,None
    code_save=code
    n=5
    for i in range(n):
        if i<=len(code) and code[0:i] in dict_助词:
            print(code[0:i],i)
            pt=NetP(code[0:i])
            pt0=NetP("助词").con(0,pt)
            return code[i:],pt0
    return code,None



def fun_连词(code):
    if code=="":
        return code,None
    code_save=code
    
    n=5
    for i in range(n):
        if i<=len(code) and code[0:i] in dict_连词:
            print(code[0:i],i)
            pt=NetP(code[0:i])
            pt0=NetP("连词").con(0,pt)
            return code[i:],pt0
    return code,None



def fun_介词(code):
    if code=="":
        return code,None
    code_save=code
    
    n=5
    for i in range(n):
        if i<=len(code) and code[0:i] in dict_介词:
            print(code[0:i],i)
            pt=NetP(code[0:i])
            pt0=NetP("介词").con(0,pt)
            return code[i:],pt0
    return code,None



def fun_数量词(code):
    if code=="":
        return code,None
    code_save=code
    
    n=5
    for i in range(n):
        if i<=len(code) and code[0:i] in dict_数量词:
            print(code[0:i],i)
            pt=NetP(code[0:i])
            pt0=NetP("数量词").con(0,pt)
            return code[i:],pt0
    return code,None



def fun_副词(code):
    if code=="":
        return code,None
    code_save=code
    
    n=5
    for i in range(n):
        if i<=len(code) and code[0:i] in dict_副词:
            print(code[0:i],i)
            pt=NetP(code[0:i])
            pt0=NetP("副词").con(0,pt)
            return code[i:],pt0
    return code,None



def fun_代词(code):
    if code=="":
        return code,None
    code_save=code
    
    n=5
    for i in range(n):
        if i<=len(code) and code[0:i] in dict_代词:
            print(code[0:i],i)
            pt=NetP(code[0:i])
            pt0=NetP("代词").con(0,pt)
            return code[i:],pt0
    return code,None



def fun_形容词(code):
    if code=="":
        return code,None
    code_save=code
    
    n=5
    for i in range(n):
        if i<=len(code) and code[0:i] in dict_形容词:
            print(code[0:i],i)
            pt=NetP(code[0:i])
            pt0=NetP("形容词").con(0,pt)
            return code[i:],pt0
    return code,None



def fun_名词(code):
    if code=="":
        return code,None
    code_save=code
    
    n=5
    for i in range(n):
        if i<=len(code) and code[0:i] in dict_名词:
            print(code[0:i],i)
            pt=NetP(code[0:i])
            pt0=NetP("名词").con(0,pt)
            return code[i:],pt0
    return code,None



def fun_动词(code):
    if code=="":
        return code,None
    code_save=code
    
    n=5
    for i in range(n):
        if i<=len(code) and code[0:i] in dict_动词:
            print(code[0:i],i)
            pt=NetP(code[0:i])
            pt0=NetP("动词").con(0,pt)
            return code[i:],pt0
    return code,None



def fun_谓语(code):
    if code=="":
        return code,None
    code_save=code
    
    code,状语=fun_状语(code)
    if 状语!=None:
        
        code,动词=fun_动词(code)
        if 动词!=None:
                
            
            谓语=NetP("谓语")
            谓语.m_db[1]=动词.m_db[1]
            
            Karma(谓语.m_db[1])
            
            NetP('的').con(谓语,状语)
            NetP('的').con(谓语,动词)
            return code,谓语
    code=code_save
    
    code,动词=fun_动词(code)
    if 动词!=None:
        
        
        谓语=NetP("谓语")
        谓语.m_db[1]=动词.m_db[1]
        
        Karma(谓语.m_db[1])
        
        NetP('的').con(谓语,动词)
        return code,谓语
    code=code_save
    
    return code,None



def fun_主语(code):
    if code=="":
        return code,None
    code_save=code
    
    code,定语=fun_定语(code)
    if 定语!=None:
        
        code,名词=fun_名词(code)
        if 名词!=None:
                
            
            主语=NetP("主语")
            主语.m_db[1]=名词.m_db[1]
            
            Karma(主语.m_db[1])
            if 定语.m_db[1].m_name in dict_名词:
                pt_de=NetP('的').con(定语.m_db[1],主语.m_db[1])
                Karma(pt_de)
                定语.m_db[1].m_master.addKarma(pt_de.m_master)
                pt_de.m_master.addKarma(主语.m_db[1].m_master)
            elif 定语.m_db[1].m_name in dict_动词:
                if 定语.m_db[1].m_db[0]!=None:
                    定语.m_db[1].con(0,名词.m_db[1])
                else:
                    定语.m_db[1].con(名词.m_db[1],0)
            else:
                定语.m_db[1].con(名词.m_db[1],0)
                主语.m_db[1].m_master.addKarma(定语.m_db[1].m_master,"从句")
            
            NetP('的').con(主语,定语)
            NetP('的').con(主语,名词)
            return code,主语
    code=code_save
    
    code,名词=fun_名词(code)
    if 名词!=None:
        
        
        主语=NetP("主语")
        主语.m_db[1]=名词.m_db[1]
        
        Karma(主语.m_db[1])
        
        NetP('的').con(主语,名词)
        return code,主语
    code=code_save
    
    return code,None



def fun_句子(code):
    if code=="":
        return code,None
    code_save=code
    
    code,主语=fun_主语(code)
    if 主语!=None:
        
        code,谓语=fun_谓语(code)
        if 谓语!=None:
                
            code,宾语=fun_宾语(code)
            if 宾语!=None:
                        
                
                句子=NetP("句子")
                句子.m_db[1]=谓语.m_db[1]
                谓语.m_db[1].con(主语.m_db[1],宾语.m_db[1])
                
                主语.m_db[1].m_master.addKarma(宾语.m_db[1].m_master)
                宾语.m_db[1].m_master.addKarma(谓语.m_db[1].m_master)
                谓语.m_db[1].m_master.m_buildMode=True
                
                NetP('的').con(句子,主语)
                NetP('的').con(句子,谓语)
                NetP('的').con(句子,宾语)
                return code,句子
    return code,None



def fun_宾语(code):
    if code=="":
        return code,None
    code_save=code
    
    code,定语=fun_定语(code)
    if 定语!=None:
        
        code,名词=fun_名词(code)
        if 名词!=None:
                
            
            宾语=NetP("宾语")
            宾语.m_db[1]=名词.m_db[1]
            
            Karma(宾语.m_db[1])
            if 定语.m_db[1].m_name in dict_名词:
                pt_de=NetP('的').con(定语.m_db[1],宾语.m_db[1])
                Karma(pt_de)
                定语.m_db[1].m_master.addKarma(pt_de.m_master)
                pt_de.m_master.addKarma(宾语.m_db[1].m_master)
            elif 定语.m_db[1].m_name in dict_动词:
                if 定语.m_db[1].m_db[0]!=None:
                    定语.m_db[1].con(0,名词.m_db[1])
                else:
                    定语.m_db[1].con(名词.m_db[1],0)
            else:
                定语.m_db[1].con(名词.m_db[1],0)
                宾语.m_db[1].m_master.addKarma(定语.m_db[1].m_master,"从句")
            
            
            NetP('的').con(宾语,定语)
            NetP('的').con(宾语,名词)
            return code,宾语
    code=code_save
    
    code,名词=fun_名词(code)
    if 名词!=None:
        
        
        宾语=NetP("宾语")
        宾语.m_db[1]=名词.m_db[1]
        
        Karma(宾语.m_db[1])
        
        NetP('的').con(宾语,名词)
        return code,宾语
    code=code_save
    
    return code,None



def fun_定语(code):
    if code=="":
        return code,None
    code_save=code
    
    code,短语=fun_短语(code)
    if 短语!=None:
        
        code,助词=fun_助词(code)
        if 助词!=None:
                
            
            定语=NetP("定语")
            定语.m_db[1]=短语.m_db[1]
            
            NetP('的').con(定语,短语)
            NetP('的').con(定语,助词)
            return code,定语
    code=code_save
    
    code,形容词=fun_形容词(code)
    if 形容词!=None:
        
        code,助词=fun_助词(code)
        if 助词!=None:
                
            
            定语=NetP("定语")
            定语.m_db[1]=形容词.m_db[1]
            
            Karma(定语.m_db[1])
            
            NetP('的').con(定语,形容词)
            NetP('的').con(定语,助词)
            return code,定语
    code=code_save
    
    code,数量词=fun_数量词(code)
    if 数量词!=None:
        
        code,助词=fun_助词(code)
        if 助词!=None:
                
            
            定语=NetP("定语")
            定语.m_db[1]=数量词.m_db[1]
            
            Karma(定语.m_db[1])
            
            NetP('的').con(定语,数量词)
            NetP('的').con(定语,助词)
            return code,定语
    code=code_save
    
    code,名词=fun_名词(code)
    if 名词!=None:
        
        code,助词=fun_助词(code)
        if 助词!=None:
                
            
            定语=NetP("定语")
            定语.m_db[1]=名词.m_db[1]
            
            Karma(定语.m_db[1])
            
            NetP('的').con(定语,名词)
            NetP('的').con(定语,助词)
            return code,定语
    code=code_save
    
    return code,None



def fun_状语(code):
    if code=="":
        return code,None
    code_save=code
    
    code,并列短语=fun_并列短语(code)
    if 并列短语!=None:
        
        
        状语=NetP("状语")
        状语.m_db[1]=并列短语.m_db[1]
        NetP('的').con(状语,并列短语)
        return code,状语
    code=code_save
    
    code,介宾短语=fun_介宾短语(code)
    if 介宾短语!=None:
        
        
        状语=NetP("状语")
        状语.m_db[1]=介宾短语.m_db[1]
        NetP('的').con(状语,介宾短语)
        return code,状语
    code=code_save
    
    code,副词=fun_副词(code)
    if 副词!=None:
        
        
        状语=NetP("状语")
        状语.m_db[1]=副词.m_db[1]
        NetP('的').con(状语,副词)
        return code,状语
    code=code_save
    
    code,形容词=fun_形容词(code)
    if 形容词!=None:
        
        
        状语=NetP("状语")
        状语.m_db[1]=形容词.m_db[1]
        NetP('的').con(状语,形容词)
        return code,状语
    code=code_save
    
    code,代词=fun_代词(code)
    if 代词!=None:
        
        
        状语=NetP("状语")
        状语.m_db[1]=代词.m_db[1]
        NetP('的').con(状语,代词)
        return code,状语
    code=code_save
    
    return code,None



def fun_补语(code):
    if code=="":
        return code,None
    code_save=code
    
    code,并列短语=fun_并列短语(code)
    if 并列短语!=None:
        
        
        补语=NetP("补语")
        补语.m_db[1]=并列短语.m_db[1]
        NetP('的').con(补语,并列短语)
        return code,补语
    code=code_save
    
    code,介宾短语=fun_介宾短语(code)
    if 介宾短语!=None:
        
        
        补语=NetP("补语")
        补语.m_db[1]=介宾短语.m_db[1]
        NetP('的').con(补语,介宾短语)
        return code,补语
    code=code_save
    
    code,动词=fun_动词(code)
    if 动词!=None:
        
        
        补语=NetP("补语")
        补语.m_db[1]=动词.m_db[1]
        NetP('的').con(补语,动词)
        return code,补语
    code=code_save
    
    code,形容词=fun_形容词(code)
    if 形容词!=None:
        
        
        补语=NetP("补语")
        补语.m_db[1]=形容词.m_db[1]
        NetP('的').con(补语,形容词)
        return code,补语
    code=code_save
    
    code,数量词=fun_数量词(code)
    if 数量词!=None:
        
        
        补语=NetP("补语")
        补语.m_db[1]=数量词.m_db[1]
        NetP('的').con(补语,数量词)
        return code,补语
    code=code_save
    
    code,代词=fun_代词(code)
    if 代词!=None:
        
        
        补语=NetP("补语")
        补语.m_db[1]=代词.m_db[1]
        NetP('的').con(补语,代词)
        return code,补语
    code=code_save
    
    return code,None



def fun_短语(code):
    if code=="":
        return code,None
    code_save=code
    
    code,并列短语=fun_并列短语(code)
    if 并列短语!=None:
        
        
        return code,并列短语
    code=code_save
    
    code,偏正短语=fun_偏正短语(code)
    if 偏正短语!=None:
        
        
        return code,偏正短语
    code=code_save
    
    code,述宾短语=fun_述宾短语(code)
    if 述宾短语!=None:
        
        
        return code,述宾短语
    code=code_save
    
    code,述补短语=fun_述补短语(code)
    if 述补短语!=None:
        
        
        return code,述补短语
    code=code_save
    
    code,主谓短语=fun_主谓短语(code)
    if 主谓短语!=None:
        
        
        return code,主谓短语
    code=code_save
    
    code,介宾短语=fun_介宾短语(code)
    if 介宾短语!=None:
        
        
        return code,介宾短语
    code=code_save
    
    return code,None



def fun_并列短语(code):
    if code=="":
        return code,None
    code_save=code
    
    code,形容词=fun_形容词(code)
    if 形容词!=None:
        
        code,连词=fun_连词(code)
        if 连词!=None:
                
            code,并列短语=fun_并列短语(code)
            if 并列短语!=None:
                        
                
                并列短语_0=NetP("并列短语")
                连词.m_db[1].con(形容词.m_db[1],并列短语.m_db[1])
                并列短语_0.m_db[1]=形容词.m_db[1]
                
                NetP('的').con(并列短语_0,形容词)
                NetP('的').con(并列短语_0,连词)
                NetP('的').con(并列短语_0,并列短语)
                return code,并列短语_0
    code=code_save
    
    code,名词=fun_名词(code)
    if 名词!=None:
        
        code,连词=fun_连词(code)
        if 连词!=None:
                
            code,并列短语=fun_并列短语(code)
            if 并列短语!=None:
                        
                
                并列短语_0=NetP("并列短语")
                连词.m_db[1].con(名词.m_db[1],并列短语.m_db[1])
                并列短语_0.m_db[1]=名词.m_db[1]
                
                NetP('的').con(并列短语_0,名词)
                NetP('的').con(并列短语_0,连词)
                NetP('的').con(并列短语_0,并列短语)
                return code,并列短语_0
    code=code_save
    
    code,名词_0=fun_名词(code)
    if 名词_0!=None:
        
        code,连词=fun_连词(code)
        if 连词!=None:
                
            code,名词_1=fun_名词(code)
            if 名词_1!=None:
                        
                
                并列短语=NetP("并列短语")
                连词.m_db[1].con(名词_0.m_db[1],名词_1.m_db[1])
                并列短语.m_db[1]=名词_0.m_db[1]
                
                NetP('的').con(并列短语,名词_0)
                NetP('的').con(并列短语,连词)
                NetP('的').con(并列短语,名词_1)
                return code,并列短语
    code=code_save
    
    code,形容词=fun_形容词(code)
    if 形容词!=None:
        
        code,连词=fun_连词(code)
        if 连词!=None:
                
            code,名词=fun_名词(code)
            if 名词!=None:
                        
                
                并列短语=NetP("并列短语")
                连词.m_db[1].con(形容词.m_db[1],名词.m_db[1])
                并列短语.m_db[1]=形容词.m_db[1]
                
                NetP('的').con(并列短语,形容词)
                NetP('的').con(并列短语,连词)
                NetP('的').con(并列短语,名词)
                return code,并列短语
    code=code_save
    
    code,名词=fun_名词(code)
    if 名词!=None:
        
        code,连词=fun_连词(code)
        if 连词!=None:
                
            code,形容词=fun_形容词(code)
            if 形容词!=None:
                        
                
                并列短语=NetP("并列短语")
                连词.m_db[1].con(名词.m_db[1],形容词.m_db[1])
                并列短语.m_db[1]=名词.m_db[1]
                
                NetP('的').con(并列短语,名词)
                NetP('的').con(并列短语,连词)
                NetP('的').con(并列短语,形容词)
                return code,并列短语
    code=code_save
    
    code,形容词_0=fun_形容词(code)
    if 形容词_0!=None:
        
        code,连词=fun_连词(code)
        if 连词!=None:
                
            code,形容词_1=fun_形容词(code)
            if 形容词_1!=None:
                        
                
                并列短语=NetP("并列短语")
                连词.m_db[1].con(形容词_0.m_db[1],形容词_1.m_db[1])
                并列短语.m_db[1]=形容词_0.m_db[1]
                
                NetP('的').con(并列短语,形容词)
                NetP('的').con(并列短语,连词)
                NetP('的').con(并列短语,形容词)
                return code,并列短语
    code=code_save
    
    return code,None



def fun_偏正短语(code):
    if code=="":
        return code,None
    code_save=code
    
    code,名词_0=fun_名词(code)
    if 名词_0!=None:
        
        code,名词_1=fun_名词(code)
        if 名词_1!=None:
                
            
            偏正短语=NetP("偏正短语")
            偏正短语.m_db[1]=名词_1.m_db[1]
            
            pt_de=NetP('的').con(名词_0.m_db[1],名词_1.m_db[1])
            Karma(名词_0.m_db[1])
            Karma(名词_1.m_db[1])
            Karma(pt_de)
            名词_0.m_db[1].m_master.addKarma(pt_de.m_master)
            pt_de.m_master.addKarma(名词_1.m_db[1].m_master)
            
            NetP('的').con(偏正短语,名词_0)
            NetP('的').con(偏正短语,pt_de)
            NetP('的').con(偏正短语,名词_1)
            return code,偏正短语
    code=code_save
    
    code,形容词=fun_形容词(code)
    if 形容词!=None:
        
        code,动词=fun_动词(code)
        if 动词!=None:
                
            
            偏正短语=NetP("偏正短语")
            偏正短语.m_db[1]=动词.m_db[1]
            形容词.m_db[1].con(动词.m_db[1],0)
            
            Karma(动词.m_db[1])
            Karma(形容词.m_db[1])
            动词.m_db[1].m_master.addKarma(形容词.m_db[1].m_master)
            
            NetP('的').con(偏正短语,形容词)
            NetP('的').con(偏正短语,动词)
            return code,偏正短语
    code=code_save
    
    code,形容词=fun_形容词(code)
    if 形容词!=None:
        
        code,名词=fun_名词(code)
        if 名词!=None:
                
            
            偏正短语=NetP("偏正短语")
            偏正短语.m_db[1]=名词.m_db[1]
            形容词.m_db[1].con(名词.m_db[1],0)
            
            Karma(形容词.m_db[1])
            Karma(名词.m_db[1])
            名词.m_db[1].m_master.addKarma(形容词.m_db[1].m_master)
            
            NetP('的').con(偏正短语,形容词)
            NetP('的').con(偏正短语,名词)
            return code,偏正短语
    code=code_save
    
    return code,None



def fun_述宾短语(code):
    if code=="":
        return code,None
    code_save=code
    
    code,动词=fun_动词(code)
    if 动词!=None:
        
        code,宾语=fun_宾语(code)
        if 宾语!=None:
                
            
            述宾短语=NetP("述宾短语")
            述宾短语.m_db[1]=动词.m_db[1]
            动词.m_db[1].con(0,宾语.m_db[1])
            
            Karma(动词.m_db[1])
            动词.m_db[1].m_master.addKarma(宾语.m_db[1].m_master)
            
            NetP('的').con(述宾短语,动词)
            NetP('的').con(述宾短语,宾语)
            return code,述宾短语
    code=code_save
    
    return code,None



def fun_述补短语(code):
    if code=="":
        return code,None
    code_save=code
    
    code,动词=fun_动词(code)
    if 动词!=None:
        
        code,形容词=fun_形容词(code)
        if 形容词!=None:
                
            
            述补短语=NetP("述补短语")
            述补短语.m_db[1]=动词.m_db[1]
            形容词.m_db[1].con(动词.m_db[1],0)
            
            Karma(动词.m_db[1])
            Karma(形容词.m_db[1])
            动词.m_db[1].m_master.addKarma(形容词.m_db[1].m_master)
            
            NetP('的').con(述补短语,动词)
            NetP('的').con(述补短语,形容词)
            return code,述补短语
    code=code_save
    
    return code,None



def fun_主谓短语(code):
    if code=="":
        return code,None
    code_save=code
    
    code,名词=fun_名词(code)
    if 名词!=None:
        
        code,动词=fun_动词(code)
        if 动词!=None:
                
            
            主谓短语=NetP("主谓短语")
            主谓短语.m_db[1]=动词.m_db[1]
            动词.m_db[1].con(名词.m_db[1],0)
            
            Karma(名词.m_db[1])
            Karma(动词.m_db[1])
            动词.m_db[1].m_master.addKarma(名词.m_db[1].m_master)
            
            NetP('的').con(主谓短语,名词)
            NetP('的').con(主谓短语,动词)
            return code,主谓短语
    code=code_save
    
    return code,None



def fun_介宾短语(code):
    if code=="":
        return code,None
    code_save=code
    
    code,介词=fun_介词(code)
    if 介词!=None:
        
        code,宾语=fun_宾语(code)
        if 宾语!=None:
                
            
            介宾短语=NetP("介宾短语")
            介宾短语.m_db[1]=介词.m_db[1]
            介词.m_db[1].con(0,宾语.m_db[1])
            
            Karma(介词.m_db[1])
            介词.m_db[1].m_master.addKarma(宾语.m_db[1].m_master)
            
            NetP('的').con(介宾短语,介词)
            NetP('的').con(介宾短语,宾语)
            return code,介宾短语
    code=code_save
    
    return code,None



def collectPts(pt,list_pt=None):
    if list_pt==None:
        list_pt=[]
    if pt not in list_pt:
        list_pt.append(pt)
    for con in pt.m_con:
        if con.m_db[0]==pt:
            if con not in list_pt:
                list_pt.append(con)
            if con.m_name=="的" and con.m_db[1]!=None:
                collectPts(con.m_db[1],list_pt)
    if pt.m_db[0]!=None:
        if pt.m_db[0] not in list_pt:
            list_pt.append(pt.m_db[0])
    if pt.m_db[1]!=None:
        if pt.m_db[1] not in list_pt:
            list_pt.append(pt.m_db[1])
    return list_pt

def sentStruct(pt):
    list_pt=collectPts(pt)
    return tools_basic.writeStdCode([],list_pt)

def sent2Struct(sent):
    code,pt=fun_句子(sent)
    if pt==None:
        return ''
    else:
        return sentStruct(pt)



