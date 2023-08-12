%% Master Thesis: Data Analysis
% Biomechanical analysis of a toss to hands in cheer sport: qualitative and
% quantitative characteristics

% by Katja Korte
% katja.korte@sport.uni-giessen.de

clear
clc

%% LOAD VARIABLES
cd 'C:\Users\katja\OneDrive - Justus-Liebig-Universität Gießen\Uni\M. Sc. Human Movement Analytics\MA-HMA-14 MASTER THESIS\TossThesis\DATA'
files = dir('*.mat');
for i=1:length(files)
    load(files(i).name);
end

ASIS_F = zeros([1113, 4]);
for ctr = 1:4
    ASIS_F(1:length(eval(strcat("NL0", string(ctr),".ASIS_F"))), ctr) = eval(strcat("NL0", string(ctr),".ASIS_F"));
end

plot(ASIS_F)


%% 