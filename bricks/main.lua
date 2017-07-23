local columns = 11
local rows = 8

local ball = {}
ball.position_x = 300
ball.position_y = 300
ball.speed_x = 300
ball.speed_y = 300
ball.radius = 30

local platform = {}
platform.position_x = 500
platform.position_y = 500
platform.speed_x = 300
platform.width = 70
platform.height = 20

local bricks = {}
bricks.rows = rows
bricks.columns = columns
bricks.top_left_position_x = 70
bricks.top_left_position_y = 50
bricks.brick_width = 50
bricks.brick_height = 30
bricks.horizontal_distance = 10
bricks.vertical_distance = 15
bricks.current_level_bricks = {}

local walls = {}
walls.current_level_walls = {}
walls.wall_thickness = 20

local collisions = {}

-- COLLISION LOGIC
function collisions.resolve_collisions()
  collisions.ball_platform_collision( ball, platform )
  collisions.ball_walls_collision( ball, walls )
  collisions.ball_bricks_collision( ball, bricks )
  collisions.platform_walls_collision( platform, walls )
end

function collisions.check_rectangles_overlap( a, b )
  local overlap = false
  if not( a.x + a.width < b.x or b.x + b.width < a.x or
          a.y + a.height < b.y or b.y + b.height < a.y ) then
    overlap = true
  end
  return overlap
end

function collisions.ball_platform_collision()
  local a = { x = platform.position_x,
              y = platform.position_y,
              width = platform.width,
              height = platform.height }
  local b = { x = ball.position_x - ball.radius,
              y = ball.position_y - ball.radius,
              width = 2 * ball.radius,
              height = 2 * ball.radius }
  if collisions.check_rectangles_overlap( a, b ) then
    print("Ball platform collision!")
  end
end

function collisions.ball_bricks_collision()
  local b = { x = ball.position_x - ball.radius,
              y = ball.position_y - ball.radius,
              width = 2 * ball.radius,
              height = 2 * ball.radius }
  for _, brick in pairs(bricks.current_level_bricks) do
    local a = { x = brick.position_x,
                y = brick.position_y,
                width = brick.width,
                height = brick.height }
    if collisions.check_rectangles_overlap( a, b ) then
      print('Ball brick collision')
    end
  end
end

function collisions.ball_walls_collision()
  local b = { x = ball.position_x - ball.radius,
              y = ball.position_y - ball.radius,
              width = 2 * ball.radius,
              height = 2 * ball.radius }
  for _, wall in pairs(walls.current_level_walls) do
    local a = { x = wall.position_x,
                y = wall.position_y,
                width = wall.width,
                height = wall.height }
    if collisions.check_rectangles_overlap( a, b ) then
      print('Ball wall collision')
    end
  end
end

function collisions.platform_walls_collision()
  local a = { x = platform.position_x,
              y = platform.position_y,
              width = platform.width,
              height = platform.height }
  for _, wall in pairs(walls.current_level_walls) do
    local b = { x = wall.position_x,
                y = wall.position_y,
                width = wall.width,
                height = wall.height }
    if collisions.check_rectangles_overlap( a, b ) then
      print('Platform wall collision')
    end
  end
end
-- END COLLISION LOGIC

-- BRICK LOGIC
function bricks.new_brick(position_x, position_y, width, height)
  return ( {
    position_x=position_x,
    position_y=position_y,
    width = width or bricks.brick_width, -- use default value if no width provided
    height = height or bricks.brick_height -- same as above
  } )
end

function bricks.draw_brick( single_brick )
  love.graphics.rectangle( 'line',
                            single_brick.position_x,
                            single_brick.position_y,
                            single_brick.width,
                            single_brick.height )
end

function bricks.update_brick( single_brick )
end

function bricks.construct_level()
  for row = 1, bricks.rows do
    for col = 1, bricks.columns do
      local new_brick_position_x = bricks.top_left_position_x +
      ( col - 1 ) * ( bricks.brick_width + bricks.horizontal_distance )
      local new_brick_position_y = bricks.top_left_position_y +
      ( row - 1 ) * ( bricks.brick_height + bricks.vertical_distance )
      local new_brick = bricks.new_brick( new_brick_position_x, new_brick_position_y )
      table.insert( bricks.current_level_bricks, new_brick )
    end
  end
end

function bricks.draw()
  for _, brick in pairs(bricks.current_level_bricks) do
    bricks.draw_brick(brick)
  end
end

function bricks.update( dt )
  for _, brick in pairs(bricks.current_level_bricks) do
    bricks.update_brick(brick)
  end
end
-- BRICK LOGIC

-- WALL LOGIC
function walls.new_wall( position_x, position_y, width, height )
  return ({
    position_x=position_x,
    position_y=position_y,
    width=width,
    height=height
  })
end

function walls.construct_walls()
  local left_wall = walls.new_wall(
    0,
    0,
    walls.wall_thickness,
    love.graphics.getHeight()
  )
  local right_wall = walls.new_wall(
    love.graphics.getWidth() - walls.wall_thickness,
    0,
    walls.wall_thickness,
    love.graphics.getHeight()
  )
  local top_wall = walls.new_wall(
    0,
    0,
    love.graphics.getWidth(),
    walls.wall_thickness
  )
  local bottom_wall = walls.new_wall(
    0,
    love.graphics.getHeight() - walls.wall_thickness,
    love.graphics.getWidth(),
    walls.wall_thickness
  )
  walls.current_level_walls["left"] = left_wall
  walls.current_level_walls["right"] = right_wall
  walls.current_level_walls["top"] = top_wall
  walls.current_level_walls["bottom"] = bottom_wall
end

function walls.update_wall( wall )
end

function walls.update( dt )
  for _, wall in pairs(walls.current_level_walls) do
    walls.update_wall( wall )
  end
end

function walls.draw_wall( single_wall )
  love.graphics.rectangle( 'line',
                            single_wall.position_x,
                            single_wall.position_y,
                            single_wall.width,
                            single_wall.height )
end

function walls.draw()
  for _, wall in pairs(walls.current_level_walls) do
    walls.draw_wall(wall)
  end
end
-- WALL LOGIC

function love.load()
  bricks.construct_level()
  walls.construct_walls()
end

-- Update helper functions for objects
function ball.update(dt)
  ball.position_x = ball.position_x + ball.speed_x * dt
  ball.position_y = ball.position_y + ball.speed_y * dt
end

function platform.update(dt)
  if love.keyboard.isDown("right") then
    platform.position_x = platform.position_x + (platform.speed_x * dt)
  end
  if love.keyboard.isDown("left") then
    platform.position_x = platform.position_x - (platform.speed_x * dt)
  end
end
-- Update helper functions for objects

function love.update(dt)
  ball.update(dt)
  platform.update(dt)
  bricks.update(dt)
  walls.update(dt)
  collisions.resolve_collisions()
end

-- Draw helper functions for objects
function ball.draw()
  local segments_in_circle = 16

  love.graphics.circle( 'line',
                        ball.position_x,
                        ball.position_y,
                        ball.radius,
                        segments_in_circle )
end

function platform.draw()
  love.graphics.rectangle( 'line',
                            platform.position_x,
                            platform.position_y,
                            platform.width,
                            platform.height )
end
-- Draw helper functions for objects

function love.draw()
  ball.draw()
  platform.draw()
  bricks.draw()
  walls.draw()
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end

function love.keyreleased( key, _code )
  if key == 'escape' then
    love.event.quit()
  end
end
