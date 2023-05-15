load("MC1\dataFile.mat");

damages = mc1reportsdata(:, ["medical", "sewer_and_water", "power", "roads_and_bridges", "buildings", "shake_intensity"]);


types = damages.Properties.VariableNames;
types = categorical(types);
boxplot(damages{:,:}, types);
title('Overall damage intensity by category')
xlabel('Category')
ylabel('Damage intensity')
%%


