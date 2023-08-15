import sys, re
if __name__=='__main__':
    sys.path.append(sys.path[0]+'\\..')
from body.bone import NetP
from body.soul import Karma
from tools import tools_basic



def readFile(fileName):
    try:
        f=open(fileName,encoding='gbk')
    except:
        print("The file, "+fileName+", doesn't exist.")
        return [None,None]
    try:
        textGbk=f.read()
    except:
        textGbk=None
    f.close()

    f=open(fileName,encoding='utf-8')
    try:
        textUtf=f.read()
    except:
        textUtf=None
    f.close()
    return [textGbk,textUtf]


# Read snb files
def readFile_snb(fileName):
    [text1,text2]=readFile(fileName)
    if text1==None and text2==None:
        return []
    return loadText_snb(text1,text2)


def loadText_snb(text1,text2):
    head=None
    code1,n1=checkFormat_snb(text1)
    code2,n2=checkFormat_snb(text2)
    print(n1,n2)
    if n1!=-1:
        code=code1
    elif n2!=-1:
        code=code2
    else:
        return []
    return tools_basic.buildPoints_tokener(code)

def checkFormat_snb(text):
    if text==None:
        return '',-1
    mark='\n-----------系统-----------\n'
    ni=text.find(mark)
    if ni==-1:
        return '',-1
    else:
        code=text[len(mark):]
    return code,ni