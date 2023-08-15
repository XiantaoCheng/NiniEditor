import sys
from PyQt5.QtWidgets import QWidget, QApplication
from PyQt5.QtGui import QPainter, QFont, QColor, QPen, QKeySequence
from PyQt5.QtCore import Qt, QRectF, QEvent
if __name__=='__main__':
    sys.path.append(sys.path[0]+'\\..')
from body.bone import NetP
# from body.body_port import Port
from body import GLOBAL
from tools import tools_basic, tools_format

class Viewer(QWidget):
    def __init__(self,point=None):
        super().__init__()

        self.m_self=None

        self.m_detect=None
        self.m_orign=None
        self.m_select=None
        self.m_event=None

        self.m_unit=40
        self.m_worldOrigin=[-5,-5]
        self.m_origin=None
        self.m_window=None
        self.m_sizeW=[500,500]
        # self.m_posW=[100,200]

        self.m_mode=0                           # 0-normal, 1-connect left, 2-connect right

        # self.m_ctrlEvents={}
        self.m_mouse=None

        self.initialize(point)

        # self.setWindow()
        # self.show()


        #QMessageBox.about(self,"test","test")

    def initialize(self,point):
        if point==None:
            point=NetP('screen')
        self.m_self=point
        point.m_permission=0
        point.m_dev=self

        list_pt=GLOBAL.LIST_PT
        self.m_detect=tools_basic.getVarFromPt(point,'m_detect',list_pt)
        self.m_select=tools_basic.getVarFromPt(point,'m_select',list_pt)
        self.m_event=tools_basic.getVarFromPt(point,'m_event',list_pt)
        self.m_orign=tools_basic.getVarFromPt(point,'m_origin',list_pt)

        # self.m_unit=tools_basic.getVarFromPt(point,'m_unit',list_pt)
        self.m_window=tools_basic.getVarFromPt(point,'m_window',list_pt)
        self.m_mouse=tools_basic.getVarFromPt(point,'m_mouse',list_pt)

        if self.m_detect.m_db[1]==None:
            self.m_detect.con(0,NetP("空"))
        if self.m_select.m_db[1]==None:
            self.m_select.con(0,NetP("list"))
        if self.m_event.m_db[1]==None:
            self.m_event.con(0,NetP("空"))
        # self.m_event.m_db[1].m_permission=1
        # self.m_detect.m_db[1].m_permission=1

        self.opLookAt(self.m_detect.m_db[1])
        
        

    def operate(self,action):
        result=False
        obj=action.m_db[1]
        if action.m_name=='[选中]' or action.m_name=='[select]':
            self.addSel(obj)
            result=True
        elif action.m_name=='[导入事件]' or action.m_name=='[loadEvents]':
            self.loadEvent(obj,action)
            result=True
        elif action.m_name=='[显示事件]' or action.m_name=='[printEvents]':
            self.printEvents()
            result=True
        elif action.m_name=='[删除事件]' or action.m_name=='[removeEvents]':
            self.removeEvent(obj)
            result=True
        elif action.m_name=='[清空事件]' or action.m_name=='[clearEvents]':
            self.clearEvents(action)
            result=True
        elif action.m_name=='[查看]' or action.m_name=='[lookAt]':
            self.opLookAt(obj)
            result=True
        return result,[]

    def opLookAt(self,obj):
        if obj==None or obj.m_dev==None:
            return
        pt_port=self.m_detect.m_db[1]
        if pt_port!=None and pt_port.m_dev!=None:
            port=pt_port.m_dev
            if self.m_self in port.m_viewers:
                port.m_viewers.remove(self.m_self)
        self.m_detect.con(0,obj)
        port=obj.m_dev
        if self.m_self not in port.m_viewers:
            port.m_viewers.append(self.m_self)
        self.update()
        self.updateTitle()

    def setWindow(self):
        # self.setWindowTitle(self.m_self.m_name)
        self.updateTitle()
        size=tools_format.str2Mat(self.m_window.m_text)
        if len(size)==0:
            size=[[200,200,500,500]]
        print(size)
        self.setGeometry(size[0][0],size[0][1],size[0][2],size[0][3])
        self.m_sizeW[0]=size[0][2]
        self.m_sizeW[1]=size[0][3]
        # self.setGeometry(self.m_posW[0],self.m_posW[1],self.m_sizeW[0],self.m_sizeW[1])

    def updateInfoW(self):
        size=[]
        size.append(self.geometry().x())
        size.append(self.geometry().y())
        size.append(self.geometry().width())
        size.append(self.geometry().height())
        self.m_window.m_text=tools_format.mat2Str(size)
        self.m_sizeW[0]=size[2]
        self.m_sizeW[1]=size[3]

    def updateTitle(self):
        title=self.m_self.m_name
        port=self.m_detect.m_db[1]
        if port!=None:
            title+=': '+port.m_name
        self.setWindowTitle(title)

    def genPool(self):
        pt_port=self.m_detect.m_db[1]
        if pt_port==None or pt_port.m_dev==None:
            pool=[]
        else:
            port=pt_port.m_dev
            pt_list=port.m_pool.m_db[1]
            if pt_list==None:
                print('Invalid pool!')
                pool=[]
            else:
                pool=tools_basic.getPointByFormat(pt_list,'list')
        return pool

    def genEnters(self):
        pt_port=self.m_detect.m_db[1]
        try:
            list_pt=pt_port.m_dev.enters()
        except:
            print("Error! Invalid detections of this viewer!")
            list_pt=[]
        return list_pt


    def paintEvent(self,event):
        self.updateInfoW()
        pool=self.genPool()
        enters=self.genEnters()
        qp=QPainter()
        qp.begin(self)
        self.gridOn(qp)
        self.drawScene(pool,enters,qp)
        qp.end()


    def drawScene(self,pool,enters,qp):
        dict_con={}
        pt_sel=self.m_select.m_db[1]
        list_sel=tools_basic.getPointByFormat(pt_sel,'list')
        for connect in pool:
            if connect.m_name!='的' or connect.m_db[0]==None or connect.m_db[0] not in pool \
                or connect.m_db[1]==None or connect.m_db[1] not in pool:
                if connect not in list_sel:
                    self.drawNetEdge(connect,250,qp,pool,3)
                else:
                    self.drawNetEdge(connect,250,qp,pool,5)
            elif connect.m_db[0] in list_sel:
                list_pt=dict_con.get(connect.m_db[0],[])
                if list_pt==[]:
                    dict_con.update({connect.m_db[0]:list_pt})
                list_pt.append(connect.m_db[1])

        for point in pool:
            if self.inScreen(point.m_pos):
                if point.m_name!='的' or point.m_db[0]==None or point.m_db[0] not in pool \
                    or point.m_db[1]==None or point.m_db[1] not in pool:
                    self.drawNetPoint(point,100,qp)
        for point in enters:
            if self.inScreen(point.m_pos):
                if point.m_name!='的' or point.m_db[0]==None or point.m_db[1]==None:
                    self.drawNetPoint(point,255,qp)

        for con in dict_con:
            self.drawRange(con,dict_con[con],qp)

    def drawRange(self,con,list_pt,qp):
        if list_pt==[]:
            return
        xmin=None
        ymin=None
        xmax=None
        ymax=None
        for pt in list_pt:
            if xmin==None or xmin>pt.m_pos[0]:
                xmin=pt.m_pos[0]
            if xmax==None or xmax<pt.m_pos[0]:
                xmax=pt.m_pos[0]
            if ymin==None or ymin>pt.m_pos[1]:
                ymin=pt.m_pos[1]
            if ymax==None or ymax<pt.m_pos[1]:
                ymax=pt.m_pos[1]
        
        dx=1/2
        x0,y0=self.pointPosition([xmin-dx,ymin-dx])
        x1,y1=self.pointPosition([xmax+dx,ymax+dx])
        xs,ys=self.pointPosition(con.m_pos)
        
        qp.setPen(QPen(Qt.black,1.5,Qt.DashLine))
        qp.setBrush(Qt.FDiagPattern)
        # qp.setBrush(faceColor)
        qp.drawRect(x0,y0,x1-x0,y1-y0)
        qp.drawLine(xs,ys,x0,y0)
        qp.drawLine(xs,ys,x0,y1)
        qp.drawLine(xs,ys,x1,y0)
        qp.drawLine(xs,ys,x1,y1)
        for pt in list_pt:
            self.drawNetPoint(pt,255,qp)



    def pointPosition(self,pos):
        x=(pos[0]-self.m_worldOrigin[0])*self.m_unit
        y=(pos[1]-self.m_worldOrigin[1])*self.m_unit
        return [x,y]

    def screenPos2WorldPos(self,posS):
        x=posS[0]/self.m_unit+self.m_worldOrigin[0]+0.5
        if x<0:
            x+=-1
        y=posS[1]/self.m_unit+self.m_worldOrigin[1]+0.5
        if y<0:
            y+=-1
        return [int(x),int(y)]

    def inScreen(self,pos):
        R=self.m_unit*0.4
        dx=(pos[0]-self.m_worldOrigin[0])*self.m_unit
        dy=(pos[1]-self.m_worldOrigin[1])*self.m_unit
        return dx>-R and dx<self.m_sizeW[0]+R and dy>-R and dy<self.m_sizeW[1]+R

    def screenAreaInWorld(self):
        x0=self.m_worldOrigin[0]
        y0=self.m_worldOrigin[1]
        dx=self.m_sizeW[0]/self.m_unit
        dy=self.m_sizeW[1]/self.m_unit
        return [x0,y0,dx,dy]

    def gridOn(self,qp):
        [x0,y0,dx,dy]=self.screenAreaInWorld()
        width=self.m_unit*0.5
        qp.setFont(QFont("Decorative",self.m_unit*0.2))

        for i in range(int(x0),int(x0+dx+1)):
            [xi,yi]=self.pointPosition([i,int(y0)])
            qp.drawLine(xi,0,xi,self.m_sizeW[1])
            if i!=x0:
                qp.drawText(QRectF(xi-width,yi,width,width),Qt.AlignCenter,str(i))
        for i in range(int(y0),int(y0+dy+1)):
            [xi,yi]=self.pointPosition([int(x0),i])
            qp.drawLine(0,yi,self.m_sizeW[0],yi)
            if i!=y0:
                qp.drawText(QRectF(xi,yi-width,width,width),Qt.AlignCenter,str(i))

    def drawNetPoint(self,point,transparency,qp):
        R=self.m_unit*0.4
        pos=self.pointPosition(point.m_pos)
        pt_sel=self.m_select.m_db[1]
        list_sel=tools_basic.getPointByFormat(pt_sel,'list')

        if point in list_sel:
            if point==list_sel[-1]:
                if self.m_mode==0:
                    lineColor=QColor(0,0,250,150)
                elif self.m_mode==1:
                    lineColor=QColor(0,250,0,150)
                else:
                    lineColor=QColor(250,0,0,150)
            else:
                if self.m_mode==0:
                    lineColor=QColor(31,73,125,100)
                elif self.m_mode==1:
                    lineColor=QColor(0,125,0,100)
                else:
                    lineColor=QColor(125,0,0,100)
        else:
            lineColor=QColor(31,73,125,0)

        if point.m_permission==0:
            faceColor=QColor(187,155,89,transparency)
        elif point.m_var!=None:
            faceColor=QColor(200,20,50,transparency)
        elif point.m_creator!=None or point.m_needed==None:
            faceColor=QColor(155,187,89,transparency)
        else:
            faceColor=QColor(50,50,200,transparency)

        self.drawNetP(pos,point.m_name,R,qp,lineColor,faceColor)


    def drawNetEdge(self,point,transparency,qp,pool=None,lineWidth=5):
        if pool==None:
            pool=self.genPool()
        pos0=self.pointPosition(point.m_pos)

        if point.m_db[0]!=None and point.m_db[0] in pool:
            pos1=self.pointPosition(point.m_db[0].m_pos)
            lineColor=QColor(31,73,125,transparency)
            self.drawEdge(pos0,pos1,qp,lineColor,lineWidth)

        if point.m_db[1]!=None and point.m_db[1] in pool:
            pos1=self.pointPosition(point.m_db[1].m_pos)
            lineColor=QColor(73,125,37,transparency)
            self.drawEdge(pos0,pos1,qp,lineColor,lineWidth)

    def drawNetP(self,pos,name,R,qp,lineColor,faceColor,fontColor=Qt.white,lineWidth=4):
        x0=pos[0]-R
        y0=pos[1]-R
        qp.setPen(QPen(lineColor,lineWidth,Qt.SolidLine))
        qp.setBrush(faceColor)
        # qp.drawEllipse(x0,y0,R*2,R*2)
        qp.drawRect(x0,y0,R*2,R*2)

        qp.setPen(fontColor)
        qp.setFont(QFont("Decorative",8))
        # qp.drawText(QRectF(x0,y0,R*2,R*2),Qt.AlignCenter&Qt.TextWordWrap,name)
        if len(name)>3:
            name=name[0:3]
        qp.drawText(QRectF(x0,y0,R*2,R*2),Qt.AlignCenter,name)

    def drawEdge(self,pos0,pos1,qp,lineColor,lineWidth=5):
        x0=pos0[0]
        y0=pos0[1]
        x1=pos1[0]
        y1=pos1[1]
        qp.setPen(QPen(lineColor,lineWidth,Qt.SolidLine))
        qp.drawLine(x0,y0,x1,y1)


    def selectPoint(self,pos,pos2):
        list_pt=self.genPool()
        list_pt.reverse()
        list_sel=[]
        if pos[0]==pos2[0] and pos[1]==pos2[1]:
            for point in list_pt:
                if point.m_name=='的' and point.m_db[0] in list_pt and point.m_db[0]!=None\
                     and point.m_db[1] in list_pt and point.m_db[1]!=None:
                    continue
                if pos[0]==point.m_pos[0] and pos[1]==point.m_pos[1]:
                    return [point]
        else:
            for point in list_pt:
                if point.m_name=='的' and point.m_db[0] in list_pt and point.m_db[0]!=None\
                     and point.m_db[1] in list_pt and point.m_db[1]!=None:
                    continue
                if between(pos,pos2,point.m_pos):
                    list_sel.append(point)
        return list_sel


    def updateMouse(self,pos,state,db=1):
        pos_w=self.screenPos2WorldPos(pos)
        mouse=self.m_mouse
        mouse.m_pos=pos_w.copy()

        if mouse.m_db[db]==None:
            mouse.m_db[db]=NetP(state)
        else:
            mouse.m_db[db].m_name=state
        return mouse
        


    def mouseReleaseEvent(self, event):
        list_sel=tools_basic.getPointByFormat(self.m_select.m_db[1],'list')

        pos=[event.x(),event.y()]
        mouse=self.m_mouse
        pos_old=mouse.m_pos.copy()
        mouse=self.updateMouse(pos,'up')
        pos=mouse.m_pos.copy()

        modifier=QApplication.keyboardModifiers()
        list_pt=self.selectPoint(pos,pos_old)
        button=mouse.m_db[0]

        tools_basic.printPtList(list_pt)

        if len(list_pt)==1:
            list_pt[0].print("全部关联")
        if button.m_name=='left':
            if list_pt==[]:
                if self.m_mode==0:
                    self.movePoints(list_sel,pos)
                else:
                    self.connectPoints(point,list_sel,self.m_mode)
            else:
                if modifier==Qt.ControlModifier:
                    for pt in list_pt:
                        if pt not in list_sel:
                            self.addSel(pt)
                else:
                    self.clearSel()
                    for pt in list_pt:
                        self.addSel(pt)
        else:
            self.m_mode=0
            if modifier!=Qt.ControlModifier:
                self.clearSel()
            else:
                for pt in list_pt:
                    if pt in list_sel:
                        self.removeSel(pt)
        # self.runEvent('mouseRelease')
        self.update()

    def mousePressEvent(self,event):
        pos=[event.x(),event.y()]
        mouse=self.updateMouse(pos,'down')
        if event.buttons()==Qt.LeftButton:
            mouse=self.updateMouse(pos,'left',0)
        else:
            mouse=self.updateMouse(pos,'right',0)
        # self.runEvent('mousePress')
        self.update()

        return super().mousePressEvent(event)

    def addSel(self,point):
        pt_select=self.m_select.m_db[1]
        list_sel=tools_basic.getPointByFormat(pt_select,'list')
        if point==None or point in list_sel:
            return
        # pt_select=tools_basic.getPoint(self.m_self,'m_select','list')
        # To select the invisiable 的
        for con in point.m_con:
            if con.m_name=='的':
                if con.m_db[0]!=point and con.m_db[0]!=None:
                    if con.m_db[0] in list_sel:
                        tools_basic.setPointByFormat(pt_select,'list.append',con)
                elif con.m_db[1]!=point and con.m_db[1]!=None:
                    if con.m_db[1] in list_sel:
                        tools_basic.setPointByFormat(pt_select,'list.append',con)
                        
        list_sel.append(point)
        tools_basic.setPointByFormat(pt_select,'list.append',point)



    def clearSel(self):
        pt_select=self.m_select.m_db[1]
        tools_basic.setPointByFormat(pt_select,'list.clear')

    def removeSel(self,point):
        pt_select=self.m_select.m_db[1]
        list_sel=tools_basic.getPointByFormat(pt_select,'list')
        if point==None or point not in list_sel:
            return
        tools_basic.setPointByFormat(pt_select,'list.remove',point)
        # To remove the invisiable 的.
        for con in point.m_con:
            if con.m_name=='的':
                if con.m_db[0]!=None and con.m_db[1]!=None and con in list_sel:
                    tools_basic.setPointByFormat(pt_select,'list.remove',con)


    def popSel(self):
        # self.m_select.pop()
        # pt_select=tools_basic.getPoint(self.m_self,'m_select','list')
        pt_select=self.m_select.m_db[1]
        tools_basic.setPointByFormat(pt_select,'list.pop')

    def movePoints(self,list_pt,pos):
        # if list_pt==[]:
        #     return
        # pos0=list_pt[-1].m_pos
        # pos1=self.screenPos2WorldPos(pos)
        # dx=pos1[0]-pos0[0]
        # dy=pos1[1]-pos0[1]
        # for point in list_pt:
        #     point.m_pos[0]+=dx
        #     point.m_pos[1]+=dy
        if list_pt==[]:
            return
        pos0=list_pt[-1].m_pos
        dx=pos[0]-pos0[0]
        dy=pos[1]-pos0[1]
        for point in list_pt:
            point.m_pos[0]+=dx
            point.m_pos[1]+=dy
        

    def connectPoints(self,anchor,list_pt,mode):
        if list_pt==[]:
            return
        for connect in list_pt:
            if mode==1:
                connect.disconnect_i(0)
                if anchor!=None:
                    connect.connect(anchor,0)
            elif mode==2:
                connect.disconnect_i(1)
                if anchor!=None:
                    connect.connect(anchor,1)


    def keyPressEvent(self, event):
        modifier=QApplication.keyboardModifiers()
        if modifier==Qt.ControlModifier:
            key_text=QKeySequence(event.key()).toString()
            if key_text=='C':
                self.copyPoints()
            elif key_text=='V':
                self.pastePoints()
            # check whether is encoded in utf-8
            try:
                key_text="ctrl+"+key_text
                print(key_text)
                self.runEvent(key_text)
            except:
                pass
        else:
            if event.key()==Qt.Key_Up:
                self.m_worldOrigin[1]-=1
            elif event.key()==Qt.Key_Down:
                self.m_worldOrigin[1]+=1
            elif event.key()==Qt.Key_Right:
                self.m_worldOrigin[0]+=1
            elif event.key()==Qt.Key_Left:
                self.m_worldOrigin[0]-=1
            elif event.key()==Qt.Key_PageUp:
                self.m_unit+=1
            elif event.key()==Qt.Key_PageDown:
                self.m_unit-=1
            elif event.key()==Qt.Key_Q:
                self.m_mode=0
                # self.m_select.clear()
                self.clearSel()
            elif event.key()==Qt.Key_L:
                if self.m_mode!=1:
                    self.m_mode=1
                else:
                    self.m_mode=0
            elif event.key()==Qt.Key_R:
                if self.m_mode!=2:
                    self.m_mode=2
                else:
                    self.m_mode=0
            key_text=QKeySequence(event.key()).toString()
            # check whether is encoded in utf-8
            try:
                print(key_text)
                self.runEvent(key_text)
            except:
                pass
        self.update()
        
    def runEvent(self,event):
        if self.m_event.m_db[1]==None or self.m_event.m_db[1].m_dev==None:
            print("Warning! No event library exist!")
            return
        if self.m_detect.m_db[1]==None or self.m_detect.m_db[1].m_dev==None:
            print("Warning! No detect port exist!")
            return
        # print("Event,",event+", happens in a viewer,",self.m_self.m_name)
        pt_event=self.m_event.m_db[1]
        pt_port=self.m_detect.m_db[1]
        pt_action=NetP('['+event+']')
        pt_action.m_needed=1
        pt_action.con(self.m_self,0)
        result=pt_event.m_dev.transfer(pt_action,pt_port)
        # if result==[]:
        #     print('['+event+'] 的动作没有被定义')
        # else:
        #     print('执行结果:',result)

    def copyPoints(self):
        # To include 的(a,b), which is invisiable in the screen, anytime when a and b are selected, 的 will be selected automatically
        # Changes are made in addSel.
        pt_port=self.m_detect.m_db[1]
        if pt_port==None or pt_port.m_dev==None:
            return
        port=pt_port.m_dev
        pt_select=self.m_select.m_db[1]
        if pt_select==None:
            return
        port.opCopy(pt_select)

    def pastePoints(self):
        pt_port=self.m_detect.m_db[1]
        if pt_port==None or pt_port.m_dev==None:
            return
        port=pt_port.m_dev
        list_pt=port.paste()
        if list_pt!=[]:
            self.clearSel()
            pt_select=self.m_select.m_db[1]
            tools_basic.setPointByFormat(pt_select,'list.+=',list_pt)




    # def focusInEvent(self,event):
    #     print(1222)
    #     return super().focusInEvent(self,event)
        

def between(pt1,pt2,pt0):
    x1=pt1[0]
    y1=pt1[1]
    x2=pt2[0]
    y2=pt2[1]
    x0=pt0[0]
    y0=pt0[1]
    return (x1-x0)*(x2-x0)<=0 and (y1-y0)*(y2-y0)<=0



if __name__=='__main__':
    # app=QApplication(sys.argv)
    # window=Viewer('Draw')
    # sys.exit(app.exec_())
    print(between([2,2],[0,0],[2,1]))
