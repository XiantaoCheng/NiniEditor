import sys, re, os
if __name__=='__main__':
    sys.path.append(sys.path[0]+'\\..')
from body.bone import NetP
from body.soul import Karma
# from body.body_compiler import Compiler
# from body.body_port import Port
# from body.body_viewer import Viewer
# from body.body_debugger import Debugger
from body import GLOBAL
from tools import tools_basic, tools_format
from PyQt5.QtWidgets import QTextEdit, QApplication, QMessageBox, QFontDialog
from PyQt5.QtCore import Qt
from PyQt5.QtGui import QTextCursor, QFont, QKeySequence
import logging
import platform
# import matlab.engine

class Editor(QTextEdit):
    def __init__(self,point=None):
        super().__init__()
        self.m_self=point
        
        self.m_port=None
        self.m_compiler=None
        self.m_event=None
        # self.m_debugger=None
        self.m_readPtr=None
        self.m_cursor=None

        self.m_x=None
        self.m_y=None
        self.m_height=None
        self.m_width=None
        

        self.m_currentFile=None
        self.m_currentFolder=''
        self.m_changed=False
        self.textChanged.connect(self.changed)
        
        # debugger part
        self.m_debug=False
        self.m_words={}
        self.m_sents={}
        self.m_karmas=[]
        self.m_ptrKm=0


        self.initialize(point)


    def initialize(self,point):
        if point==None:
            point=NetP('editor')
        self.m_self=point
        point.m_dev=self
        point.m_permission=1
        
        if point.m_db[0]==None:
            point.con(NetP('file'),0)
        self.m_currentFile=point.m_db[0]

        list_pt=GLOBAL.LIST_PT
        self.m_readPtr=tools_basic.getVarFromPt(point,'m_readPtr',list_pt)
        self.m_cursor=tools_basic.getVarFromPt(point,'m_cursor',list_pt)

        self.m_port=tools_basic.getVarFromPt(point,'m_port',list_pt)
        self.m_event=tools_basic.getVarFromPt(point,'m_event',list_pt)
        self.m_compiler=tools_basic.getVarFromPt(point,'m_compiler',list_pt)

        self.m_x=tools_basic.getVarFromPt(self.m_self,'m_x',list_pt)
        self.m_y=tools_basic.getVarFromPt(self.m_self,'m_y',list_pt)
        self.m_height=tools_basic.getVarFromPt(self.m_self,'m_height',list_pt)
        self.m_width=tools_basic.getVarFromPt(self.m_self,'m_width',list_pt)

        if self.m_event.m_db[1]==None:
            self.m_event.con(0,NetP("空"))
        if self.m_port.m_db[1]==None:
            self.m_port.con(0,NetP("空"))
        # self.m_event.m_db[1].m_permission=1
        # self.m_port.m_db[1].m_permission=1

        self.opSetReadPtr(self.m_readPtr.m_db[1])
        self.updateByPts()
        # self.setFont(QFont('宋体'))
        # self.setFont(QFont('Cascadia Mono'))
        # self.setFont(QFont('Cascadia Code'))
        # self.setFont(QFont('Fira Code'))
        # self.setFont(QFont('Dina'))
        # self.setFont(QFont('Lucida'))
        # font_=QFont('Ubuntu Mono')
        # font_=QFont('Anonymous Pro')
        # font_.setFixedPitch(True)
        # self.setFont(font_)
        self.setFont(QFont('Times New Roman'))
        # self.setFont(QFont('Arial'))
        self.setStyleSheet('font: 20px;')
        self.show()


    def operate(self,action):
        result=False
        obj=action.m_db[1]
        if action.m_name=='[编辑文本]' or action.m_name=='[edit]':
            self.opSetReadPtr(obj)
            result=True
        elif action.m_name=='[设置端口]' or action.m_name=='[setPort]':
            self.opSetPort(obj)
            result=True
        elif action.m_name=='[输入文本]' or action.m_name=='[inputText]':
            self.opInputText(obj,action)
            result=True
        elif action.m_name=='[更新文本]' or action.m_name=='[updateText]':
            self.opUpdateText()
            result=True
        elif action.m_name=='[设置光标]' or action.m_name=='[setCursor]':
            result=self.opSetCursor(obj,action)
        elif action.m_name=='[另存为]' or action.m_name=='[saveAs]':
            result=self.opSaveAs(obj)
        return result,[]

    def opSaveAs(self,obj):
        if obj==None or obj.m_text=='':
            return
        self.saveAsFile(obj.m_text)
        

    def opSetCursor(self,obj,action):
        if obj!=None:
            str_pos=obj.m_text
        elif action.m_text!='':
            str_pos=action.m_text
        else:
            return False
        self.m_cursor.m_text=str_pos
        try:
            pos=tools_format.str2Mat(str_pos)
            ns=int(pos[0,0])
            ne=int(pos[0,1])
            self.selectText(ns,ne)
            return True
        except Exception as e:
            logging.exception(e)
            return False


    def opSetPort(self,obj):
        if obj==None or obj.m_dev==None:
            print("Error! No port existed!")
            return
        self.m_port.con(0,obj)
        self.m_currentFile=obj.m_dev.m_pool.m_db[1]
        self.m_self.con(self.m_currentFile,0)
        self.opSetReadPtr(None)


    def opInputText(self,obj,action):
        if obj==None and action.m_text=='':
            return
        elif action.m_text=='':
            text=obj.m_text
        elif obj==None:
            text=action.m_text
        else:
            pat=action.m_text
            con=obj.m_text
            try:
                text=pat%(con)
            except:
                text=pat+con
        
        text=self.toPlainText()+text
        self.setPlainText(text)
        
    def opUpdateText(self):
        text=self.m_readPtr.m_db[1].m_text
        self.setPlainText(text)
        str_pos=self.m_cursor.m_text
        try:
            pos=tools_format.str2Mat(str_pos)
            ns=int(pos[0,0])
            ne=int(pos[0,1])
            self.selectText(ns,ne)
            return True
        except Exception as e:
            logging.exception(e)
            return False

    def resizeEvent(self, QResizeEvent):
        self.updateSysPts()
        return super().resizeEvent(QResizeEvent)

    def updateCursor(self):
        cursor=self.textCursor()
        s=cursor.selectionStart()
        e=cursor.selectionEnd()
        self.m_cursor.m_text="%d,%d"%(s,e)

    def closeEvent(self, event):
        print('Window closed!')
        self.m_readPtr.con(0,None)
        return super().closeEvent(event)

    def focusInEvent(self, event):
        self.updateCursor()
        return super().focusInEvent(event)

    def focusOutEvent(self, event):
        self.updateCursor()
        return super().focusOutEvent(event)

    def mousePressEvent(self, event):
        self.updateCursor()
        return super().mousePressEvent(event)

    def keyPressEvent(self, event):
        self.updateCursor()
        if self.m_debug==False:
            self.editEvent(event)
        else:
            self.debugEvent(event)
        # print('????还能这样?')
        # result=super().keyPressEvent(event)
        # print('!!!!不是吧!')
        # return result
        return super().keyPressEvent(event)

    def editEvent(self,event):
        modifier=QApplication.keyboardModifiers()
        if modifier==Qt.ControlModifier:
            if event.key()==Qt.Key_S:
                self.saveAsFile()
            elif event.key()==Qt.Key_R:
                self.runCode()
            elif event.key()==Qt.Key_T:
                self.startDebug()
            elif event.key()==Qt.Key_P:
                self.createPage()
            elif event.key()==Qt.Key_Q:
                self.resetColor()
            try:
                key_text="ctrl+"+QKeySequence(event.key()).toString()
                print('Key Pressed:',key_text)
                self.runEvent(key_text)
            except:
                pass

    
    def runEvent(self,event):
        if self.m_event.m_db[1]==None or self.m_event.m_db[1].m_dev==None:
            print("Warning! No event library exist!")
            return
        if self.m_port.m_db[1]==None or self.m_port.m_db[1].m_dev==None:
            print("Warning! No output port exist!")
            return
        #print("Event,",event+", happens in an editor,",self.m_self.m_name)
        pt_event=self.m_event.m_db[1]
        pt_port=self.m_port.m_db[1]
        pt_action=NetP('['+event+']')
        pt_action.m_needed=1
        pt_action.con(self.m_self,0)
        result=pt_event.m_dev.transfer(pt_action,pt_port)
        # if result==[]:
        #     print('['+event+'] 的动作没有被定义')
        # else:
        #     print('执行结果:',result)


    def saveAsFile(self,fileName=None):
        if fileName==None:
            fileName=self.m_currentFile.m_text
        if fileName=='':
            QMessageBox.Warning(self,"Save failed!","Warning: the file name can't be empty")
        
        if platform.uname()[0]=='Linux':
            fileName=fileName.replace('\\','/')
            
        if fileName[-5:]=='.ftxt':
            text=self.saveFText()
        else:
            text=self.saveText()
        
        try:
            f=open(fileName,'r')
            text_old=f.read()
            f.close()
        except:
            text_old=''
        try:
            f=open(fileName,'+w',encoding='utf-8')
        except Exception as e:
            logging.exception(e)
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
        # self.m_currentFile.m_text=fileName
        self.m_changed=False
        self.updateState()

    def saveText(self):
        list_pt=tools_basic.getPointByFormat(self.m_currentFile,'list')
        list_text=[]
        for pt in list_pt:
            if pt.m_permission==4:
                list_text.append(pt)
        return tools_basic.writeStdCode([],list_text)

    def saveFText(self):
        list_pt=tools_basic.getPointByFormat(self.m_currentFile,'list')
        list_text=[]
        for pt in list_pt:
            if pt.m_permission==4:
                list_text.append(pt)
        return tools_basic.genFCode(list_text)


    def updateState(self):
        title=''
        address=self.m_currentFile.m_text
        if self.m_changed==True:
            title='*'
        i=address.rfind('\\')
        if i+1==len(address):
            i=-1
        title+=address[i+1:]
        reading=self.m_readPtr.m_db[1]
        if reading!=None:
            title+=': '+reading.info(show_info='不显示位置,不显示文本')
        else:
            title+='[x]'
        title+='    ::'+os.getcwd()
        self.setWindowTitle(title)

    def changed(self):
        self.m_changed=True
        self.updateState()
        if self.m_readPtr.m_db[1]!=None:
            self.m_readPtr.m_db[1].m_text=self.toPlainText()


    def selectWholeLine(self):
        text=self.toPlainText()
        cursor=self.textCursor()
        s=cursor.selectionStart()
        e=cursor.selectionEnd()
        ns=text.rfind('\n',0,s)+1
        ne=text.find('\n',e,-1)
        # cursor=self.selectText(ns,ne)
        # line=cursor.selectedText().replace("\u2029",'\n')
        # line=cursor.selectedText()
        if text[ne]=='\n':
            line=text[ns:ne]
        else:
            line=text[ns:]
        return line,ns,ne



    def runCode(self):
        code,ns,ne=self.selectWholeLine()
        # operate code
        pt_ptr=self.m_readPtr.m_db[1]
        pt_port=self.m_port.m_db[1]
        compiler=self.m_compiler.m_db[1].m_dev
        if pt_ptr==None:
            print('Error! This editor isn\'t reading anything.')
            return
        if compiler==None:
            print('Error! No compiler!')
            return
        if pt_port==None:
            print('Error! No port!')
            return
        # if pt_ptr.m_name=='文本' or pt_ptr.m_name=='目录':
        if pt_ptr.m_name=='目录':
            result=compiler.runCode_shell(code,IO=pt_port)
        elif tools_basic.checkPtsRelation(pt_ptr,'property','全局'):
            result=compiler.runCode_shell(code,IO=pt_port)
        else:
            # list_pt=listOfPt(pt_ptr)
            # if pt_ptr not in list_pt:
            #     list_pt.append(pt_ptr)
            # result=compiler.runCode_shell(code,IO=pt_port,limit=True,list_pt=list_pt)
            result=compiler.runCode_shell(code,IO=pt_port,limit=True,pt_ptr=pt_ptr)
        # print("句子执行结果:",result)
        cursor=self.selectText(ns,ne)
        print(result)
        if result==[]:
            pass
        elif result[0]==True:
            self.setTextBackgroundColor(Qt.green)
            self.setTextColor(Qt.black)
        else:
            self.setTextBackgroundColor(Qt.red)
            self.setTextColor(Qt.white)
        # self.setCursor(cursor)

    def opSetReadPtr(self,pt_text):
        if pt_text==None:
            pt_file=self.m_currentFile
            list_pt=tools_basic.getPointByFormat(pt_file,'list')
            for pt in list_pt:
                if pt.m_name=="文本" or pt.m_name=="目录":
                    pt_text=pt
                    break
            if pt_text==None:
                pt_text=NetP("目录")
                NetP("的").con(pt_file,pt_text)
            self.m_readPtr.con(0,pt_text)
        elif pt_text!=self.m_currentFile:
            self.m_readPtr.con(0,pt_text)
        else:
            return
        self.setPlainText(pt_text.m_text)

    def selectText(self,start,end):
        cursor=self.textCursor()
        cursor.movePosition(QTextCursor.Start)
        cursor.movePosition(QTextCursor.Right,QTextCursor.MoveAnchor,start)
        if end==-1:
            cursor.movePosition(QTextCursor.End,QTextCursor.KeepAnchor)
        else:
            cursor.movePosition(QTextCursor.Right,QTextCursor.KeepAnchor,end-start)
        self.setTextCursor(cursor)
        return cursor


    ######## functions interact with points
    def updateSysPts(self):
        self.m_x.m_text=str(self.geometry().x())
        self.m_y.m_text=str(self.geometry().y())
        self.m_width.m_text=str(self.geometry().width())
        self.m_height.m_text=str(self.geometry().height())


    def updateByPts(self):
        pt_x=self.m_x
        pt_y=self.m_y
        pt_height=self.m_height
        pt_width=self.m_width

        try:
            x=int(pt_x.m_text)
        except:
            x=300
            pt_x.m_text='300'

        try:
            y=int(pt_y.m_text)
        except:
            y=600
            pt_y.m_text='600'
            
        try:
            height=int(pt_height.m_text)
        except:
            height=400
            pt_height.m_text='400'
            
        try:
            width=int(pt_width.m_text)
        except:
            width=800
            pt_width.m_text='800'
        # width=int(pt_width.m_text)
        # height=int(pt_height.m_text)

        self.setGeometry(x,y,width,height)


    #tmp:
    def createPage(self):
        line,ns,ne=self.selectWholeLine()
        pt_read=self.m_readPtr.m_db[1]
        pt_port=self.m_port.m_db[1]
        if pt_read==None or pt_port==None:
            return
        try:
            name_code,text=re.split(':\s*',line,1)
            name_code=re.sub('^[\n \t]*[0-9]+[.] ','',name_code)
            name,tags=name_tokener(name_code)
            if name==None:
                return
            pos_o=pt_read.m_pos
            pt_page=None
            pt_con=None
            for con in pt_read.m_con:
                if con.m_name=='的' and con.m_db[1]!=None and con.m_db[1].m_name==name:
                    pt_con=con
                    pt_page=con.m_db[1]
                    break
            rewrite=False
            if text!='' and text[0]==':':
                rewrite=True
                text=text[1:]
            if pt_page==None:
                text=re.sub('^\n*','',text)
                pt_page=NetP(name,text)
                pt_con=NetP('的').con(pt_read,pt_page)
                pt_port.m_dev.input([pt_con,pt_page])
                pt_page.m_pos=pos_o.copy()
                pt_page.m_pos[0]+=1
                # add tags:
                for tag in tags:
                    pt_tag=NetP(tag).con(pt_page,None)
                    pt_port.m_dev.input([pt_con,pt_tag])
                    pt_tag.m_pos=pt_page.m_pos.copy()
                    pt_tag.m_pos[1]-=1
                    # if tag=='公式':
                    #     pt_action=NetP('[公式]',text).con(None,pt_page)
                    #     pt_action.m_needed=self.m_self
                    #     pt_port.m_dev.input([pt_action])
                        
                if text[-3:]=='...':
                    self.opSetReadPtr(pt_page)
                    pt_page.m_text=text[0:-3]
            elif not rewrite:
                self.opSetReadPtr(pt_page)
            else:
                pt_page.m_text=text
                # pt_page.print()
                pt_action=NetP('[置顶]').con(pt_read,pt_con)
                pt_action.m_needed=self.m_self
                pt_port.m_dev.input([pt_action])
                for con in pt_con.m_con:
                    if con.m_name=='的' and con.m_db[1]==self.m_currentFile:
                        pt_action=NetP('[置顶]').con(self.m_currentFile,con)
                        pt_action.m_needed=self.m_self
                        pt_port.m_dev.input([pt_action])
                        break

        except Exception as e:
            logging.exception(e)




    # Debugger internal:
    def startDebug(self):
        pt_compiler=self.m_compiler.m_db[1]
        if pt_compiler==None or pt_compiler.m_dev==None:
            return
        compiler=pt_compiler.m_dev

        # complete the selection area
        [code,ns,ne]=self.selectWholeLine()
        self.m_debug=True
        self.setReadOnly(True)
        self.reset()
        self.setSentsForRun(code,ns,ne)

        compiler.m_source.con(0,self.m_port.m_db[1])
        

    def debugEvent(self,event):
        modifier=QApplication.keyboardModifiers()
        if modifier==Qt.ControlModifier:
            if event.key()==Qt.Key_Q:
                self.leaveDebug()
            try:
                key_text="ctrl+"+QKeySequence(event.key()).toString()
                # print(key_text)
                self.runEvent(key_text)
            except:
                pass
        else:
            self.control(event.key())

    def leaveDebug(self):
        self.setReadOnly(False)
        self.m_debug=False
        self.reset()

        
    def control(self,key):
        pt_compiler=self.m_compiler.m_db[1]
        if pt_compiler==None or pt_compiler.m_dev==None:
            return
        compiler=pt_compiler.m_dev

        if key==Qt.Key_S:
            compiler.run(1)
        elif key==Qt.Key_W:
            compiler.runAll()
        elif key==Qt.Key_A:
            self.changeSent(False)
        elif key==Qt.Key_D:
            self.changeSent(True)
        self.markWords()
        # if self.m_outPool!=None:
        #     self.m_outPool.update()

    def setSentsForRun(self,code,ns,ne):
        pt_compiler=self.m_compiler.m_db[1]
        if pt_compiler==None or pt_compiler.m_dev==None:
            return
        compiler=pt_compiler.m_dev
        
        text=self.toPlainText()

        compiler.reset()
        karmas=compiler.compile(code)
        compiler.loadCode(karmas)
        self.m_karmas=karmas
        if karmas==[]:
            return
        start=ns
        for sent in karmas:
            list_pt=tools_basic.pointsInChain(sent)
            words=[pt.m_name for pt in list_pt]
            word_map,start=self.mapWord(words,text,start,ne)
            pos_sent=[start,start]
            for pt in list_pt:
                i=list_pt.index(pt)
                pos=word_map[i]
                if pos[0]==-1 or pos[1]==-1:
                    continue
                else:
                    if pos[0]<pos_sent[0]:
                        pos_sent[0]=pos[0]
                self.m_words.update({pt:pos})
            self.m_sents.update({sent:pos_sent})
        self.markWords()
        compiler.run(0,karmas[0])
        

    def mapWord(self,words,text,start,ne):
        word_map=[]
        for word in words:
            pos=text.find(word,start)
            if pos==-1:
                word_map.append((-1,-1))
                pos=start
            elif ne!=-1 and pos > ne:
                word_map.append((-1,-1))
                pos=start
            else:
                word_map.append((pos,pos+len(word)))
            start=pos+len(word)
        return word_map,start

    # def selectText(self,start,end):
    #     cursor=self.textCursor()
    #     cursor0=self.textCursor()
    #     cursor.movePosition(QTextCursor.Start)
    #     cursor.movePosition(QTextCursor.Right,QTextCursor.MoveAnchor,start)
    #     cursor.movePosition(QTextCursor.Right,QTextCursor.KeepAnchor,end-start)
    #     self.setTextCursor(cursor)
    #     return cursor0

    def markWords(self):
        for word in self.m_words:
            index=self.m_words[word]
            cursor0=self.selectText(index[0],index[1])
            if word.m_master.m_reState=='':
                if word.m_master.stateSelf()=='green':
                    self.setTextBackgroundColor(Qt.green)
                    self.setTextColor(Qt.black)
                elif word.m_master.stateSelf()=='red':
                    self.setTextBackgroundColor(Qt.red)
                    self.setTextColor(Qt.black)
                elif word.m_master.stateSelf()=='blue':
                    self.setTextBackgroundColor(Qt.blue)
                    self.setTextColor(Qt.white)
                else:
                    self.setTextBackgroundColor(Qt.yellow)
                    self.setTextColor(Qt.black)
            elif word.m_master.m_reState=='dark green':
                self.setTextBackgroundColor(Qt.darkGreen)
                self.setTextColor(Qt.white)
            else:
                self.setTextBackgroundColor(Qt.darkYellow)
                self.setTextColor(Qt.white)
            self.setTextCursor(cursor0)

    def markSent(self,sent,mark):
        index=self.m_sents[sent]
        cursor0=self.selectText(index[0],index[1])
        self.setFontUnderline(mark)
        self.setTextCursor(cursor0)

    def movePtr(self,right):
        pt_compiler=self.m_compiler.m_db[1]
        if pt_compiler==None or pt_compiler.m_dev==None:
            return -1
        compiler=pt_compiler.m_dev

        ptr=self.m_ptrKm
        try:
            curKm=self.m_karmas[ptr]
        except:
            print("Error! Ptr=",ptr)
            return -1
        if right==False:
            if ptr<=0:
                ptr=0
            elif compiler.m_running==[] or compiler.m_running[-1]!=curKm:
                pass
            elif curKm.m_stage!=1:
                pass
            else:
                ptr-=1
        else:
            if ptr>=len(self.m_karmas)-1:
                ptr=len(self.m_karmas)-1
            else:
                ptr+=1
        return ptr

    def changeSent(self,right):
        pt_compiler=self.m_compiler.m_db[1]
        if pt_compiler==None or pt_compiler.m_dev==None:
            return
        compiler=pt_compiler.m_dev

        ptr=self.movePtr(right)
        curKm=self.m_karmas[self.m_ptrKm]
        if right==True and ptr==self.m_ptrKm:
            compiler.run(-1)
        elif right==True and ptr>self.m_ptrKm:
            compiler.run(-1)
            self.setRunningSent(ptr)
        elif right==False and ptr==self.m_ptrKm:
            self.setRunningSent(ptr)
        elif right==False and ptr<self.m_ptrKm:
            compiler.retrive(curKm)
            self.setRunningSent(ptr)

    def setRunningSent(self,ptr):
        pt_compiler=self.m_compiler.m_db[1]
        if pt_compiler==None or pt_compiler.m_dev==None:
            return
        compiler=pt_compiler.m_dev

        curKm=self.m_karmas[ptr]
        self.m_ptrKm=ptr
        compiler.retrive(curKm)
        compiler.run(0,curKm)
        

    def reset(self):
        pt_compiler=self.m_compiler.m_db[1]
        if pt_compiler==None or pt_compiler.m_dev==None:
            return
        compiler=pt_compiler.m_dev

        self.m_words.clear()
        self.m_sents.clear()
        compiler.reset()
        self.resetColor()

    def resetColor(self):
        self.selectAll()
        self.setTextBackgroundColor(Qt.white)
        self.setTextColor(Qt.black)
        self.selectText(0,0)





def isPtName(name):
    title=r'[\w \[\]~#.+=\-^/*\\!<\']*|^\[>=?\]'
    t_name=re.match(title,name).group()
    return t_name==name

def name_tokener(string):
    title=r'[\w \[\]~#.+=\-^/*\\!<\']*|^\[>=?\]'
    pat=r'('+title+r')\((.*)\)'
    try:
        m=re.match(pat,string)
        name=m.group(1)
        str_tags=m.group(2)
        tags=re.split(r',\s*',str_tags)
        for tag in tags:
            if not isPtName(tag):
                return [None,[]]
        return [name,tags]
    except:
        if not isPtName(string):
            return [None,[]]
        else:
            return [string,[]]

def listOfPt(pt):
    list_pt=[]
    for con in pt.m_con:
        if con.m_name=='的' and con.m_db[0]==pt and con.m_db[1]!=None:
            list_pt.append(con.m_db[1])
    return list_pt

def labeled(pt,name,db=0):
    for con in pt.m_con:
        if con.m_db[1]==pt and con.m_name==name:
            return True
    return False
        


if __name__=="__main__":
    app=QApplication(sys.argv)
    editor=Editor()
    sys.exit(app.exec_())
    # name,tags=name_tokener('12(1,2,3,4)')
    # print(name)
    # print(tags)
