%% Master Thesis: Survey Processing
% Biomechanical analysis of a toss to hands in cheer sport: qualitative and
% quantitative characteristics

% by Katja Korte
% katja.korte@sport.uni-giessen.de / 
% katjakorte@gmx.net

clear
clc
close all

%% LOAD VARIABLES
surveydata = readmatrix("DATA\results-surveyDATA.csv");

% Overall
overall = struct("raw", []);
speed = overall; flow = overall; dip = overall; fbl = overall; bbl = overall;
for ctr = 1 : 6 : length(surveydata)
    overall.raw(:, end +1) = surveydata(:, ctr);
    speed.raw(:, end +1) = surveydata(:, ctr +1);
    flow.raw(:, end +1) = surveydata(:, ctr +2);
    dip.raw(:, end +1) = surveydata(:, ctr +3);
    fbl.raw(:, end +1) = surveydata(:, ctr +4);
    bbl.raw(:, end +1) = surveydata(:, ctr +5);
end


%%
overallBefore = overall;
trialsByPatch = ["AE01", "AE05", "AE06", "HB08", "MO01", "MO04", "NL01", ...
    "AE02", "AE04", "FP02", "FP05", "JH10", "MO05", "NL03", ...
    "DA06", "DA12", "HB01", "HB07", "JH02", "JH11", "NL02", ...
    "DA05", "DA07", "DA09", "FP01", "HB08", "MO02", "MO03", ...
    "FP03", "FP04", "HB05", "JH01", "JH12", "NL04", "NL05"];
[trials, idx] = sort(trialsByPatch);

overall.raw = overall.raw(:, idx);
speed.raw = speed.raw(:, idx);
flow.raw = flow.raw(:, idx);
dip.raw = dip.raw(:, idx);
fbl.raw = fbl.raw(:, idx);
bbl.raw = bbl.raw(:, idx);

for rows = 1:length(overall(:, 1))
    for cols = 1:length(overall(1, :))
        if speed.raw(rows, cols) == 0;  speed.raw(rows, cols) = nan; end
        if flow.raw(rows, cols) == 0;   flow.raw(rows, cols) = nan; end
        if dip.raw(rows, cols) == 0;    dip.raw(rows, cols) = nan;  end
        if fbl.raw(rows, cols) == 0;    fbl.raw(rows, cols) = nan;  end
        if bbl.raw(rows, cols) == 0;    bbl.raw(rows, cols) = nan;  end
    end
end

% FIND MEAN Rating for all tosses
overall.mean = mean(overall.raw, "omitnan");
speed.mean = mean(speed.raw, "omitnan");
flow.mean = mean(flow.raw, "omitnan");
dip.mean = mean(dip.raw, "omitnan");
fbl.mean = mean(fbl.raw, "omitnan");
bbl.mean = mean(bbl.raw, "omitnan");

% get BEST and WORST 5
[overall.sorted(1, :), overall.sorted(2, :)] = sort(overall.mean);
[speed.sorted(1, :), speed.sorted(2, :)] = sort(speed.mean);
[flow.sorted(1, :), flow.sorted(2, :)] = sort(flow.mean);
[dip.sorted(1, :), dip.sorted(2, :)] = sort(dip.mean);
[fbl.sorted(1, :), fbl.sorted(2, :)] = sort(fbl.mean);
[bbl.sorted(1, :), bbl.sorted(2, :)] = sort(bbl.mean);

[~, ~, overall.least] = find(overall.sorted(2, :), 5, "first");
[~, ~, speed.least] = find(speed.sorted(2, :), 5, "first");
[~, ~, flow.least] = find(flow.sorted(2, :), 5, "first");
[~, ~, dip.least] = find(dip.sorted(2, :), 5, "first");
[~, ~, fbl.least] = find(fbl.sorted(2, :), 5, "first");
[~, ~, bbl.least] = find(bbl.sorted(2, :), 5, "first");

[~, ~, overall.best] = find(overall.sorted(2, :), 5, "last");
[~, ~, speed.best] = find(speed.sorted(2, :), 5, "last");
[~, ~, flow.best] = find(flow.sorted(2, :), 5, "last");
[~, ~, dip.best] = find(dip.sorted(2, :), 5, "last");
[~, ~, fbl.best] = find(fbl.sorted(2, :), 5, "last");
[~, ~, bbl.best] = find(bbl.sorted(2, :), 5, "last");


save("surveyData.mat", "bbl", "fbl", "dip", "flow", "speed", "overall", "trials")