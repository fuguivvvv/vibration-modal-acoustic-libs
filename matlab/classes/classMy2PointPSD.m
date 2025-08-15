classdef classMy2PointPSD<handle
    
    properties
        F1=0;
        F2=0;
        W1=0;
        W2=0;
        dB=0
        rms=0;
    end
    methods
        
        function obj=classMy2PointPSD(F1,F2,W1,W2,dB)
            obj.F1=F1;
            obj.F2=F2;
            obj.W1=W1;
            obj.W2=W2;
            
            switch nargin
                case 5
                    obj.dB=dB;
                    
                    if F1=='?'& F2~='?' & W1~='?'& W2~='?' & dB~='?'
                        obj.F1=F2*2^(-10/dB*log10(W2/W1));
                    elseif F1~='?'& F2=='?' & W1~='?'& W2~='?' & dB~='?'
                        obj.F2=F1*2^(10/dB*log10(W2/W1));
                    elseif F1~='?'& F2~='?' & W1=='?'& W2~='?' & dB~='?'
                        obj.W1=W2*10^((-1)*log2(F2/F1)*dB/10);
                    elseif F1~='?'& F2~='?' & W1~='?'& W2=='?' & dB~='?'
                        obj.W2=W1*10^(log2(F2/F1)*dB/10);
                    elseif F1~='?'& F2~='?' & W1~='?'& W2~='?' & dB=='?'
                        obj.dB=10*log10(W2/W1)/log2(F2/F1);
                    else
                        msgbox '输入参数有错误！';
                    end
                    
                    
                case 4
                    
                    obj.dB=10*log10(W2/W1)/log2(F2/F1);
                    
                    m=obj.dB/3;
                    
                    if m >0
                        
                        obj.rms=(obj.W2*obj.F2/(m+1)*(1-(obj.F1/obj.F2)^(m+1)))^0.5;
                        %                 obj.rms2=(obj.W1*obj.F1/(m + 1)*((obj.F2/obj.F1) ^ (m + 1) - 1))^0.5;
                    elseif m<0
                        
                        m=m*(-1);
                        if m~=1 & abs(m-1)>0.05
                            %                             obj.rms=(W1*F1/(m-1)*(1-(F1/F2)^(m-1)))^0.5
                            obj.rms=(obj.W1*obj.F1/(m-1)*(1-(obj.F1/obj.F2)^(m-1)))^0.5;
                            
                        else
                            obj.rms=(2.3*obj.W1*obj.F1*log10(obj.F2/obj.F1))^0.5;
                        end
                    elseif m==0
                        obj.rms=(obj.W2*(obj.F2-obj.F1))^0.5;
                    end
                    
            end
            
        end
        
    end
    
end

