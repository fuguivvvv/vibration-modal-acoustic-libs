function allRms=calRMS_gongShi(f,W)
N=length(f);
allRms=0;
allRms_MianJi=0;

for i=1:N-1
    if f(i)==f(i+1)
        i=i+1;
    else
        a=classMy2PointPSD(f(i),f(i+1),W(i),W(i+1));
        allRms_MianJi=allRms_MianJi+a.rms^2;
        clear a;
    end
    
end

allRms=allRms_MianJi^0.5;