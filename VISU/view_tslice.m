%% Visualize 3 slices of a seismic cube S and a volumetric attribute A 
function view_tslice(S,slice)

fig1=figure;
fig1.NumberTitle='off';
fig1.Name='Time slice view';
%fig1.Colormap=[1 0 1; 0 0 1; 1 1 0];
colormap(gray);
fig1.Units='inches'; fig1.PaperUnits='inches';
fig1.Position=[.25 .25 22 17];%this is twice "letter" size
fig1.PaperSize=[11 8.5];%this is "letter" size

%Inline slice --------------------------------
dslice(:,:)=S(slice,:,:);
 
imagesc(real(rot90(transpose(dslice),1))); 

colorbar; title(['Time slice ',num2str(slice)]);
%caxis([-5000 5000]);%minmax of the colorbar
end