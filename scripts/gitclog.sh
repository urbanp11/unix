width=$(tput cols)
height=$(tput lines)
lines_to_draw=$(($height-3))
title="Git log - colored by Petr Urban - Kreatur s.r.o."
line_length=${#title}

tput civis #hide cursor
tput clear

#echo "line_length" $line_length
#echo "width" $width


tput cup 1 "$((($width-$line_length)/2))"

echo `tput bold`"$(tput setaf 1)$title$(tput sgr0)" `tput sgr0`

cmd='git log --pretty=format:"%h $(tput setaf 4)%an$(tput sgr0) %ad $(tput setaf 1)%s$(tput sgr0)" -'$lines_to_draw' --date=iso' 
#echo $lines_to_draw
#echo $cmd
eval $cmd
tput cnorm #show cursor
#git log --pretty=format:"%an %ad $(tput setaf 1)%s$(tput sgr0)" --date=short -lines

#ls -l | grep ^- | awk '{print $9}' // 