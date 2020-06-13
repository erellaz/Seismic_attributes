%% Visualize 3 slices of a seismic cube S and a volumetric attribute A 
%Synopsis: view_panel(S,A,[100 120 125]);
function view_panel(S,A,slices)

depth=slices(1);
iline=slices(2);
xline=slices(3);

%fig1=figure('Name','Seismic Attribut view','NumberTitle','off'); colormap(gray);
fig1=figure;
fig1.NumberTitle='off';
fig1.Name='Seismic Attribut view';
%fig1.Colormap=[1 0 1; 0 0 1; 1 1 0];
%colormap(gray);
fig1.Units='inches'; fig1.PaperUnits='inches';
fig1.Position=[.25 .25 22 17];%this is twice "letter" size
fig1.PaperSize=[11 8.5];%this is "letter" size

%Z slice --------------------------------
Szslice(:,:)=S(depth,:,:);
Czslice(:,:)=A(depth,:,:);
subplot(2,3,1);
imagesc(Szslice); colorbar; title(['Seismic Zslice ',num2str(depth)]);
subplot(2,3,4);
imagesc(Czslice); colorbar; title(['Attribut Zslice ',num2str(depth)]); 

%Inline slice --------------------------------
Sislice(:,:)=S(:,iline,:);
Cislice(:,:)=A(:,iline,:);
subplot(2,3,2); 
imagesc(Sislice); colorbar; title(['Seismic IL ',num2str(iline)]);
subplot(2,3,5);
imagesc(Cislice); colorbar; title(['Attribut IL ',num2str(iline)]);


%X line slice--------------------------------
Sjslice(:,:)=S(:,:,xline);
Cjslice(:,:)=A(:,:,xline);
subplot(2,3,3);
imagesc(Sjslice); colorbar;  title(['Seismic XL ',num2str(xline)]);
subplot(2,3,6);
imagesc(Cjslice); colorbar;  title(['Attribut XL ',num2str(xline)]);

end