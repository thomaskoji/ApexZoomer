pico-8 cartridge // http://www.pico-8.com
version 42

__lua__

-------------------------------
-- globals -- 
-------------------------------
#include pecs.lua

local world = pecs()

local Position = world.component({ x = 0, y = 0 })
local Velocity = world.component({ x = 0, y = 0 })
local Size = world.component({ width = 0, height = 0 })
-- To indicate an entity is controlled by input
-- In the future I want to put this in a system filter to check if an entity is controllable
-- I'm not sure if adding this component to an entity is enough for it to work as an filter
-- or maybe i have to add a function or something to the component
local InputControlled = world.component()
local NeedsDraw = world.component({color = 8, drawFunc = nil})
local NeedsUpdate = world.component({updateFunc = nil})

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

local entityDraw = world.system
(
    {
        NeedsDraw,
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
            entity[NeedsDraw].color
        )

        if entity.NeedsDraw ~= nil and entity.NeedsDraw.drawFunc ~= nil then
            entity.NeedsDraw.drawFunc()
            print("")
        end
    end
)

local entityUpdate = world.system
(
    {
        NeedsUpdate
    },

    function(entity)
        if entity.NeedsUpdate ~= nil and entity.NeedsUpdate.updateFunc ~= nil then
            entity.NeedsUpdate.updateFunc()
        end
    end
)

-- Table that stores all the buttons
key =
{
    left = 0,
    right = 1,
    up = 2,
    down = 3,
    z = 4,
    x = 5
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
        NeedsDraw()
    )

    local inputManager = world.entity
    (
        {
            manager = true,
            x = 0,
            y = 0,
            z = false,
            x = false
        },
        NeedsUpdate({ updateFunc = function(this)
            this.x = 0
            if (btn(key.left)) this.x -= 1
            if (btn(key.right)) this.x += 1
            this.y = 0
            if (btn(key.up)) this.y -= 1
            if (btn(key.down)) this.y += 1

            -- goofy ahh line
            this.x = (btn(0) and btn(1) and 0) or (btn(0) and -1) or (btn(1) and 1) or 0
            this.y = (btn(2) and btn(3) and 0) or (btn(2) and -1) or (btn(3) and 1) or 0

            this.z = btn(key.z)
            this.x = btn(key.x)
        end}),
        NeedsDraw({ drawFunc = function(this)   
            print("X : " .. this.x, 5, 10, 8)
            print("Y : " .. this.y, 5, 15, 8)
            print("Z : " .. this.z, 5, 20, 8)
            print("X : " .. this.x, 5, 25, 8)
            print("lets go", 5, 5, 11)
        end})
    )
end

function _update60()
    world.update()
    move()
    entityUpdate()
end

function _draw()
    cls()
    entityDraw()
    printDebug("A")
    printDebug("B")
    printDebug("C")
    printDebug("D")
end

-----------------------------------------------
--helper functions--
-----------------------------------------------

function printDebug(text)
    print(text, 5, printline or 1 * 5, 11)
    printline = (printline or 0) + 1 -- comment this and extention to open default file type 
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
