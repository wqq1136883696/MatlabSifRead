classdef MatlabSifOpen < matlab.apps.AppBase
    %MatlabSifOpen ���ļ�����
    %   ʹ��ʱ�ȴ�������
    %   Ȼ��ʹ�ö�����÷�����������
    
    properties (Access  = public)
        filePath               % �ļ�·��
        fileName               % �ļ���
        fullFilePath           % �������ļ���ַ
        sifFileNumber = 0             % �ļ�����
    end
    
    % ˽������
    properties (Access  = private)
        Property2
    end
    
    % ˽�з���
    methods (Access = private)
        function theFullFilePath = GetFullFileName(obj,path,file)
             % ����������ļ�·��
            fileNumber = length(file);
            obj.sifFileNumber = obj.sifFileNumber + fileNumber;
            
            theFullFilePath = strcat(path,file(1));
            % �������һ���ļ���ִ�������б�
            if(fileNumber > 1)
                for i = 2:fileNumber
                    theFullFilePath(i,1) = strcat(path,file(i));
                end
            end
        end
        
        function AddFirstFile(obj)
            % ���б�ͷ����ļ�
            [path,file] = obj.ChooseFile();
            if file ~= "0"
                fileNumber = length(file);

                % ���������µ��б�
                newFileName = file';
                newFullFilePath = strcat(path,file(1));
                % �������һ���ļ���ִ�������б�
                if(fileNumber > 1)
                    for i = 2:fileNumber
                        newFullFilePath(i,1) = strcat(path,file(i));
                    end
                end

                % �Ѿɵ��б�����ݲ��ں���
                newFileName(fileNumber+1:fileNumber+obj.sifFileNumber,1) = obj.fileName;
                newFullFilePath(fileNumber+1:fileNumber+obj.sifFileNumber,1) = obj.fullFilePath;

                % �����б��ֵ������������
                obj.fileName = newFileName;
                obj.fullFilePath = newFullFilePath;

                % �޸��ļ�����
                obj.sifFileNumber = obj.sifFileNumber + fileNumber;
            end
            
        end
        
        function AddLastFile(obj)
            % ���б��β����ļ�
            [path,file] = obj.ChooseFile();
            if file ~= "0"
            
                fileNumber = length(file);            

                % ��ӵ��б�
                for i = 1:fileNumber
                    obj.fileName(obj.sifFileNumber + i,1) = file(i);
                    obj.fullFilePath(obj.sifFileNumber + i,1) = strcat(path,file(i));
                end

                % �޸��ļ�����
                obj.sifFileNumber = obj.sifFileNumber + fileNumber;
            end
        end

            function DeleteCurrentFileFromList(obj,number)
                % DeleteCurrentFileFromList(number)     ���б���ɾ����ǰ�ļ�
                %
                %   ���������ɾ�����ļ����б��е�λ��
                %

                % ���б���ɾ���ļ�
                newFileName = obj.DeleteOneFileFromList(obj.fileName,number);
                newFullFilePath = obj.DeleteOneFileFromList(obj.fullFilePath,number);
                % �����µ��б�
                if number == 2
                    obj.fileName = newFileName';
                    obj.fullFilePath = newFullFilePath';
                else
                    obj.fileName = newFileName;
                    obj.fullFilePath = newFullFilePath;
                end
                % �����б�Ĵ�С
                obj.sifFileNumber = obj.sifFileNumber -1;
        end
        
        function DeleteAllFileFromList(obj)
            % DeleteAllFileFromList()     ���б���ɾ�������ļ�
            %
            
            % �����µ��б�
            obj.fileName = "";
            obj.fullFilePath = "";
            % �����б�Ĵ�С
            obj.sifFileNumber = 0;
        end
        
        
        
    end
    
    
    % ��̬����
    methods (Static)
        function [path,file] = ChooseFile()
            %ChooseFile
            %
            %       ѡ��Ҫ�򿪵��ļ�
            %
            %       ���������path �ļ�·�����ַ�����
            %                file �ļ������ַ������飩
            %               
            
            % Ĭ�ϴ�·��
            rootPath = 'H:\Group_Work\Wyatt_Experiment';
            [cellFile,charPath] = uigetfile('*.sif','Select One or More Files','MultiSelect', 'on',rootPath);
            path = string(charPath);
            file = string(cellFile);
        end
        
        function newList = DeleteOneFileFromList(list,number)
            %
            % DeleteOneFileFromList(list,number)    ɾ��һ��ֵ���б���
            %
%           ��������� list һ���б�
%                      number Ҫɾ����ֵ��λ��
%
%           ��������� �µ��б�
% 
            sizeList = length(list);
            % �ж�ɾ����ֵ�ú�����
            if number < 1
                number = 1;
            elseif number > sizeList
                number = sizeList;
            end  
            % ɾ����λ�õ�ֵ
            newList = list(1:number-1);
            newList(number:sizeList-1) = list(number+1:sizeList); 
        end
        
        function number = StrPositionInList(strList,str)
            % Ѱ��һ���ַ������б��е�λ�ã�����һ����ֵ
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
            
            % �Ҳ����Ļ�����0
            if number > size
                number = 0;
            end
        end
        
    end
    
    
    % ���з���
    methods (Access = public)
        
        function obj = MatlabSifOpen()
            %MatlabSifOpen() ��������ʵ��
            %   
        end
        
        function GetFileList(obj)
            %GetFileList 
            %
            %   ����ļ��б�
            %
            
            [path,file] = obj.ChooseFile();
            if file ~= "0"
                % ȡ���ļ����͵�ַ����������
                obj.filePath = path;
                obj.fileName = file';
                % ����������ļ���
                obj.fullFilePath = obj.GetFullFileName(path,file);
            end
        end
        
        function AddFileToList(obj,position)
            % AddFileToList(position)
            %
            %       �����ļ����б�
            %
            %       ������� ��  0 �����ڿ�ʼλ�ò���
            %                   1 �����ڽ���λ�ò���
            
            if position == 0
               obj.AddFirstFile();
            elseif position == 1
                obj.AddLastFile();
            end
            
        end
        
        function DeleteFile(obj,choose,number)
            % DeleteFile(choose,number)
            %
            %   ɾ���б��ļ���
            %          choose 0 ����ɾ��һ���ļ���
            %                 1 ����ɾ��ȫ���ļ�
            %
            %          number ��ʾɾ����λ��
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

