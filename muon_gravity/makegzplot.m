% makegzplot.m
% code to make figures to compare forward models
% Megan Lewis, Oct 2016
clear all
close all

% % [X, Y, Elev] = read_binary_file('TA41_Tunnel_LIDAR_NAVD88.bin', 2422420, 1540, 1573);
% [X, Y, Elev] = BinaryTerrain.read_file('Tunnel_points_20160715.bin', 23363400, 4600, 5079);
% 
% % Generate submesh on which to downsample
% [XI, YI] = meshgrid(linspace(min(X(:)), max(X(:)), n), ...
%                     linspace(min(Y(:)), max(Y(:)), n));
%                 
%  %Xn = linspace(min(X(:)), max(X(:)), n)
%  %Yn = linspace(min(Y(:)), max(Y(:)), n)
% 
% % Interpolate linearly since we're downsampling
% ElevI = interp2(X, Y, Elev, XI, YI, 'linear');
% 
% dx = XI(1,2) - XI(1,1);
% dy = YI(2,1) - YI(1,1);
% assert(dx > 0 & dy > 0)

rho1200=dlmread('AllData_2000_1200_0_2100.dat');
rho1300=dlmread('AllData_2000_1300_0_2100.dat');
rho1400=dlmread('AllData_2000_1400_0_2100.dat');
rho1500=dlmread('AllData_2000_1500_0_2100.dat');
rho1600=dlmread('AllData_2000_1600_0_2100.dat');
rho1700=dlmread('AllData_2000_1700_0_2100.dat');
rho1900=dlmread('AllData_2000_1900_0_2100.dat');
rho1400m500=dlmread('AllData_2000_1400_-500_2163.dat');
rho1400p500=dlmread('AllData_2000_1400_500_2163.dat');
rho1600p500=dlmread('AllData_2000_1600_500_2163.dat');
rho1600m500=dlmread('AllData_2000_1600_-500_2163.dat');
rho1900m500=dlmread('AllData_2000_1900_-500_2163.dat');
rho1900p500=dlmread('AllData_2000_1900_500_2163.dat');



northing=(rho1200(:,2));
easting=(rho1200(:,1));
elevation=(rho1200(:,3));
gzCalc1200=(rho1200(:,4));
gzObs=(rho1200(:,5));
gzErr=(rho1200(:,6));
gzCalc1300=(rho1300(:,4));
gzCalc1400=(rho1400(:,4));
gzCalc1500=(rho1500(:,4));
gzCalc1600=(rho1600(:,4));
gzCalc1700=(rho1700(:,4));
gzCalc1900=(rho1900(:,4));
gzCalc1400m500=(rho1400m500(:,4))
gzCalc1400p500=(rho1400p500(:,4))
gzCalc1600m500=(rho1600m500(:,4))
gzCalc1600p500=(rho1600p500(:,4))
gzCalc1900m500=(rho1900m500(:,4))
gzCalc1900p500=(rho1900p500(:,4))
cutoff_height = elevation < 2150;

%     function do_plot(fig_num, fig_name, mask, N, gz_calc, gz_meas, error)
%         figure(fig_num); hold on;
%         scatter(N(mask), gz_calc(mask))
%         errorbar(N(mask), gz_meas(mask), error(mask), 'o');
%         
%         %title([fig_name ' n = ' num2str(n) ', bottom density = ' num2str(rock_density) ', delta density = ' num2str(delta_rock_density) ', layer elevation = ' num2str(LayerElev)]);
%         legend('Calculated', 'Observed');
%         xlabel('Northing (m)'); ylabel('gz (mgal)');
%         % saveas(gcf, ['figures/' fig_name ' stations_' num2str(n) '_' num2str(int64(Constants.rock_density))], 'png');
%     end
figure(1)    
subplot(212)
scatter(northing(cutoff_height),gzCalc1200(cutoff_height),'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0]); hold on
scatter(northing(cutoff_height),gzCalc1400(cutoff_height),'x','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(northing(cutoff_height),gzCalc1500(cutoff_height),'+','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(northing(cutoff_height),gzCalc1600(cutoff_height),'*','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(northing(cutoff_height),gzCalc1700(cutoff_height),'s','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(northing(cutoff_height),gzCalc1900(cutoff_height),'d','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(northing(cutoff_height),gzObs(cutoff_height),'^','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1])
legend('1200','1400','1500','1600','1700','1900','Observed')
subplot(211)
scatter(northing(~cutoff_height),gzCalc1200(~cutoff_height),'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0]); hold on
scatter(northing(~cutoff_height),gzCalc1400(~cutoff_height),'x','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(northing(~cutoff_height),gzCalc1500(~cutoff_height),'+','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(northing(~cutoff_height),gzCalc1600(~cutoff_height),'*','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(northing(~cutoff_height),gzCalc1700(~cutoff_height),'s','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(northing(~cutoff_height),gzCalc1900(~cutoff_height),'d','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(northing(~cutoff_height),gzObs(~cutoff_height),'^','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1])

figure(2)
subplot(212)
scatter(easting(cutoff_height),gzCalc1200(cutoff_height),'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0]); hold on
scatter(easting(cutoff_height),gzCalc1400(cutoff_height),'x','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(easting(cutoff_height),gzCalc1500(cutoff_height),'+','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(easting(cutoff_height),gzCalc1600(cutoff_height),'*','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(easting(cutoff_height),gzCalc1700(cutoff_height),'s','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(easting(cutoff_height),gzCalc1900(cutoff_height),'d','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(easting(cutoff_height),gzObs(cutoff_height),'^','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1])
legend('1200','1400','1500','1600','1700','1900','Observed')
subplot(211)
scatter(easting(~cutoff_height),gzCalc1200(~cutoff_height),'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0]); hold on
scatter(easting(~cutoff_height),gzCalc1400(~cutoff_height),'x','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(easting(~cutoff_height),gzCalc1500(~cutoff_height),'+','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(easting(~cutoff_height),gzCalc1600(~cutoff_height),'*','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(easting(~cutoff_height),gzCalc1700(~cutoff_height),'s','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(easting(~cutoff_height),gzCalc1900(~cutoff_height),'d','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(easting(~cutoff_height),gzObs(~cutoff_height),'^','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1])

figure(3)
subplot(212)
scatter(elevation(cutoff_height),gzCalc1200(cutoff_height),'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0]); hold on
scatter(elevation(cutoff_height),gzCalc1400(cutoff_height),'x','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(elevation(cutoff_height),gzCalc1500(cutoff_height),'+','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(elevation(cutoff_height),gzCalc1600(cutoff_height),'*','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(elevation(cutoff_height),gzCalc1700(cutoff_height),'s','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(elevation(cutoff_height),gzCalc1900(cutoff_height),'d','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(elevation(cutoff_height),gzObs(cutoff_height),'^','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1])
legend('1200','1400','1500','1600','1700','1900','Observed')
subplot(211)
scatter(elevation(~cutoff_height),gzCalc1200(~cutoff_height),'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0]); hold on
scatter(elevation(~cutoff_height),gzCalc1400(~cutoff_height),'x','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(elevation(~cutoff_height),gzCalc1500(~cutoff_height),'+','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(elevation(~cutoff_height),gzCalc1600(~cutoff_height),'*','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(elevation(~cutoff_height),gzCalc1700(~cutoff_height),'s','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(elevation(~cutoff_height),gzCalc1900(~cutoff_height),'d','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(elevation(~cutoff_height),gzObs(~cutoff_height),'^','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1])
figure(4)
subplot(212)
scatter(northing(cutoff_height),gzCalc1400m500(cutoff_height),'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 1]); hold on
scatter(northing(cutoff_height),gzCalc1400p500(cutoff_height),'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(northing(cutoff_height),gzCalc1600m500(cutoff_height),'s','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 1])
scatter(northing(cutoff_height),gzCalc1600p500(cutoff_height),'s','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(northing(cutoff_height),gzCalc1900m500(cutoff_height),'d','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 1])
scatter(northing(cutoff_height),gzCalc1900p500(cutoff_height),'d','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(northing(cutoff_height),gzObs(cutoff_height),'^','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1])
legend('1200','1400','1500','1600','1700','1900','Observed')
subplot(211)
scatter(northing(~cutoff_height),gzCalc1400m500(~cutoff_height),'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0]); hold on
scatter(northing(~cutoff_height),gzCalc1400p500(~cutoff_height),'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 1])
scatter(northing(~cutoff_height),gzCalc1600m500(~cutoff_height),'s','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(northing(~cutoff_height),gzCalc1600p500(~cutoff_height),'s','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 1])
scatter(northing(~cutoff_height),gzCalc1900m500(~cutoff_height),'d','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0])
scatter(northing(~cutoff_height),gzCalc1900p500(~cutoff_height),'d','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 1])
scatter(northing(~cutoff_height),gzObs(~cutoff_height),'^','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1])
