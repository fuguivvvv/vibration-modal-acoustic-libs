function P=calP_for_DiQiYa(H)

if H >0 && H <=20
    P=101.33*((288-6.5*H)/288)^5.2558*1000;
elseif H >20
    P=101.33*((304-6.5*H)/304)^5.2558*1000;
end