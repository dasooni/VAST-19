%PRE-PROCESSING
clear
load("MC1\dataFile.mat");

%Conversion to timetable type to utilize MATLAB functions specifically to
%this type.
timetabl = table2timetable(mc1reportsdata);
timetabl = sortrows(timetabl);

% Table of only damage intensity data.
damages = mc1reportsdata(:, ["medical", "sewer_and_water", "power", ...
                "roads_and_bridges", "buildings", "shake_intensity"]);

%Damage types conversion to categorical for plotting purposes.
types = damages.Properties.VariableNames;
types = categorical(types);

numAreas = 1:19;
%% OVERALL DAMAGE ACROSS ALL CATEGORIES AND AREAS
boxplot(damages{:,:}, types);
title('Overall damage intensity by category')
xlabel('Category')
ylabel('Damage intensity')

%% NUMBER OF REPORTS TO APPROX. POPULATION SIZE FOR EACH NEIGHBORHOOD.

numReports = hist(timetabl{:,"location"},numAreas);
out = [numAreas; numReports];

b = bar(numAreas, numReports, 'FaceColor', 'flat');

b.CData = numReports / max(numReports);
%% TAKING A CLOSER LOOK AT THE FORESHOCK, MAINSHOCK AND AFTERSHOCK.

prequake_index = timerange('2020-04-06 14:00:00', '2020-04-07 00:00:00');
mainshock_index = timerange('2020-04-08 07:00:00', '2020-04-09 00:00:00');
aftershock_index = timerange('2020-04-09 11:00:00', '2020-04-10 00:00:00');

prequake_table = timetabl(prequake_index,:);
mainshock_table = timetabl(mainshock_index,:);
aftershock_table = timetabl(aftershock_index,:);

% rolling_prequake_mean = retime(prequake_table(:,"shake_intensity"), ...
%     "hourly","mean");
% rolling_mainshock_mean = retime(mainshock_table(:,"shake_intensity"), ...
%     "hourly","mean");
% rolling_aftershock_mean = retime(aftershock_table(:,"shake_intensity"), ...
%     "hourly","mean");

for i = 1:length(numAreas)
    prequake_rows = prequake_table{:,"location"} == numAreas(i);
    mainshock_rows = mainshock_table{:,"location"} == numAreas(i);
    aftershock_rows = aftershock_table{:,"location"} == numAreas(i);

    rolling_prequake_mean{i} = retime(prequake_table(prequake_rows,"shake_intensity"), "hourly", "mean");
    rolling_prequake_mean{i}.location = repmat(numAreas(i), size(rolling_prequake_mean{i},1),1);

    rolling_mainshock_mean{i} = retime(mainshock_table(mainshock_rows,"shake_intensity"), "hourly", "mean");
    %rolling_mainshock_mean{i}.location = repmat(numAreas(i), size(rolling_mainshock_mean{i},1),1);

    rolling_aftershock_mean{i} = retime(aftershock_table(aftershock_rows,"shake_intensity"), "hourly", "mean");
    rolling_aftershock_mean{i}.location = repmat(numAreas(i), size(rolling_aftershock_mean{i},1),1);
    
end

for j = 1 : length(numAreas)
    rolling_prequake_mean{j} = rmmissing(rolling_prequake_mean{j});
    rolling_mainshock_mean{j} = rmmissing(rolling_mainshock_mean{j});
    rolling_aftershock_mean{j} = rmmissing(rolling_aftershock_mean{j});
end

%rolling_mainshock_mean = sortrows(vertcat(rolling_mainshock_mean{:}));

%stackedplot(rolling_mainshock_mean);
%stackedplot(rolling_aftershock_mean)

plotColors = jet(7);
subplot(3,1,1);
hold on

for k = 1:7
    plot(rolling_mainshock_mean{k}, "shake_intensity", 'Color', plotColors(k,:), 'Marker','o');
end
hold off
legend show
ylim([0 6])

subplot(3,1,2);
hold on
for k = 8:13
    plot(rolling_mainshock_mean{k}, "shake_intensity", 'Color', plotColors(k-7,:), 'Marker','o');
end
hold off
legend show
ylim([0 6])

subplot(3,1,3);
hold on
for k = 14:19
    plot(rolling_mainshock_mean{k}, "shake_intensity", 'Color', plotColors(k-12,:), 'Marker','o');
end
hold off
legend show
ylim([0 6])


