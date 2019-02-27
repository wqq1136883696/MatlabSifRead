% ²âÊÔMatlabSifOpenº¯Êý

clear;clc;

obj = MatlabSifOpen();
obj.GetFileList();
ret1 = obj.fullFilePath;
file1 = obj.fileName;
num1 = obj.sifFileNumber;

% obj.DeleteFile(0,2)
% ret2 = obj.fullFilePath;
% file2 = obj.fileName;
% num2 = obj.sifFileNumber;
% 
obj.AddFileToList(1)
ret3 = obj.fullFilePath;
file3 = obj.fileName;
num3 = obj.sifFileNumber;

