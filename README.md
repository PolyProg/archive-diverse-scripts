diverse-scripts
===============

Scripts for generating diplomas, slides etc.

## hc2-diplomas

Contains the python script for generating the diplomas from the output file csvs
of our backend and a svg template. Converts to pdf and prepares a mail-merge
csv for sending out the diplomas via the following Thunderbird plugin:

https://addons.mozilla.org/en-us/thunderbird/addon/mail-merge/ 

Dependencies:
python, rsvg

## santa-diplomas

Similar as hc2-diplomas, but does not contain the mail merge functionality yet.
Feel free to port it :).
