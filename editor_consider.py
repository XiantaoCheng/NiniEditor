import sys
if __name__=='__main__':
    sys.path.append('C:\\Users\\cheng\\Desktop\\Laser\\TACC\\PIC\\Smilei\\')
from body import GLOBAL
from body.body_kernel import Kernel
from tools import tools_basic
from PyQt5.QtWidgets import QApplication, QMessageBox
# if sys.platform.startswith('linux'):
#     from OpenGL import GL



if __name__=="__main__":
    sys.argv.append('--disable-web-security')
    app=QApplication(sys.argv)
    testFile="配置文件_new.txt"
    try:
        code=tools_basic.readFile(testFile)
    except:
        print("File doesn't exist!")
        code=""
    list_pt=tools_basic.buildPoints_tokener(code)
    head=None
    for pt in list_pt:
        pt.m_permission=0
        if pt.m_name=='根源':
            head=pt
    print(testFile,"的节点数:",len(list_pt))
    Kernel(head)
    sys.exit(app.exec_())

