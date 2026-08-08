[
(let
  researcher = {
  name = "Ella";
  age = 20;
  colour = "Purple";
  GPA = 4;
  favMedia = {
    book = "Throne of Glass";
    movie = "Spirited Away";
    song = "Cherry wine";
  };
};
in
  researcher.favMedia.book)

(let
  myData = {
    mean = 20.1;
    mode = 18.5;
    median = 23.5;
  };
in
  with myData; (mean+mode+median) / 3 )

(let
  a = {
    garbageInfo = "We don't need this";
    x = "Nix";
    y = "Rocks";
  }; 
  inherit (a) x y;
in [x y])

(let
  name = "Kei";
in
  "Hello ${name}")


(''
This
is
indented
'')

# == Functions ==
# Funcitons don't have names in Nix, rather eval as <lambda>.
# A function can only have one arguement, 
(let
 f = x: x + x; # Should return 8
 in 
 f 4)
# however, we may nest functions.
(let 
  f = x: y: x + y; # Should return 10
in 
  f 4 6)
# Alternatively we may use attributes
# Heres the '?' indicates a default value if none is sepcified
(let
  f = {a, b ? 0}: a + b; # Should return 12
in 
  f { a = 3; b = 9;})
# If we want to let the user input more without crashing
# (f = {a, b, ...}: a + b)

]
