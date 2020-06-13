%% Compute the instantaneous enveloppe, phase and frequency on a 3D cube
% Synopsis: [AS,IE,IP,IF]=instantaneous_attribut(S);
% AS: Analytic Signal
% IE: Instantaneous Envelop
% IP: Instantaneous Phase
% IF: Instantaneous Frequency
function [AS,IE,IP,IF]=instantaneous_attribut(S)
%% Load the 3D seismic cube
%load('S');
[ni,nj,nk]=size(S);

AS=zeros(size(S)); % create a cube to host the Analytic Signal
IE=zeros(size(S)); % create a cube to host the Instantaneous Envelop
IP=zeros(size(S)); % create a cube to host the Instantaneous Phase

%% For each trace in the cube
for j=1:nj
    fprintf('At position j=%i -------------------------------------\n',j);
    for k=1:nk
    %fprintf('At position j=%i k=%i\n',j,k);
    AS(:,j,k)=hilbert(S(:,j,k));%analytic signal
    IE(:,j,k)=abs(AS(:,j,k));%magnitude of the analytic signal
    IP(:,j,k)=unwrap(angle(AS(:,j,k)));%phase of the analytic signal
    end
end

% Diff calculate the differental along the first non 1 dimension
% also the result of diff has a dimension of n-1
% although this does work in cases, it is not a stable way to calculate
% differentials in case of noise.
IF=[ni-1,nj,nk]; % create a cube to host the Instantaneous Frequency
IF=diff(IP);% first time derivative of the phase
