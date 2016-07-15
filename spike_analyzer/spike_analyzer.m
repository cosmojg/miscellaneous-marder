% Need help with this script? Ask Cosmo! :)
% But if it's something to do with Spike2, ask Jess or someone else.
% I don't know anything about that stuff.

% SET THE INSTFREQ THRESHOLD FOR SPIKE CLUSTERS
% (All spikes with instFreq < threshold will be classified as a cluster.)
threshold = 5;

% SET THE NAME OF THE INPUT SPIKES FILE
spikein = 'spikes.txt';

% SET THE NAME OF THE OUTPUT SPIKES FILE
spikeout = 'spike_data.txt';

% SET THE NAME OF THE OUTPUT CLUSTERS FILE
clustout = 'spike_cluster_data.txt';

% Read the file and store its contents in a cell array split every line
rawdata = fileread(spikein);
rawarr = strsplit(rawdata, '\n');

% Check if default headings were included
start = 1;
if rawarr{1}(1) == 'S'
    start = 2;
end

% Sort the spike data based on whether it's in a spike cluster
spikearr = {}; % Between spikes within clusters
clustarr = {}; % Between clusters

% Loop through rawarr and split every comma
for n = start:length(rawarr)
    splitup = strsplit(rawarr{n}, ',');
    
    % Convert chars to doubles
    for nn = 1:length(splitup)
        splitup{nn} = str2double(splitup{nn});
    end
    
    % Check if instFreq is below threshold and sort accordingly
    if splitup{4} < threshold
        clustarr{length(clustarr) + 1} = cell2mat(splitup);
    else
        spikearr{length(spikearr) + 1} = cell2mat(splitup);
    end
end

% Set up temporary values for mean and standard deviation calculation
% I'm sorry about the mess; I couldn't think of a better way to do it.
spiketime = 1:length(spikearr);
corrspiketime = 1:length(spikearr);
isi = 1:length(spikearr);
instfreq = 1:length(spikearr);

% Calculate and store means and standard deviations for spike data
spikemeans = 1:4;
spikestds = 1:4;
for n = 1:length(spikearr) % Loop through spikearr and organize values
    spiketime(n) = spikearr{n}(1);
    corrspiketime(n) = spikearr{n}(2);
    isi(n) = spikearr{n}(3);
    instfreq(n) = spikearr{n}(4);
end
spikemeans(1) = mean(spiketime);
spikestds(1) = std(spiketime);
spikemeans(2) = mean(corrspiketime);
spikestds(2) = std(corrspiketime);
spikemeans(3) = mean(isi);
spikestds(3) = std(isi);
spikemeans(4) = mean(instfreq);
spikestds(4) = std(instfreq);

% Calculate and store means and standard deviations for cluster data
clustmeans = 1:4;
cluststds = 1:4;
for n = 1:length(clustarr) % Loop through clustarr and organize values
    spiketime(n) = clustarr{n}(1);
    corrspiketime(n) = clustarr{n}(2);
    isi(n) = clustarr{n}(3);
    instfreq(n) = clustarr{n}(4);
end
clustmeans(1) = mean(spiketime);
cluststds(1) = std(spiketime);
clustmeans(2) = mean(corrspiketime);
cluststds(2) = std(corrspiketime);
clustmeans(3) = mean(isi);
cluststds(3) = std(isi);
clustmeans(4) = mean(instfreq);
cluststds(4) = std(instfreq);

% Output all spike data to a text file
fileID = fopen(spikeout, 'w');
fprintf(fileID, '%20s %20s %20s %20s\r\n', 'Spiketime[s]', 'corrSpiketime[s]', 'ISI', 'instFreq');
for n = 1:length(spikearr)
    fprintf(fileID, '%20f %20f %20f %20f\r\n', spikearr{n});
end
fprintf(fileID, '\r\n%s\r\n', 'MEANS:');
fprintf(fileID, '%20f %20f %20f %20f\r\n', spikemeans);
fprintf(fileID, '\r\n%s\r\n', 'STANDARD DEVIATIONS:');
fprintf(fileID, '%20f %20f %20f %20f\r\n', spikestds);
fclose(fileID);

% Output all cluster data to a separate text file
fileID = fopen(clustout, 'w');
fprintf(fileID, '%20s %20s %20s %20s\r\n', 'Spiketime[s]', 'corrSpiketime[s]', 'ISI', 'instFreq');
for n = 1:length(clustarr)
    fprintf(fileID, '%20f %20f %20f %20f\r\n', clustarr{n});
end
fprintf(fileID, '\r\n%s\r\n', 'MEANS:');
fprintf(fileID, '%20f %20f %20f %20f\r\n', clustmeans);
fprintf(fileID, '\r\n%s\r\n', 'STANDARD DEVIATIONS:');
fprintf(fileID, '%20f %20f %20f %20f\r\n', cluststds);
fclose(fileID);

% Debugging
disp(length(spikearr));
disp(length(clustarr));
disp(length(rawarr));
