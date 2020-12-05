local facing = -1
local travelY = -1

local function setTravelY(y)
	travelY = y
end

local function move()
	while (not turtle.forward()) do
		turtle.dig()
	end
end

local function moveUp()
	while (not turtle.up()) do
		turtle.digUp()
	end
end

local function moveDown()
	while (not turtle.down()) do
		turtle.digDown();
	end
end

local function forward(n)
	for i = 1, n, 1 do
		move()
	end
end

local function up(n)
	for i = 1, n, 1 do
		moveUp()
	end
end

local function down(n)
	for i = 1, n, 1 do
		moveDown()
	end
end

local function left()
	if facing == -1 then
		print("ERROR: Direction not set.")
		error()
	end
	facing = ( facing + 3 ) % 4
	turtle.turnLeft()
end

local function right()
	if facing == -1 then
		print("ERROR: Direction not set.")
		error()
	end
	facing = ( facing + 1 ) % 4
	turtle.turnRight()
end

local function look(d)
	diff = math.abs(facing - d)
	if diff == 2 then
		left()
		left()
	elseif diff == 1 then
		if d > facing then right() else left() end
	elseif diff == 3 then
		if d > facing then left() else right() end
	end
end

local function findDir()
	x1, _, z1 = gps.locate()
	move()
	x2, _, z2 = gps.locate()
	if x1 == x2 then
		if (z1 > z2) then facing = 0 else facing = 2 end
	else
		if (x1 > x2) then facing = 3 else facing = 1 end
	end
	print(facing)
end

local function getDir()
	if facing == -1 then
		findDir()
		left()
		left()
		forward(1)
		right()
		right()
	end
	return facing
end

local function changex(x)
	if x < 0 then
		look(1)
	elseif x > 0 then
		look(3)
	end
	forward(math.abs(x))
end

local function changey(y)
	print("Y: "..y)
	if y < 0 then
		down(math.abs(y))
	elseif y > 0 then
		up(y)
	end
end

local function changez(z)
	if z < 0 then
		look(2)
	elseif z > 0 then
		look(0)
	end
	forward(math.abs(z))
end

local function goto(x, y, z)
	if facing == -1 then
		findDir()
	end
	currx, curry, currz = gps.locate()
	if currx == x and curry == y and currz == z then
		return
	end
	if travelY ~= -1 then
		changey(travelY - curry)
	else
		changey(y - curry)
	end
	changex(currx - x)
	changez(currz - z)
	if travelY ~= -1 then
		changey(y - travelY)
	end
end

return {
	goto = goto,
	findDir = findDir,
	getDir = getDir,
	setTravelY = setTravelY,
	forward = forward,
	up = up,
	down = down,
	left = left,
	right = right,
}
