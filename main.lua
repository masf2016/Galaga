widthWindow = love.graphics.getWidth()                                 -- largura da janela de jogo
widthWindowPlayerArea = love.graphics.getWidth() * 0.7                 -- area do player, 70% da tela
widthWindowInfoArea = love.graphics.getWidth() - widthWindowPlayerArea -- area de informacao
heightWindow = love.graphics.getHeight()                               -- altura da janela de jogo
function love.load()
naveBrancaImage = love.graphics.newImage("assets/player-white.png")

  nave = {
    posX = widthWindow / 2,                                            -- posicao X do objeto na tela, no meio dela
    posY = heightWindow - (naveBrancaImage:getHeight()/2),             -- posicao Y do objeto na tela, equivale a altura da janela menos a metade do tamanho do player
    velocidade = 500                                                       -- velocidade de deslocamento do player
  }
  atira = true                                                       -- disparo, habilitado
  delayTiro = 0.1                                                   -- delay entre os disparo
  tempoAteAtirar = delayTiro                                           -- tempo ate o disparo, equivale ao delayShoot
  tiros = {}                                                            -- disparos
  imageTiro = love.graphics.newImage("assets/ammunition.png")        --imagem usada para munição
end

function love.draw()
  -- Nave
  love.graphics.draw(naveBrancaImage, --imagem a ser carregada
                     nave.posX, --posicao do objeto em X
                     nave.posY, --posicao do objeto em Y
                     0,   --angulo de rotação do objeto na tela
                     0.3, --tamanho do objeto na tela em 30%
                     0.3, --tamanho do objeto na tela em 30%
                     naveBrancaImage:getWidth()/2, --posicionamento da imagem (centralizar em X)
                     naveBrancaImage:getHeight()/2) --posicionamento da imagem (centralizar em Y)

  -- tiros
  for i,tiro in ipairs(tiros) do
    love.graphics.draw(tiro.img, --imagem a ser carregada
                       tiro.x, --posicao do objeto em X
                       tiro.y, --posicao do objeto em Y
                       0,  --angulo de rotação do objeto na tela
                       0.3, --tamanho do objeto na tela em 30%
                       0.3, --tamanho do objeto na tela em 30%
                       imageTiro:getWidth()/2,  --posicionamento da imagem (centralizar em X)
                       imageTiro:getHeight()/2) --posicionamento da imagem (centralizar em Y)
  end
end

function love.update(dt)
  movimentos (dt)
  atirar (dt)
end

function atirar (dt)
      tempoAteAtirar = tempoAteAtirar - (1 * dt)                  -- decremetar a variavel de tiro
      if tempoAteAtirar < 0 then                               -- se for menor que zero, ele dispara
        atira = true
      end
      if love.keyboard.isDown("space") and atira then       -- se a tecla space for disparada e ele puder disparar
                                                             -- é criado um novo objeto de tiro na mesma posicao da nave
        novoTiro = { x = nave.posX, y = nave.posY, img = imageTiro}

        table.insert (tiros,novoTiro)                       -- o novo objeto é entao inserido na tabela shots
        atirar = false                                       -- tiro é bloqueado
        tempoAteAtirar = delayTiro                            -- o tempo de disparo retorna para 0.1
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
