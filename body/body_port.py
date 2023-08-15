import sys, time
import clipboard
if __name__=='__main__':
    sys.path.append(sys.path[0]+'\\..')
from body.bone import NetP
from body.body_lib import Library
from body import GLOBAL
from tools import tools_acts, tools_parsers, tools_basic

class Port:
    def __init__(self,point=None):
        super().__init__()

        self.m_self=None

        self.m_sysPool=[]
        # self.m_outDev=[]
        # self.m_inDev=[]

        self.m_pool=None
        # self.m_enters=None
        self.m_updates=None
        self.m_history=None
        self.m_viewers=[]

        self.m_lib=None

        self.initialize(point)

    def initialize(self,point):
        if point==None:
            point=NetP('port')
        self.m_self=point
        point.m_dev=self
        point.m_permission=0
        # GLOBAL.LIST_DEV.append(self.m_self)

        list_pt=GLOBAL.LIST_PT
        self.m_lib=tools_basic.getVarFromPt(point,'m_lib',list_pt)
        self.m_pool=tools_basic.getVarFromPt(point,'m_pool',list_pt)
        self.m_updates=tools_basic.getVarFromPt(point,'m_updates',list_pt)
        self.m_history=tools_basic.getVarFromPt(point,'m_history',list_pt)

        # self.m_enters=tools_basic.getVarFromPt(point,'m_enters','Enters',pt_permission=0)


        # tools_basic.getPointByFormat(self.m_enters,'list')

        # self.m_pool=pt_pool.m_db[1]
        # if self.m_lib.m_db[1]!=None:
        #     self.m_lib.m_dev=self.m_lib.m_db[1].m_dev
        
        # if self.m_lib.m_dev==None:
        #     if self.m_lib.m_db[1]!=None:
        #         if self.m_lib.m_db[1].m_dev!=None:
        #             lib=Library(self.m_lib.m_db[1])
        #         else:
        #             lib=self.m_lib.m_db[1].m_dev
        #     self.m_lib.m_dev=lib

        # if self.m_enters not in list_pool:
        #     self.input([self.m_enters])


        if self.m_pool.m_db[1]==None:
            self.m_pool.con(0,NetP('list'))
        if self.m_updates.m_db[1]==None:
            self.m_updates.con(0,NetP('list'))
            
        # tools_basic.getPointByFormat(self.m_updates,'list')
        self.removePoolRepeat(self.m_pool.m_db[1])

    def removePoolRepeat(self,pt_pool):
        list_remove=[]
        set_have=set()
        self.m_self.print()
        for i in range(0,len(pt_pool.m_con)):
            if pt_pool.m_con[i].m_name=='的' and pt_pool.m_con[i].m_db[0]==pt_pool:
                if pt_pool.m_con[i] in set_have:
                    list_remove.append(pt_pool.m_con[i])
                else:
                    set_have.add(pt_pool.m_con[i])
        for pt in list_remove:
            pt.delete()



    def operate(self,action):
        pt_pool=self.m_pool.m_db[1]
        pool=tools_basic.getPointByFormat(pt_pool,'list')

        actions_new=[]
        sbj=action.m_db[0]
        obj=action.m_db[1]
        if action.m_name=='[导入设备]' or action.m_name=='[loadDev]':
            self.opLoadUpdateDev(obj)
        elif action.m_name=='[删除设备]' or action.m_name=='[DelDev]':
            self.opDelUpdateDev(obj)
        elif action.m_name=='[复制]' or action.m_name=='[copy]':
            self.opCopy(obj,action)
        elif action.m_name=='[粘贴]' or action.m_name=='[paste]':
            self.opPaste(obj,action)
        elif action.m_name=='[置顶]' or action.m_name=='[toTop]':
            self.opToTop(obj)
        elif action.m_name=='[置底]' or action.m_name=='[toBottom]':
            self.opToBottom(obj)
        else:
            return False,[]
        return True,actions_new

    def transfer(self,action,limit=False,form=None,pt_ref=None):
        try:
            lib=self.m_lib.m_db[1].m_dev
        except:
            print('Error! No lib is found in this port! ')
        # actions_new=[]
        sbj=action.m_db[0]
        obj=action.m_db[1]
        results=lib.transfer(action,limit=limit,form=form,pt_ref=pt_ref)
        if results==[]:
            pass
        else:
            print(action,':',results)
        # if results==[]:
        #     print(action.info(show_info="不显示文本不显示位置"),"没有被定义")
        # else:
        #     print(action.info("不显示文本不显示位置"),"运行结果:",results)
        return True
        # return True,actions_new


    def opLoadUpdateDev(self,obj):
        try:
            obj.m_dev.update()
        except:
            print("Error! Loading device into update pool failed!")
            return
        tools_basic.setPointByFormat(self.m_updates.m_db[1],'list.append',obj)
        obj.m_permission=0


    def opDelUpdateDev(self,obj):
        if obj==None:
            return
        try:
            tools_basic.setPointByFormat(self.m_updates.m_db[1],'list.remove',obj)
        except:
            print("Error! Deleting object,",obj.info(),'failed.')

    def paste(self):
        str_pt=clipboard.paste()
        try:
            list_pt=tools_basic.buildPoints_tokener(str_pt)
            tools_basic.printPtList(list_pt)
            self.addPtsIntoPool(list_pt)
        except:
            return []
        return list_pt

    def opPaste(self,obj,action):
        list_pt=self.paste()
        if obj==None:
            return
        list_de=[]
        type_all=False
        for con in action.m_con:
            if con.m_db[0]==action and (con.m_name=='全部' or con.m_name=='[全部]'):
                for pt in list_pt:
                    pt_de=NetP('的').con(obj,pt)
                    list_de.append(pt_de)
                type_all=True
                break
        if not type_all:
            pt_de=NetP('的').con(obj,list_pt[-1])
            list_de.append(pt_de)
        self.addPtsIntoPool(list_de)
        return

    def opCopy(self,obj,action=None):
        if obj!=None:
            list_pt=tools_basic.getPointByFormat(obj,'list')
            if list_pt==[]:
                list_pt=[obj]
        else:
            list_pt=[]
            for con in action.m_con:
                if con.m_name=='[的]' and con.m_db[0]==action and con.m_db[1]!=None:
                    list_pt.append(con.m_db[1])
        if list_pt==[]:
            return
        else:
            try:
                str_pt=tools_basic.writeStdCode([],list_pt)
                clipboard.copy(str_pt)
            except:
                return

    def opToTop(self,obj):
        pt_pool=self.m_pool.m_db[1]
        if tools_basic.checkPointByFormat(pt_pool,'list.in',obj):
            tools_basic.setPointByFormat(pt_pool,'list.remove',obj)
            tools_basic.setPointByFormat(pt_pool,'list.append',obj)
        # except:
        #     return

    def opToBottom(self,obj):
        pt_pool=self.m_pool.m_db[1]
        try:
            tools_basic.setPointByFormat(pt_pool,'list.remove',obj)
            tools_basic.setPointByFormat(pt_pool,'list.insertHead',obj)
        except:
            return
        

    def update(self):
        for viewer in self.m_viewers:
            if viewer.m_dev!=None:
                viewer.m_dev.update()
        list_updates=tools_basic.getPointByFormat(self.m_updates.m_db[1],'list')
        for pt_device in list_updates:
            if pt_device.m_dev!=None:
                pt_device.m_dev.update()

    def updateTitle(self):
        for viewer in self.m_viewers:
            if viewer.m_dev!=None:
                viewer.m_dev.updateTitle()

    def input(self,points,mode=1,keepPos=False):
        if points==[]:
            return
        pool=tools_basic.getPointByFormat(self.m_pool.m_db[1],'list')
        points_new=[]
        origin=None
        for pt in pool:
            if pt.m_name=='诞生地':
                origin=pt
                break
        for point in points:
            if point not in pool:
                points_new.append(point)
                point.m_building=False
                if origin!=None and not keepPos:
                    point.m_pos=origin.m_pos.copy()
        pt_act,pt_obj=self.divPts(points_new)
        self.addPtsIntoPool(pt_obj)
        # self.update()
        # if points_new!=[] and mode==1:
        if mode==1:
            tools_acts.operateAll(pt_act,self)
        self.update()
    

    def addPtsIntoPool(self,pts):
        pt_pool=self.m_pool.m_db[1]
        # self.m_pool.m_db[1]+=pts
        tools_basic.setPointByFormat(pt_pool,'list.+=',pts)
    
    def rmPtFromPool(self,pt):
        pt_pool=self.m_pool.m_db[1]
        tools_basic.setPointByFormat(pt_pool,'list.remove',pt)

    def renew(self,points):
        pt_pool=self.m_pool.m_db[1]
        tools_basic.setPointByFormat(pt_pool,'list.clear')
        # self.m_pool.m_db[1].clear()
        self.input(points)

    def clear(self):
        pt_pool=self.m_pool.m_db[1]
        tools_basic.setPointByFormat(pt_pool,'list.clear')
        # self.m_pool.m_db[1].clear()
        self.update()

    def close(self):
        self.clear()
        for device in self.m_outDev:
            self.signout(device)
        for device in self.m_inDev:
            self.signout(device)

    def divPts(self,points):
        actions=[]
        outputs=[]
        for point in points:
            if point.m_creator==None and point.m_needed!=None:
                # point.print()
                actions.append(point)
            else:
                outputs.append(point)
        return actions,outputs

    # def enters(self):
    #     list_pt=tools_basic.getPointByFormat(self.m_enters,'list')
    #     if list_pt==[]:
    #         list_pt=tools_basic.getPointByFormat(self.m_pool.m_db[1],'list')
    #     elif self.m_pool.m_db[1] not in list_pt:
    #         list_pt.append(self.m_pool.m_db[1])
    #     if self.m_enters not in list_pt:
    #         list_pt.append(self.m_enters)
    #     return list_pt

    def enters(self):
        list_pt=tools_basic.getPointByFormat(self.m_pool.m_db[1],'list')
        return list_pt
    
    def printActionStack(self,actions,pop_ac):
        print('Pop:',pop_ac.info())
        print('Action Stack:')
        tools_basic.printPtList(actions)
        print()


    def info(self):
        pool=tools_basic.getPointByFormat(self.m_pool.m_db[1],'list')
        info_str=''
        for point in pool:
            info_str+=point.info()+'\n'
        return info_str





if __name__=='__main__':
    interior=Port(NetP('pool'))
    print(interior.enters())
    print(GLOBAL.LIST_PT)