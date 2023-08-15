"""
+[返回目录]
+[python](Python,)->+[code](+[python],画图)
地址::body\\body_draw.py
+[保存文本](,画图)

"""

from re import M
from PyQt5.QtGui import QFont, QBrush, QColor, QPen, QPainterPath, QScreen, QTransform, QKeySequence, QPixmap
from PyQt5.QtCore import Qt, QRectF, QTimer
import numpy as np

import sys, logging
from PyQt5.QtWidgets import QWidget, QApplication, QVBoxLayout, QLabel, QPushButton
from PyQt5.QtGui import QPainter
from numpy.core.fromnumeric import size
if __name__=='__main__':
    sys.path.append(sys.path[0]+'\\..')
from body.bone import NetP
from tools import tools_basic, tools_format, tools_acts


class Draw(QWidget):
    def __init__(self,point=None,python=None):
        super().__init__()
        self.m_self=point

        self.m_port=None
        self.m_scene=None
        self.m_event=None

        self.m_mouse=None
        self.m_origin=None
        self.m_unit=None
        self.m_size=None
        self.m_pos=None

        self.m_drawing=None
        self.m_select=None
        
        if python==None:
            self.m_python=NetP('Python')
            self.m_python.m_var={}
        else:
            self.m_python=python
        self.m_python.m_var.update({'QFont':QFont,'QBrush':QBrush,'QColor':QColor,'QPen':QPen,\
                                    'Qt':Qt,'QRectF':QRectF,'QPainterPath':QPainterPath,'QPixmap':QPixmap,\
                                    'QTransform':QTransform})
        self.m_python.m_var.update({'np':np})

        self.m_dt=None
        self.m_t=None

        self.m_dT=0
        self.m_T=0

        self.m_timer=QTimer()
        self.m_timer.timeout.connect(self.showTime)
        # self.m_timer.start(100)
        self.m_label=QLabel(self.timeConvert(self.m_T))
        layout=QVBoxLayout()
        layout.addWidget(self.m_label)
        layout.addStretch()
        self.setLayout(layout)


        self.initialize(point)
        self.setGeometry(30,30,600,400)
        self.show()



    def initialize(self,point):
        if point==None:
            point=NetP('draw')
        self.m_self=point
        point.m_permission=0
        point.m_dev=self

        self.m_port=tools_basic.getVarFromPt(point,'m_port')
        self.m_scene=tools_basic.getVarFromPt(point,'m_scene')
        self.m_event=tools_basic.getVarFromPt(point,'m_event')

        self.m_mouse=tools_basic.getVarFromPt(point,'m_mouse')
        self.m_origin=tools_basic.getVarFromPt(point,'m_origin')
        self.m_unit=tools_basic.getVarFromPt(point,'m_unit')
        self.m_size=tools_basic.getVarFromPt(point,'m_size')
        self.m_pos=tools_basic.getVarFromPt(point,'m_pos')
        
        self.m_dt=tools_basic.getVarFromPt(point,'m_dt')
        self.m_t=tools_basic.getVarFromPt(point,'m_t')

        self.m_drawing=tools_basic.getVarFromPt(point,'m_drawing')
        self.m_select=tools_basic.getVarFromPt(point,'m_select')

        if self.m_event.m_db[1]==None:
            self.m_event.con(0,NetP("空"))
        if self.m_port.m_db[1]==None:
            self.m_port.con(0,NetP("空"))
        if self.m_scene.m_db[1]==None:
            self.m_scene.con(0,NetP("list"))
        self.m_origin.m_text="0,0"
        self.m_unit.m_text="1"

    def operate(self,action):
        result=False
        obj=action.m_db[1]
        if action.m_name=='[设置场景]' or action.m_name=='[setScene]':
            self.opSetScene(obj)
            result=True
        elif action.m_name=='[设置间隔]' or action.m_name=='[setDt]':
            self.opSetDt(obj,action)
            result=True
        elif action.m_name=='[开始计时]' or action.m_name=='[startTimer]':
            self.opStartTimer()
            result=True
        elif action.m_name=='[暂停计时]' or action.m_name=='[pauseTimer]':
            self.opPauseTimer()
            result=True
        elif action.m_name=='[重新计时]' or action.m_name=='[resetTimer]':
            self.opResetTimer()
            result=True
        # elif action.m_name=='[截屏]' or action.m_name=='[screenShot]':
        #     self.opScreenShot(obj,action)
        #     result=True
        return result,[]

    def opSetScene(self,obj):
        self.m_scene.con(0,obj)

    def opSetDt(self,obj,action):
        if obj==None and action.m_text=='':
            return
        if obj!=None:
            str_dt=obj.m_text
        else:
            str_dt=action.m_text
        try:
            dt=int(str_dt)
            if dt<10:
                return
            self.m_dt.m_text=str_dt
            self.m_dT=dt
        except:
            return

    def opStartTimer(self):
        if self.m_dT<10:
            print('The time span must be larger than 10 ms!')
            return
        self.m_timer.start(self.m_dT)
        
    def opPauseTimer(self):
        self.m_timer.stop()
        
    def opResetTimer(self):
        self.m_timer.stop()
        self.m_T=0
        self.m_t.m_text='0'


    # def opScreenShot(self,obj,action):
    #     if obj==None:
    #         path=action.m_text
    #     else:
    #         path=obj.m_text
    #     try:
    #         p = QScreen.grabWindow(QApplication.primaryScreen(), self.winID())
    #         p.save(path)
    #     except Exception as e:
    #         logging.exception(e)
    #         print("Screen shot is unsuccessful!")

            
    def showTime(self):
        dt=self.m_dT
        t=self.m_T+dt
        self.m_label.setText(self.timeConvert(self.m_T))
        self.m_T=t
        self.m_t.m_text=str(t)
        self.runEvent('timer',self.m_dt)
    
    def timeConvert(self,t):
        # msec=t%1000
        sec=t/1000
        s=sec%60
        minu=sec//60
        m=minu%60
        h=minu//60

        return "%02d:%02d:%05.2f"%(int(h),int(m),s)

    def paintEvent(self,event):
        # if self.m_scene.m_db[1]==None:
        #     print("Warning! No detect scene exists!")
        #     return
        pt_scene=self.m_scene.m_db[1]
        list_pt=tools_basic.getPointByFormat(pt_scene,'list')
        qp=QPainter()
        qp.begin(self)
        self.setTransform(qp)
        # qp.drawRect(0,0,100,100)
        eng=self.m_python.m_var
        eng.update({'qp':qp})
        for pt in list_pt:
            for con in pt.m_con:
                if con.m_name=='的' and con.m_db[0]==pt and con.m_db[1]!=None and con.m_db[1].m_name=='画图':
                    runPFun(eng,con.m_db[1])
                    break
            # print(pt.info())
        qp.end()

    def setTransform(self,qp):
        M=QTransform()
        try:
            pt=tools_format.str2Mat(self.m_origin.m_text)
            unit=tools_format.str2Mat(self.m_unit.m_text)
            winSize=tools_format.str2Mat(self.m_size.m_text)
            scale=1/unit
            localSize=winSize*unit
            
            M.scale(scale[0][0],scale[0][0])
            # M.translate(10,-10)
            M.translate(-(pt[0][0]-localSize[0][0]/2),-(pt[0][1]-localSize[0][1]/2))
        except Exception as e:
            logging.exception(e)
            return
        qp.setTransform(M)
        

    def mouseReleaseEvent(self,event):
        # self.opScreenShot(NetP('1','1.png'),NetP('2'))
        pos=[event.x(),event.y()]
        self.updateMosPt(pos)
        self.runEvent('mouseRelease')

    def mousePressEvent(self,event):
        pos=[event.x(),event.y()]
        pos0=self.ordTransform(pos)
        pt=self.inArea(pos0)
        self.updateMosPt(pos)
        self.runEvent('mousePress',pt)

    def mouseMoveEvent(self,event):
        pos=[event.x(),event.y()]
        self.updateMosPt(pos)
        self.runEvent('mouseMove')

    def updateMosPt(self,pos0):
        pos=self.ordTransform(pos0)
        self.m_mouse.m_text=tools_format.mat2Str(pos)

    def inArea(self,pos):
        pt_scene=self.m_scene.m_db[1]
        list_pt=tools_basic.getPointByFormat(pt_scene,'list')

        eng=self.m_python.m_var
        eng.update({'mouse_pos':pos})
        for pt in reversed(list_pt):
            for con in pt.m_con:
                if con.m_name=='的' and con.m_db[0]==pt and con.m_db[1]!=None and con.m_db[1].m_name=='选中区域':
                    runPFun(eng,con.m_db[1])
                    state=eng.get('state',False)
                    if state==True:
                        return pt
        return None


    def ordTransform(self,pos):
        try:
            origin=tools_format.str2Mat(self.m_origin.m_text)
            winSize=tools_format.str2Mat(self.m_size.m_text)
            unit=tools_format.str2Mat(self.m_unit.m_text)
            
            X=(pos[0]-winSize[0][0]/2)*unit[0][0]+origin[0][0]
            Y=(pos[1]-winSize[0][1]/2)*unit[0][0]+origin[0][1]
            return [X,Y]
        except Exception as e:
            logging.exception(e)
            return pos

    def resizeEvent(self,event):
        self.updateSysPts()
        return super().resizeEvent(event)

    def updateSysPts(self):
        pos=[self.geometry().x(),self.geometry().y()]
        size=[self.geometry().width(),self.geometry().height()]
        self.m_pos.m_text=tools_format.mat2Str(pos)
        self.m_size.m_text=tools_format.mat2Str(size)

    def opUpdateWin(self):
        pos=tools_format.str2Mat(self.m_pos.m_text)
        size=tools_format.str2Mat(self.m_size.m_text)
        try:
            self.setGeometry(pos[0],pos[1],size[0],size[1])
        except:
            pass

    def keyPressEvent(self, event):
        modifier=QApplication.keyboardModifiers()
        if modifier==Qt.ControlModifier:
            key_text=QKeySequence(event.key()).toString()
            # check whether is encoded in utf-8
            try:
                key_text="ctrl+"+key_text
                self.runEvent(key_text)
            except:
                pass
        else:
            key_text=QKeySequence(event.key()).toString()
            # check whether is encoded in utf-8
            try:
                self.runEvent(key_text)
            except:
                pass
        self.update()

    def runEvent(self,event,pt_obj=None):
        if self.m_event.m_db[1]==None or self.m_event.m_db[1].m_dev==None:
            print("Warning! No event library exist!")
            return
        if self.m_port.m_db[1]==None or self.m_port.m_db[1].m_dev==None:
            print("Warning! No detect port exist!")
            return
        # print("Event,",event+", happens in a viewer,",self.m_self.m_name)
        pt_event=self.m_event.m_db[1]
        pt_port=self.m_port.m_db[1]
        pt_code=tools_basic.getPoint(self.m_self,event,None)
        if pt_code==None:
            pt_action=NetP('['+event+']')
            pt_action.m_needed=1
            pt_action.con(self.m_self,pt_obj)
            result=pt_event.m_dev.transfer(pt_action,pt_port)
        else:
            pt_action=NetP('['+pt_code.m_name+']',pt_code.m_text)
            pt_action.m_needed=1
            pt_action.con(self.m_self,None)
            result=pt_event.m_dev.transfer(pt_action,pt_port,form='自定义',pt_ref=pt_code)
        # if result==[]:
        #     print('['+event+'] 的动作没有被定义')
        # else:
        #     print('执行结果:',result)
        self.update()

def runPFun(eng,pt_fun):
    vars_in={}
    vars_out={}
    code=pt_fun.m_text
    try:
        for con in pt_fun.m_con:
            if con.m_name=='的' and con.m_db[0]==pt_fun and con.m_db[1].m_name=='输入':
                pt_in=con.m_db[1]
                for con_in in pt_in.m_con:
                    # print(con_in.m_db[1].m_name+':',con_in.m_db[1],con_in.m_name,con_in.m_db[0]==con_in)
                    if con_in.m_db[0]==pt_in and con_in.m_name=='的' and con_in.m_db[1]!=None:
                        pt_var=con_in.m_db[1]
                        pt_var=getValue(pt_var)
                        vars_in.update({pt_var.m_name:['.',pt_var]})
            elif con.m_name=='的' and con.m_db[0]==pt_fun and con.m_db[1].m_name=='输出':
                pt_out=con.m_db[1]
                for con_o in pt_out.m_con:
                    if con_o.m_db[0]==pt_out and con_o.m_name=='的' and con_o.m_db[1]!=None:
                        pt_var=con_o.m_db[1]
                        vars_in.update({pt_var.m_name:['o',pt_var]})
                        vars_out.update({pt_var.m_name:['o',pt_var]})
        tools_acts.pythonCode(eng,code,vars_in,vars_out,False)
    except Exception as e:
        logging.exception(e)
    # for var in vars_out:
    #     setValue(vars_out[var])

                            
def getValue(pt):
    for con in pt.m_con:
        if con.m_name=='是' and con.m_db[1]==pt and con.m_db[0]!=None:
            pt.m_text=con.m_db[0].m_text
            break
    return pt

def setValue(pt):
    for con in pt.m_con:
        if con.m_name=='是' and con.m_db[0]==pt and con.m_db[1]!=None:
            con.m_db[1].m_text=pt.m_text


# a=Draw()


if __name__=='__main__':
    app=QApplication(sys.argv)
    window=Draw()
    # widget = QWidget()
    # window.opScreenShot(NetP('1','test.png'),NetP('2'))
    # print(window.winID())
    # widget.show()
    # print(widget.winID())
    sys.exit(app.exec_())