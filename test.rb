require 'rmagick'
include Magick

puts <<~END_INFO
  Demonstrate the rotation= attribute in the Draw class
  by producing an animated image. View the output image
  by entering the command: animate rotating_text.miff
END_INFO

text = Draw.new
text.pointsize = 15
text.font_weight = BoldWeight
text.font_style = ItalicStyle
text.gravity = CenterGravity
text.fill = 'white'

# Let's make it interesting. Composite the
# rotated text over a gradient fill background.
fill = GradientFill.new(100, 100, 100, 100, 'green', 'blue')
fillbg = GradientFill.new(100, 100, 100, 100, 'red', 'orange')
bg = Image.new(300, 300, fillbg)

# The "none" color is transparent.
fg = Image.new(bg.columns, bg.rows) { |options| options.background_color = 'green' }

# Here's where we'll collect the individual frames.
animation = ImageList.new

0.step(345, 5) do |degrees|
  frame = fg.copy
  text.annotate(frame, 0, 0, 0, 0, 'how do i rotate text in ms paint') do |options|
    options.rotation = degrees
  end
  # Composite the text over the gradient filled background frame.
  animation << bg.composite(frame, CenterGravity, DisplaceCompositeOp)
end

animation.delay = 8

# animation.animate
puts '...Writing rotating_text.gif'
animation.write('rotating_text.gif')
exit
