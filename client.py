import wx
import socket

class MyFrame(wx.Frame):
	def __init__(self,parent,title):
		wx.Frame.__init__(self, parent, title=title, size=(350,100))
		self.vbox = wx.BoxSizer(wx.VERTICAL)
		self.hbox1 = wx.BoxSizer(wx.HORIZONTAL)
		self.panel1 = wx.Panel(self)
		self.st1 = wx.StaticText(self.panel1,label="Enter number from 1 to 100: ")
		self.text1 = wx.TextCtrl(self.panel1)
		self.hbox1.Add(self.st1)
		self.hbox1.Add(self.text1,proportion=1)
		self.vbox.Add(self.hbox1,border=10)
		self.vbox.Add((-1,10))

		self.button1 = wx.Button(self.panel1,label="Enter")
		self.st2 = wx.StaticText(self.panel1,label="Last Entered : None") 
		self.vbox2 = wx.BoxSizer(wx.VERTICAL)
		self.vbox2.Add(self.button1)
		self.vbox2.Add((-1,10))
		self.vbox2.Add(self.st2)
		self.vbox.Add(self.vbox2)
		self.panel1.SetSizer(self.vbox)

		self.button1.Bind(wx.EVT_BUTTON,self.getValue)
		self.Show()

		self.s = socket.socket()
		self.port = 5000
		self.s.connect(('',self.port))

	
	def getValue(self,event):
		self.x = self.text1.GetValue()
		self.st2.SetLabel(self.x)
		self.s.send(self.x)
		self.y = self.s.recv(1024)
		if self.y.startswith("U won"):
			print "You won"
			self.st2.SetLabel("Last Entered : " + self.x + "---" + "You won")
		elif self.y.startswith("Game Complete"):
			print self.y
			self.st2.SetLabel("Last Entered : " + self.x + "---" + self.y)
		else:
			print self.y
			self.st2.SetLabel("Last Entered : " + self.x + "---" + self.y)
	


app = wx.App(False)
frame = MyFrame(None,"Guess the number")
app.MainLoop()
 
