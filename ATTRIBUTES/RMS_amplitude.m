%% Compute RMS amplitude on a 3D cube
%Synopsis: RMS=RMS_amplitude(S); with S being a seismic cube and C the Xcor semblance 
function RMS=RMS_amplitude(S)
win=15;%this is the half amplitude window

winnorm=sqrt(2*win+1);
[ni,nj,nk]=size(S);
RMS=zeros(size(S));

parfor j=1:nj-1
    task=getCurrentTask(); id(j)=task.ID;
    fprintf('Worker %i at position j=%i ---\n',id(j),j);
    for k=1:nk-1
    %fprintf('At position j=%i k=%i\n',j,k);
            for i=win+1:ni-(win+1)
            t0=S(i-win:i+win,j,k);
            RMS(i,j,k)=norm(t0)/winnorm;
            end %i
    end %k
end %j
