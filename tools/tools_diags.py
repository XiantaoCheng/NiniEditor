import sys
if __name__=='__main__':
    sys.path.append(sys.path[0]+'\\..')
from body.bone import NetP
from body.soul import Karma

from PyQt5.QtWidgets import QApplication, QLineEdit, QDialog, QDialogButtonBox, QFormLayout

class InputDialog(QDialog):
    def __init__(self, list_pt):
        super().__init__()

        self.m_outputs=[]
        self.m_lines=[]
        self.initialize(list_pt)

    def initialize(self,list_pt):
        lines=self.m_lines
        self.m_outputs=list_pt

        buttonBox = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel, self)
        layout = QFormLayout(self)
        for pt in list_pt:
            line=QLineEdit(self)
            line.setPlaceholderText(pt.m_text)
            lines.append(line)
            layout.addRow(pt.m_name,line)
        layout.addWidget(buttonBox)
        
        buttonBox.accepted.connect(self.accept)
        buttonBox.rejected.connect(self.reject)

    def getInputs(self):
        for i in range(len(self.m_lines)):
            line=self.m_lines[i]
            pt=self.m_outputs[i]
            if line.text()!='':
                pt.m_text=line.text()
        return self.m_outputs

if __name__ == '__main__':
    app = QApplication(sys.argv)
    dialog = InputDialog([NetP('A'),NetP('A','1111'),NetP('A'),NetP('A')])
    if dialog.exec():
        print(dialog.getInputs())
    dialog = InputDialog([NetP('B'),NetP('B','1111'),NetP('B'),NetP('B')])
    if dialog.exec():
        print(dialog.getInputs())
    exit(0)