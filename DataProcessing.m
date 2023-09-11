%% Master Thesis: Data Processing
% Biomechanical analysis of a toss to hands in cheer sport: qualitative and
% quantitative characteristics

% by Katja Korte
% katja.korte@sport.uni-giessen.de / 
% katjakorte@gmx.net

clear
clc
close all

%% LOAD VARIABLES

load("DATA/trajectories.mat")
nTosses = length(flyer.ASIS.x);

ASIS = nan([1953, nTosses]); % 1953 is max data points in all trials
RPSI = ASIS; LPSI = ASIS;

handLeft = nan([1953, nTosses]); handRight = handLeft; 
heelLeft = handLeft; heelRight = handLeft;

for ctr = 1:nTosses
    ASIS(1:length(flyer.ASIS.z{ctr}), ctr) = flyer.ASIS.z{ctr}/1000;
    RPSI(1:length(flyer.RPSI.z{ctr}), ctr) = flyer.RPSI.z{ctr}/1000;
    LPSI(1:length(flyer.LPSI.z{ctr}), ctr) = flyer.LPSI.z{ctr}/1000;

    handLeft(1:length(base.LFIN.z{ctr}), ctr) = base.LFIN.z{ctr}/1000;
    handRight(1:length(base.RFIN.z{ctr}), ctr) = base.RFIN.z{ctr}/1000;
    heelLeft(1:length(flyer.LHEE.z{ctr}), ctr) = flyer.LHEE.z{ctr}/1000;
    heelRight(1:length(flyer.RHEE.z{ctr}), ctr) = flyer.RHEE.z{ctr}/1000;
end



%% interpolate from dip to catch
% BEGINNING Toss:
% lowest point of the hip (markers)

startToss = nan([1, 35]);
idxASIS = startToss; idxRPSI = startToss; idxLPSI = startToss; 
for ctr = 1:nTosses
    idxASIS(ctr) = find(min(ASIS(:, ctr)) == ASIS(:, ctr));
    idxRPSI(ctr) = find(min(RPSI(:, ctr)) == RPSI(:, ctr));
    idxLPSI(ctr) = find(min(LPSI(:, ctr)) == LPSI(:, ctr));
    startToss(ctr) = round(sum([idxASIS(ctr), idxRPSI(ctr), idxLPSI(ctr)]) / 3);
end

% END Toss:
% first frame in which HEE exceeds FIN

endToss = nan([1, 35]);
idxLeft = endToss; idxRight = endToss;
for ctr = 1 : nTosses
    idxLeft(ctr) = find(heelLeft(:, ctr) > handLeft(:, ctr), 1, "first");
    idxRight(ctr) = find(heelRight(:, ctr) > handRight(:, ctr), 1, "first");
    endToss(ctr) = round(sum([idxLeft(ctr), idxRight(ctr)])/ 2);
end

% CUT tosses
for ctrMarker = 1 : length(fieldnames(base))
    markers = fieldnames(base);
    for ctrDim = 1 : 3 %(x, y, z)
        dim = ["x", "y", "z"];
        for ctrTrial = 1 : nTosses
            marker = string(markers(ctrMarker));
            tossesBase.(marker).(dim(ctrDim)){ctrTrial} = base.(marker).(dim(ctrDim)){ctrTrial}(startToss(ctrTrial) : endToss(ctrTrial));          
        end
    end
end

for ctrMarker = 1 : length(fieldnames(flyer))
    markers = fieldnames(flyer);
    for ctrDim = 1 : 3 %(x, y, z)
        dim = ["x", "y", "z"];
        for ctrTrial = 1 : nTosses
            marker = string(markers(ctrMarker));
            tossesFlyer.(marker).(dim(ctrDim)){ctrTrial} = flyer.(marker).(dim(ctrDim)){ctrTrial}(startToss(ctrTrial) : endToss(ctrTrial));
        end
    end
end

% INTERPOLATE to 100/200 frames
markers = fieldnames(base);
for ctrMarker = 1:length(fieldnames(base))
    for ctrDim = 1 : 3 %(x, y, z)
        dim = ["x", "y", "z"];
        for ctrTrial = 1 : nTosses
            marker = string(markers(ctrMarker));
            sample_points = transpose(1 : 1 : length(tossesBase.(marker).(dim(ctrDim)){ctrTrial}));
            sample_values = tossesBase.(marker).(dim(ctrDim)){ctrTrial};
            query_points = transpose(linspace(1, length(sample_points), 201));
            interp = interp1(sample_points, sample_values(:, 1), query_points);

            base.(marker).interp.(dim(ctrDim))(:, ctrTrial) = interp;
        end
    end
end
markers = fieldnames(flyer);
for ctrMarker = 1:length(fieldnames(flyer))
    for ctrDim = 1 : 3 %(x, y, z)
        dim = ["x", "y", "z"];
        for ctrTrial = 1 : nTosses
            marker = string(markers(ctrMarker));
            sample_points = transpose(1 : 1 : length(tossesFlyer.(marker).(dim(ctrDim)){ctrTrial}));
            sample_values = tossesFlyer.(marker).(dim(ctrDim)){ctrTrial};
            query_points = transpose(linspace(1, length(sample_points), 201));
            interp = interp1(sample_points, sample_values(:, 1), query_points);

            flyer.(marker).interp.(dim(ctrDim))(:, ctrTrial) = interp;
        end
    end
end

save("dataProcessed.mat", "flyer", "base", "startToss", "endToss")


%% PLOTS
whichTrial = 24;

% fig1 = figure(1); % view all hip marker trajectories 
%     subplot(3, 1, 1)
%     plot(ASIS)
%     hold on
%     title("ASIS")
%     subplot(3, 1, 2)
%     plot(RPSI)
%     title("RPSI")
%     subplot(3, 1, 3)
%     plot(LPSI)
%     title("LPSI")
%     fig1.Name = "RAW Hip Marker Trajectories Flyer";
% 
% fig2 = figure(2); % test if markers differentiate
%     plot([ASIS(:, whichTrial), RPSI(:, whichTrial), LPSI(:, whichTrial)])
%     hold on
%     plot(idxASIS(whichTrial), ASIS(idxASIS(whichTrial), whichTrial), 'o')
%     legend("ASIS", "RPSI", "LPSI", "minASIS")
%     fig2.Name = "Differences in marker trajectories (one trial)";


% figure(3)   % test hand-heel distance
% for ctr = 1:nTosses
%     fig3 = figure(3);
%     whichTrial = ctr;
%     subplot(5, 7, ctr)
%     plot([handLeft(:, whichTrial), heelLeft(:, whichTrial)])
%     hold on
%     xline(startToss(whichTrial))
%     xline(endToss(whichTrial))
%     fig4 = figure(4);
%     subplot(5, 7, ctr)
%     plot([handRight(:, whichTrial), heelRight(:, whichTrial)])
%     hold on
%     xline(idxRight(whichTrial))
% end
% fig3.Name = "Left Hand - Left Heel";
% fig4.Name = "Right Hand - Right Heel";
 
% % CHECK CUTS
% fig5 = figure(5); % view all CUT hip marker trajectories 
%     subplot(3, 1, 1)
%     for ctr = 1:nTosses
%         plot(tossesFlyer.ASIS.z{ctr}/1000)
%         hold on
%     end
%     title("ASIS")
%     subplot(3, 1, 2)
%     for ctr = 1:nTosses
%         plot(tossesFlyer.RPSI.z{ctr}/1000)
%         hold on
%     end
%     title("RPSI")
%     legend("Location","eastoutside")
%     subplot(3, 1, 3)
%     for ctr = 1:nTosses
%         plot(tossesFlyer.ASIS.z{ctr}/1000)
%         hold on
%     end
%     title("LPSI")
%     fig5.Name = "CUT hip marker trajectories";
    

% for n = 1 : 35
% fig6 = figure(6);
%     subplot(5, 7, n)
%     plot(tossesFlyer.ASIS.z{n})
% end
%     fig6.Name = "Cut tosses";
% 
% % test Interpolation
% t = 0 : 1 : 200;
% fig7 = figure(7);
%     subplot(1, 2, 1)
%     plot(t, flyer.ASIS.interp.z/1000)
%     grid on
%     xlim([0, 200])
%     subplot(1, 2, 2)
%     plot(t, base.RASI.interp.z/1000)
%     grid on
%     xlim([0, 200])
%     fig7.Name = "Test Interpolation: ASIS vs. RASI";

% SORT BY PAIRS
fig8 = figure(8);
t = 0 : 1 : 200;
t01 = plot(t, base.RASI.interp.z(:, 1:5)/1000, "Color", "#0072BD");
hold on
t02 = plot(t, base.RASI.interp.z(:, 6:10)/1000, "Color", "#D95319");
t03 = plot(t, base.RASI.interp.z(:, 11:15)/1000, "Color", "#EDB120");
t04 = plot(t, base.RASI.interp.z(:, 16:20)/1000, "Color", "#7E2F8E");
t05 = plot(t, base.RASI.interp.z(:, 21:25)/1000, "Color", "#77AC30");
t06 = plot(t, base.RASI.interp.z(:, 26:30)/1000, "Color", "#4DBEEE");
t07 = plot(t, base.RASI.interp.z(:, 31:35)/1000, "Color", "#A2142F");
xlim([0, 200])
grid on
set(gca, "TickDir", "both");
xlabel("Time (s)")
ylabel("Height (m)")
legend([t01(1), t02(1), t03(1), t04(1), t05(1), t06(1), t07(1)], ["Alex", "Daniel", "Felix", "Habip", "Jakob", "Mehdi", "Nausi"])


