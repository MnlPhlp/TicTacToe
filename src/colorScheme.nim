import chroma

type 
  ColorScheme = ref object
      fieldLight*,fieldDark*,warn*,buttonColor*,buttonPressed*,buttonHover*: Color

let 
  colors* = ColorScheme(
      fieldLight: parseHtmlColor("#AAAAAA"),
      fieldDark: parseHtmlColor("#999999"),
      warn: color(1,0,0),
      buttonColor: parseHtmlColor("#c4c4c4"),
      buttonHover: parseHtmlColor("#DDDDDD"),
      buttonPressed: parseHtmlColor("#BBBBBB")
  )