#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from PyQt4.QtWebKit import *

# create application QT and WebView
app = QApplication(sys.argv)
web = QWebView()

# Set Title and Icon
web.setWindowIcon(QIcon("kcenter.ico"))
web.setWindowTitle("Centro de Controle Kaiana")

# Configuration: Center Window, Enable extra tools for developers
web.move(app.desktop().screen().rect().center() - web.rect().center())
web.page().settings().setAttribute(QWebSettings.DeveloperExtrasEnabled, True)

# Set URL to Show
web.load(QUrl("http://127.0.0.1:2222"))
web.show()

sys.exit(app.exec_())
