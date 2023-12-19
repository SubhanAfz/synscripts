local aukit = require("aukit")
aukit.play(aukit.stream.dfpwm(io.lines("mindthegap.dfpwm", 48000)), peripheral.find("speaker"))