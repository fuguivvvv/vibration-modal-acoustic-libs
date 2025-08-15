classdef Square < handle
    properties
        a;
        b;
    end
    
    methods
        function obj=Square(a,b)
            obj.a=a;
            obj.b=b;
        end
     
               
        function draw(obj)
            plot(obj.a,obj.b);
        end
    end
    
    
end