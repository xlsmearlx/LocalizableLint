#!/usr/bin/env ruby

system("chmod +x hooks/*")
system("cp -a ./hooks/. ./.git/hooks/")
