classdef calssTest<handle
    %   ���� ���� ʱ�����ߺ�dB
    %   Detailed explanation goes here
    properties
        x=0;
        t=0;
        
        
    end
    methods
        function obj=calssTest(x,t)
            
            obj.x=x;
            obj.t=t;
            
            
        end
        function draw(obj,b)
            plot(obj.t,obj.x);
            obj.x+b
            
        end
        
    end
end