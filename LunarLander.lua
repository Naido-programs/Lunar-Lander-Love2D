local moduleImage = love.graphics.newImage("images/lunarLander.png")

function LunarModule(x,y)
	local this = {}
	this.x = x
	this.y = y 
	this.w = 135
	this.h = 100
	this.speedx = 0
	this.speedy = 0
	this.rot = 0

	function this.move(dx,dy)
		this.speedx = this.speedx + dx
		this.speedy = this.speedy + dy
		this.x = this.x + this.speedx
		this.y = this.y + this.speedy
	end

	function this.paint()
		love.graphics.draw(moduleImage,this.x,this.y,math.rad(this.rot),0.34,0.34)
		--love.graphics.rectangle("line", this.x, this.y, this.w, this.h)
	end

	return this
end