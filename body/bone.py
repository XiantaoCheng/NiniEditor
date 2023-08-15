import sys
import re

class NetP:
    def __init__(self,name,text=''):
        self.m_master=None
        self.m_needed=None
        self.m_creator=None
        self.m_dev=None
        self.m_var=None
        self.m_permission=4
        
        self.m_building=False
        
        self.m_name=name
        self.m_text=text
        self.m_db=[None,None]
        self.m_con=[]
        self.m_pos=[-1,-1]

    def copy(self,point=None):
        if point!=None:
            self.m_name=point.m_name
            self.m_text=point.m_text
            return self
        else:
            point=NetP(self.m_name,self.m_text)
            return point

    def connect(self,con,index):
        if index>1 | index<0:
            return
        else:
            self.disconnect_i(index)
            self.m_db[index]=con
            if con!=None:
                if self in con.m_con:
                    pass
                    # print('Error! '+self.m_name+' is already connecting '+con.m_name+'.')
                    # print('It may be an old problem. Check soul().map()')
                else:
                    con.m_con.append(self)

    def con(self,con0,con1):
        if con0!=0:
            self.disconnect_i(0)
            self.connect(con0,0)
        if con1!=0:
            self.disconnect_i(1)
            self.connect(con1,1)
        return self

    def disconnect(self,con):
        if con==self.m_db[0]:
            self.m_db[0]=None
            if con!=self.m_db[1]:
                con.m_con.remove(self)
        elif con==self.m_db[1]:
            self.m_db[1]=None
            if con!=self.m_db[0]:
                con.m_con.remove(self)
                    
    def disconnect_i(self,index):
        if index==0 or index==1:
            con=self.m_db[index]
            self.m_db[index]=None
            if con!=None:
                if self not in con.m_con:
                    print('Something strange happened when deleting '+self.info()+'.m_db['+str(index)+']')
                elif con!=self.m_db[1-index]:
                    con.m_con.remove(self)

    def takeAllCon(self,target):
        list_pt=target.m_con.copy()
        for con in list_pt:
            if con.m_db[0]==target:
                con.con(self,0)
            if con.m_db[1]==target:
                con.con(0,self)

    def delete(self):
        self.disconnect_i(0)
        self.disconnect_i(1)
        cons=self.m_con.copy()
        for point in cons:
            point.disconnect(self)

    def print(self,show_type=0):
        text=self.m_text
        if text=='':
            str_self=self.m_name+'('
        else:
            str_self=self.m_name+'\"'+text+'\"'+'('
        if self.m_db[0]!=None:
            str_self=str_self+self.m_db[0].m_name
        str_self=str_self+','
        if self.m_db[1]!=None:
            str_self=str_self+self.m_db[1].m_name
        str_self=str_self+')'
        if show_type==0:
            str_self+='['+str(self.m_pos[0])+','+str(self.m_pos[1])+']'
        elif show_type=='全部关联':
            str_self+='\n全部关联: '
            name=self.m_name
            self.m_name+='#SELF'
            for con in self.m_con:
                str_self+=con.info(show_info='不显示文本不显示位置')+' '
            self.m_name=name
        print(str_self)
        if self.m_var!=None:
            print("m_var:",self.m_var)
        
        # cons=[]
        # for con in self.m_con:
        #     cons.append(con.m_name)
        # print('m_con:',cons)

    def __str__(self) -> str:
        return self.info(show_info='不显示文本不显示位置')

    def info(self,show_info='不显示位置',show_type=0):
        text=re.sub('\"','\\\"',self.m_text)
        # if text=='' or show_type!=0 or (not infoInStr(show_str,'显示文本')):
        if text=='' or infoInStr(show_info,'不显示文本'):
            str_self=self.m_name
        else:
            str_self=self.m_name+'\"'+text+'\"'

        str_self+='('
        if self.m_db[0]!=None:
            str_self=str_self+self.m_db[0].m_name
        str_self=str_self+','
        if self.m_db[1]!=None:
            str_self=str_self+self.m_db[1].m_name
        str_self=str_self+')'

        # if show_type==0 or infoInStr(show_str,'显示位置'):
        if not infoInStr(show_info,'不显示位置'):
            str_self+='['+str(self.m_pos[0])+','+str(self.m_pos[1])+']'

        return str_self

    
    # BE CAREFUL!!!!!!!
    # BE CAREFUL!!!!!!!
    # BE CAREFUL!!!!!!!
    # I'm using this function to save the pt_info into file. Any change to this function may cause a serious problem!!!!
    def info_saving(self):
        text=re.sub('\"','\\\"',self.m_text)
        if text!='' and text[-1]=='\\':
            text=text[:-1]
        str_self=self.m_name+'\"'+text+'\"'

        str_self+='('
        if self.m_db[0]!=None:
            str_self=str_self+self.m_db[0].m_name
        str_self=str_self+','
        if self.m_db[1]!=None:
            str_self=str_self+self.m_db[1].m_name
        str_self=str_self+')'

        # str_self+='['+str(self.m_pos[0])+','+str(self.m_pos[1])+']'

        return str_self


    def printAllConnect(self):
        for point in self.m_con:
            point.print()
    
    # function to build a very complex structure
    def build(self,structure):
        building={}
        undefined={}
        list_return=[]

        aNetPoint=re.compile(r'[\w.,\[\]#=+*\\\-^$_\'~:@/\(\)]*\([\w.,\[\]#=+*\\\-^$_\'~:@/\(\)]*, *[\w.,\[\]#=+*\\\-^$_\'~:@/\(\)]*\)\[[\-0-9]+,[\-0-9]+\]')
        aNetPoint2=re.compile(r'([\w.,\[\]#=+*\\\-^$_\'~:@/\(\)]*\([\w.,\[\]#=+*\\\-^$_\'~:@/\(\)]*, *[\w.,\[\]#=+*\\\-^$_\'~:@/\(\)]*\))(?![\[])')
        # aNetPoint3=re.compile(r'[\w.,#=+*\\\-_\']*\[[-0-9]+,[-0-9]+\]')
        # aNetPoint4=re.compile(r'([\w.,#=+*\\\-_\']*)(?![\[\(,\)])')

        selfName=re.compile(r'([\w.,\[\]#=+*\\\-^$_\'~:@/\(\)]*)(?=\()')
        con0Name=re.compile(r'\(([\w.\[\]#=+*\\\-^$_\'~:@/\(\)]*),')
        con1Name=re.compile(r', *([\w.\[\]#=+*\\\-^$_\'~:@/\(\)]*)\)')
        posX=re.compile(r'\[([-0-9]+),')
        posY=re.compile(r',([-0-9]+)\]')
        
        points=aNetPoint.findall(structure)
        points+=aNetPoint2.findall(structure)
        for point_str in points:
            name=selfName.findall(point_str)[0]

            con0s=con0Name.findall(point_str)
            con0_name=''
            if con0s!=[]:
                con0_name=con0s[0]
            
            con1s=con1Name.findall(point_str)
            con1_name=''
            if con1s!=[]:
                con1_name=con1s[0]
            x=posX.findall(point_str)
            y=posY.findall(point_str)

            if name=='#THIS':
                point=self
            else:
                point=undefined.get(name,None)
                if point!=None:
                    undefined.pop(name)
                else:
                    point=NetP(name)
                    list_pt=building.get(name,[])
                    list_pt.append(point)
                    building.update({name:list_pt})
                list_return.append(point)
            
            if con0_name=='#THIS':
                point.connect(self,0)
            elif con0_name!='':
                list_con0=building.get(con0_name,[])
                if list_con0==[]:
                    point_new=NetP(con0_name)
                    list_con0.append(point_new)
                    building.update({con0_name:list_con0})
                    undefined.update({con0_name:point_new})
                point.connect(list_con0[-1],0)

            if con1_name=='#THIS':
                point.connect(self,1)
            elif con1_name!='':
                list_con1=building.get(con1_name,[])
                if list_con1==[]:
                    point_new=NetP(con1_name)
                    list_con1.append(point_new)
                    building.update({con1_name:list_con1})
                    undefined.update({con1_name:point_new})
                point.connect(list_con1[-1],1)

            if x!=[]:
                point.m_pos[0]=int(x[0])
            if y!=[]:
                point.m_pos[1]=int(y[0])
        for name in undefined:
            list_return.append(undefined[name])
        for point in list_return:
            point.m_name=re.sub(r'#.*$',"",point.m_name)

        return list_return

def infoInStr(string,str_info):
    a=string.find(str_info)
    return a!=-1


if __name__=="__main__":
    test=NetP("Nini")
    test2=NetP("haha")
    test3=NetP("gaga")
    test.connect(test2,0)
    test.connect(test3,1)


    test.print()
    test.build("a(#THIS,)[0,0];a#1(#THIS, a)")
    test.printAllConnect()