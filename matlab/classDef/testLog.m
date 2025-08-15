
clc;
clear;
fclose('all');
a=20;
hlog=calssMyLog('mylog.log');
i=1;

while(1)    
    hlog.writeLog('i=',i,'a=', a);
    a=a+2.56;
    i=i+1;
end

