classdef calssMyLog
    %MYLOG �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    properties
        logFilename=[];
        logPath='.\log\';
        fid=0;
    end
    
    methods
        
        function obj = calssMyLog(logFilename)
            obj.logFilename=logFilename;
        end
        
        function [] = writeLog(obj,varargin)
            
            obj.fid = fopen([obj.logPath obj.logFilename],'at');
            fidLoacl=obj.fid;
            %���ļ�����at����ʾ�������ԭ������ĩβ�ķ�ʽд��
            fprintf(fidLoacl,'%s','[');
            fprintf(fidLoacl,'%s',datestr(now,0));
            %��fprintf������д�����ݣ�datestr����������ʽ��ʱ�� 0��ʾʱ���ʽΪ��dd-mmm-yyyy HH:MM:SS
            fprintf(fidLoacl,'%s','] ');
            %  %sָ�������ַ�������ʽ�����\n��ʾ�����Ϻ�س�
            vararginStr{numel(varargin)}=0;
            for i = 1:length(varargin)
                
                switch class(varargin{i})                    
                    case 'char'
                        vararginStr{i}=varargin{i};                        
                    case 'double'
                        vararginStr{i}=num2str(varargin{i});
                    case 'float'
                        vararginStr{i}=num2str(varargin{i});                        
                    case 'int'
                        vararginStr{i}=num2str(varargin{i});                        
                    case 'cell'                                              
                        
                end
                
                fprintf(fidLoacl,'%s',vararginStr{i});
                
%                 if(mod(i,2) == 1)
%                     fprintf(fid,'%s',':');
%                 end
                
%                 if(mod(i,2) == 0)
%                     fprintf(fid,'%s\n',' ');
%                 end
                
            end
            
            fprintf(fidLoacl,'%s\n',';');
            
            fclose(fidLoacl);%��Ҫ���˹ر��ļ�
        end
        
        function []=closeLogFile(obj)
            fclose(obj.fid);%��Ҫ���˹ر��ļ�            
        end
    end
end
