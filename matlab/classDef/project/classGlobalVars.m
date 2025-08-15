classdef classGlobalVars < handle
    %CLASSGLOBALVARS 此处显示有关此类的摘要
    %   此处显示详细说明
    properties
        globalFs;
        globalXlim;
        globalYlim;
        globalUserdata;
    end
    methods(Access = private)               
        function obj=classGlobalVars()
            disp('constrcutor called!');
        end
    end
    methods(Static)
        
        function obj = getInstance()
            persistent localObj;
            if isempty(localObj) || ~isvalid(localObj)
                localObj=classGlobalVars;
            end
            obj=localObj;
        end
    end
end

