function forward_calculation(n, enable_plotting)
%FORWARD_CALCULATION Terrain based forward model gravity calculation
if ~exist('enable_plotting', 'var')
    enable_plotting = true;
end

% [X, Y, Elev] = read_binary_file('TA41_Tunnel_LIDAR_NAVD88', 2422420, 1540, 1573);
[X, Y, Elev] = read_binary_file('Tunnel_points_20160715', 23363400, 4600, 5079);

% Generate submesh on which to downsample
[XI, YI] = meshgrid(linspace(min(X(:)), max(X(:)), n), ...
                    linspace(min(Y(:)), max(Y(:)), n));

% Interpolate linearly since we're downsampling
ElevI = interp2(X, Y, Elev, XI, YI, 'linear');

dx = XI(1,2) - XI(1,1);
dy = YI(2,1) - YI(1,1);
assert(dx > 0 & dy > 0)

min_z = min(ElevI(:));

rho = repmat(Constants.rock_density, n*n, 1);

% eval_pts = [Constants.base_station, Constants.tunnel_pts];

[map, eval_names, eval_pts] = build_map();

voxel_corners = [XI(:)'; YI(:)'; repmat(min_z, 1, n*n)];

voxel_diag = [repmat(dx, 1, n*n); repmat(dy, 1, n*n); ElevI(:)' - min_z];

tic;
interaction_matrix = create_interaction_matrix_mex(eval_pts, voxel_corners, voxel_diag);
toc;

ind = 1;
for pt = eval_pts
    for p_id = 1:4
        tunnel_effect(ind, p_id) = Constants.tunnel_rooms(p_id).eval_gz_at(pt);
    end
    ind = ind + 1;
end

rho_oriented = repmat(-Constants.rock_density, numel(Constants.tunnel_rooms), 1);
% rho_oriented = [-Constants.rock_density; -Constants.rock_density + 500];

gz_vals = interaction_matrix * rho + tunnel_effect * rho_oriented;
% inverse = interaction_matrix \ gz_vals;
% diff = sum(abs(inverse - rho)./rho) / numel(rho)

gz_vals = (gz_vals - gz_vals(strcmp(eval_names, 'BS_TN_1'))) * 1E5;

if ~enable_plotting
    return
end

colormap(parula(1024*16));

elevations = eval_pts(3, :);
northing = eval_pts(2, :);

measure_data = values(map, eval_names);
gz_avg_at_stations = cellfun(@(c) mean(c(:,2)), measure_data);
gz_error_at_stations = cellfun(@(c) norm(c(:,1)), measure_data);

below_cutoff_height = elevations < 2150;

figure(10); hold on;
scatter(northing(below_cutoff_height), gz_vals(below_cutoff_height))
errorbar(northing(below_cutoff_height), gz_avg_at_stations(below_cutoff_height), ...
    gz_error_at_stations(below_cutoff_height), 'o');

title(['n = ' num2str(n) ', density = ' num2str(Constants.rock_density)]);
legend('Calculated', 'Observed');
xlabel('Northing (m)'); ylabel('gz (mgal)');
saveas(gcf, ['figures/Lower stations_' num2str(n) '_' num2str(int64(Constants.rock_density))], 'png');

figure(11); hold on;
scatter(northing(~below_cutoff_height), gz_vals(~below_cutoff_height))
errorbar(northing(~below_cutoff_height), gz_avg_at_stations(~below_cutoff_height), ...
    gz_error_at_stations(~below_cutoff_height), 'o');

title(['n = ' num2str(n) ', density = ' num2str(Constants.rock_density)]);
legend('Calculated', 'Observed');
xlabel('Northing (m)'); ylabel('gz (mgal)');
saveas(gcf, ['figures/Upper stations_' num2str(n) '_' num2str(int64(Constants.rock_density))], 'png');

figure(2); hold on;
title('Elevation Data and Station Locations');
xlabel('Easting (m)'); ylabel('Northing (m)');
% for i = 1:size(voxel_corners, 2),
%     render_prism(voxel_corners(:,i), voxel_diag(:,i), [1;0;0], [0;1;0], [0;0;1]);
% end

surf(XI, YI, ElevI, 'EdgeAlpha', 0.15);
scatter3(Constants.all_pts(1,:), Constants.all_pts(2,:), Constants.all_pts(3,:) + 2, 10, 'o', 'MarkerEdgeColor','k',...
        'MarkerFaceColor', 'r');

axis equal tight
lighting gouraud

figure(3); hold on; axis equal;
scatter3(Constants.tunnel_pts(1,:), Constants.tunnel_pts(2,:), Constants.tunnel_pts(3,:));

for prism = Constants.tunnel_rooms
    prism.render
end

% figure(2);  hold on;
% title('Calculated gz (mGal)');
% surf(XI, YI, gz_vals, 'EdgeColor', 'none');
% contour3(XI, YI, gz_vals, 20, 'k');
%
% scatter3(Constants.tunnel_pts(1,:), Constants.tunnel_pts(2,:), Constants.tunnel_pts(3,:), 'ro');

% figure(3); hold on;
% title('Calculated vs Measured in tunnel (mGal)');
% gravity_vals = interp2(XI, YI, gz_vals, Constants.tunnel_pts(1,:), Constants.tunnel_pts(2,:));

% for i = 1:size(Constants.tunnel_pts, 2),
%     dist_along_tunnel(i) = norm(Constants.tunnel_pts(:,i) - Constants.tunnel_pts(:,1));
% end
%
% plot(dist_along_tunnel, gravity_vals - max(gravity_vals));
%
% scatter(dist_along_tunnel, tunnel_gz_vals);
end

function test_rrpa
    x = -150:1:150;
    y = -150:1:150;
    [X, Y] = meshgrid(x,y);

    corner = [-100; -100; -200];
    diagonal = [200; 200; 100];

    m = create_interaction_matrix([X(:)'; Y(:)'; 0 * X(:)'], corner, diagonal);

    calc_gz = reshape(m * 2000, [length(y), length(x)]) * 1E5;

    surf(X, Y, calc_gz, 'EdgeColor', 'none'); hold on;
    contour3(X, Y, calc_gz, 'k');
    axis equal
end

function write_binary_file_from_txt(file_name)
    fid = fopen([file_name '.txt'], 'r');
    data = textscan(fid, '%d %f %f %f', 'HeaderLines', 1, 'Delimiter', ',');
    fclose(fid);

    binary_file = fopen([file_name '.bin'], 'w');
    fwrite(binary_file, [data{2}, data{3}, data{4}], 'single');
    fclose(binary_file);
end

function [X,Y,Elev] = read_binary_file(file_name, total_points, num_points_x, num_points_y)
    assert(num_points_x * num_points_y == total_points);

    fileID = fopen([file_name '.bin']);
    topo = fread(fileID, [total_points, 3], 'single') * 0.3048;
    fclose(fileID);

    X    = reshape(topo(:,2), [num_points_x, num_points_y])';
    Y    = reshape(topo(:,3), [num_points_x, num_points_y])';
    Elev = reshape(topo(:,1), [num_points_x, num_points_y])';
end