local spr = {[[
---------------*
	-**-**--
	*--*--*-
	*-----*-
	-*---*--
	--*-*---
	---*----
	--------
	--------
]], [[
---------------*
	-**-**--
	*******-
	*******-
	-*****--
	--***---
	---*----
	--------
	--------
]]
}
local w, h = screen:size()
stars = {}

for i=1, #spr do
	spr[i] = gfx.new(spr[i])
end

for i=1, 128 do
	table.insert(stars, {
		x = math.random(w),
		y = math.random(h),
		c = math.random(16),
		s = math.random(8),
	})
end

local fps = 0
local start = sys.time()
local frames = 0
local txt = ''

local function showkeys()
	local t = ''
	local k = { 'left', 'right', 'up', 'down', 'space', 'z', 'x' }
	for _, v in ipairs(k) do
		if input.keydown(v) then
			t = t .. v .. ' '
		end
	end
	return t
end

-- no upvalues!
beep3 = function()
	local abs = math.abs
	local sfx = require "sfx"
	local SR = 44100

	for t = 0, SR * 4, 1 do
		coroutine.yield(0.3 * sfx.sin(t, 2) * sfx.dsf(sfx.hz(t, 450), 0.120, 0.1 + 0.7 * abs(sfx.sin(t, 0.2))))
	end
end


function tune()
	local sfx = require "sfx"
	local voices = {
		sfx.SquareVoice(),
		sfx.SawVoice(),
		sfx.SquareVoice(),
	}
	local pans = { -1, 0, 1 };
	local song = [[
C-3 80 | E-4 FF | C-5 50
... .. | ... .. | D-5 45
... .. | ... .. | C-5 40
E-3 .. | ... .. | D-5 35
... .. | ... .. | C-5 30
... .. | ... .. | D-5 25
G-3 .. | D-4 A0 | C-5 20
... .. | ... .. | D-5 15
... .. | ... .. | C-5 10
C-3 .. | C-4 FF | D-5 50
... .. | ... .. | C-5 45
... .. | ... .. | D-5 40
E-3 .. | G-3 FF | C-5 35
... .. | ... .. | D-5 30
... .. | ... .. | C-5 25
G-3 .. | ... .. | D-5 20
... .. | ... .. | C-5 15
... .. | ... .. | D-5 10
C-3 .. | A-3 A0 | C-5 50
... .. | ... .. | D-5 45
... .. | ... .. | C-5 40
E-3 .. | ... .. | D-5 35
... .. | ... .. | C-5 30
... .. | ... .. | D-5 25
G-3 .. | ... .. | C-5 20
... .. | ... .. | D-5 15
... .. | ... .. | C-5 10
C-3 .. | C-4 FF | D-5 50
... .. | ... .. | C-5 45
... .. | ... .. | D-5 40
E-3 .. | ... .. | C-5 35
... .. | ... .. | C-5 30
... .. | ... .. | D-5 25
G-3 .. | ... .. | C-5 20
... .. | ... .. | C-5 15
... .. | ... .. | D-5 10
]]
	local song = sfx.parse_song(song)
	for i = 1, 3 do
		sfx.play_song(voices, pans, song)
	end
end

mixer.setvol(0.4)
mixer.add(tune)
--mixer.add(beep3)

local s = gfx.new
[[
-------78-----e-
-----------
--8888888--
-8-------8-
-8-78-78-8-
-8-------8-
-8---e---8-
-8---e---8-
-8-e---e-8-
-8--eee--8-
-8-------8-
--8888888--
-----------
]];
while true do
	local cur = sys.time()
	fps = math.floor(frames / (cur - start))
	screen:clear(0)
	screen:fill_circle(100, 100, 30, s)
	screen:offset(math.floor(math.sin(frames * 0.1)*6), math.floor(math.cos(frames * 0.1)*6))
	spr[math.floor(frames/10)%2+1]:blend(screen, 240, 0)

	local mx, my, mb = input.mouse()
	local a, b = sys.input()

	if a == 'text' then
		txt = txt .. b
	elseif a == 'keydown' and b == 'return' then
		txt = txt .. '\n'
	elseif a == 'keydown' and b == 'backspace' then
		txt = ''
	end

	printf(0, 0, 15, "FPS:%d\nМышь:%d,%d %s\nKeys:%s\nInp:%s",
		fps, mx, my, mb.left and 'left' or '',
		showkeys(), txt..'\1')

	for k, v in ipairs(stars) do
		screen:pixel(v.x, v.y, v.c)
		stars[k].y = v.y + v.s
		if stars[k].y > h then
			stars[k].y = 0
			stars[k].x = math.random(w)
		end
	end
	gfx.flip(1/50)
	frames = frames + 1
end
