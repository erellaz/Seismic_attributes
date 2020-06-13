%% Mirror extend a cube in 3 dimensions
% Synopsis: E=extend(S,[20,15,10]); E output extended cube
% in the 3 dimensions through mirror replication
% to be used to take care of the edge effect of some algorithms 
function E=extend(S,isize)
%% Load the 3D seismic cube
ei=isize(1);
ej=isize(2);
ek=isize(3);
[ni,nj,nk]=size(S);

% Initialize the output
E=zeros(ni+2*ei,nj+2*ej,nk+2*ek);

% Paste the input in the middle
E(ei+1:ei+ni,ej+1:ej+nj,ek+1:ek+nk)=S(:,:,:);

%Mirror extend along i
E(1:ei,ej+1:ej+nj,ek+1:ek+nk)=flip(S(1:ei,:,:),1);
E(ei+ni+1:2*ei+ni,ej+1:ej+nj,ek+1:ek+nk)=flip(S(ni-(ei-1):ni,:,:),1);
                
%Mirror extend along j
E(:,1:ej,:)=flip(E(:,ej+1:2*ej,:),2);
E(:,ej+nj+1:2*ej+nj,:)=flip(E(:,nj+1:nj+ej,:),2);  

%Mirror extend along k
E(:,:,1:ek)=flip(E(:,:,ek+1:2*ek),3);
E(:,:,ek+nk+1:2*ek+nk)=flip(E(:,:,nk+1:nk+ek),3);  