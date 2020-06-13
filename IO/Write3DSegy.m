%% Write a .mat into a segy file

%first set the path to Seismic Lab, then:
presets;

% Call Segyread on a segy with a structure similar to the desired output
% to easily create and populate the headers
seismic = read_segy_file('/Users/xxxx/Opendetectroot/F3.sgy'); 

%load the .mat to export
load('C2.mat');

[ni,nj,nk]=size(C);
fprintf('Cube size i:%i j:%i k:%i\n ',ni,nj,nk);

%imagesc(seismic.traces(:,1:500)); figure;

%% Unforld the 3D cube in a flat structure for SEGY write
for k=1:nk
    for j=1:nj
        seismic.traces(:,(k-1)*nj+j)=C(:,j,k);
    end
end

%imagesc(seismic.traces(:,1:500));

%Apply the lag rather than write 0s in the SEGY for the lag
%Option 1:
%seismic.headers(11,:)=0;
%Option 2 (smaller file):
seismic.first=0;
seismic.last=700;

%% Write the actual file to disk
write_segy_file(seismic,'/Users/xxxx/Opendetectroot/F3-semblance.sgy');
