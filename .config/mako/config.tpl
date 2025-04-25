# ~/.config/mako/config.tpl

# === Appearance ===
font=Noto Sans 10
width=350
padding=10
margin=15
border-size=2
border-radius=8
icons=1
max-icon-size=64
icon-path=/usr/share/icons/Papirus

# === Behavior ===
default-timeout=5000
ignore-timeout=0
max-visible=5
sort=+time
layer=overlay

# === Pywal Colors ===
background-color={{background}}    
text-color={{foreground}}          
border-color={{color4}}            

# === Urgency Levels ===
[urgency=low]
text-color={{color8}}              
border-color={{color8}}            

[urgency=normal]
# Inherits default colors (background, foreground, color4 border)

[urgency=high]
background-color={{color1}}        
text-color={{foreground}}          
border-color={{color9}}            
default-timeout=0                  
ignore-timeout=1                   