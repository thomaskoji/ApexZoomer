pico-8 cartridge // http://www.pico-8.com
version 42

__lua__

-------------------------------
-- globals -- 
-------------------------------
#include pecs/pecs.lua

local world = pecs()

local Position = world.component({ x = 0, y = 0 })
local Velocity = world.component({ x = 0, y = 0 })
local Size = world.component({ width = 0, height = 0 })
-- To indicate an entity is controlled by input
-- In the future I want to put this in a system filter to check if an entity is controllable
-- I'm not sure if adding this component to an entity is enough for it to work as an filter
-- or maybe i have to add a function or something to the component
local InputControlled = world.component()
local Renderable = world.component({color = 8})

local move = world.system
(
    {
        Position,
        InputControlled
    },

    function(entity)
        if (btn(key.left)) entity[Position].x -= 1
        if (btn(key.right)) entity[Position].x += 1
        if (btn(key.up)) entity[Position].y -= 1
        if (btn(key.down)) entity[Position].y += 1
        --if (btn(0)) then entity[Renderable].color = 11
        --else entity[Renderable].color = 8 end
    end
)

local renderDrawable = world.system
(
    {
        Renderable,
        Size,
        Position
    },

    function(entity)
        rect
        (
            entity[Position].x,
            entity[Position].y,
            entity[Position].x + entity[Size].width -1,
            entity[Position].y + entity[Size].height -1,
            entity[Renderable].color
        )
        print(entity[Position].x .. entity[Position].y, 5, 5, 11)
    end
)

-- Table that stores all the buttons
key =
{
    left = 0,
    right = 1,
    up = 2,
    down = 3,
    jump = 4,
    dash = 5
}

function _init()
    local player = world.entity
    (
        { 
            collidable=true,
            solid=true
        },
        InputControlled(),
        Position({ x=64, y=64}),
        Velocity(),
        Size({ width=8, height=8}),
        Renderable()
    )
end

function _update60()
    world.update()
    move()
end

function _draw()
    cls()
    renderDrawable()
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
