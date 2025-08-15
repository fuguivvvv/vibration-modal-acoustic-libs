function rms=calRms_f(freData,psdData)

rms=sqrt(trapz(freData,psdData));

