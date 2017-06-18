

widthWindow = love.graphics.getWidth()                                 -- largura da janela de jogo
widthWindowPlayerArea = love.graphics.getWidth() * 0.7                 -- area do player, 70% da tela
widthWindowInfoArea = love.graphics.getWidth() - widthWindowPlayerArea -- area de informacao
heightWindow = love.graphics.getHeight()
                             -- altura da janela de jogo

anim = require "anim8"

function love.load()
        -- Nave -------------------------------
        naveBrancaImage = love.graphics.newImage("assets/images/player-white.png")
        nave = {
          posX = widthWindowPlayerArea / 2,                                  -- posicao X do objeto na tela, no meio dela
          posY = heightWindow - (naveBrancaImage:getHeight()/2),             -- posicao Y do objeto na tela, equivale a altura da janela menos a metade do tamanho do player
          velocidade = 500                                                   -- velocidade de deslocamento do player
        }
        ----------------------------------------
        -- tiros -------------------------------
        disparo = true                                                    -- disparo, habilitado
        delayTiro = 0.5                                                   -- delay entre os disparo
        tempoAteAtirar = delayTiro                                        -- tempo ate o disparo, equivale ao delayShoot
        tiros = {}                                                        -- disparos
        imageTiro = love.graphics.newImage("assets/images/ammunition.png")--imagem usada para munição
        ----------------------------------------
        -- inimigos ----------------------------
        delayInimigo = 0.4
        tempoCriarInimigo = delayInimigo
        imageInimigo = love.graphics.newImage("assets/images/enemie-red.png")
        inimigos = {}
        ----------------------------------------
        -- Pontuação ----------------------------

        fontGalaga = love.graphics.newFont("assets/fonts/emulogic.ttf", 18)
        -----------------------------------------
        --vidas e pontuação ---------------------
        estarVivo = true
        pontos = 0
        statusFire = "simple fire"
        life = 5
        gameOver = false
        transparencia = 0
        imageLife = love.graphics.newImage("assets/images/life.png")
        imageLifeWidth = imageLife:getWidth()
        imageQuantLife = 0
        imageGameOver = love.graphics.newImage("assets/images/screen-game-over.png")

        -----------------------------------------

        -- Sons -------------------------------
        somTiro = love.audio.newSource("assets/sounds/Galaga_Firing_Sound_Effect.wav","static")
        explodeInimigo = love.audio.newSource("assets/sounds/Galaga_Explosion_Sound_Effect.wav","static")
        explodindoMe = love.audio.newSource("assets/sounds/Galaga_Kill_Enemy_Sound_Effect.wav","static")
        musicaFundoIntro = love.audio.newSource("assets/sounds/Galaga_Melody_Intro_Sound.wav")
        musicaFundo =  love.audio.newSource("assets/sounds/Galaga_Melody_Sound.wav")

          musicaFundo:play()
          musicaFundo:setLooping(true)





        pausarJogo = love.audio.newSource("assets/sounds/Galaga_Pause_In.wav","static")
        musicaGameOver = love.audio.newSource("assets/sounds/Galaga_Game_Over.wav","static")

        ---------------------------------------

        --backgroud -----------------------------
        fundo = love.graphics.newImage("assets/images/background.png")
        fundo2 = love.graphics.newImage("assets/images/background.png")
        planoDeFundo = {
          x = 0,
          y = 0,
          y2 = 0 - fundo:getHeight(),
          vel = 40
        }
        -----------------------------------------

        -- Tela Inicial -------------------------

        carregarTela = false
        telaTitulo = love.graphics.newImage( "assets/images/screen-game.png" )
        inOutX = 0
        inOutY = 0

        -----------------------------------------

        -- Pausar o Jogo ------------------------

        pauseGame = false

        -----------------------------------------

        -- Destruição e explosão ----------------

        explosionInimigo = {}
        destruicaoInimigo = love.graphics.newImage( "assets/images/explosion2.png" )
        explosionInimigo.x = 0
        explosionInimigo.y = 0
        local gride = anim.newGrid( 64, 64, destruicaoInimigo:getWidth(), destruicaoInimigo:getHeight() )
        destroiInimigo = anim.newAnimation( gride( '1-5', 1, '1-5', 2, '1-5', 3, '1-5', 4, '1-3', 5 ), 0.01, destroiDois )

        -----------------------------------------


end

function love.draw()

  if not gameOver then
        -- Pontos na tela -----------------------------
        love.graphics.setFont(fontGalaga)
        love.graphics.print("Score \n" .. pontos, widthWindowPlayerArea + 10, heightWindow *0.1)
        love.graphics.print("Item ", widthWindowPlayerArea + 10, heightWindow *0.4)
        love.graphics.print(statusFire, widthWindowPlayerArea + 10, heightWindow *0.5)
        love.graphics.print("Life \n" ..life, widthWindowPlayerArea + 10, heightWindow *0.7)

        --love.graphics.draw(imageLife, widthWindowPlayerArea + imageQuantLife, heightWindow *0.8)



        ---------------------------------------


        -- Background
        love.graphics.draw( fundo, planoDeFundo.x, planoDeFundo.y )
        love.graphics.draw( fundo2, planoDeFundo.x, planoDeFundo.y2 )
        -- Background



        -- Itens da Tela ----------------------
        --for i, life in ipairs(lifes) do ---- parei aqui 10-05-2017
        --end
        --love.graphics.draw()
        ---------------------------------------

        -- Nave -------------------------------
        ----------------------------------------

        -- tiros -------------------------------
        for i,tiro in ipairs(tiros) do
          love.graphics.draw(tiro.img, --imagem a ser carregada
                             tiro.x, --posicao do objeto em X
                             tiro.y, --posicao do objeto em Y
                             0,  --angulo de rotação do objeto na tela
                             1, --tamanho do objeto na tela em 30%
                             1, --tamanho do objeto na tela em 30%
                             imageTiro:getWidth()/2,  --posicionamento da imagem (centralizar em X)
                             imageTiro:getHeight()/2) --posicionamento da imagem (centralizar em Y)
          if pontos >= 2000 then -- se os pontos ultrapassarem 2000
            --love.graphics.print("Tripe \nFire-Blue" ..life, widthWindowPlayerArea + 10, heightWindow *0.5)
            statusFire = "Tripe \nFire-Blue"
            love.graphics.draw(tiro.img, --imagem a ser carregada
                               tiro.x - 10, --posicao do objeto em X
                               tiro.y + 15, --posicao do objeto em Y
                               0,  --angulo de rotação do objeto na tela
                               1, --tamanho do objeto na tela em 30%
                               1, --tamanho do objeto na tela em 30%
                               imageTiro:getWidth()/2,  --posicionamento da imagem (centralizar em X)
                               imageTiro:getHeight()/2) --posicionamento da imagem (centralizar em Y)
            love.graphics.draw(tiro.img, --imagem a ser carregada
                               tiro.x + 10, --posicao do objeto em X
                               tiro.y + 15, --posicao do objeto em Y
                               0,  --angulo de rotação do objeto na tela
                               1, --tamanho do objeto na tela em 30%
                               1, --tamanho do objeto na tela em 30%
                               imageTiro:getWidth()/2,  --posicionamento da imagem (centralizar em X)
                               imageTiro:getHeight()/2) --posicionamento da imagem (centralizar em Y)
            delayTiro = 0.4
            if pontos >= 5000 then -- se os pontos ultrapassarem 5000
              --love.graphics.print("Penta \nFire-Blue" ..life, widthWindowPlayerArea + 10, heightWindow *0.5)
              statusFire = "Penta \nFire-Blue"
              love.graphics.draw(tiro.img, --imagem a ser carregada
                                 tiro.x - 20, --posicao do objeto em X
                                 tiro.y + 30, --posicao do objeto em Y
                                 0,  --angulo de rotação do objeto na tela
                                 1, --tamanho do objeto na tela em 30%
                                 1, --tamanho do objeto na tela em 30%
                                 imageTiro:getWidth()/2,  --posicionamento da imagem (centralizar em X)
                                 imageTiro:getHeight()/2) --posicionamento da imagem (centralizar em Y)
              love.graphics.draw(tiro.img, --imagem a ser carregada
                                 tiro.x + 20, --posicao do objeto em X
                                 tiro.y + 30, --posicao do objeto em Y
                                 0,  --angulo de rotação do objeto na tela
                                 1, --tamanho do objeto na tela em 30%
                                 1, --tamanho do objeto na tela em 30%
                                 imageTiro:getWidth()/2,  --posicionamento da imagem (centralizar em X)
                                 imageTiro:getHeight()/2) --posicionamento da imagem (centralizar em Y)
              delayTiro = 0.3
              if pontos >= 10000 then -- se os pontos ultrapassarem 10000
                --love.graphics.print("Insane \nPenta \nFire-Blue" ..life, widthWindowPlayerArea + 10, heightWindow *0.5)
                statusFire = "Insane \nPenta \nFire-Blue"
                delayTiro = 0.2 --tempo de atraso do jogo diminiu para 0.2
              end
            end
          end
        end
        ----------------------------------------
        -- inimigos ----------------------------
        for i, inimigo in ipairs( inimigos ) do
         love.graphics.draw(inimigo.img,
                            inimigo.x,
                            inimigo.y,
                            0,
                            1,
                            1,
                            imageInimigo:getWidth()/2,
                            imageInimigo:getHeight()/2)
        end
        ----------------------------------------

        -- Explosao Nave -----------------------
        for i, _ in ipairs( explosionInimigo ) do
          destroiInimigo:draw( destruicaoInimigo,
                               explosionInimigo.x,
                               explosionInimigo.y )
        end
        -----------------------------------------


      end
        --fim de jogo e reinicio ----------------
        if estarVivo then
          love.graphics.draw(naveBrancaImage, --imagem a ser carregada
                             nave.posX, --posicao do objeto em X
                             nave.posY, --posicao do objeto em Y
                             0,   --angulo de rotação do objeto na tela
                             1, --tamanho do objeto na tela em 30% (0.3)
                             1, --tamanho do objeto na tela em 30%
                             naveBrancaImage:getWidth()/2, --posicionamento da imagem (centralizar em X)
                             naveBrancaImage:getHeight()/2) --posicionamento da imagem (centralizar em Y)
                           elseif gameOver then
                             love.graphics.setColor(255,255,255, transparencia)
                             love.graphics.draw(imageGameOver,0,0)
                             love.graphics.print("Total\n\nscore\n"..pontos,widthWindowPlayerArea + (widthWindowInfoArea /2),heightWindow/2)
                           else
                             love.graphics.draw(telaTitulo,inOutX,inOutY)
                             --love.graphics.print("Press R from restart",80, heightWindow/2)
                           end
        -----------------------------------------

        -- mensagem de pausa quando pressionada
              if pauseGame and not gameOver then
                  love.graphics.print("Pause",230, heightWindow/2)
              end
        ---------------------------------------
end

function love.update(dt)
        if not pauseGame then -- caso a pausa não seja acionada

          movimentos (dt)
          atirar (dt)
          inimigo (dt)
          colisions()
          resert()
          planoDeFundoScroll(dt)
          startGame(dt)
          controllerExplosionNave(dt)

        end
        if gameOver then
          galagaGameOver(dt)
        end
end

function atirar (dt)
    tempoAteAtirar = tempoAteAtirar - (1 * dt)                  -- decremetar a variavel de tiro
      if tempoAteAtirar < 0 then                               -- se for menor que zero, ele dispara
        disparo = true
      end
      if estarVivo then                                     -- testa se o player esta vivo para poder disparar
        if love.keyboard.isDown("space") and disparo then       -- se a tecla space for pressionada e ele puder disparar
                                                               -- é criado um novo objeto de tiro na mesma posicao da nave
          novoTiro = { x = nave.posX,
                       y = nave.posY,
                       img = imageTiro
                     }

          table.insert (tiros,novoTiro)    -- o novo objeto é entao inserido na tabela shots
          somTiro:stop()
          somTiro:play()
          disparo = false                                       -- tiro é bloqueado
          tempoAteAtirar = delayTiro                            -- o tempo de disparo retorna para 0.1
        end
      end
      for i,tiro in ipairs(tiros) do                         -- verificar os tiros disparados
            tiro.y = tiro.y - (500 * dt)                          -- posicao do eixo Y do tiro é decrementado 500 vezes por segundo
            if tiro.y < 0 then                                   -- verifica se a posicao do exio Y é menor que 0
              table.remove(tiros, i)                            -- o tiro é entao removido da tabela
            end
      end
end


function movimentos (dt)
      if love.keyboard.isDown("right") then
        if nave.posX < (widthWindowPlayerArea - naveBrancaImage:getWidth()/2)then
           nave.posX = nave.posX + nave.velocidade * dt
        end
      end

      if love.keyboard.isDown("left") then
        if nave.posX > (0 + naveBrancaImage:getWidth()/2)then
           nave.posX = nave.posX - nave.velocidade * dt
        end
      end

      if love.keyboard.isDown("up") then
        if nave.posY > (0 + naveBrancaImage:getHeight()/2 ) then
           nave.posY = nave.posY - nave.velocidade * dt
        end
      end

      if love.keyboard.isDown("down") then
        if nave.posY < (heightWindow - naveBrancaImage:getHeight()/2) then
           nave.posY = nave.posY + nave.velocidade * dt
        end
      end
end

function inimigo (dt)
  tempoCriarInimigo = tempoCriarInimigo - (1 * dt)
  if tempoCriarInimigo < 0 then
    tempoCriarInimigo = delayInimigo
    numAleatorio = math.random(10, widthWindowPlayerArea - ( ( imageInimigo:getWidth() / 2 ) + 10 ))
    newInimigo = { x = numAleatorio,
                   y = -imageInimigo:getWidth(),
                   img = imageInimigo
                 }

    table.insert( inimigos, newInimigo )
  end

  for i, inimigo in ipairs(inimigos) do
    inimigo.y = inimigo.y + ( 200 * dt )
        if inimigo.y > 850 then
          table.remove( inimigos, i )
        end
  end
end

function colisions ()                       --função que checa se houve colisoes com os tiros
  for i,inimigo in ipairs(inimigos) do
    for j,tiro in ipairs(tiros) do
      if checkColision(inimigo.x,
                       inimigo.y,
                       imageInimigo:getWidth(),
                       imageInimigo:getHeight(),
                       tiro.x,
                       tiro.y,
                       imageTiro:getWidth(),
                       imageTiro:getHeight()) then
        table.remove(tiros, j)
        explosionInimigo.x = inimigo.x
        explosionInimigo.y = inimigo.y
        table.insert( explosionInimigo, destroiInimigo )
        table.remove(inimigos, i)
        explodeInimigo:stop()
        explodeInimigo:play()
        pontos = pontos + 90
      end
    end
    -- checa se ouve colisao com a nave do inimigo
    if checkColision(inimigo.x,
                     inimigo.y,
                     imageInimigo:getWidth(),
                     imageInimigo:getHeight(),
                     nave.posX - ((naveBrancaImage:getWidth()/2)),
                     nave.posY,
                     naveBrancaImage:getWidth(),
                     naveBrancaImage:getHeight())
    and estarVivo then
                    table.remove(inimigos, i)
                    explodindoMe:play()
                    estarVivo = false
                    carregarTela = false
                    life = life - 1
                      if life < 0 then
                        gameOver = true
                        musicaGameOver:play()
                        musicaGameOver:setLooping(false)
                      end
    end
  end
end

function checkColision (X1,Y1,W1,H1,X2,Y2,W2,H2) -- função que checa colisões.
  --Os Parametros necessarios são dois objetos: posicão x e y do objeto na tela e largura e altura do objeto que irá colidir
return X1 < X2 + W2 and X2 < X1 + W1 and Y1 < Y2 + H2 and Y2 < Y1 + H1
end

function resert ()  -- função responsavel pelo reset do jogo
  if not estarVivo and inOutY == 0 and love.keyboard.isDown("return") then --caso tenha sido atingido, as variaveis são resetardas para  padrao
    tiros = {}
    inimigos = {}

    disparo = tempoAteAtirar
    tempoCriarInimigo = delayInimigo

    nave.posX = widthWindowPlayerArea / 2
    nave.posY =  heightWindow - naveBrancaImage:getHeight()/2

    --pontos = 0
    --estarVivo = true
    carregarTela = true
  end
end

function planoDeFundoScroll (dt)
  planoDeFundo.y = planoDeFundo.y + planoDeFundo.vel * dt
  planoDeFundo.y2 = planoDeFundo.y2 + planoDeFundo.vel * dt

  if planoDeFundo.y < heightWindow then
    planoDeFundo.y = planoDeFundo.y2 -fundo2:getHeight()
  end
  if planoDeFundo.y2 > heightWindow then
  planoDeFundo.y2 = planoDeFundo.y - fundo:getHeight()
  end
end

function startGame (dt)
  if carregarTela and not estarVivo then -- se carregarTela for verdade e estarVivo não...
    inOutX = inOutX + 600 * dt
    if inOutX > 559 then
        inOutY = -598
        inOutX = 0
        estarVivo = true
    end
	elseif not carregarTela then  -- se carregarTela for falso
		estarVivo = false
		inOutY = inOutY + 600 * dt
		if inOutY > 0 then
			inOutY = 0
		end
	end
end

function love.keyreleased(key)
  if key == "p" and carregarTela then
    pauseGame = not pauseGame
  end
  if pauseGame and not gameOver then
    pausarJogo:play()
    musicaFundo:pause()
  else
    love.audio.resume(musicaFundo)
  end
end

function galagaGameOver (dt)
  pauseGame = true
  musicaFundo:stop()
  transparencia = transparencia + 100 * dt
    if love.keyboard.isDown("escape") then
      love.event.quit()
    end
end

function controllerExplosionNave (dt)
  for i,_ in ipairs(explosionInimigo) do
    destroiInimigo:update(dt)
  end
end

function destroiDois(dt)
  for i,_ in ipairs(explosionInimigo) do
    table.remove( explosionInimigo, i )
  end
end
