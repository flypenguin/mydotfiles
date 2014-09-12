#!/usr/bin/env bash

# http://bit.ly/1tIX73E
# this does not work any longer with gnome.
# and FINALLY I have a solution.
# see here.
# new_pointer_map=$(xmodmap -pp 2>&1 \
#     | grep -E '[[:space:]]*[0-9]+[[:space:]]+[0-9]+' \
#     | awk '{print $2}' \
#     | tr "\n" " " \
#     | sed 's/4 5/5 4/g')
#
# xmodmap -e "pointer = ${new_pointer_map}"


# now to the real thing.

for a in "Logitech Unifying Device" ; do
    tmp="$(xinput list | grep "$a" 2>/dev/null)"
    if  [ "$tmp" != "" ]; then
        # find the ID of the thing. (id=XX in the line... :
        # $ xinput list
        # --> "Logitech Unifying Device. Wireless PID:4013 id=11   ..."
        id_dev=$(echo $tmp | sed -rn 's/^.+id=([0-9]+).+$/\1/gp')
        [[ -z $id_dev ]] && continue

        # get the id and param values of the scrolling property of the thing
        # $ xinput list-props <ID> | grep "Scrolling Distance"
        # -->  "Evdev Scrolling Distance (267): -1, -1, -1"
        # The number in brackets is the propertie's ID, the following numbers
        # are the property value settings.
        #
        # MORE PRECISE BUT OVERKILL BELOW:
        #  sed -nr 's/^.+ Scrolling Distance \(([0-9]+)\):(.+)$/\1 \2/gp' \
        #  tr -d ,
        tmp=$( \
            xinput list-props $id_dev \
            | grep "Scrolling Distance" \
            | sed 's/[^0-9\t .]//g' )   # strip all but whitespace and numbers
        [[ -z $tmp ]] && continue
        # get property id
        id_prop=$(echo $tmp | cut -f 1 -d " ")

        # get values, and make sure they are "clean" (remove the '-'s ...)
        values=$(echo $tmp | cut -f 2- -d " ")

        # now, change values to negative
        values=$(echo $values | sed -r 's/([0-9]+)/-\1/g')

        # now, FINALLY set the values.
        xinput set-prop $id_dev $id_prop $values

        # done. easy-peasy, eh? ... wow.
    fi
done



