#!/usr/bin/env python
 
# Simple Netflix laucher
# AUTHOR: Wilson Junior <wilsonpjunior@gmail.com>
# AUTHOR: Bruno Goncalves <bruno@gmail.com>

import os
import sys


from gi.repository import (
    Gdk, Gtk, WebKit, Soup)
 

class NetflixWindow(Gtk.Window):
 
    def __init__(self, cookie_path="~/.netflix.cookie",
                 *args, **kwargs):
        Gtk.Window.__init__(self, title=sys.argv[1])
        icontheme = Gtk.IconTheme.get_default()
        
        self.set_icon_from_file(sys.argv[3])

        
        super(NetflixWindow, self).__init__(*args, **kwargs)
 
        cookiejar = Soup.CookieJarText.new(
            os.path.expanduser(cookie_path), False)
        cookiejar.set_accept_policy(Soup.CookieJarAcceptPolicy.ALWAYS)
        session = WebKit.get_default_session()
        session.add_feature(cookiejar)



        self.width = int(sys.argv[4])
        self.height = int(sys.argv[5])
        
	self.set_default_size(self.width, self.height)
        self.connect('destroy', Gtk.main_quit)
        self.connect('delete-event', Gtk.main_quit)
 

        self.scroll = Gtk.ScrolledWindow()
        self.web = WebKit.WebView()
        self.add(self.scroll)
        self.scroll.add(self.web)
 
        self.show_all()
 
        self.web.open(sys.argv[2])


 
if __name__ == '__main__':
    app = NetflixWindow()
    Gtk.main()
    
    



