local platform = {}

platform.position_x = 300
platform.position_y = 500
platform.speed_x = 300
platform.width = 70
platform.height = 20

function platform.update(dt)
  if love.keyboard.isDown("right") then
    platform.position_x = platform.position_x + (platform.speed_x * dt)
  end
  if love.keyboard.isDown("left") then
    platform.position_x = platform.position_x - (platform.speed_x * dt)
  end
end

function platform.draw()
  love.graphics.rectangle( 'line',
                            platform.position_x,
                            platform.position_y,
                            platform.width,
                            platform.height )
end

function platform.rebound( shift_platform_x, shift_platform_y )
  local min_shift = math.min( math.abs( shift_platform_x ),
                              math.abs( shift_platform_y ) )
  if math.abs( shift_platform_x ) == min_shift then 
    shift_platform_y = 0
  else
    shift_platform_x = 0
  end

  platform.position_x = platform.position_x - shift_platform_x
  platform.position_y = platform.position_y - shift_platform_y
end

return platform
