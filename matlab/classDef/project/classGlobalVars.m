classdef classGlobalVars < handle
    %CLASSGLOBALVARS �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
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

