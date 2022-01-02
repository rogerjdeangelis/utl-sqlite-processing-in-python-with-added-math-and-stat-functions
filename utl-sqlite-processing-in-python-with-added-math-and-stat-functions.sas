%let pgm=utl-sqlite-processing-in-python-with-added-math-and-stat-functions;

SQL processing in python with added math and stat functions

gitnub
https://tinyurl.com/khkhkxxm
https://github.com/rogerjdeangelis/utl-sqlite-processing-in-python-with-added-math-and-stat-functions

Python drop down macros on end

How to run this SAS 'Proc sql' code in Python and R

  proc sql;
    select
      (select count(*) from sashelp.class) as students
     ,SEX
     ,count(*)       as sexCnt
     ,std(WEIGHT)    as stdWgt
     ,min(WEIGHT)    as minWgt
     ,max(WEIGHT)    as maxWgt
    from
      sashelp.class
    where
      name in ('James', 'Jane', 'Janet', 'Jeffrey', 'John', 'Joyce')
    group
      by SEX
;quit;

For the same code in R see
https://tinyurl.com/36fd6d2n
https://github.com/rogerjdeangelis/utl-drop-down-from-sas-to-R-and-summarize-weight-by-sex

Windows 10 64 bit Python 64 bit 3.9 and SAS 64 bit 9.4M7 pandasql installed 12/29/2021

   Using Python sql to summarize sashelp.class statistics by sex.
   This opens up Python to SAS 'proc sql' programmers.

   Process
      1. Download the load module with the must have sql functions
      2. Place downloaded libsqlitefunctions.dll in  c:/temp/libsqlitefunctions.dll
      3. Compile Python drop down macros located at the end of this repo
      4. Run Python SQL code
      5. SAS/Python log

Download from OneDrive (place in c:/temp/libsqlitefunctions.dll)
You can compile from source if you do not want to download. see below.

This is the dynamically loadable windows dll with added sqlite functions
https://1drv.ms/u/s!AoqaX8I7j_icgx2BAyQY9pGup-UQ?e=wbuSYO

If you do not want to download. Not so easy but you can create the load module from source.
https://apimirror.com/sqlite/loadext
Python sqlite is missing these function;

/*         _         _                __                  _   _
 _ __ ___ (_)___ ___(_)_ __   __ _   / _|_   _ _ __   ___| |_(_) ___  _ __  ___
| `_ ` _ \| / __/ __| | `_ \ / _` | | |_| | | | `_ \ / __| __| |/ _ \| `_ \/ __|
| | | | | | \__ \__ \ | | | | (_| | |  _| |_| | | | | (__| |_| | (_) | | | \__ \
|_| |_| |_|_|___/___/_|_| |_|\__, | |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
                             |___/
*/

Thi is a sample of missing functions, you will be adding these to sqlite

rounding                      : ceil, floor, trunc;
logarithmic                   : ln, log10, log2, log;
arithmetic                    : pow, sqrt, mod;
trigonometric                 : cos, sin, tan;
hyperbolic                    : cosh, sinh, tanh;
inverse trigonometric         : acos, asin, atan, atan2;
inverse hyperbolic            : acosh, asinh, atanh;
angular measures              : radians, degrees; pi.

median(x)                     : median (50th percentile),
percentile_25(x)              : 25th percentile,
percentile_75(x)              : 75th percentile,
percentile_90(x)              : 90th percentile,
percentile_95(x)              : 95th percentile,
percentile_99(x)              : 99th percentile,
percentile(x, perc)           : custom percentile (perc between 0 and 100),
stddev(x) or stddev_samp(x)   : sample standard deviation,
stddev_pop(x)                 : population standard deviation,
variance(x) or var_samp(x)    : sample variance,
var_pop(x)                    : population variance.

/*
 _                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

libname tmp "c:/temp";
data tmp.class;
  set sashelp.class;
run;quit;

/*
Up to 40 obs TMP.CLASS total obs=19 02JAN2022:10:44:45

Obs    NAME       SEX    AGE    HEIGHT    WEIGHT

  1    Alfred      M      14     69.0      112.5
  2    Alice       F      13     56.5       84.0
  3    Barbara     F      13     65.3       98.0
  4    Carol       F      14     62.8      102.5
  5    Henry       M      14     63.5      102.5
  6    James       M      12     57.3       83.0
 ...
*/

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/


 Obs from CLASS total obs=2 02JAN2022:10:54:19

 STUDENTS    SEX    SEXCNT    STDEVWGT    MINWGT    MAXWGT

    19        F        3       31.0483     50.5      112.5
    19        M        3        9.2511     83.0       99.5

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/
* this solution uses c:/temp to store objects;


proc datasets lib=work kill;
run;quit;

%utlfkil(c:/temp/class.xpt);

%utl_pybegin39;
parmcards4;
from os import path
import pandas as pd
import xport
import xport.v56
import pyreadstat
import numpy as np
import pandas as pd
from pandasql import sqldf
mysql = lambda q: sqldf(q, globals())
from pandasql import PandaSQL
pdsql = PandaSQL(persist=True)
sqlite3conn = next(pdsql.conn.gen).connection.connection
sqlite3conn.enable_load_extension(True)
sqlite3conn.load_extension('c:/temp/libsqlitefunctions.dll')
mysql = lambda q: sqldf(q, globals())
have, meta = pyreadstat.read_sas7bdat("c:/temp/class.sas7bdat")
print(have);
res = pdsql("""
     select
       (select count(*) from have) as students
      ,SEX
      ,count(*)       as sexCnt
      ,stdev(WEIGHT)  as stdevWgt
      ,min(WEIGHT)    as minWgt
      ,max(WEIGHT)    as maxWgt
     from
       have
     where
       name in ('James', 'Jane', 'Janet', 'Jeffrey', 'John', 'Joyce')
     group
       by SEX
    ;""")
print(res);
ds = xport.Dataset(res, name='CLASS')
with open('c:/temp/class.xpt', 'wb') as f:
    xport.v56.dump(ds, f)
;;;;
%utl_pyend39;

libname pyxpt xport "c:/temp/class.xpt";

proc contents data=pyxpt._all_;
run;quit;

proc print data=pyxpt.class;
run;quit;

data class;
   set pyxpt.class;
run;quit;

/*
 _ __ ___   __ _  ___ _ __ ___  ___
| `_ ` _ \ / _` |/ __| `__/ _ \/ __|
| | | | | | (_| | (__| | | (_) \__ \
|_| |_| |_|\__,_|\___|_|  \___/|___/

*/

/* as a side note
   This algorithm is less flexible then macro 'utl_submit_p64' maily because
   of the difficutlty in operatng on the code after parmcards.
   Macro variables are not resoved and it you want to use create
   global system environment variables to pass text the parmcards
   you need admin priviliges. May be able to use existing global system variables.
*/

%macro utl_pybegin39;

%utlfkil(c:/temp/py_pgm.py);
%utlfkil(c:/temp/py_pgm.log);
%utlfkil(c:/temp/example.xpt);
filename ft15f001 "c:/temp/py_pgm.py";

%mend utl_pybegin39;

%macro utl_pyend39;
run;quit;

* EXECUTE THE PYTHON PROGRAM;
options noxwait noxsync;
filename rut pipe  "c:\Python39\python.exe c:/temp/py_pgm.py 2> c:/temp/py_pgm.log";
run;quit;

data _null_;
  file print;
  infile rut;
  input;
  put _infile_;
  putlog _infile_;
run;quit;

data _null_;
  infile " c:/temp/py_pgm.log";
  input;
  putlog _infile_;
run;quit;

%mend utl_pyend39;
/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/
2648  %utlfkil(c:/temp/res.xpt);
MLOGIC(UTLFKIL):  Beginning execution.
MLOGIC(UTLFKIL):  Parameter UTLFKIL has value c:/temp/res.xpt
MLOGIC(UTLFKIL):  %LOCAL  URC
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable UTLFKIL resolves to c:/temp/res.xpt
SYMBOLGEN:  Macro variable URC resolves to 0
SYMBOLGEN:  Macro variable FNAME resolves to #LN00585
MLOGIC(UTLFKIL):  %IF condition &urc = 0 and %sysfunc(fexist(&fname)) is TRUE
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable FNAME resolves to #LN00585
MLOGIC(UTLFKIL):  %LET (variable name is URC)
MPRINT(UTLFKIL):   run;
MLOGIC(UTLFKIL):  Ending execution.
2649  %utl_pybegin39;
MLOGIC(UTL_PYBEGIN39):  Beginning execution.
MLOGIC(UTLFKIL):  Beginning execution.
MLOGIC(UTLFKIL):  Parameter UTLFKIL has value c:/temp/py_pgm.py
MLOGIC(UTLFKIL):  %LOCAL  URC
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable UTLFKIL resolves to c:/temp/py_pgm.py
SYMBOLGEN:  Macro variable URC resolves to 0
SYMBOLGEN:  Macro variable FNAME resolves to #LN00586
MLOGIC(UTLFKIL):  %IF condition &urc = 0 and %sysfunc(fexist(&fname)) is TRUE
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable FNAME resolves to #LN00586
MLOGIC(UTLFKIL):  %LET (variable name is URC)
MPRINT(UTLFKIL):   run;
MLOGIC(UTLFKIL):  Ending execution.
MPRINT(UTL_PYBEGIN39):  ;
MLOGIC(UTLFKIL):  Beginning execution.
MLOGIC(UTLFKIL):  Parameter UTLFKIL has value c:/temp/py_pgm.log
MLOGIC(UTLFKIL):  %LOCAL  URC
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable UTLFKIL resolves to c:/temp/py_pgm.log
SYMBOLGEN:  Macro variable URC resolves to 0
SYMBOLGEN:  Macro variable FNAME resolves to #LN00587
MLOGIC(UTLFKIL):  %IF condition &urc = 0 and %sysfunc(fexist(&fname)) is TRUE
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable FNAME resolves to #LN00587
MLOGIC(UTLFKIL):  %LET (variable name is URC)
MPRINT(UTLFKIL):   run;
MLOGIC(UTLFKIL):  Ending execution.
MPRINT(UTL_PYBEGIN39):  ;
MLOGIC(UTLFKIL):  Beginning execution.
MLOGIC(UTLFKIL):  Parameter UTLFKIL has value c:/temp/example.xpt
MLOGIC(UTLFKIL):  %LOCAL  URC
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable UTLFKIL resolves to c:/temp/example.xpt
SYMBOLGEN:  Macro variable URC resolves to 0
SYMBOLGEN:  Macro variable FNAME resolves to #LN00588
MLOGIC(UTLFKIL):  %IF condition &urc = 0 and %sysfunc(fexist(&fname)) is FALSE
MLOGIC(UTLFKIL):  %LET (variable name is URC)
MPRINT(UTLFKIL):   run;
MLOGIC(UTLFKIL):  Ending execution.
MPRINT(UTL_PYBEGIN39):  ;
MPRINT(UTL_PYBEGIN39):   filename ft15f001 "c:/temp/py_pgm.py";
MLOGIC(UTL_PYBEGIN39):  Ending execution.
2650  parmcards4;
2688  ;;;;

2689  %utl_pyend39;
MLOGIC(UTL_PYEND39):  Beginning execution.
MPRINT(UTL_PYEND39):   run;
MPRINT(UTL_PYEND39):  quit;
MPRINT(UTL_PYEND39):   * EXECUTE THE PYTHON PROGRAM;
MPRINT(UTL_PYEND39):   options noxwait noxsync;
MPRINT(UTL_PYEND39):   filename rut pipe "c:\Python39\python.exe c:/temp/py_pgm.py 2> c:/temp/py_pgm.log";
MPRINT(UTL_PYEND39):   run;
MPRINT(UTL_PYEND39):  quit;
MPRINT(UTL_PYEND39):   data _null_;
MPRINT(UTL_PYEND39):   file print;
MPRINT(UTL_PYEND39):   infile rut;
MPRINT(UTL_PYEND39):   input;
MPRINT(UTL_PYEND39):   put _infile_;
MPRINT(UTL_PYEND39):   putlog _infile_;
MPRINT(UTL_PYEND39):   run;

NOTE: The infile RUT is:
      Unnamed Pipe Access Device,
      PROCESS=c:\Python39\python.exe c:/temp/py_pgm.py 2> c:/temp/py_pgm.log,
      RECFM=V,LRECL=384

       NAME SEX   AGE  HEIGHT  WEIGHT
0    Alfred   M  14.0    69.0   112.5
1     Alice   F  13.0    56.5    84.0
2   Barbara   F  13.0    65.3    98.0
3     Carol   F  14.0    62.8   102.5
4     Henry   M  14.0    63.5   102.5
5     James   M  12.0    57.3    83.0
6      Jane   F  12.0    59.8    84.5
7     Janet   F  15.0    62.5   112.5
8   Jeffrey   M  13.0    62.5    84.0
9      John   M  12.0    59.0    99.5
10    Joyce   F  11.0    51.3    50.5
11     Judy   F  14.0    64.3    90.0
12   Louise   F  12.0    56.3    77.0
13     Mary   F  15.0    66.5   112.0
14   Philip   M  16.0    72.0   150.0
15   Robert   M  12.0    64.8   128.0
16   Ronald   M  15.0    67.0   133.0
17   Thomas   M  11.0    57.5    85.0
18  William   M  15.0    66.5   112.0
   students SEX  sexCnt   stdevWgt  minWgt  maxWgt
0        19   F       3  31.048349    50.5   112.5
1        19   M       3   9.251126    83.0    99.5
NOTE: 23 lines were written to file PRINT.
NOTE: 23 records were read from the infile RUT.
      The minimum record length was 37.
      The maximum record length was 50.
NOTE: DATA statement used (Total process time):
      real time           1.81 seconds
      user cpu time       0.06 seconds
      system cpu time     0.10 seconds
      memory              329.43k
      OS Memory           19192.00k
      Timestamp           01/02/2022 10:46:20 AM
      Step Count                        318  Switch Count  0


MPRINT(UTL_PYEND39):  quit;
MPRINT(UTL_PYEND39):   data _null_;
MPRINT(UTL_PYEND39):   infile " c:/temp/py_pgm.log";
MPRINT(UTL_PYEND39):   input;
MPRINT(UTL_PYEND39):   putlog _infile_;
MPRINT(UTL_PYEND39):   run;

NOTE: The infile " c:/temp/py_pgm.log" is:
      Filename=c:\temp\py_pgm.log,
      RECFM=V,LRECL=384,File Size (bytes)=350,
      Last Modified=02Jan2022:10:46:20,
      Create Time=02Jan2022:08:21:16

c:\Python39\lib\site-packages\xport\v56.py:635: UserWarning: Converting column dtypes {'students': 'float', 'SEX': 'string', 'sexCnt': 'float'}
  warnings.warn(f'Converting column dtypes {conversions}')
Converting column 'students' from int64 to float
Converting column 'SEX' from object to string
Converting column 'sexCnt' from int64 to float
NOTE: 5 records were read from the infile " c:/temp/py_pgm.log".
      The minimum record length was 45.
      The maximum record length was 143.
NOTE: DATA statement used (Total process time):
      real time           0.04 seconds
      user cpu time       0.00 seconds
      system cpu time     0.04 seconds
      memory              315.31k
      OS Memory           19192.00k
      Timestamp           01/02/2022 10:46:20 AM
      Step Count                        319  Switch Count  0


MPRINT(UTL_PYEND39):  quit;


















































































































































































































































    libname pyxpt xport "c:/temp/res.xpt";

    proc contents data=pyxpt._all_;
    run;quit;


    proc print data=pyxpt.sasdata;
    run;quit;

    ds = xport.Dataset(df)
    with open('c:/temp/example.xpt', 'wb') as f:
        f:xport.from_columns(ds,f)
    print(df)
    ;;;;
    run;quit;

    * EXECUTE THE PYTHON PROGRAM;
    options noxwait noxsync;
    filename rut pipe  "c:\Python39\python.exe c:/temp/py_pgm.py 2> c:/temp/py_pgm.log";
    run;quit;

    data _null_;
      file print;
      infile rut;
      input;
      put _infile_;
      putlog _infile_;
    run;quit;

    libname pyxpt xport "c:/temp/res.xpt";

    proc contents data=pyxpt._all_;
    run;quit;

    proc print data=pyxpt.sasdata;
    run;quit;



ds = xport.Dataset(df, name='MAX8CHRS', label='Up to 40!')






















https://raw.githubusercontent.com/rogerjdeangelis/utl-sqlite-processing-in-python-with-added-math-and-stat-functions/main/libsqlitefunctions.txt

%utl_submit_py64('
import base64;
data = open("d:/sqlite/libsqlitefunctions.dll", "rb").read();
encoded = base64.b64encode(data);
with open("d:/txt/libsqlitefunctions.txt", "wb") as f:;
.    f.write(encoded);
with open("c", "rb") as g:;
.    b64encode_from_file=g.read();
decoded=base64.b64decode(b64encode_from_file);
with open("c:/temp/libsqlitefunctions.txt", "wb") as w:;
.    w.write(decoded);
');

%utl_submit_py64_39('
import base64;
.    f.write(encoded);
with open("https://tinyurl.com/mvez3ykc", "rb") as g:;
decoded=base64.b64decode(b64encode_from_file);
with open("c:/temp/libsqlitefunctions.dll", "wb") as w:;
.    w.write(decoded);
');

%utl_submit_py64_39('
import base64;
import wget;
url = "https://tinyurl.com/mvez3ykc";
wget.download(url, "d:/txt/libsqlitefunctions.txt");
decoded=base64.b64decode("d:/txt/libsqlitefunctions.txt");
with open("d:/txt/libsqlitefunctions.dll", "wb") as w:;
.    w.write(decoded);
');

          %end;%mend;;;;;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;



             libsqlitefunctions.txt


 import requests
fylurl = "http://codex.cs.yale.edu/avi/db-book/db4/slide-dir/ch1-2.pdf"

r = requests.get(file_url, stream = True)

with open("python.pdf","wb") as pdf:
    for chunk in r.iter_content(chunk_size=1024):

         # writing one chunk at a time to pdf file
         if chunk:
             pdf.write(chunk)

               %end;%mend;;;;;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;

%inc "c:/oto/utl_submit_py64_39.sas";

%utl_submit_py64_39('
import base64;
import wget;
image_64_encode =wget.download(url, "d:/txt/libsqlitefunctions.txt");
image_64_decode = base64.decodestring(image_64_encode);
image_result = open("d:/txt/libsqlitefunctions.dll", "wb");
image_result.write(image_64_decode);
');

%utl_pybegin39;
parmcards4;
import base64
import wget
f='https://raw.githubusercontent.com/rogerjdeangelis/utl-sqlite-processing-in-python-with-added-math-and-stat-functions/main/libsqlitefunctions.txt'
b64encode_from_file = wget.download (f)
decoded=base64.b64decode(b64encode_from_file)
with open("c:/temp/libsqlitefunctions.dll", "wb") as w:
     w.write(decoded);
;;;;
%utl_pyend39;

image_64_decode = base64.decodestring(image_64_encode)
image_result = open("d:/txt/libsqlitefunctions.dll", "wb")
image_result.write(image_64_decode);
;;;;


3 Simple Ways to Download Files With Python | by Zack West | Better Programming


%utl_pybegin39;
parmcards4;
import base64
import requests
remote_url='https://raw.githubusercontent.com/rogerjdeangelis/utl-sqlite-processing-in-python-with-added-math-and-stat-functions/main/libsqlitefunctions.txt'
local_file = 'c:/temp/req.txt'
data = requests.get(remote_url)
with open(local_file, 'wb')as file:
     file.write(data.content)
decoded=base64.b64decode('c:/temp/req.txt')
with open("c:/temp/libsqlitefunctions.dll", "wb") as w:
     w.write(decoded);
;;;;
%utl_pyend39;
























               %end;%mend;;;;;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;



%utl_submit_py64_39('
import base64;
data = open("d:/sqlite/libsqlitefunctions.dll", "rb").read();
encoded = base64.b64encode(data);
with open("d:/txt/libsqlitefunctions.txt", "wb") as f:;
.    f.write(encoded);
with open("d:/txt/libsqlitefunctions.txt", "rb") as g:;
.    b64encode_from_file=g.read();
decoded=base64.b64decode(b64encode_from_file);
with open("d:/txt/libsqlitefunctions.dll", "wb") as w:;
.    w.write(decoded);
');


%utl_submit_py64_39('
import base64;
with open("c:/temp/libsqlitefunctions.txt", "rb") as g:;
.    b64encode_from_file=g.read();
decoded=base64.b64decode(b64encode_from_file);
with open("c:/temp/libsqlitefunctions.dll", "wb") as w:;
.    w.write(decoded);
');


%utl_submit_py64_39('
import base64;
with open("https://tinyurl.com/mvez3ykc", "rb") as g:;
.    b64encode_from_file=g.read();
decoded=base64.b64decode(b64encode_from_file);
with open("c:/temp/libsqlitefunctions.dll", "wb") as w:;
.    w.write(decoded);
');













import os
from dotenv import load_dotenv
load_dotenv()
MY_ENV_VAR = os.getenv('MY_ENV_VAR')


















proc means data=sd1.class(where=(
  name in ('James', 'Jane', 'Janet', 'Jeffrey', 'John', 'Joyce')));
class sex;
run;quit;

filename ft15f001 "c:/temp/py_pgm.py";
parmcards4;
from os import path
import pandas as pd
import pyreadstat
import numpy as np
from pandasql import sqldf
mysql = lambda q: sqldf(q, globals())
from pandasql import PandaSQL
pdsql = PandaSQL(persist=True)
sqlite3conn = next(pdsql.conn.gen).connection.connection
sqlite3conn.enable_load_extension(True)
sqlite3conn.load_extension('d:/sqlite/libsqlitefunctions.dll')
mysql = lambda q: sqldf(q, globals())
have, meta = pyreadstat.read_sas7bdat("d:/sd1/class.sas7bdat")
print(have);
res = pdsql("""
     select
       (select count(*) from have) as students
      ,SEX
      ,count(*)       as sexCnt
      ,stdev(WEIGHT)  as stdevWgt
      ,min(WEIGHT)    as minWgt
      ,max(WEIGHT)    as maxWgt
    from
       have
    where
       name in ('James', 'Jane', 'Janet', 'Jeffrey', 'John', 'Joyce')
    group
       by SEX
    ;""")
print(res)
res=pdsql("select sqrt(16);")
print(res);
;;;;
%py_end;


* Note Python sql sqlite does nor support many crucial
math and stat functions.


%utl_submit_py64('
import base64;
data = open("d:/sqlite/libsqlitefunctions.dll", "rb").read();
encoded = base64.b64encode(data);
with open("d:/txt/libsqlitefunctions.txt", "wb") as f:;
.    f.write(encoded);
');
with open("d:/txt/class_encode.txt", "rb") as g:;
.    b64encode_from_file=g.read();
decoded=base64.b64decode(b64encode_from_file);
with open("d:/xls/class_decode.xlsx", "wb") as w:;
.    w.write(decoded);
');

To add these functions you need to download this base64 encoded file

 libsqlitefunctions.b64 and

decode it into

c:/temp/libsqlitefunctions.dll

This code will do that for you

















Possible issues when creating sas xport files from python

GitHub
https://tinyurl.com/2p8dzn7n
https://github.com/rogerjdeangelis/utl-possible-issues-when-creating-sas-xport-files-from-python

/*
 ___ _   _ _ __ ___  _ __ ___   __ _ _ __ _   _
/ __| | | | `_ ` _ \| `_ ` _ \ / _` | `__| | | |
\__ \ |_| | | | | | | | | | | | (_| | |  | |_| |
|___/\__,_|_| |_| |_|_| |_| |_|\__,_|_|   \__, |
                                          |___/
*/

Thre appears to be an issue with the V56 xport files created
by the Python xport package(and pyreadstat).

Platform: SAS 9.4M7 Python 3.9 and Win`0 64bit

Gregory Warnes R SASxport is rock solid and more flexible.

I suspect the same issue exits with pyreadstat. I could not import using either package.

Here is a comparison of the differences between a python xport file
and a sas created xport file with the same data


  From _    Record    80 byte Card
                      ........................XXX.....XXXXXXXX...................................XX..X
  SAS          2      SAS     SAS     SASLIB  9.4     X64_10PR                        30DEC21:09:48:27
  PYTHON       2      SAS     SAS     SASLIB                                          30DEC21:09:36:25


                      ........XXXXXXX.........XXX.....XXXXXXXX...................................XX..X
  SAS          6      SAS     SASDATA SASDATA 9.4     X64_10PR                        30DEC21:09:48:27
  PYTHON       6      SAS             SASDATA                                         30DEC21:09:36:25

The python xport file can be fixed by slugging the SAS record in python records 2 and 6.
If I subsitute the SAS card for the python card

Here is some code that corrects the Python xport file

%macro utl_xptFix(fyl);
filename pyx "c:/temp/example.xpt" lrecl=80 recfm=f;
filename pyfix "c:/temp/examplefix.xpt" lrecl=80 recfm=f;
data _null_;
  infile pyx;
  input lyn $char80.;
  select(_n_);
     when(2) substr(lyn,1,40)='SAS     SAS     SASLIB  9.4     X64_10PR';
     when(6) substr(lyn,1,40)='SAS     SASDATA SASDATA 9.4     X64_10PR';
     otherwise;
  end;
  file pyfix;
  put lyn $char80.;
run;quit;
%mend utl_xptFix;

proc fslist file=pyfix;
run;quit;

/*                 _           _
  __ _ _ __   __ _| |_   _ ___(_)___
 / _` | `_ \ / _` | | | | / __| / __|
| (_| | | | | (_| | | |_| \__ \ \__ \
 \__,_|_| |_|\__,_|_|\__, |___/_|___/
     _               |___/ _                                   _   _
  __| |_ __ ___  _ __   __| | _____      ___ __    _ __  _   _| |_| |__   ___  _ __
 / _` | `__/ _ \| `_ \ / _` |/ _ \ \ /\ / / `_ \  | `_ \| | | | __| `_ \ / _ \| `_ \
| (_| | | | (_) | |_) | (_| | (_) \ V  V /| | | | | |_) | |_| | |_| | | | (_) | | | |
 \__,_|_|  \___/| .__/ \__,_|\___/ \_/\_/ |_| |_| | .__/ \__, |\__|_| |_|\___/|_| |_|
                |_|                               |_|    |___/
*/

/*__ _
 / _(_)_  __
| |_| \ \/ /
|  _| |>  <
|_| |_/_/\_\

*/
* create python v5 trasport file;

proc datasets lib=work kill;
run;quit;

%utlfkil(c:/temp/py_pgm.py);
%utlfkil(c:/temp/py_pgm.log);
%utlfkil(c:/temp/example.xpt);

filename ft15f001 "c:/temp/py_pgm.py";
parmcards4;
import xport.v56
import pandas as pd;
df = pd.DataFrame({
    'ALPHA': ['A','B' , 'C'],
    'BETA': ['x', 'y', 'z'],
})
ds = xport.Dataset(df)
with open('c:/temp/example.xpt', 'wb') as f:
    f:xport.from_columns(ds,f)
print(df)
;;;;
run;quit;

* EXECUTE THE PYTHON PROGRAM;
options noxwait noxsync;
filename rut pipe  "c:\Python39\python.exe c:/temp/py_pgm.py 2> c:/temp/py_pgm.log";
run;quit;

data _null_;
  file print;
  infile rut;
  input;
  put _infile_;
  putlog _infile_;
run;quit;

libname pyxpt xport "c:/temp/examplefix.xpt";

proc contents data=pyxpt._all_;
run;quit;

proc print data=pyxpt.sasdata;
run;quit;


    Obs    NAME       SEX    AGE    HEIGHT    WEIGHT

      1    Alfred      M      14     69.0      112.5
      2    Alice       F      13     56.5       84.0
      3    Barbara     F      13     65.3       98.0
      4    Carol       F      14     62.8      102.5
      5    Henry       M      14     63.5      102.5
      6    James       M      12     57.3       83.0
      7    Jane        F      12     59.8       84.5
      8    Janet       F      15     62.5      112.5
      9    Jeffrey     M      13     62.5       84.0
     10    John        M      12     59.0       99.5
     11    Joyce       F      11     51.3       50.5
     12    Judy        F      14     64.3       90.0
     13    Louise      F      12     56.3       77.0
     14    Mary        F      15     66.5      112.0
     15    Philip      M      16     72.0      150.0
     16    Robert      M      12     64.8      128.0
     17    Ronald      M      15     67.0      133.0
     18    Thomas      M      11     57.5       85.0
     19    William     M      15     66.5      112.0


filename ft15f001 "c:/temp/py_pgm.py";
parmcards4;
from os import path
import pandas as pd
import pyreadstat
import numpy as np
from pandasql import sqldf
mysql = lambda q: sqldf(q, globals())
have, meta = pyreadstat.read_sas7bdat("d:/sd1/class.sas7bdat")
have.info()
q = """
     select
       (select count(*) from have) as students
      ,SEX
      ,count(*)       as sexCnt
      ,avg(WEIGHT)    as wgtAvg
      ,min(WEIGHT)    as minWgt
      ,max(WEIGHT)    as maxWgt
    from
       have
    where
       name in ('James', 'Jane', 'Janet', 'Jeffrey', 'John', 'Joyce')
    group
       by SEX
    ;"""
print(mysql(q))
want=mysql(q);
pyreadstat.write_xport(want, "c:/temp/want.xpt")
;;;;
run;quit;
* EXECUTE THE PYTHON PROGRAM;
options noxwait noxsync;
filename rut pipe  "c:\Python39\python.exe c:/temp/py_pgm.py 2> c:/temp/py_pgm.log";

data _null_;
  file print;
  infile rut;
  input;
  put _infile_;
  putlog _infile_;
run;

libname sd1 "d:/sd1";


libname xpt xport "c:/temp/want.xpt";
proc print data=xpt.dataset;
run;quit;

filename ft15f001 "c:/temp/py_pgm.py";
parmcards4;
from os import path
import pandas as pd
import pyreadstat
import numpy as np
from pandasql import sqldf
mysql = lambda q: sqldf(q, globals())
from pandasql import PandaSQL
pdsql = PandaSQL(persist=True)
sqlite3conn = next(pdsql.conn.gen).connection.connection
sqlite3conn.enable_load_extension(True)
sqlite3conn.load_extension('d:/sqlite/libsqlitefunctions.dll')
mysql = lambda q: sqldf(q, globals())
have, meta = pyreadstat.read_sas7bdat("d:/sd1/class.sas7bdat")
have.info()
res=pdsql("select sqrt(16);")
print(res);
;;;;
%py_end;

sashelp.class

proc means data=sd1.class(where=(
  name in ('James', 'Jane', 'Janet', 'Jeffrey', 'John', 'Joyce')));
class sex;
run;quit;

filename ft15f001 "c:/temp/py_pgm.py";
parmcards4;
from os import path
import pandas as pd
import pyreadstat
import numpy as np
from pandasql import sqldf
mysql = lambda q: sqldf(q, globals())
from pandasql import PandaSQL
pdsql = PandaSQL(persist=True)
sqlite3conn = next(pdsql.conn.gen).connection.connection
sqlite3conn.enable_load_extension(True)
sqlite3conn.load_extension('d:/sqlite/libsqlitefunctions.dll')
mysql = lambda q: sqldf(q, globals())
have, meta = pyreadstat.read_sas7bdat("d:/sd1/class.sas7bdat")
print(have);
res = pdsql("""
     select
       (select count(*) from have) as students
      ,SEX
      ,count(*)       as sexCnt
      ,stdev(WEIGHT)  as stdevWgt
      ,min(WEIGHT)    as minWgt
      ,max(WEIGHT)    as maxWgt
    from
       have
    where
       name in ('James', 'Jane', 'Janet', 'Jeffrey', 'John', 'Joyce')
    group
       by SEX
    ;""")
print(res)
res=pdsql("select sqrt(16);")
print(res);
;;;;
%py_end;



https://gitmemory.cn/repo/yhat/pandasql/issues/81





connection.enable_load_extension(True)
cursor.execute('select load_extension("d:/sqlite/libsqlitefunctions.dll");')
have, meta = pyreadstat.read_sas7bdat("d:/sd1/class.sas7bdat")
have.info()
q = """
     select
       (select count(*) from have) as students
      ,SEX
      ,count(*)       as sexCnt
      ,sqrt(WEIGHT)    as wgtAvg
      ,min(WEIGHT)    as minWgt
      ,max(WEIGHT)    as maxWgt
    from
       have
    where
       name in ('James', 'Jane', 'Janet', 'Jeffrey', 'John', 'Joyce')
    group
       by SEX
    ;"""
print(mysql(q))
want=mysql(q);
pyreadstat.write_xport(want, "c:/temp/want.xpt")
;;;;
%py_end;



* EXECUTE THE PYTHON PROGRAM;
options noxwait noxsync;
filename rut pipe  "c:\Python39\python.exe c:/temp/py_pgm.py 2> c:/temp/py_pgm.log";

data _null_;
  file print;
  infile rut;
  input;
  put _infile_;
  putlog _infile_;
run;


libname xpt xport "c:/temp/want.xpt";
proc print data=xpt.dataset;
run;quit;

filename ft15f001 "c:/temp/py_pgm.py";
parmcards4;
from os import path
import pandas as pd
import pyreadstat
import numpy as np
from pandasql import sqldf
x=2;
print(x);
connection.enable_load_extension(True)
cursor.execute('select load_extension("d:/sqlite/libsqlitefunctions.dll");')
mysql = lambda q: sqldf(q, globals())
have, meta = pyreadstat.read_sas7bdat("d:/sd1/class.sas7bdat")
have.info()
q = """
     select
       (select count(*) from have) as students
      ,SEX
      ,count(*)       as sexCnt
      ,avg(WEIGHT)    as wgtAvg
      ,min(WEIGHT)    as minWgt
      ,max(WEIGHT)    as maxWgt
    from
       have
    where
       name in ('James', 'Jane', 'Janet', 'Jeffrey', 'John', 'Joyce')
    group
       by SEX
    ;"""
print(mysql(q))
want=mysql(q);
;;;;
run;quit;
* EXECUTE THE PYTHON PROGRAM;
options noxwait noxsync;
filename rut pipe  "c:\Python39\python.exe c:/temp/py_pgm.py 2> c:/temp/py_pgm.log";

data _null_;
  file print;
  infile rut;
  input;
  put _infile_;
  putlog _infile_;
run;

libname xpt xport "c:/temp/want.xpt";
proc print data=xpt.dataset;
run;quit;

conn.enable_load_extension(True)
conn.load_extension("./json1")

%utl_pybegin;
connection.enable_load_extension(True)
cursor.execute('select load_extension("d:/sqlite/libsqlitefunctions.dll");')










        %end;%mend;;;;;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;

        %end;%mend;;;;;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
%utlopts;
%macro py_begin;
parmcards4;
x=2;
print(x);
connection.enable_load_extension(True)
;;;;
%py_end;

         %end;%mend;;;;;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;


* create temp directory;

%macro py_begin;

%utlfkil(c:/temp/py_pgm.py);
%utlfkil(c:/temp/py_pgm.log);
%utlfkil(c:/temp/example.xpt);
filename ft15f001 "c:/temp/py_pgm.py";

%mend py_begin;

%macro py_end;
run;quit;

* EXECUTE THE PYTHON PROGRAM;
options noxwait noxsync;
filename rut pipe  "c:\Python39\python.exe c:/temp/py_pgm.py 2> c:/temp/py_pgm.log";
run;quit;

data _null_;
  file print;
  infile rut;
  input;
  put _infile_;
  putlog _infile_;
run;quit;

data _null_;
  infile " c:/temp/py_pgm.log";
  input;
  putlog _infile_;
run;quit;

%mend py_end;


data _null_;

   wrkPth = "%sysfunc(pathname(work))";
   wrkPth=translate(wrkPth,'/','\');
   putlog wrkPth=;
   call symputx("wrkPth",wrkPth);

run;quit;

%put &=wrkPth;





























































import pandas as pd
import pyreadstat
df = pd.DataFrame([[1,1],[2,2],[1,3]], columns=['mylabl', 'myord'])
print(df)
pyreadstat.write_xport(df, "c:\temp\df.xpt", table_name="thename")

import pandas as pd
import pyreadstat
df = pd.DataFrame([["Z","Z","Z"],["Z","Z","Z"],["Z","Z","Z"]], columns=['mylabl', 'myord','mytre'])
print(df)
pyreadstat.write_xport(df, "c:/temp/df.xpt")

libname xpt xport "c:/temp/df.xpt";

proc contents data=xpt.DATASET;
run;quit;

data want;
  set xpt.DATASET;
run;quit;

filename e9 "c:\temp\df.xpt" lrecl=80 recfm=f;
proc fslist file=e9;
run;quit;

data DATASET;
  informat mylabl myord mytre $1.;
  input mylabl myord mytre;
cards4;
Z Z Z
Z Z Z
Z Z Z
;;;;
run;quit;

libname xptx xport "c:/temp/dx.xpt";
data xptx.DATASET;
  set DATASET;
run;quit;

filename e9 "c:/temp/dx.xpt" lrecl=80 recfm=f;
proc fslist file=e9;
run;quit;
*
123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
;
