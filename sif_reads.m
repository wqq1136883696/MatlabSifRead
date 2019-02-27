%读取sif文件，保存成asc文件
clear;
clc;
path = 'H:\Group_Work\Wyatt_Experiment\Adjust_the_collection_light_path\Three_Lenses.sif';
path1 = 'H:\Group_Work\Wyatt_Experiment\Raman_Spectroscopy\20181207\Si.sif';
[pattern,calibvals,data] = read_sif(path1);