classdef MatlabSifOpen < matlab.apps.AppBase
    %MatlabSifOpen 打开文件的类
    %   使用时先创建对象
    %   然后使用对象调用方法或者属性
    
    properties (Access  = public)
        filePath               % 文件路径
        fileName               % 文件名
        fullFilePath           % 完整的文件地址
        sifFileNumber = 0             % 文件个数
    end
    
    % 私有属性
    properties (Access  = private)
        Property2
    end
    
    % 私有方法
    methods (Access = private)
        function theFullFilePath = GetFullFileName(obj,path,file)
             % 获得完整的文件路径
            fileNumber = length(file);
            obj.sifFileNumber = obj.sifFileNumber + fileNumber;
            
            theFullFilePath = strcat(path,file(1));
            % 如果多于一个文件，执行生成列表
            if(fileNumber > 1)
                for i = 2:fileNumber
                    theFullFilePath(i,1) = strcat(path,file(i));
                end
            end
        end
        
        function AddFirstFile(obj)
            % 往列表开头添加文件
            [path,file] = obj.ChooseFile();
            if file ~= "0"
                fileNumber = length(file);

                % 生成两个新的列表
                newFileName = file';
                newFullFilePath = strcat(path,file(1));
                % 如果多于一个文件，执行生成列表
                if(fileNumber > 1)
                    for i = 2:fileNumber
                        newFullFilePath(i,1) = strcat(path,file(i));
                    end
                end

                % 把旧的列表的内容插在后面
                newFileName(fileNumber+1:fileNumber+obj.sifFileNumber,1) = obj.fileName;
                newFullFilePath(fileNumber+1:fileNumber+obj.sifFileNumber,1) = obj.fullFilePath;

                % 把新列表的值赋给保存起来
                obj.fileName = newFileName;
                obj.fullFilePath = newFullFilePath;

                % 修改文件个数
                obj.sifFileNumber = obj.sifFileNumber + fileNumber;
            end
            
        end
        
        function AddLastFile(obj)
            % 往列表结尾添加文件
            [path,file] = obj.ChooseFile();
            if file ~= "0"
            
                fileNumber = length(file);            

                % 添加到列表
                for i = 1:fileNumber
                    obj.fileName(obj.sifFileNumber + i,1) = file(i);
                    obj.fullFilePath(obj.sifFileNumber + i,1) = strcat(path,file(i));
                end

                % 修改文件个数
                obj.sifFileNumber = obj.sifFileNumber + fileNumber;
            end
        end

            function DeleteCurrentFileFromList(obj,number)
                % DeleteCurrentFileFromList(number)     从列表中删除当前文件
                %
                %   输入参数：删除的文件在列表中的位置
                %

                % 从列表中删除文件
                newFileName = obj.DeleteOneFileFromList(obj.fileName,number);
                newFullFilePath = obj.DeleteOneFileFromList(obj.fullFilePath,number);
                % 保存新的列表
                if number == 2
                    obj.fileName = newFileName';
                    obj.fullFilePath = newFullFilePath';
                else
                    obj.fileName = newFileName;
                    obj.fullFilePath = newFullFilePath;
                end
                % 更新列表的大小
                obj.sifFileNumber = obj.sifFileNumber -1;
        end
        
        function DeleteAllFileFromList(obj)
            % DeleteAllFileFromList()     从列表中删除所有文件
            %
            
            % 保存新的列表
            obj.fileName = "";
            obj.fullFilePath = "";
            % 更新列表的大小
            obj.sifFileNumber = 0;
        end
        
        
        
    end
    
    
    % 静态方法
    methods (Static)
        function [path,file] = ChooseFile()
            %ChooseFile
            %
            %       选择要打开的文件
            %
            %       输出参数：path 文件路径（字符串）
            %                file 文件名（字符串数组）
            %               
            
            % 默认打开路径
            rootPath = 'H:\Group_Work\Wyatt_Experiment';
            [cellFile,charPath] = uigetfile('*.sif','Select One or More Files','MultiSelect', 'on',rootPath);
            path = string(charPath);
            file = string(cellFile);
        end
        
        function newList = DeleteOneFileFromList(list,number)
            %
            % DeleteOneFileFromList(list,number)    删除一个值从列表中
            %
%           输入参数： list 一个列表
%                      number 要删除的值的位置
%
%           输出参数： 新的列表
% 
            sizeList = length(list);
            % 判断删除的值得合理性
            if number < 1
                number = 1;
            elseif number > sizeList
                number = sizeList;
            end  
            % 删除该位置的值
            newList = list(1:number-1);
            newList(number:sizeList-1) = list(number+1:sizeList); 
        end
        
        function number = StrPositionInList(strList,str)
            % 寻找一个字符串在列表中的位置，返回一个数值
            cellReturn = strfind(strList,str);
            size = length(cellReturn);
            number = 1;
            for i=1:size
               if cellReturn{i}
                   break;
               else
                   number = number + 1;
               end
            end
            
            % 找不到的话返回0
            if number > size
                number = 0;
            end
        end
        
    end
    
    
    % 公有方法
    methods (Access = public)
        
        function obj = MatlabSifOpen()
            %MatlabSifOpen() 构造此类的实例
            %   
        end
        
        function GetFileList(obj)
            %GetFileList 
            %
            %   获得文件列表
            %
            
            [path,file] = obj.ChooseFile();
            if file ~= "0"
                % 取出文件名和地址，保存起来
                obj.filePath = path;
                obj.fileName = file';
                % 获得完整的文件名
                obj.fullFilePath = obj.GetFullFileName(path,file);
            end
        end
        
        function AddFileToList(obj,position)
            % AddFileToList(position)
            %
            %       增加文件到列表
            %
            %       输入参数 ：  0 代表在开始位置插入
            %                   1 代表在结束位置插入
            
            if position == 0
               obj.AddFirstFile();
            elseif position == 1
                obj.AddLastFile();
            end
            
        end
        
        function DeleteFile(obj,choose,number)
            % DeleteFile(choose,number)
            %
            %   删除列表文件：
            %          choose 0 代表删除一个文件，
            %                 1 代表删除全部文件
            %
            %          number 表示删除的位置
            %
            %
            if choose == 0
                if obj.sifFileNumber == 1
                    obj.DeleteAllFileFromList();
                elseif obj.sifFileNumber ~= 0
                    obj.DeleteCurrentFileFromList(number);
                end
            elseif choose == 1
                obj.DeleteAllFileFromList();
            end
            
        end
        
        
              
    end
end

