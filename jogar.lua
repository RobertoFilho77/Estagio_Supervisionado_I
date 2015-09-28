  --Requisita o storyboard e cria uma nova cena
local storyboard = require("storyboard")
local scene = storyboard.newScene()

--Adiciona física e gravidade
local fisica = require("physics")
fisica.start()
--physics.setGravity( 0, 15 )

_W = display.contentWidth 
_H = display.contentHeight

local formas = {"images/triangulovermelho.png", "images/trianguloazul.png","images/trianguloverde.png",
                    "images/circulovermelho.png", "images/circuloazul.png", "images/circuloverde.png",
                    "images/quadradovermelho.png", "images/quadradoazul.png", "images/quadradoverde.png"}

local forma_piloto = {"images/triangulovermelho.png", "images/trianguloazul.png","images/trianguloverde.png",
                    "images/circulovermelho.png", "images/circuloazul.png", "images/circuloverde.png",
                    "images/quadradovermelho.png", "images/quadradoazul.png", "images/quadradoverde.png"}                    

function scene:createScene(event)
  local group = self.view

  --Adiciona o background
  local background = display.newImage("images/background2.jpg")
  background.x = _W/2
  background.y = _H/2
  group:insert(background) 

  local ground = display.newImage( "images/ground.png", _W/2, _H+20 )
  ground.myName = "ground"

  -- The parameter "myName" is arbitrary; you can add any parameters, functions or data to Corona display objects

  physics.addBody( ground, "static", { friction=0.5, bounce=0.3 } )

  local numero = 1
  local sorteioformas_piloto_inicial = math.random(9)

  local formas_piloto = {display.newImage(forma_piloto[sorteioformas_piloto_inicial])}
  formas_piloto[numero].x = _W/2
  formas_piloto[numero].y = _H-80
  formas_piloto[numero].myName = sorteioformas_piloto_inicial

  physics.addBody( formas_piloto[numero], "static", { friction=0.5, bounce=0.3 } )

  function move_formas(move_formas)
    
    local sorteiroforma = math.random(9)

    forma = nil
    forma = display.newImage(formas[sorteiroforma])
    forma.isSensor = false
    forma.x = _W/2
    forma.y = -100
    forma.myName = sorteiroforma

    physics.addBody(forma, { density=3.0, friction=0.5, bounce=0.3 } )  
  end  

  local function onLocalCollision( self, event )
    if event.phase =="began" then                      
      if formas_piloto[table.maxn(formas_piloto)].myName == forma.myName then
        x = formas_piloto[table.maxn(formas_piloto)].x
        y =formas_piloto[table.maxn(formas_piloto)].y                        
        timer.performWithDelay(10,move_formas,1)                        
        --event.target:removeSelf()                        
        event.other:removeSelf()                        
      end
    end
  end

  function formas_piloto:touch(event)
    print("tocado")
    
    local numerolocal = table.maxn(formas_piloto)

    formas_piloto[numerolocal]:removeSelf()
    formas_piloto[numerolocal] = nil

    local sorteioformas_piloto_posterior = math.random(9)

    formas_piloto[numero + 1] = display.newImage(forma_piloto[sorteioformas_piloto_posterior])
    formas_piloto[numero + 1].x = _W/2
    formas_piloto[numero + 1].y = _H-80
    formas_piloto[numero + 1].myName = sorteioformas_piloto_posterior

    physics.addBody( formas_piloto[numero + 1], "static", { friction=0.5, bounce=0.3 } )

    formas_piloto[table.maxn(formas_piloto)]:addEventListener("touch", formas_piloto)
    formas_piloto[table.maxn(formas_piloto)].collision = onLocalCollision
    formas_piloto[table.maxn(formas_piloto)]:addEventListener( "collision" )  
  end
  formas_piloto[table.maxn(formas_piloto)]:addEventListener("touch", formas_piloto)

  formas_piloto[table.maxn(formas_piloto)].collision = onLocalCollision
  formas_piloto[table.maxn(formas_piloto)]:addEventListener( "collision" )  

  move_formas( formas )
end


--Recebe os metodos criados
scene:addEventListener("createScene", scene)
return scene

