function love.load()

    height = love.graphics.getHeight()
    width = love.graphics.getWidth()

    colours = {
        purple = {51/255, 51/255, 255/255},
        lime = {26/255, 255/255, 26/255},
        pink = {255/355, 26/255, 117/255},
        orange = {255/255, 128/255, 0/255},
        lightGreen = {51/255, 204/255, 51/255},
        lightBlue = {51/255, 204/255, 255/255},
        yellow = {255/255, 255/255, 0/255},
        redOrange = {255/255, 51/255, 0/255},
        neonPurple = {204/255, 51/255, 255/255},
        seaGreen = {0/255, 255/255, 204/255},
    }

    target1 = {
        x = 300,
        y = 300,
        radius = 50,
        colour = colours.pink,
        grow = nil,
        moveVertical = nil,
        moveHorizontal = nil,
    }

    target2 = {
        x = 450,
        y = 150,
        radius = 0,
        colour = {0, 0, 0},
        grow = nil,
        moveVertical = nil,
        moveHorizontal = nil,
    }

    target3 = {
        x = 150,
        y = 450,
        radius = 0,
        colour = {0, 0, 0},
        grow = nil,
        moveVertical = nil,
        moveHorizontal = nil,
    }

    target4 = {
        x = 150,
        y = 450,
        radius = 0,
        colour = {0, 0, 0},
        grow = nil,
        moveVertical = nil,
        moveHorizontal = nil,
    }

    target5 = {
        x = 150,
        y = 450,
        radius = 0,
        colour = {0, 0, 0},
        grow = nil,
        moveVertical = nil,
        moveHorizontal = nil,
    }

    targetList = {target1, target2, target3, target4, target5}

    score = 0
    timer = 0
    health = 5
    isPaused = false
    pauseText = "Play"

    gameFont = love.graphics.newFont(40)
end

function love.update(dt)
    if isPaused == true then
        pauseText = "Paused"
    end

    if isPaused == false then
        pauseText = " "
    end

    if isPaused == false then

        timer = timer + 1

        if timer == 4*60 then
            target2.colour = randomElementFromTable(colours)
            target2.radius = 50
        end

        if timer == 6*60 then
            target3.colour = randomElementFromTable(colours)
            target3.radius = 50
        end

        if timer == 8*60 then
            target4.colour = randomElementFromTable(colours)
            target4.radius = 50
        end

        if timer == 10*60 then
            target5.colour = randomElementFromTable(colours)
            target5.radius = 50
        end

        -- Make them grow or shrink 
        if timer > 5*60 then
            for _, target in ipairs(targetList) do
                if target.grow ~= nil then
                    if target.grow then
                        target.radius = target.radius + 1/10
                    else
                        if not target.grow then
                            target.radius = target.radius - 1/10
                        end
                    end
                end
            end
        end

        -- Make them move vertically
        if timer > 21*60 then
            for _, target in ipairs(targetList) do
                if target.moveVertical then
                    target.y = target.y + 3
                else
                    if not target.moveVertical then
                        target.y = target.y - 3
                    end
                end
            end
        end

        -- Make them move horizontally
        if timer > 21*60 then
            for _, target in ipairs(targetList) do
                if target.moveHorizontal then
                    target.x = target.x + 5
                else
                    if not target.moveHorizontal then
                        target.x = target.x - 5
                    end
                end
            end
        end

        -- Check that they aren't smacking the wall
        if timer > 2*60 then
            for _, target in ipairs(targetList) do
                if checkVerticalDirection(target) then
                    if (target.y < 0) then
                        target.y = 1
                    end

                    if (target.y > height) then
                        target.y = height - 1
                    end

                    target.moveVertical = not target.moveVertical
                end

                if checkHorizontalDirection(target) then
                    if (target.x < 0) then
                        target.x = 1
                    end

                    if (target.x > width) then
                        target.x = width - 1
                    end

                    target.moveHorizontal = not target.moveHorizontal
                end
            end
        end

        -- Check that they aren't getting too big or small
        if timer > 16*60 then
            for _, target in ipairs(targetList) do
                if target.radius < 1 or target.radius > height then
                    setGrowValue(target)
                    health = health - 1
                end
            end
        end
end
end

function love.draw()
    if isPaused == false then
        -- First circle
        love.graphics.setColor(target1.colour[1], target1.colour[2], target1.colour[3])
        love.graphics.circle('fill', target1.x, target1.y, target1.radius)

        -- Second circle
        love.graphics.setColor(target2.colour[1], target2.colour[2], target2.colour[3])
        love.graphics.circle('fill', target2.x, target2.y, target2.radius)

        -- Third circle
        love.graphics.setColor(target3.colour[1], target3.colour[2], target3.colour[3])
        love.graphics.circle('fill', target3.x, target3.y, target3.radius)

        -- Fourth circle
        love.graphics.setColor(target4.colour[1], target4.colour[2], target4.colour[3])
        love.graphics.circle('fill', target4.x, target4.y, target4.radius)

        -- Fifth circle
        love.graphics.setColor(target5.colour[1], target5.colour[2], target5.colour[3])
        love.graphics.circle('fill', target5.x, target5.y, target5.radius)

        -- font
        love.graphics.setFont(gameFont)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(score, 0, 0)

        love.graphics.print(health, width-(width*0.1), 0)
    else
        if isPaused == true then
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle('line', width-(width*0.75), height-(height*0.8), (width*0.5), (height*0.5))
            love.graphics.setColor(1, 0.5, 1)
            love.graphics.rectangle('line', width-(width*0.63), height-(height*0.68), (width*0.25), (height*0.25))
            love.graphics.print(pauseText,  (width*0.4), (height*0.4))
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if isPaused == false then
            local target = identifyCircle(x, y)
            if target then
                local mouseToTarget = distanceBetween(x, y, target.x, target.y)
                if mouseToTarget < target.radius then
                    score = score + 1

                    if timer > 15*60 then
                        setGrowValue(target)
                    end

                    if timer > 20*60 then
                        setMoveValue(target)
                    end

                    target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
                    target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
                    target.colour = randomElementFromTable(colours)
                end
            end
        else
            if isPaused == true then
                if x > width*0.39 and x < width*0.63 and y < height*0.57 and y > height*0.32 then
                    isPaused = false
                end
            end
        end
    end
end

-- Pause menu
function love.keyreleased(key)
    if key == "escape" then
        if isPaused == false then
            isPaused = true
        else
            if isPaused == true then
                isPaused = false
            end
        end
    end
 end

-- Custom functions

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function identifyCircle(x, y)
    for _, target in ipairs(targetList) do
        local distance = distanceBetween(x, y, target.x, target.y)
        if distance < target.radius then
            return target
        end
    end
    return nil
end

function randomElementFromTable(tbl)
    local keys = {}

    for key in pairs(tbl) do
        table.insert(keys, key)
    end

    local randomKey = keys[math.random(#keys)]
    return tbl[randomKey]
end

function tableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function setGrowValue(target)
    local randomNumber = math.random(0, 10)

    if randomNumber <= 1 then
        target.radius = 40
        target.grow = true
    elseif randomNumber > 5 then
        target.radius = 120
        target.grow = false
    end
end

function setMoveValue(target)
    local randomNumber = math.random(0, 10)

    if randomNumber <= 5 then
        target.moveVertical = true
        target.moveHorizontal = true
    elseif randomNumber > 5 then
        target.moveHorizontal = false
        target.moveVertical = false
    end
end

function checkVerticalDirection(target)
    local a = height - target.radius;
    if target.y <= target.radius or target.y > a then
        return true
    end
    return false
end

function checkHorizontalDirection(target)
    local a = width - target.radius;
    if target.x <= target.radius or target.x > a then
        return true
    end
    return false
end
