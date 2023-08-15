# -*- coding: utf-8 -*-
"""
Created on 2023-08-11 Fri 23:31:11
Updated on 2023-08-11 Fri 23:31:11

@author: 
"""

# Python 3 server example
from http.server import BaseHTTPRequestHandler, HTTPServer
import time
import pyautogui

# hostName = "localhost"
hostName = ""
serverPort = 8000

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()

        f=open("tmp.html")
        self.wfile.write(bytes(f.read(), "utf-8"))

    def do_POST(self):
        self.send_response(200)
        self.send_header('Content-type','text/html')
        self.end_headers()

        content_length = int(self.headers['Content-Length'])
        post_data_bytes = self.rfile.read(content_length)
        post_data_str = post_data_bytes.decode("UTF-8")

        post_data_dict=get_data_from_POST(post_data_str)
        print(post_data_dict)

        f=open("tmp.html")
        self.wfile.write(bytes(f.read(), "utf-8"))

        act_str = post_data_dict['mouse']
        mouseAction(act_str)


     
def mouseAction(act_str):
    if act_str=="play":
        pyautogui.click(819,548)
    if act_str=="jump":
#         pyautogui.click(819,548)
        pyautogui.click(1819,644)
    elif act_str=="screen":
        pyautogui.doubleClick(819,548)
    elif act_str=="back":
        pyautogui.press("left")
    elif act_str=="forward":
        pyautogui.press("right")


     
def get_data_from_POST(post_data_str):
    list_of_item = post_data_str.split('&')
    post_data_dict={}
    for item_str in list_of_item:
        var_str,val_str=item_str.split('=')
        post_data_dict[var_str]=val_str
    return post_data_dict


webServer = HTTPServer((hostName, serverPort), MyServer)
print("Server started http://%s:%s" % (hostName, serverPort))

try:
    webServer.serve_forever()
except KeyboardInterrupt:
    pass

output=webServer.handle_request()
print(output)

webServer.server_close()
print("Server stopped.")




"""
f=open("tmp.html")
print(f.read())
+[P函数](,响应按键)

"""

