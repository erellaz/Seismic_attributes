%% Compute the instantaneous dip on a 3D cube
function [p,q,s]=instantaneous_dip(S)
%% Load the 3D seismic cube
[ni,nj,nk]=size(S);

AS=zeros(size(S)); % create a cube for the Analytic Signal
IP=zeros(size(S)); % create a cube for the Instantaneous Phase


ky=zeros(size(S)); % create a cube for the Instantaneous wave number along y

%% For each trace in the cube, compute the Analytic Signal and Instantaneous Phase
for j=1:nj
    for k=1:nk
    AS(:,j,k)=hilbert(S(:,j,k));% analytic signal
    IP(:,j,k)=unwrap(angle(AS(:,j,k)));% instantaneous phase
    end
end
fprintf('Analytic Signal and Instantaneous Phase - Computation Complete\n');

IPS=smooth3(IP,'box',[7 15 15]);
fprintf('Smoothing of the Instantaneous Phase volume Complete\n');
%viewf(IP,IPS);
%h=slice(IPS,[50 100],100,100);
%h(1).EdgeColor='none'; h(2).EdgeColor='none'; h(3).EdgeColor='none'; h(4).EdgeColor='none';

%% Calculate the Instantaneous Frequency
w=zeros(size(S));  % create a cube for the Instantaneous Frequency
for j=1:nj
    for k=1:nk
    vi=IPS(:,j,k); %extract a vector along i
    dvi=diff(vi); %calculate the first differental, it shrinks 
    w(:,j,k)=[dvi(:); dvi(ni-1)]; %fix the shrink
    end
end
fprintf('Instantaneous Frequency - Computation Complete\n');
%viewf(S,w);pause

%% Calculate kx
kx=zeros(size(S)); % create a cube for the Instantaneous wave number along x
for i=1:ni
    for k=1:nk
    vj=IPS(i,:,k); %extract a vector along i
    dvj=diff(vj); %calculate the first differental, it shrinks 
    kx(i,:,k)=[dvj(:); dvj(nj-1)]; %fix the shrink
    end
end
fprintf('kx - Computation Complete\n');
%viewf(S,kx);pause;

%% Calculate ky
ky=zeros(size(S)); % create a cube for the Instantaneous wave number along x
for i=1:ni
    for j=1:nj
    vk=IPS(i,j,:); %extract a vector along i
    dvk=diff(vk); %calculate the first differental, it shrinks 
    ky(i,j,:)=[dvk(:); dvk(nk-1)]; %fix the shrink
    end
end
fprintf('ky - Computation Complete\n');
%viewf(S,ky);pause

%% Calculate p and q and s, the dip
%p=kx./w;
%p=smooth3(kx,'box',[5 11 5])./w;
p=smooth3(kx,'box',[5 11 5]);
viewf(S,p);pause
%q=ky./w;
%q=smooth3(ky,'box',[5 5 11])./w;
q=smooth3(ky,'box',[5 5 11]);
viewf(S,q);pause
%s=(p.^2+q.^2).^.5;

s=atan(((p.^2+q.^2).^.5)./w);
viewf(S,s);pause;
fprintf('p, q and s - Computation Complete\n');
