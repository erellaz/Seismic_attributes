%% Compute semblance through cross correlationon a 3D cube
%Synopsis: C=semblance_xcor(S); with S being a seismic cube and C the Xcor semblance 
function C=semblance_xcor_prod(S)
win=3;%this is half the correlation window

[ni,nj,nk]=size(S);
C=zeros(size(S));

parfor j=1:nj-1
    task=getCurrentTask(); id(j)=task.ID;
    fprintf('Worker %i at position j=%i ---\n',id(j),j);
    for k=1:nk-1
    %fprintf('At position j=%i k=%i\n',j,k);
            for i=win+1:ni-(win+1)
            %fprintf('Calculating coherence at position i=%i j=%i k=%i windowed at win=%i \n',i,j,k,win);
            t0=S(i-win:i+win,j,k);
            t1=S(i-win:i+win,j,k+1);
            t2=S(i-win:i+win,j+1,k);
     
            c01=xcorr(t0,t1);
            c02=xcorr(t0,t2);
  
            a=max(c01)/(norm(t0)*norm(t1));
            b=max(c02)/(norm(t0)*norm(t2));
            C(i,j,k)=sqrt(a*b);
            end %i
    end %k
end %j
