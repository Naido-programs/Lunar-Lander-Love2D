require("LunarLander")

function love.load()
  scw = love.graphics.getWidth()
  sch = love.graphics.getHeight()
  flame = love.graphics.newImage("images/flame.png")
  earth = love.graphics.newImage("images/earth.png")
  moon = love.graphics.newImage("images/moon.jpg")
  base = love.graphics.newImage("images/base.png")
	love.graphics.setBackgroundColor(0,0,0)
	lunarModule = LunarModule(330,0)
	restart()
end

function restart()
	lunarModule.x = 330
	lunarModule.y = 0
	lunarModule.speedx = 0
	lunarModule.speedy = 0
	lunarModule.rot = 0
	accelx = 0
	accely = 0
	time = 1
	power = 0 --0.0001/100
	fuel = 20
	speed = 0
	lastPos = lunarModule.y + lunarModule.h
	failed = false
	landed = false
	powerOn = false
	score = 0
end

function love.touchreleased(id,x,y,dx,dy,pressure)
    --if exit.isPointInside(x,y) then
      --  love.event.quit()
    --end
end

function love.mousereleased( x, y, button, istouch, presses )
    --if exit.isPointInside(x,y) then
      --  love.event.quit()
    --end
end

--luna 1,62 m/s²
function love.update(dt)
	distance = 800 - lunarModule.y + lunarModule.h
	accely = ((6.67E-11 * 7.3477E22)/math.pow((1737100 + distance),2))/60

	if love.keyboard.isDown("left") then
		accelx = accelx - 0.01 * dt
	end

	if love.keyboard.isDown("right") then
		accelx = accelx + 0.01 * dt
	end
	
	if love.keyboard.isDown("up") and not landed then
		if power < 0.1 then
			power = power + 0.001
		end
	end

	if love.keyboard.isDown("down") and not landed then
		if power > 0 then
			power = power - 0.001
		end
	end

	if love.keyboard.isDown("a") and fuel > 0 and not landed and power > 0 then
		fuel = fuel - power
		accely = accely - power
		powerOn = true
	else
		powerOn = false
	end

	if love.keyboard.isDown("space") and landed then
		restart()
	end 

	if lunarModule.y + lunarModule.h < 500 then
		lunarModule.move(accelx,accely)
		if dt > 0 then
			local pos = lunarModule.y + lunarModule.h
			speed = (pos - lastPos)/dt
			--print(pos, lastPos, dt, speed)
			lastPos = pos
		end
	else
		landed = true
		if speed > 20 then
			failed = true
			lunarModule.rot = 7
		else
			score = (fuel * 500) + ((20 - speed)*500)
			--print(fuel, speed)
			--print((fuel * 500), ((20 - speed)*500))
		end
	end
	time = time + dt
end

function love.draw()
	love.graphics.setColor(1,1,1,1)
	love.graphics.print("presiona la tecla A para acelerar",10,10)
	love.graphics.print("y arriba o abajo para variar la potencia",10,25)
	love.graphics.draw(moon,scw/2 - moon:getWidth()/2,470)
	love.graphics.draw(base,(scw - (base:getWidth()+73)*0.25)/2,485,0,0.25)
	love.graphics.draw(earth,550,200,math.rad(-9),0.5,0.5)
	lunarModule.paint()
	if powerOn then
		local r,g,b,a = love.graphics.getColor()
		love.graphics.setColor(1,1,1,power*10)
		love.graphics.draw(flame,(lunarModule.x + lunarModule.w/2) - 12,lunarModule.y + 91,0,0.19,0.19)
		love.graphics.setColor(r,g,b,a)
	end
	love.graphics.setColor(1,1,1)
	love.graphics.print("Power : "..(power*1000).." %",lunarModule.x + lunarModule.w + 10,lunarModule.y)
	love.graphics.print("Fuel    : "..math.abs(math.ceil((fuel*100)/20)).." %",lunarModule.x + lunarModule.w + 10,lunarModule.y+20)
	--love.graphics.print("speed: "..speed,lunarModule.x + lunarModule.w + 10,lunarModule.y+40)
	if landed then
		if failed then
			love.graphics.print("FAILED!",300,300)
			love.graphics.print("Presiona espacio para reiniciar",300,350)
		else
			if speed > 10 and speed <= 20 then
				love.graphics.print("GREAT",300,300)
			else
				if speed > 5 and speed <= 10 then
					love.graphics.print("AMAIZING !",300,300)
				else
					if speed >= 0 and speed <= 5 then
						love.graphics.print("PERFECT !!!",300,300)
					end
				end
			end
			love.graphics.print("Score: "..math.ceil(score).." Speed: "..math.ceil(speed),300,320)
			love.graphics.print("Presiona espacio para reiniciar",300,350)
		end
	end
	love.graphics.setColor(0,0,0,1)
	love.graphics.line(332,500,465,500)
end
