classdef get_all_dir_class < handle
    %      按照规则 查找  reg_str
    properties
        all_dirs={};
        all_fullfiles={}
        all_files={}
    end
    methods
        function  obj=get_all_dir_class(root_dir_name,reg_str)
            % 调用方法，递归求解所有文件
            obj.get_all_dirs_files(root_dir_name);
            %如果输入参数是2个，表示用正则去过滤
            if nargin==2
                obj.all_fullfiles=regexp(obj.all_fullfiles,reg_str,'match');
                % 去空
                obj.all_fullfiles=str_cell_deempty(obj.all_fullfiles);
                
                obj.all_files=regexp(obj.all_files,reg_str,'match');
                %           去空
                obj.all_files=str_cell_deempty(obj.all_files);
                % 解掉一层cell
                obj.all_fullfiles= str_decell(obj.all_fullfiles);
                obj.all_files=str_decell(obj.all_files);
                
            end
            obj.all_fullfiles=obj.all_fullfiles';
            obj.all_files=obj.all_files';
            obj.all_dirs=unique(obj.all_dirs');
        end
        
        function get_all_dirs_files(obj,dir_name)
            obj.all_dirs{end+1}=dir_name;
            dir_truct=dir(dir_name);
            N=length(dir_truct);
            for i=3:N
                full_file_name=fullfile(dir_truct(i).folder,dir_truct(i).name);
                if dir_truct(i).isdir
                    %递归调用 遍历文件
                    obj.all_dirs{end+1}=full_file_name;
                    obj.get_all_dirs_files(full_file_name) ;
                else
                    %递归出口
                    obj.all_fullfiles{end+1}=full_file_name;
                    obj.all_files{end+1}=dir_truct(i).name;
                end
            end
        end
    end
end
