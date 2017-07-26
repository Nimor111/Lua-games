local levels = {}

local ball = require "ball"

levels.sequence = {}
levels.sequence[1] = [[
___________

# # ### # #
# # #   # #
### ##   # 
# # #    # 
# # ###  # 
___________
]]

levels.sequence[2] = [[
___________

### # # ###
# # # # #  
###  #  ## 
# #  #  #  
###  #  ###
___________
]]

levels.current_level = 1

function levels.switch_to_next_level( bricks ) 
  if bricks.no_more_bricks then
    if levels.current_level < #levels.sequence then
      levels.current_level = levels.current_level + 1
      bricks.construct_level( levels.sequence[levels.current_level] )
      ball.reposition()
    else
      levels.gamefinished = true
    end
  end
end

return levels
