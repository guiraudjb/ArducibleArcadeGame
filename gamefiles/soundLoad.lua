local functions = {}  --(*1)
function functions.soundLoad()
	sonHit = love.audio.newSource("sound/son1.wav", "stream")
	sonBonus = love.audio.newSource("sound/son3.ogg", "stream")
	sonBad = love.audio.newSource("sound/son2.wav", "stream")
	SynthwaveVibe = love.audio.newSource("music/Meydn-SynthwaveVibe.mp3", "stream")
	Starcade = love.audio.newSource("music/BlueNavi-Starcade.mp3", "stream")
end


return functions --(*2)
