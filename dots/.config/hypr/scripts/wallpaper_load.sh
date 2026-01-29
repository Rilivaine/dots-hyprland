swww query &> /dev/null
if [ $? -ne 0 ] ; then
    swww-daemon --format xrgb &
    swww query && swww restore
fi

