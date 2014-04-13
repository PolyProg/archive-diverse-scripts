diverse-scripts
===============

Scripts for generating diplomas, slides etc.

## hc2-ceremony

Contains an outdated Microsoft Powerpoint macro for generating slides for the
final ceremony of HC2. We wholeheartedly recommend to switch to a python
script that generates (a) pdf(s) that can be merged with the rest of the 
presentation, similar to hc2-diplomas.

## hc2-diplomas

Contains the python script for generating the diplomas from the output file csvs
of our backend and a svg template. We typically just copy-paste the HTML table 
from the backend into a CSV file. Converts to pdf and prepares a mail-merge
csv for sending out the diplomas via the following Thunderbird plugin:

https://addons.mozilla.org/en-us/thunderbird/addon/mail-merge/ 

Dependencies:
python, rsvg



## santa-diplomas

Similar as hc2-diplomas, but does not contain the mail merge functionality yet.
Feel free to port it :).
