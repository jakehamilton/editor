(fn clamp [value min max]
  (math.min max (math.max min value)))

(export clamp)
