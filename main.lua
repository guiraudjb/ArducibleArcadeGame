function love.load() -- init run once --------------------------------------------------
	
	--love.window.setFullscreen(true, desktop)
	love.mouse.setVisible(false)
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()

	firstInit()

	levelsPackParameters = require 'levels/levelsPackParameters'
	levelsPackParameters.getLevelsPackParameters()
	
	rng=love.math.newRandomGenerator()
	keyboard = require 'gamefiles/keyboard'
	activeKeyboard = true
	keyBoardTimer = 0
	sound = require 'gamefiles/soundLoad'
	sound.soundLoad()

	sprites = require 'gamefiles/loadSprites'
	sprites.loadSprites()

	fonts = require 'gamefiles/loadFonts'
	fonts.loadFonts()

	help = require 'gamefiles/help'

	level = require 'gamefiles/level'

	ending = require 'gamefiles/endGame'
	print ("Largeur : "..screenWidth)
	print ("Hauteur : "..screenHeight)
	print ("Largeur cible attendue : "..targetFinalWidth)
	print ("Hauteur cible attendue : "..targetFinalHeight)
	--print ("Facteur d'échèle Largeur cible : "..targetFinalWidthScale)
	--print ("Facteur d'échèle hauteur cible : "..targetFinalHeightScale)
	print ("Facteur d'échèle final : "..targetFinalScale)
end

function love.update(dt)
	
	if love.timer.getTime() >= keyBoardTimer then
	activeKeyboard = true
	end
  
	if activeKeyboard == true then
		keyboard.keyboardRead()
	end

		if not Starcade:isPlaying( ) then
		Starcade:setVolume(0.1)
		love.audio.play( Starcade )
		end
		if gameState == 0 then
				if introTimer > 0 then
					if backgroundLoad == false then
						sprites.backgroundLoad(gameState)
						--level.levelLoad(gameState)
						backgroundLoad = true
					end
					help.updateIntroContdown()
					level.timeExtenderAnimating()
					level.TargetAnimating()
				else
					runFirstLevel()
				end
		elseif gameState >0 and  gameState < numberOfLevels+1 then
			if globalTimer > 0 then
				if backgroundLoad == false then
					sprites.backgroundLoad(gameState)
					level.levelLoad(gameState)
					backgroundLoad = true
					activeTarget=levelTargets[levelProgress]
					timeExtending=levelTimeExtenderPositions[levelProgress]
					timeExtendingValue = levelTimeExtenderValues[levelProgress]
					timestampDebut=os.time()
          targetAnimatingScaler = 100
				end
				level.updateGameContdown()
				-- level.timeExtenderAnimating()
				level.TargetAnimating()
				level.bangAnimating()
				level.levelEngine()
			else
			  endingGame()
			end
		elseif  gameState > numberOfLevels then
			if endTimer > 0 then
				if backgroundLoad == false then
					sprites.backgroundLoad(0)
					backgroundLoad = true
						if score < bronzeMedal then
						playerRank = 0
						grade="TRY AGAIN"
						end

						if score > bronzeMedal and score < silverMedal then
							playerRank = 3
							grade="BRONZE"
						end
						if score >= silverMedal and score < goldMedal then
							playerRank = 2
							grade="SILVER"
						end
						if score >= goldMedal then
							playerRank = 1
							grade="GOLD"
						end
				end
				ending.endingUpdate()
			else
				backToNewgame()
			end
		end
end

function love.draw()

	if  gameState == 0 then
		sprites.backgroundDraw()
		help.helpDrawItemInformations()
	elseif gameState > 0 and  gameState < numberOfLevels + 1 then
		sprites.backgroundDraw()
		level.inGameInformations(gameState)

    if timeExtender.position == "back" then
        level.timeExtenderDraw(timeExtendingValue)
      	level.targetDraw()
    else
      level.targetDraw()
      level.timeExtenderDraw(timeExtendingValue)
    end

    level.bangDraw()
	elseif gameState > numberOfLevels then
	sprites.backgroundDraw()
	ending.endingDraw()
	end
   
   love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 0, screenHeight*95/100)

end

function firstInit()
	gameState=0
	backgroundLoad = false
end

function runFirstLevel()
	gameState = 1
	score = 0
	playerRank=0
	grade=""
	levelProgress = 1
	introTimer=IntroLenght
	globalTimer=gameLenght
	endTimer=endLenght
	backgroundLoad = false
end

function endingGame()
	gameState = numberOfLevels+1
	backgroundLoad = false
end

function backToNewgame()
	gameState = 0
	backgroundLoad = false
end
