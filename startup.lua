local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")

local decoder = dfpwm.make_decoder()
function playMindTheGap()
    for chunk in io.lines("mindthegap.dfpwm", 16 * 1024) do
        local buffer = decoder(chunk)
    
        while not speaker.playAudio(buffer) do
            os.pullEvent("speaker_audio_empty")
        end
    end
end

while true do
    os.pullEvent("redstone")
    if redstone.getInput("top") == true then
        playMindTheGap()
    end
end

